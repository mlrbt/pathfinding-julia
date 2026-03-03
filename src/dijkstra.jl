module DijkstraAlgo

using ..Utils

export algoDijkstra

"""
    algoDijkstra(fname, D, A)

Implémentation de l’algorithme de Dijkstra
pour graphe pondéré à coûts non négatifs.
"""
function algoDijkstra(fname, D::Tuple{Int,Int}, A::Tuple{Int,Int})

    grid, height, width = Utils.readMap(fname)

    dist = fill(Inf, height, width)
    visited = falses(height, width)
    parent = Dict{Tuple{Int,Int}, Tuple{Int,Int}}()

    dist[D[1], D[2]] = 0.0

    statesEvaluated = 0

    while true

        # Recherche du sommet non permanent de distance minimale
        minDist = Inf
        current = nothing

        for i in 1:height
            for j in 1:width
                if !visited[i,j] && dist[i,j] < minDist
                    minDist = dist[i,j]
                    current = (i,j)
                end
            end
        end

        # Si aucun sommet atteignable
        if current === nothing
            break
        end

        i, j = current
        visited[i,j] = true
        statesEvaluated += 1

        # Arrêt anticipé si arrivée atteinte
        if current == A
            break
        end

        neighbors = Utils.getNeighbors(grid, i, j)

        for n in neighbors
            ni, nj = n

            if !visited[ni,nj]

                cost = Utils.movementCost(grid, ni, nj)
                newDist = dist[i,j] + cost

                if newDist < dist[ni,nj]
                    dist[ni,nj] = newDist
                    parent[n] = current
                end
            end
        end
    end

    # Si pas de chemin
    if dist[A[1], A[2]] == Inf
        return -1, statesEvaluated, Tuple{Int,Int}[]
    end

    # Reconstruction chemin
    path = Tuple{Int,Int}[]
    current = A

    while current != D
        push!(path, current)
        current = parent[current]
    end

    push!(path, D)
    reverse!(path)

    return dist[A[1], A[2]], statesEvaluated, path
end

end