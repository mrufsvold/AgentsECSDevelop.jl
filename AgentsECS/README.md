# AgentsECS.jl

An opinionated, Entity-Component-System based framework for Agent-Based Modeling. AgentsECS
tries to help parallize stepping the model and assure that all manipulation of entities and
model variables are free of race conditions and ABA problems. 

## Getting Started
Create a new directory for your modeling project and open a REPL in that directory. Then run
```
julia> ] # Open Pkg
(@v1.8) pkg> activate .
(YourProjectName) pkg> activate .
(YourProjectName) pkg> add AgentsECS
# Backspace to exit pkg
julia> using AgentsECS
julia> generate_AgentsESC_project()
```
The last function will generate the folder structure that this package will use to read in
the ECS that you define. From there, you can fill in the specifics of your model and run
the `main()` function in `src/model.jl` to run the simulation.

## Creating your first model
TODO = add instructions :)

## What is ECS
Entity-Component-System is an architecture born out of video game programming that prioritizes
data-oriented design over object-oriented design. ECS is named after its three essential elements:
1. **Entities** are the things in the simulation. They can be people, cars, animals, rocks, etc.
An entity would normally be represented as an instantiation of a class in an OOO design. In
ECS, an entity is an integer that points to the index of the thing's value in an array of values
for any given component.
2. **Components** are the attributes of things in the simulation. This can be things like
CanFly (Bool), Age (Int), or Parent (Index to another Entity). All entities have some value
for all components (i.e. `Rock.CanFly = false`), whereas in OOO, you would usually only give
attributes to a class if they make logical sense in the real world.
3. **Systems** is a set of one or more functions used to analyze and update the state of the 
world and entities. There might be a Physics System that finds and process collisions or a 
Disease System that processes the spread of a disease through a graph of people.

In OOO, we normally store the data for the objects in our model in an array of structs. Updates
are done by iterating over that and handling each object with the functions that are stored
in the class. ECS stores the data for object as a struct of arrays. Each component is a
property of the World that contains a vector of length N (where N is the number of entities).
Then we can access the properties of a certain entity by indexing into each component.

For example:
```
# OOO Structure:
struct Agent1
    prop1
    prop2
end
struct World
    Agents::Vector{Agents1}
end

myworld = World([Agent1(1,"A"), Agent1(6,"B")])
# Access the first agent's second property
myworld.Agents.prop2

# ECS Structure:
struct World
    props1
    props2
end
myworld = World([1,6], ["A","B"])
# Access first agent's second property
myworld.props2[1]
```
## Why ECS
Many developers learned to code in an object-oriented style. It has lots of benefits for
reasoning about a system and maintaining clean code. If it ain't broke, why fix it?
### Performance
First and foremost, ECS enables data-oriented design which is makes it generally easier to 
optomize code and take advantage of the hardware in a computer.

#### Parallelization
It can be difficult to parallelize OOO code because, for an operation to update the values
of an agent, no other processes can be reading or writing to the agent and all the other 
agents that the process needs to reference to make the update must not be changed during
the operation. 

ECS allows us to dictate which components need to be protected during an operation, so 
systems can work on all agents simultaneously in parallel as long as they are not writing
to the same components. That means we can put more precise locks on data and parallize more 
operations.

#### Memory and Cache
Further, by operating on arrays of single datatypes (instead of an array of different objects)
we work with the architecture of our machines. Without going into too low-level details
modern processors do two things to go faster that we can take advantage of.

First, processors store instructions that it is using over and over. When you iterate over 
many objects with different functions, each iteration might require the CPU to read in
new instructions. Julia's dispatch system does some work to improve this, but you will still
get cases where the processor needs to flush its instruction cache. When you run the same 
function over an array with a known datatype, the CPU does not need to flush its instruction 
cache over and over which greatly improves its performance.

Second, processors store data ready for operations in their cache. Cache memory is 100x faster 
than RAM. When you are reading data from objects that are scattered all over the memory "heap",
you are unlikely to find any of the data you need already cached. On the other hand,
iterating over an array of a bitstype values (Ints, Floats, Bools), etc. allows the processor
to request one contiguous chunk of memory, operate over that chunk in the cache, and meanwhile,
request another contiguous chunk of data to fill the cache when it's done. This is
enormously more efficient 

