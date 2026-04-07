module AStarAlgo

using ..Utils
using DataStructures

export algoAstar

"""
    algoAstar(fname, D, A)

Implémentation de l’algorithme A*
avec heuristique de Manhattan.
"""
function algoAstar(fname, D::Tuple{Int,Int}, A::Tuple{Int,Int})

    grid, height, width = Utils.readMap(fname)

    g = fill(Inf, height, width)
    visited = falses(height, width)
    parent = Dict{Tuple{Int,Int}, Tuple{Int,Int}}()

    pq = PriorityQueue{Tuple{Int,Int}, Float64}()

    g[D...] = 0.0
    pq[D] = 0.0

    statesEvaluated = 0

    while !isempty(pq)

        current = dequeue!(pq)
        i, j = current

        if visited[i,j]
            continue
        end

        visited[i,j] = true
        statesEvaluated += 1

        if current == A
            break
        end

        neighbors = Utils.getNeighbors(grid, i, j)

        for (ni, nj) in neighbors

            if !visited[ni,nj]

                cost = Utils.movementCost(grid, ni, nj)
                newG = g[i,j] + cost

                if newG < g[ni,nj]
                    g[ni,nj] = newG
                    parent[(ni,nj)] = current

                    f = newG + Utils.manhattan((ni,nj), A)
                    pq[(ni,nj)] = f
                end
            end
        end
    end

    if g[A...] == Inf
        return -1, statesEvaluated, Tuple{Int,Int}[]
    end

    path = Tuple{Int,Int}[]
    current = A

    while current != D
        push!(path, current)
        current = parent[current]
    end

    push!(path, D)
    reverse!(path)

    return g[A...], statesEvaluated, path
end

end