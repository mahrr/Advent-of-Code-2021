# Common

struct Entry
    patterns :: Vector{String}
    digits   :: Vector{String}
end

function parse_input() :: Vector{Entry}
    input = open("input.txt")
    entries = []

    while !eof(input)
        patterns, digits = split(readline(input), '|')
        entry = Entry(split(patterns), split(digits))
        push!(entries, entry)
    end

    close(input)
    return entries
end

# Part I

function part1() :: Int
    entries = parse_input()
    count = 0

    for entry in entries
        for digit in entry.digits
            len = length(digit)
            count += Int(len == 2 || len == 3 || len == 4 || len == 7)
        end
    end

    return count
end

# Part II

Mapping = Vector{Tuple{Char, Char}}

valid_patterns = Dict{String, Int}([
    ("cf", 1),
    ("acf", 7),
    ("bcdf", 4),
    ("acdeg", 2),
    ("acdfg", 3),
    ("abdfg", 5),
    ("abcefg", 0),
    ("abdefg", 6),
    ("abcdfg", 9),
    ("abcdefg", 8),
])

function convert_segment(segment :: Char, mapping :: Mapping) :: Char
    for pair in mapping
        if segment == pair[1]
            return pair[2]
        end
    end
end

function convert_pattern(pattern :: String) :: Tuple{Int, Bool}
    sorted = join(sort(collect(pattern)))

    if haskey(valid_patterns, sorted) == false
        return (0, false)
    end

    return (valid_patterns[sorted], true)
end

function calculate_possible_mapping(entry :: Entry) :: Vector{Mapping}
    visited_segments = Set{Char}()
    remaining_segments :: Vector{Char} = []
    mappings :: Vector{Mapping} = [[], [], [], [], [], [], [], []]
    patterns = sort(entry.patterns, by = pattern -> length(pattern))

    # length = 2, number = 1
    pattern = patterns[1]
    for i = 1:4
        push!(mappings[i+0], (pattern[1], 'c'), (pattern[2], 'f'))
        push!(mappings[i+4], (pattern[1], 'f'), (pattern[2], 'c'))
    end
    push!(visited_segments, pattern[1], pattern[2])

    # length = 3, number = 7
    pattern = patterns[2]

    for segment in pattern
        if segment in visited_segments
            continue
        end

        for i = 1:8
            push!(mappings[i], (segment, 'a'))
        end

        push!(visited_segments, segment)
        break
    end

    # length = 4, number = 4
    pattern = patterns[3]

    for segment in pattern
        if segment in visited_segments
            continue
        end

        push!(remaining_segments, segment)
        push!(visited_segments, segment)
    end

    for i = 1:2
        push!(mappings[i+0], (remaining_segments[1], 'd'), (remaining_segments[2], 'b'))
        push!(mappings[i+2], (remaining_segments[1], 'b'), (remaining_segments[2], 'd'))
        push!(mappings[i+4], (remaining_segments[1], 'd'), (remaining_segments[2], 'b'))
        push!(mappings[i+6], (remaining_segments[1], 'b'), (remaining_segments[2], 'd'))
    end

    # length = 7, number = 8
    pattern = last(patterns)

    for segment in pattern
        if segment in visited_segments
            continue
        end

        push!(remaining_segments, segment)
        push!(visited_segments, segment)
    end

    for i = 1:2:8
        push!(mappings[i+0], (remaining_segments[3], 'e'), (remaining_segments[4], 'g'))
        push!(mappings[i+1], (remaining_segments[3], 'g'), (remaining_segments[4], 'e'))
    end

    return mappings
end

function calculate_correct_mapping(entry :: Entry, mappings :: Vector{Mapping}) :: Mapping
    non_fixed_patterns = filter(patt -> length(patt) == 5 || length(patt) == 6, entry.patterns)

    for mapping in mappings
        failed = false

        for pattern in non_fixed_patterns
            mapped_pattern = map(seg -> convert_segment(seg, mapping), pattern)
            _, valid = convert_pattern(mapped_pattern)

            if valid == false
                failed = true
                break
            end
        end

        if failed == false
            return mapping
        end
    end

    @assert false "uncreachable"
end

function calculate_entry_sum(entry :: Entry, mapping :: Mapping) :: Int
    entry_sum = 0

    for pattern in entry.digits
        mapped_pattern = map(seg -> convert_segment(seg, mapping), pattern)
        number, valid = convert_pattern(mapped_pattern)

        @assert valid == true

        entry_sum = entry_sum * 10 + number
    end

    return entry_sum
end

function part2() :: Int
    entries = parse_input()
    sum = 0

    for entry in entries
        mappings = calculate_possible_mapping(entry)
        correct_mapping = calculate_correct_mapping(entry, mappings)
        sum += calculate_entry_sum(entry, correct_mapping)
    end

    return sum
end

# Result

println("Part I: ", part1())
println("Part II: ", part2())