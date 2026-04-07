module MultiAMR
using ..Utils
using ..AStarAlgo

export AMR, Quai, Mission, Constraint, EdgeConstraint, runMultiAMR, runMultiAMRFromMissions

# =========================
# STRUCTURES
# =========================

"""
Représente un robot AMR déjà prêt à être planifié.
"""
struct AMR
    id::Int
    start::Tuple{Int,Int}
    goal::Tuple{Int,Int}
    start_time::Int
end

"""
Représente un quai du crossdock.
- id       : identifiant logique du quai
- position : position du quai dans la grille
"""
struct Quai
    id::Int
    position::Tuple{Int,Int}
end

"""
Représente une mission métier :
un transfert d’un quai de départ vers un quai d’arrivée.
"""
struct Mission
    id::Int
    start_quai::Quai
    end_quai::Quai
    start_time::Int
end

"""
Contrainte de nœud :
interdit une position à un instant donné.
"""
struct Constraint
    position::Tuple{Int,Int}
    time::Int
end

"""
Contrainte d’arête :
interdit un déplacement de type swap à un instant donné.
"""
struct EdgeConstraint
    from::Tuple{Int,Int}
    to::Tuple{Int,Int}
    time::Int
end

# =========================
# UTILITAIRES
# =========================

"""
Convertit une mission métier en AMR exploitable par l’algorithme.
"""
function missionToAMR(m::Mission)
    return AMR(
        m.id,
        m.start_quai.position,
        m.end_quai.position,
        m.start_time
    )
end

"""
Transforme un chemin spatial en chemin temporel.
"""
function pathWithTime(path::Vector{Tuple{Int,Int}}, start_time::Int)

    timed_path = Vector{Tuple{Tuple{Int,Int}, Int}}()

    for (k, pos) in enumerate(path)
        push!(timed_path, (pos, start_time + k - 1))
    end

    return timed_path
end

"""
Construit les contraintes de nœuds à partir d’un chemin temporel.
"""
function buildConstraints(timed_path)

    constraints = Constraint[]

    for (pos, t) in timed_path
        push!(constraints, Constraint(pos, t))
    end

    return constraints
end

"""
Construit les contraintes d’arêtes à partir d’un chemin temporel.
Ces contraintes servent à interdire les collisions croisées.
"""
function buildEdgeConstraints(timed_path)

    constraints = EdgeConstraint[]

    if length(timed_path) <= 1
        return constraints
    end

    for k in 1:length(timed_path)-1
        (pos1, t1) = timed_path[k]
        (pos2, _) = timed_path[k+1]

        push!(constraints, EdgeConstraint(pos1, pos2, t1))
    end

    return constraints
end

"""
Reconstruit le meilleur chemin spatial atteignant goal_pos.

Comme plusieurs états temporels peuvent atteindre la même position finale,
on choisit celui de coût minimal.
"""
function reconstructPath(g, parent, start_pos, goal_pos)

    best_cost = Inf
    goal_state = nothing

    for (s, cost) in g
        if (s[1], s[2]) == goal_pos && cost < best_cost
            best_cost = cost
            goal_state = s
        end
    end

    if goal_state === nothing
        return Tuple{Int,Int}[]
    end

    path = Tuple{Int,Int}[]
    current = goal_state

    while haskey(parent, current)
        push!(path, (current[1], current[2]))
        current = parent[current]
    end

    push!(path, start_pos)
    reverse!(path)

    return path
end

# =========================
# PLANIFICATION D'UN AMR
# =========================

"""
Planifie un seul AMR avec A* spatio-temporel.

Si aucun chemin n’est trouvé au temps initial,
on tente un recalcul simple en retardant le départ.
"""
function planOneAMR(mapFile::String, amr::AMR, node_constraints, edge_constraints)

    g, parent, states = AStarAlgo.algoAstarTime(
        mapFile,
        amr.start,
        amr.goal,
        amr.start_time,
        node_constraints,
        edge_constraints
    )

    path = reconstructPath(g, parent, amr.start, amr.goal)

    if isempty(path)

        println("Aucun chemin au temps ", amr.start_time, ", recalcul avec départ retardé")

        for delay in 1:10

            new_start_time = amr.start_time + delay

            g, parent, states = AStarAlgo.algoAstarTime(
                mapFile,
                amr.start,
                amr.goal,
                new_start_time,
                node_constraints,
                edge_constraints
            )

            path = reconstructPath(g, parent, amr.start, amr.goal)

            if !isempty(path)
                return path, states, new_start_time
            end
        end

        return Tuple{Int,Int}[], states, amr.start_time
    end

    return path, states, amr.start_time
end
function printGrid(grid, positions)

    height = size(grid, 1)
    width  = size(grid, 2)

    # copie propre de la grille
    display = copy(grid)

    for (id, (i,j)) in positions
        display[i, j] = Char('A' + id - 1)
    end

    for i in 1:height
        println(String(display[i, :]))
    end
end
# =========================
# SIMULATION TEMPORELLE
# =========================

"""
Affiche la position de chaque AMR à chaque instant.
"""
function simulate(amr_paths)

    timeline = Dict{Int, Vector{Tuple{Int,Tuple{Int,Int}}}}()

    for (amr_id, path) in amr_paths
        for (pos, t) in path

            if !haskey(timeline, t)
                timeline[t] = []
            end

            push!(timeline[t], (amr_id, pos))
        end
    end

    println("\n===== Simulation temporelle =====")

    for t in sort(collect(keys(timeline)))

        print("t=", t, " : ")

        for (id, pos) in timeline[t]
            print("AMR", id, " ", pos, "  ")
        end

        println()
    end
end
function simulateVisual(mapFile, amr_paths)

    grid, height, width = Utils.readMap(mapFile)

    timeline = Dict{Int, Vector{Tuple{Int,Tuple{Int,Int}}}}()

    for (amr_id, path) in amr_paths
        for (pos, t) in path

            if !haskey(timeline, t)
                timeline[t] = []
            end

            push!(timeline[t], (amr_id, pos))
        end
    end

    println("\n===== Simulation VISUELLE =====")

    for t in sort(collect(keys(timeline)))

        println("\nt = ", t)

        positions = Dict(id => pos for (id,pos) in timeline[t])

        printGrid(grid, positions)

       sleep(1)  # ralentit la simulation
    end
end
# =========================
# MULTI AMR
# =========================

"""
Planification séquentielle des AMR.

Chaque AMR planifié ajoute :
- des contraintes de nœuds
- des contraintes d’arêtes

pour les AMR suivants.
"""
function runMultiAMR(mapFile::String, amrs::Vector{AMR})

    node_constraints = Constraint[]
    edge_constraints = EdgeConstraint[]

    global_end_time = 0

    amr_paths = Dict{Int, Vector{Tuple{Tuple{Int,Int},Int}}}()

    for amr in amrs

        println("\n==============================")
        println("AMR ", amr.id)
        println("==============================")

        path, states, actual_start_time = planOneAMR(
            mapFile,
            amr,
            node_constraints,
            edge_constraints
        )

        if isempty(path)
            println("Aucun chemin trouvé")
            continue
        end

        timed_path = pathWithTime(path, actual_start_time)

        amr_paths[amr.id] = timed_path

        println("Distance : ", length(path) - 1)
        println("States : ", states)
        println("Path length : ", length(path))
        println("Start time used : ", actual_start_time)

        println("Timed path (first 5):")
        println(timed_path[1:min(5, length(timed_path))])

        append!(node_constraints, buildConstraints(timed_path))
        append!(edge_constraints, buildEdgeConstraints(timed_path))

        last_time = timed_path[end][2]
        global_end_time = max(global_end_time, last_time)
    end

    println("\n==============================")
    println("Tous les AMR terminés à t = ", global_end_time)
    println("==============================")

    simulateVisual(mapFile, amr_paths)
end

"""
Version métier :
prend des missions (quai de départ -> quai d’arrivée)
et les convertit automatiquement en AMR.
"""
function runMultiAMRFromMissions(mapFile::String, missions::Vector{Mission})

    amrs = [missionToAMR(m) for m in missions]

    runMultiAMR(mapFile, amrs)
end

end