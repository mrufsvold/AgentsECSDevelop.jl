using AgentsECS

macro test(expr1, expr2)
    dump(expr1)
    dump(expr2)
end

@test adult (CovidStatus, Age, RidesBus = false)
@Entity child (CovidStatus, Age, RidesBus, Guardians)
