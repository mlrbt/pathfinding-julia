include("src/utils.jl")
include("src/astar.jl")
include("src/multi_amr.jl")

using .MultiAMR

println("======================================")
println("   DEMO GOULOT + QUAIS STRUCTURÉS")
println("======================================")

# =========================
# QUAIS
# =========================

Q1 = MultiAMR.Quai(1, (2,4))
Q2 = MultiAMR.Quai(2, (2,9))
Q3 = MultiAMR.Quai(3, (2,14))
Q4 = MultiAMR.Quai(4, (2,19))
Q5 = MultiAMR.Quai(5, (2,24))
Q6 = MultiAMR.Quai(6, (2,29))

Q7  = MultiAMR.Quai(7, (8,29))
Q8  = MultiAMR.Quai(8, (8,24))
Q9  = MultiAMR.Quai(9, (8,19))
Q10 = MultiAMR.Quai(10, (8,14))
Q11 = MultiAMR.Quai(11, (8,9))
Q12 = MultiAMR.Quai(12, (8,4))

# =========================
# SCÉNARIO CLÉ
# =========================

missions = [
    #  collision frontale PARFAITE dans le goulot
    MultiAMR.Mission(1, Q1, Q6, 1),
    MultiAMR.Mission(2, Q6, Q1, 1),

    # ajoute pression
    MultiAMR.Mission(3, Q2, Q7, 2),

    #  trafic croisé
    MultiAMR.Mission(4, Q3, Q8, 3)
]

# =========================
# EXECUTION
# =========================

MultiAMR.runMultiAMRFromMissions("dat/crossdock/goulot_strict.map", missions)

println("\n======================================")
println("   FIN DEMO")
println("======================================")