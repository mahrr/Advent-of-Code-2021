# Common

function parse_input(path) :: Vector{Vector{Int8}}
    input = open(path)
    result :: Vector{Vector{Int8}} = []

    while !eof(input)
        line = readline(input)
        row = map(c -> parse(Int8, c), collect(line))
        push!(result, row)
    end

    close(input)
    return result
end

function pump(levels, flashed, x, y) :: Int
    if flashed[y][x]
        return 0
    end

    if levels[y][x] != 9
        levels[y][x] += 1
        return 0
    end

    flashed[y][x] = true
    levels[y][x] = 0
    sum = 1

    at_left = x == 1
    at_right = x == length(levels[1])

    at_top = y == 1
    at_bottom = y == length(levels)

    # left
    if !at_left
        sum += pump(levels, flashed, x-1, y)

        if !at_top
            sum += pump(levels, flashed, x-1, y-1)
        end

        if !at_bottom
            sum += pump(levels, flashed, x-1, y+1)
        end
    end

    # right
    if !at_right
        sum += pump(levels, flashed, x+1, y)

        if !at_top
            sum += pump(levels, flashed, x+1, y-1)
        end

        if !at_bottom
            sum += pump(levels, flashed, x+1, y+1)
        end
    end

    # top
    if !at_top
        sum += pump(levels, flashed, x, y-1)
    end

    if !at_bottom
        sum += pump(levels, flashed, x, y+1)
    end

    return sum
end

function simulate(levels :: Vector{Vector{Int8}}) :: Int
    flashed :: Vector{Vector{Bool}} = map(row -> map(_ -> false, row), levels)
    result = 0

    for y in 1:length(levels)
        for x in 1:length(levels[y])
            result += pump(levels, flashed, x, y)
        end
    end

    return result
end

# Part I

function part1()
    levels = parse_input("input.txt")
    result = 0

    for _ = 1:100
        result += simulate(levels)
    end

    return result
end

# Part II

function  part2()
    levels = parse_input("input.txt")
    elements_count = length(levels) * length(levels[1])

    step = 1
    while true
        if simulate(levels) == elements_count
            break
        end
        step += 1
    end

    return step
end

# Result

println("Part I: ", part1())
println("Part II: ", part2())
