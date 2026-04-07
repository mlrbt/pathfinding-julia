include("src/utils.jl")
include("src/astar.jl")
include("src/multi_amr.jl")

using .MultiAMR

println("======================================")
println("  CONFLITS MULTI-AMR")
println("======================================")

# =========================
# QUAIS
# =========================

Q1 = MultiAMR.Quai(1, (2,4))
Q2 = MultiAMR.Quai(2, (2,19))
Q3 = MultiAMR.Quai(3, (2,34))

Q4 = MultiAMR.Quai(4, (10,4))
Q5 = MultiAMR.Quai(5, (10,19))
Q6 = MultiAMR.Quai(6, (10,34))

# =========================
# SCENARIO
# =========================

missions = [

    #  collision frontale dans le goulot
    MultiAMR.Mission(1, Q1, Q6, 1),
    MultiAMR.Mission(2, Q6, Q1, 1),

    #  autre flux qui crée congestion
    MultiAMR.Mission(3, Q2, Q5, 2),

    #  croisement + pression
    MultiAMR.Mission(4, Q3, Q4, 3)
]

# =========================
# EXECUTION
# =========================

MultiAMR.runMultiAMRFromMissions("dat/crossdock/demo_oral.map", missions)

println("\n======================================")
println("   FIN DEMO")
println("======================================")