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

    # Je lis toutes les lignes du fichier
    lines = readlines(joinpath("dat", fname))

    height = 0
    width = 0
    grid_start = 0

    # Je parcours le header pour récupérer height et width
    for (i, line) in enumerate(lines)

        if startswith(line, "height")
            height = parse(Int, split(line)[2])

        elseif startswith(line, "width")
            width = parse(Int, split(line)[2])

        elseif line == "map"
            grid_start = i + 1
            break
        end
    end

    # Je vérifie que les dimensions ont bien été trouvées
    if height == 0 || width == 0
        error("Erreur : format .map invalide (height ou width manquant).")
    end

    # J’alloue explicitement la matrice (performance maîtrisée)
    grid = Array{Char}(undef, height, width)

    # Je remplis la grille caractère par caractère
    for i in 1:height
        row = lines[grid_start + i - 1]
        for j in 1:width
            grid[i, j] = row[j]
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