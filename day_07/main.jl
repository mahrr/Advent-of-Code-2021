# Common

function parse_input() :: Tuple{Vector{Int}, Int, Int}
    input = open("input.txt")
    positions = split(readline(input), ',')
    close(input)

    values = []
    min = Inf
    max = -Inf
    for position in positions
        value = parse(Int, position)
        push!(values, value)

        if value > max
            max = value
        end

        if value < min
            min = value
        end
    end
    return (values, min, max)
end

# Part I

function part1()
    positions, min, max = parse_input()
    minimum_cost = Inf

    for position in min:max
        position_cost = mapreduce(other -> abs(position - other), +, positions)
        if position_cost < minimum_cost
            minimum_cost = position_cost
        end
    end

    return minimum_cost
end

# Part II

function part2()
    positions, min, max = parse_input()
    minimum_cost = Inf

    for position in min:max
        reducer = other -> begin
            delta = abs(position - other)
            Int((delta+1)/2 * delta)
        end

        position_cost = mapreduce(reducer, +, positions)
        if position_cost < minimum_cost
            minimum_cost = position_cost
        end
    end

    return minimum_cost
end

# Result

println("Part I: ", part1())
println("Part II: ", part2())