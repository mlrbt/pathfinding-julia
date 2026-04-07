module Scenarios

using ..MultiAMR

export scenario_demo_oral,
       scenario_goulot_strict,
       scenario_crossdock_simple,
       scenario_crossdock_14

# ======================================
# SCENARIO 1 — DEMO ORAL (conflits)
# ======================================

function scenario_demo_oral()

    Q1 = MultiAMR.Quai(1, (2,4))
    Q2 = MultiAMR.Quai(2, (2,19))
    Q3 = MultiAMR.Quai(3, (2,34))

    Q4 = MultiAMR.Quai(4, (10,4))
    Q5 = MultiAMR.Quai(5, (10,19))
    Q6 = MultiAMR.Quai(6, (10,34))

    missions = [
        MultiAMR.Mission(1, Q1, Q6, 1),
        MultiAMR.Mission(2, Q6, Q1, 1),
        MultiAMR.Mission(3, Q2, Q5, 2),
        MultiAMR.Mission(4, Q3, Q4, 3)
    ]

    return "dat/crossdock/demo_oral.map", missions
end

# ======================================
# SCENARIO 2 — GOULOT STRICT
# ======================================

function scenario_goulot_strict()

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

    missions = [
        MultiAMR.Mission(1, Q1, Q6, 1),
        MultiAMR.Mission(2, Q6, Q1, 1),
        MultiAMR.Mission(3, Q2, Q7, 2),
        MultiAMR.Mission(4, Q3, Q8, 3)
    ]

    return "dat/crossdock/goulot_strict.map", missions
end

# ======================================
# SCENARIO 3 — CROSSDOCK SIMPLE
# ======================================

function scenario_crossdock_simple()

    Q1 = MultiAMR.Quai(1, (2,2))
    Q2 = MultiAMR.Quai(2, (2,25))
    Q3 = MultiAMR.Quai(3, (10,2))
    Q4 = MultiAMR.Quai(4, (10,25))

    missions = [
        MultiAMR.Mission(1, Q1, Q2, 1),
        MultiAMR.Mission(2, Q2, Q1, 1),
        MultiAMR.Mission(3, Q3, Q4, 2)
    ]

    return "dat/crossdock/crossdock.map", missions
end

# ======================================
# SCENARIO 4 — CROSSDOCK 14 QUAIS
# ======================================

function scenario_crossdock_14()

    Q1  = MultiAMR.Quai(1, (1,4))
    Q2  = MultiAMR.Quai(2, (1,9))
    Q3  = MultiAMR.Quai(3, (1,14))
    Q4  = MultiAMR.Quai(4, (1,19))
    Q5  = MultiAMR.Quai(5, (1,24))
    Q6  = MultiAMR.Quai(6, (1,29))
    Q7  = MultiAMR.Quai(7, (1,34))

    Q8  = MultiAMR.Quai(8,  (11,34))
    Q9  = MultiAMR.Quai(9,  (11,29))
    Q10 = MultiAMR.Quai(10, (11,24))
    Q11 = MultiAMR.Quai(11, (11,19))
    Q12 = MultiAMR.Quai(12, (11,14))
    Q13 = MultiAMR.Quai(13, (11,9))
    Q14 = MultiAMR.Quai(14, (11,4))

    missions = [
        MultiAMR.Mission(1, Q1, Q8, 1),
        MultiAMR.Mission(2, Q8, Q1, 1),
        MultiAMR.Mission(3, Q2, Q9, 2),
        MultiAMR.Mission(4, Q3, Q10, 3),
        MultiAMR.Mission(5, Q14, Q7, 4)
    ]

    return "dat/crossdock/crossdock14.map", missions
end

end