#!/usr/bin/julia

using Printf

source_template = raw"# Common

function parse_input(path)
    input = open(path)
    # TODO
    close(input)
end

# Part I

function part1()
    # TODO
end

# Part II

function  part2()
    # TODO
end

# Result

println(\"Part I: \", part1())
println(\"Part II: \", part2())
"

function main()
    if length(ARGS) != 1
        println("Usage: ./template.jl <day-number>")
        exit(1)
    end

    day_number = parse(Int, ARGS[1])

    dir_path = @sprintf "day_%02d" day_number
    mkdir(dir_path)

    input_path = "$(dir_path)/input.txt"
    touch(input_path)

    sample_path = "$(dir_path)/sample.txt"
    touch(sample_path)

    main_source_path = "$(dir_path)/main.jl"
    main_source = open(main_source_path, "w")

    write(main_source, source_template)
    close(main_source)

    println("Generated template for day $(day_number).")
end

main()