module AStarAlgo

using ..Utils
using DataStructures

export algoAstarTime

function isNodeForbidden(pos, time, node_constraints)

    for c in node_constraints
        if c.position == pos && c.time == time
            return true
        end
    end

    return false
end

function isEdgeForbidden(from, to, time, edge_constraints)

    for c in edge_constraints
        if c.from == to && c.to == from && c.time == time
            return true
        end
    end

    return false
end

function algoAstarTime(fname, D, A, start_time, node_constraints, edge_constraints)

    max_time = 1000

    grid, height, width = Utils.readMap(fname)

    g = Dict{Tuple{Int,Int,Int}, Float64}()
    parent = Dict{Tuple{Int,Int,Int}, Tuple{Int,Int,Int}}()

    pq = PriorityQueue{Tuple{Int,Int,Int}, Float64}()

    start = (D[1], D[2], start_time)

    g[start] = 0.0
    pq[start] = 0.0

    statesEvaluated = 0

    while !isempty(pq)

        current = dequeue!(pq)
        i, j, t = current

        # Si cette entrée de file est dépassée, on l’ignore
        # Cela évite de traiter plusieurs fois un état avec un coût obsolète.
        current_priority = g[current] + Utils.manhattan((i, j), A)
        if current_priority < 0
            continue
        end

        statesEvaluated += 1

       if (i, j) == A
            println("GOAL REACHED AT: ", (i, j), " time=", t)
            println("EXPECTED GOAL: ", A)
            return g, parent, statesEvaluated
        end

        neighbors = Utils.getNeighbors(grid, i, j)

        # attente autorisée
        push!(neighbors, (i, j))

        for (ni, nj) in neighbors

            nt = t + 1

            if nt > max_time
                continue
            end

            if isNodeForbidden((ni, nj), nt, node_constraints)
                continue
            end

            if isEdgeForbidden((i, j), (ni, nj), t, edge_constraints)
                continue
            end

            new_state = (ni, nj, nt)

            cost = Utils.movementCost(grid, ni, nj)

            # On préfère légèrement l’attente aux détours inutiles
            if (ni, nj) == (i, j)
                cost = 0.5
            end

            newG = g[current] + cost

            if !haskey(g, new_state) || newG < g[new_state]
                g[new_state] = newG
                parent[new_state] = current

                f = newG + Utils.manhattan((ni, nj), A)
                pq[new_state] = f
            end
        end
    end

    return g, parent, statesEvaluated
end

end