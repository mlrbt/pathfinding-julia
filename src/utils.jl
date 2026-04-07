module Utils

export readMap

"""
    readMap(fname::String)

Je charge une instance .map depuis le dossier `dat/`.
Je respecte le format MovingAI (header + grille).

Retourne :
- grid  :: Matrix{Char}
- height :: Int
- width  :: Int
"""
function readMap(fname::String)

    lines = readlines(fname)

    height = parse(Int, split(lines[2])[2])
    width  = parse(Int, split(lines[3])[2])

    grid = fill('@', height, width)

    map_lines = lines[5:end]

    for i in 1:height

        line = rstrip(map_lines[i])  # enlève espaces invisibles

        if length(line) < width
            # complète la ligne si trop courte
            line *= repeat(".", width - length(line))
        end

        if length(line) > width
            # coupe si trop longue
            line = line[1:width]
        end

        for j in 1:width
            grid[i,j] = line[j]
        end
    end

    return grid, height, width
end



"""
    getNeighbors(grid, i, j)

Retourne la liste des cases voisines accessibles
(Nord, Sud, Est, Ouest uniquement).
Les obstacles '@' sont exclus.
"""
function getNeighbors(grid, i, j)

    height, width = size(grid)

    neighbors = Tuple{Int,Int}[]

    # Nord
    if i > 1 && grid[i-1, j] != '@'
        push!(neighbors, (i-1, j))
    end

    # Sud
    if i < height && grid[i+1, j] != '@'
        push!(neighbors, (i+1, j))
    end

    # Ouest
    if j > 1 && grid[i, j-1] != '@'
        push!(neighbors, (i, j-1))
    end

    # Est
    if j < width && grid[i, j+1] != '@'
        push!(neighbors, (i, j+1))
    end

    return neighbors
end

"""
    movementCost(grid, i, j)

Retourne le coût pour entrer dans la case (i,j)
"""
function movementCost(grid, i, j)

    if grid[i,j] == 'S'
        return 5
    elseif grid[i,j] == 'W'
        return 8
    else
        return 1
    end
end

"""
    manhattan(a, b)

Distance de Manhattan entre deux positions.
Admissible car pas de diagonale autorisée.
"""
function manhattan(a::Tuple{Int,Int}, b::Tuple{Int,Int})
    return abs(a[1] - b[1]) + abs(a[2] - b[2])
end

end