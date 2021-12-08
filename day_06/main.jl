# Common

CYCLES_TO_SPAWN = 7
NEW_COMER_TIMER = 8

calculation_cache = Dict{Int, Int}()

function calculate_spawns(timer, days) :: Int
    if days <= timer
        return 0
    end

    cycles = days - timer - 1
    spawns = trunc(Int, cycles / CYCLES_TO_SPAWN) + 1

    if haskey(calculation_cache, cycles)
        return calculation_cache[cycles]
    end

    remaining_cycles = cycles
    for _ = 1:spawns
        spawns += calculate_spawns(NEW_COMER_TIMER, remaining_cycles)
        remaining_cycles -= CYCLES_TO_SPAWN
    end

    calculation_cache[cycles] = spawns
    return spawns
end

function simulate(days) :: Int
    timers = parse_input()
    result = length(timers)

    for timer in timers
        result += calculate_spawns(timer, days)
    end

    return result
end

function parse_input() :: Vector{Int}
    input = open("input.txt")
    timers = split(readline(input), ',')
    close(input)
    return map(s -> parse(Int, s), timers)
end

# Part I
println("Part I: ", simulate(80))

# Part II
println("Part II: ", simulate(256))