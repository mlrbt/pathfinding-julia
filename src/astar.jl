module AStarAlgo

using ..Utils
using DataStructures

export algoAstarTime

# Vérifie si une case est interdite à un instant donné
# → évite que deux AMR soient sur la même case au même moment
function isNodeForbidden(pos, time, node_constraints)

    for c in node_constraints
        if c.position == pos && c.time == time
            return true
        end
    end

    return false
end

# Vérifie si un mouvement est interdit (collision de type swap)
# → typiquement A -> B et B -> A au même moment
function isEdgeForbidden(from, to, time, edge_constraints)

    for c in edge_constraints
        if c.from == to && c.to == from && c.time == time
            return true
        end
    end

    return false
end

# A* spatio-temporel
# → on ajoute la dimension temps pour gérer plusieurs robots
function algoAstarTime(fname, D, A, start_time, node_constraints, edge_constraints)

    max_time = 1000  # limite pour éviter les boucles infinies

    grid, height, width = Utils.readMap(fname)

    # coût g : (position + temps) → coût
    g = Dict{Tuple{Int,Int,Int}, Float64}()

    # parent pour reconstruire le chemin
    parent = Dict{Tuple{Int,Int,Int}, Tuple{Int,Int,Int}}()

    # file de priorité (A*)
    pq = PriorityQueue{Tuple{Int,Int,Int}, Float64}()

    # ensemble des états déjà explorés
    visited = Set{Tuple{Int,Int,Int}}()

    # état initial (on part avec un temps donné)
    start = (D[1], D[2], start_time)

    g[start] = 0.0
    pq[start] = 0.0

    statesEvaluated = 0

    while !isempty(pq)

        current = dequeue!(pq)

        # évite de traiter plusieurs fois le même état
        if current in visited
            continue
        end

        push!(visited, current)

        i, j, t = current
        statesEvaluated += 1

        # condition d’arrêt : on atteint la position cible
        # (le temps peut varier → premier trouvé = optimal avec A*)
        if (i, j) == A
            println("GOAL REACHED AT: ", (i, j), " time=", t)
            println("EXPECTED GOAL: ", A)
            return g, parent, statesEvaluated, current
        end

        # voisins classiques (haut, bas, gauche, droite)
        neighbors = Utils.getNeighbors(grid, i, j)

        # on autorise aussi l’attente (rester sur place)
        push!(neighbors, (i, j))

        for (ni, nj) in neighbors

            nt = t + 1  # on avance dans le temps

            if nt > max_time
                continue
            end

            # évite collision de position
            if isNodeForbidden((ni, nj), nt, node_constraints)
                continue
            end

            # évite collision croisée (swap)
            if isEdgeForbidden((i, j), (ni, nj), t, edge_constraints)
                continue
            end

            new_state = (ni, nj, nt)

            cost = Utils.movementCost(grid, ni, nj)

            # petit hack volontaire :
            # attendre coûte moins cher → encourage à attendre plutôt que faire un détour
            if (ni, nj) == (i, j)
                cost = 0.5
            end

            newG = g[current] + cost

            # relaxation classique A*
            if !haskey(g, new_state) || newG < g[new_state]
                g[new_state] = newG
                parent[new_state] = current

                # heuristique = Manhattan (on ignore le temps ici volontairement)
                f = newG + Utils.manhattan((ni, nj), A)

                pq[new_state] = f
            end
        end
    end

    # aucun chemin trouvé
    return g, parent, statesEvaluated, nothing
end

end