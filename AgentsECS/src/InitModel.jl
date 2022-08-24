using StructArrays

struct World <: Any
    Components
    Properties
    Config
    Space
    FieldStatuses
end


function World(Properties, Config, Space)
    
    # Get a list of all defined components and create a property line for defining
    # the Components struct
    components = [
        "$(Symbol(component))::$(Symbol(component().type)) = $(Symbol(component().null))"
        for component in subtypes(Component)
    ]

    null_entity_constructor = """Base.@kwdef struct BaseEntity <: Entity
$(join(components, "\n"))
end"""
        
    eval(Meta.parse(null_entity_constructor))

    return World(StructArray{BaseEntity}(undef,0), Properties, Config, Space, 
    Dict{String, Vector{Tuple{Char, String}}}())

end
