using Graphs

# TODO figure out how to wrap this in a macro. Getting @__FILE__ to work right is challenging
for directory in ["Components","Entities", "Systems"]
    dirpath = joinpath(@__DIR__, directory)
    for file in readdir(dirpath, join=true)
        include(file)
    end
end




struct Config end

function init_properties()
    return Properties(0, false)
end

function main()
    config = Config()
    properties = init_properties()
    space = SimpleDiGraph()

    world = World(properties, config, space)
    return world
end

main()
