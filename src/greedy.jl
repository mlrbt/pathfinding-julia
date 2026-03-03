module GreedyAlgo

using ..Utils

export algoGlouton

"""
    algoGlouton(fname, D, A)

Implémentation de la recherche gloutonne
(Greedy Best-First Search).

Choisit le sommet avec heuristique minimale h.
Ne garantit pas l’optimalité.
"""
function algoGlouton(fname, D::Tuple{Int,Int}, A::Tuple{Int,Int})

    grid, height, width = Utils.readMap(fname)

    visited = falses(height, width)
    parent = Dict{Tuple{Int,Int}, Tuple{Int,Int}}()

    # open list
    open = [D]

    visited[D[1], D[2]] = true

    statesEvaluated = 0

    while !isempty(open)

        # Choisir le sommet avec h minimal
        minH = Inf
        bestIndex = 1

        for (idx, node) in enumerate(open)
            h = Utils.manhattan(node, A)
            if h < minH
                minH = h
                bestIndex = idx
            end
        end

        current = open[bestIndex]
        deleteat!(open, bestIndex)

        statesEvaluated += 1

        if current == A
            break
        end

        neighbors = Utils.getNeighbors(grid, current[1], current[2])

        for n in neighbors
            if !visited[n[1], n[2]]
                visited[n[1], n[2]] = true
                parent[n] = current
                push!(open, n)
            end
        end
    end

    # Si pas de chemin
    if !haskey(parent, A) && D != A
        return -1, statesEvaluated, Tuple{Int,Int}[]
    end

    # Reconstruction
    path = Tuple{Int,Int}[]
    current = A

    while current != D
        push!(path, current)
        current = parent[current]
    end

    push!(path, D)
    reverse!(path)

    # Distance en nombre d’étapes (pas coût pondéré ici)
    distance = length(path) - 1

    return distance, statesEvaluated, path
end

end