module BFSAlgo

using ..Utils

export algoBFS

"""
    algoBFS(fname, D, A)

Implémentation du parcours en largeur (Breadth-First Search).

Paramètres :
- fname : nom du fichier .map
- D     : position de départ (i,j)
- A     : position d’arrivée (i,j)

Retourne :
- distance
- number of states evaluated
- path (liste des positions)
"""
function algoBFS(fname, D::Tuple{Int,Int}, A::Tuple{Int,Int})

    grid, height, width = Utils.readMap(fname)

    # File FIFO
    queue = [D]

    # Matrice visited
    visited = falses(height, width)

    # Dictionnaire pour reconstruire le chemin
    parent = Dict{Tuple{Int,Int}, Tuple{Int,Int}}()

    visited[D[1], D[2]] = true

    statesEvaluated = 0

    while !isempty(queue)

        current = popfirst!(queue)
        statesEvaluated += 1

        if current == A
            break
        end

        neighbors = Utils.getNeighbors(grid, current[1], current[2])

        for n in neighbors
            if !visited[n[1], n[2]]

                visited[n[1], n[2]] = true
                parent[n] = current
                push!(queue, n)

            end
        end
    end

    # Reconstruction du chemin
    path = Tuple{Int,Int}[]

    if !haskey(parent, A) && D != A
        return -1, statesEvaluated, path
    end

    current = A

    while current != D
        push!(path, current)
        current = parent[current]
    end

    push!(path, D)
    reverse!(path)

    distance = length(path) - 1


    return distance, statesEvaluated, path
end

end