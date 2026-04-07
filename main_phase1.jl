include("src/utils.jl")
include("src/bfs.jl")
include("src/dijkstra.jl")
include("src/astar_phase1.jl")
include("src/greedy.jl")
import .BFSAlgo
import .DijkstraAlgo
import .AStarAlgo
import .GreedyAlgo

"""
    runAlgo(algoName, fname, D, A)

Exécute l’algorithme demandé et affiche
les résultats conformément aux consignes.
"""
function runAlgo(algoName::String, fname::String, D, A)

    t = @elapsed begin

        if algoName == "BFS"
            dist, states, path = BFSAlgo.algoBFS(fname, D, A)

        elseif algoName == "Dijkstra"
            dist, states, path = DijkstraAlgo.algoDijkstra(fname, D, A)

        elseif algoName == "Astar"
            dist, states, path = AStarAlgo.algoAstar(fname, D, A)

        elseif algoName == "Greedy"
            dist, states, path = GreedyAlgo.algoGlouton(fname, D, A)

        else
            error("Algorithme inconnu.")
        end
    end

    println("Distance D → A : ", dist)
    println("Number of states evaluated : ", states)
    println("Path D → A : ", join(path, "→"))
    println("CPU time (s) : ", t)
end