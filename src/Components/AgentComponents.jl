
"""The age of an entity in years"""
Base.@kwdef struct Age <: Component
    type = UInt8
    null = UInt8(0)
end

"""Indicates whether the entity rides the bus"""
Base.@kwdef struct RidesBus <: Component
    type = Bool
    null = false
    default = true
end

"""Indicates the current health status in the Covid infection cycle"""
@enum Status no_status healthy asymptomatic symptomatic recovered
Base.@kwdef struct CovidStatus <: Component
    type = Status
    null = no_status
    default = healthy
end

const u64 = UInt64(0)
"""Points to the guardian(s) of the entity"""
Base.@kwdef struct Guardians <: Component
    type = NTuple{4, UInt64}
    null = (u64, u64, u64, u64)
    default = (u64, u64, u64, u64)
end
