include("src/utils.jl")
include("src/astar.jl")
include("src/multi_amr.jl")

using .MultiAMR

println("======================================")
println("   DEMO CROSSDOCK MULTI-AMR (QUAIS)")
println("======================================")

# =========================
# DEFINITION DES QUAIS
# =========================

Q1 = MultiAMR.Quai(1, (2,2))
Q2 = MultiAMR.Quai(2, (2,25))
Q3 = MultiAMR.Quai(3, (10,2))
Q4 = MultiAMR.Quai(4, (10,25))

# =========================
# MISSIONS (logique métier)
# =========================

missions = [
    MultiAMR.Mission(1, Q1, Q2, 1),  # gauche → droite
    MultiAMR.Mission(2, Q2, Q1, 1),  # droite → gauche → conflit frontal
    MultiAMR.Mission(3, Q3, Q4, 2)   # flux parallèle
]

# =========================
# LANCEMENT
# =========================

MultiAMR.runMultiAMRFromMissions("dat/crossdock/crossdock.map", missions)

println("\n======================================")
println("   FIN DEMO")
println("======================================")