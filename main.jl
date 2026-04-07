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
println("1 - Demo oral (conflits)")
println("2 - Goulot strict")
println("3 - Crossdock simple")
println("4 - Crossdock 14 quais")

print("Votre choix : ")
choice = parse(Int, readline())

mapFile = ""
missions = []

if choice == 1
    mapFile, missions = Scenarios.scenario_demo_oral()

elseif choice == 2
    mapFile, missions = Scenarios.scenario_goulot_strict()

elseif choice == 3
    mapFile, missions = Scenarios.scenario_crossdock_simple()

elseif choice == 4
    mapFile, missions = Scenarios.scenario_crossdock_14()

else
    error("Choix invalide")
end

println("\nLancement simulation...\n")

MultiAMR.runMultiAMRFromMissions(mapFile, missions)

println("\n======================================")
println("   FIN DEMO")
println("======================================")