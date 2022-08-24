
abstract type Component <: Any end
abstract type Entity <: Any end
abstract type System <: Any end
abstract type SystemStep <: Any end


"""@Component(expr)
The @Component macro takes a component struct with the properties :type, :null, and (optional)
:default and constructs two things. First, a struct that subtype of Component. Second,
an external constructor with the default values.

The macro raises exceptions if the input is not a struct, the fields are incorrect, or the 
user added a supertype to the struct definition.
"""
macro Component(base_struct)
    @assert base_struct.head == :struct "Component definition must be a struct"
    component_name = base_struct.args[2]
    @assert typeof(component_name) == Symbol "Component definition should not be subtyped"
    base_struct.args[2] = Expr(Symbol("<:"), component_name, :Component)

    # Get list of field names
    fields = [field.args[1] for field in base_struct.args[3].args if typeof(field) == Expr]
    
    @assert all(in.([:type, :null], Ref(fields))) "Component must define a type and null field"

    # TODO -- check if Null and Default values match the type of :type. If not, update type
    # to a union.
    finalexpr = Expr(
        :macrocall,
        Expr(Symbol("."), :Base, QuoteNode(Symbol("@kwdef"))),
        base_struct.args[1],
        base_struct
    )
    dump(finalexpr)
    finalexpr

end

macro Entity(entity_name, entity_components)
    @assert typeof(entity_name) == Symbol "First argument of @Entity must be a symbol with the entity name."
    @assert typeof(entity_components) == Expr && entity_components.head == :tuple "Second argument of @Entity must be a tuple"

    @show subtypes(Component)
    """struct $entity_name <: Entity

    """

    # Can I look up subtypes of Component from macro?
    Expr(
        :struct,
        false,
        Expr(Symbol("<:"), entity_name, :Entity),
        Expr(:block, ) #Expr 

    )
    # Take a entity type name and a tuple of component names
    # A component can be "= newdefault" to overwrite the component's default
    # Create a new subtype of Entity with fields for each defined component set to null except
    # Set components declared for this entity type to default
    # Use Base.@kwdef to make the default constructor function
end


# Need to create a BaseEntity constructor that all of the entity type constructors can 
# call to get defaults
# ** This could probably use Tricks.jl to precompile BaseEntities with all of the subtypes
# To avoid looking them up everytime we add an entity

macro System()

end


macro includeESC()
    quote
        for directory in ["Components","Entities", "Systems"]
            dirpath = joinpath(@__DIR__, directory)
            for file in readdir(dirpath, join=true)
                include(file)
            end
        end
    end
end


@includeESC

