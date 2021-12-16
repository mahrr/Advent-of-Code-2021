# Common

struct Info
    match :: Char
    is_opening :: Bool
    value :: Int
end

map = Dict{}([
    (')', Info('(', false,     3)),
    (']', Info('[', false,    57)),
    ('}', Info('{', false,  1197)),
    ('>', Info('<', false, 25137)),

    ('(', Info(')', true,    1)),
    ('[', Info(']', true,    2)),
    ('{', Info('}', true,    3)),
    ('<', Info('>', true,    4)),
])

# Part I

function part1()
    input = open("input.txt")
    points = 0

    while !eof(input)
        stack :: Vector{Char} = []

        for char in readline(input)
            if map[char].is_opening
                push!(stack, char)
            else
                info = map[char]
                if info.match != pop!(stack)
                    points += info.value
                    break
                end
            end
        end
    end

    close(input)
    return points
end

# Part II

function  part2()
    input = open("input.txt")
    scores :: Vector{Int} = []

    while !eof(input)
        stack :: Vector{Char} = []
        corrupted = false

        for char in readline(input)
            if map[char].is_opening
                push!(stack, char)
            else
                if map[char].match != pop!(stack)
                    corrupted = true
                    break
                end
            end
        end

        if !corrupted
            score = 0

            while length(stack) != false
                opening = pop!(stack)
                score = score*5 + map[opening].value
            end

            push!(scores, score)
        end
    end

    close(input)

    sort!(scores)
    return scores[ceil(Int, length(scores) / 2)]
end

# Result

println("Part I: ", part1())
println("Part II: ", part2())
