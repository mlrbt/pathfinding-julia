module AStarAlgo

using ..Utils

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

    g[D[1], D[2]] = 0.0

    statesEvaluated = 0

    while true

        minF = Inf
        current = nothing

        for i in 1:height
            for j in 1:width
                if !visited[i,j] && g[i,j] < Inf
                    f = g[i,j] + Utils.manhattan((i,j), A)
                    if f < minF
                        minF = f
                        current = (i,j)
                    end
                end
            end
        end

        if current === nothing
            break
        end

        i, j = current
        visited[i,j] = true
        statesEvaluated += 1

        if current == A
            break
        end

        neighbors = Utils.getNeighbors(grid, i, j)

        for n in neighbors
            ni, nj = n

            if !visited[ni,nj]

                cost = Utils.movementCost(grid, ni, nj)
                newG = g[i,j] + cost

                if newG < g[ni,nj]
                    g[ni,nj] = newG
                    parent[n] = current
                end
            end
        end
    end

    if g[A[1], A[2]] == Inf
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

    return g[A[1], A[2]], statesEvaluated, path
end

end