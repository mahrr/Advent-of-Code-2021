# Part I

open("input.txt") do input
    previous_number = parse(Int64, readline(input))
    increase_counter = 0

    while !eof(input)
        number = parse(Int64, readline(input))
        if number > previous_number
            increase_counter += 1
        end
        previous_number = number
    end

    println("Part I: ", increase_counter)
end


# Part II

open("input.txt") do input
    number1 = parse(Int64, readline(input))
    number2 = parse(Int64, readline(input))
    number3 = parse(Int64, readline(input))

    previous_sum = number1 + number2 + number3
    increase_counter = 0

    while !eof(input)
        number1 = number2
        number2 = number3
        number3 = parse(Int64, readline(input))

        sum = number1 + number2 + number3
        if sum > previous_sum
            increase_counter += 1
        end
        previous_sum = sum
    end

    println("Part II: ", increase_counter)
end