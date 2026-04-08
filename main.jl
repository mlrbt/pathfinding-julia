include("src/utils.jl")
include("src/astar.jl")
include("src/multi_amr.jl")
include("scenarios.jl")

using .MultiAMR
using .Scenarios

println("======================================")
println("   MULTI-AMR DEMO")
println("======================================")

println("Choisir un scénario :")
println("1 - Demo  (conflits)")
println("2 - Goulot strict")
println("3 - Swap demo")
println("4 - No collisions")
println("5 - Wait demo")
println("6 - Sequential demo")
print("Votre choix : ")

choice = parse(Int, readline())

mapFile = ""
missions = []

if choice == 1
    mapFile, missions = Scenarios.scenario_demo_oral()

elseif choice == 2
    mapFile, missions = Scenarios.scenario_goulot_strict()

elseif choice == 3
    mapFile, missions = Scenarios.scenario_swap_demo()

elseif choice == 4
    mapFile, missions = Scenarios.scenario_no_collision()    
elseif choice == 5
    mapFile, missions = Scenarios.scenario_wait_demo()
elseif choice == 6
    mapFile, missions = Scenarios.scenario_sequential_demo()
else
    error("Choix invalide")
end

println("\nLancement simulation...\n")

MultiAMR.runMultiAMRFromMissions(mapFile, missions)

println("\n======================================")
println("   FIN DEMO")
println("======================================")