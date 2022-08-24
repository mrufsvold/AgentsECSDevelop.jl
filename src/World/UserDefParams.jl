
"""Here the user can define world properties that can be accessed in the Systems"""
Base.@kwdef mutable struct Properties
    Time::UInt64 = UInt64(0)
    StayInPlaceOrder::Bool = false
end

"""Here the user can define read-only configuration values for initializing the model"""
struct Configuration

end
