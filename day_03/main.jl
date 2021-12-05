# Part I

open("input.txt") do input
    line = readline(input)
    digits_count = length(line)

    @assert digits_count <= 64

    one_frequency = zeros(UInt64, digits_count)
    zero_frequency = zeros(UInt64, digits_count)

    begin
        pattern = parse(UInt64, line, base = 2)

        for i = 1:digits_count
            digit = (pattern >> (i-1)) & 1
            one_frequency[i] += digit
            zero_frequency[i] += xor(digit, 1)
        end
    end

    while !eof(input)
        line = readline(input)
        pattern = parse(UInt64, line, base = 2)

        @assert digits_count == length(line)

        for i = 1:digits_count
            digit = (pattern >> (i-1)) & 1
            one_frequency[i] += digit
            zero_frequency[i] += xor(digit, 1)
        end
    end

    gamma_rate::UInt64 = 0
    epsilon_rate::UInt64 = 0

    for i = 1:digits_count
        is_one = UInt64(one_frequency[i] > zero_frequency[i])
        is_zero = UInt64(one_frequency[i] < zero_frequency[i])

        is_one <<= (i-1)
        is_zero <<= (i-1)

        gamma_rate |= is_one
        epsilon_rate |= is_zero
    end

    println("Part I:")
    println("  Gamma Rate: ", gamma_rate)
    println("  Epsilon Rate: ", epsilon_rate)
    println("  Answer: ", gamma_rate * epsilon_rate)
end

# Part II

@enum RATE oxygen CO2

function filter_numbers(numbers :: Vector{UInt64}, bit_position :: Int64, rate :: RATE)
    zeros_counter = 0
    ones_counter = 0

    for i = 1:length(numbers)
        digit = (numbers[i] >> (bit_position-1)) & 1
        ones_counter += digit
        zeros_counter += xor(digit, 1)
    end

    criteria_digit = UInt64(rate === oxygen ? ones_counter >= zeros_counter : ones_counter < zeros_counter)
    return filter(number -> ((number >> (bit_position-1)) & 1) == criteria_digit, numbers)
end

open("input.txt") do input
    numbers = Vector{UInt64}()

    line = readline(input)
    digits_count = length(line)

    @assert digits_count <= 64

    begin
        append!(numbers, parse(UInt64, line, base = 2))
    end

    while !eof(input)
        line = readline(input)
        @assert digits_count == length(line)

        append!(numbers, parse(UInt64, line, base = 2))
    end

    oxygen_numbers = numbers
    CO2_numbers = numbers

    for i = digits_count:-1:1
        oxygen_numbers = filter_numbers(oxygen_numbers, i, oxygen)

        if length(oxygen_numbers) == 1
            break
        end
    end


    for i = digits_count:-1:1
        CO2_numbers = filter_numbers(CO2_numbers, i, CO2)

        if length(CO2_numbers) == 1
            break
        end
    end

    println("Part II:")
    println("  Oxygen Generator Rating: ", oxygen_numbers[1])
    println("  CO2 Scrubber Rating: ", CO2_numbers[1])
    println("  Answer: ", oxygen_numbers[1] * CO2_numbers[1])
end