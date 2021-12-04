# Part I

open("input.txt") do input
    horizontal_position = 0
    depth = 0

    while !eof(input)
        command, x = split(readline(input))

        if command == "forward"
            horizontal_position += parse(Int64, x)
        elseif command == "up"
            depth -= parse(Int64, x)
        elseif command == "down"
            depth += parse(Int64, x)
        end
    end

    println("Part I:")
    println("  Horizontal Position: ", horizontal_position)
    println("  Depth: ", depth)
    println("  Answer: ", horizontal_position * depth)
end

# Part II

open("input.txt") do input
    horizontal_position = 0
    depth = 0
    aim = 0

    while !eof(input)
        command, x = split(readline(input))
        x_value = parse(Int64, x)

        if command == "forward"
            horizontal_position += x_value
            depth += aim * x_value
        elseif command == "up"
            aim -= x_value
        elseif command == "down"
            aim += x_value
        end
    end

    println("Part II:")
    println("  Horizontal Position: ", horizontal_position)
    println("  Depth: ", depth)
    println("  Answer: ", horizontal_position * depth)
end