# Common

struct Point
    x :: Int
    y :: Int
end

struct Line
    p :: Point
    q :: Point
end

function parse_input() :: Vector{Line}
    input = open("input.txt")
    result :: Vector{Line} = []

    while !eof(input)
        xy1, xy2 = split(readline(input), "->")
        x1, y1 = split(xy1, ',')
        x2, y2 = split(xy2, ',')
        line = Line(
            Point(parse(Int, x1), parse(Int, y1)),
            Point(parse(Int, x2), parse(Int, y2))
        )
        push!(result, line)
    end

    close(input)
    return result
end

# Part I

function part1()
    lines = parse_input()
    points_frequency = Dict{Point, Int}()

    for line in lines
        if line.p.y == line.q.y
            a, b = min(line.p.x, line.q.x), max(line.p.x, line.q.x)
            for x = a:b
                point = Point(x, line.p.y)
                points_frequency[point] = get(points_frequency, point, 0) + 1
            end
        elseif line.p.x == line.q.x
            a, b = min(line.p.y, line.q.y), max(line.p.y, line.q.y)
            for y = a:b
                point = Point(line.p.x, y)
                points_frequency[point] = get(points_frequency, point, 0) + 1
            end
        end
    end

    result = mapreduce(n -> Int(n > 1), +, values(points_frequency))
    println("Part I: ", result)
end

# Part II

function part2()
    lines = parse_input()
    points_frequency = Dict{Point, Int}()

    for line in lines
        if line.p.y == line.q.y
            a, b = min(line.p.x, line.q.x), max(line.p.x, line.q.x)
            for x = a:b
                point = Point(x, line.p.y)
                points_frequency[point] = get(points_frequency, point, 0) + 1
            end
        elseif line.p.x == line.q.x
            a, b = min(line.p.y, line.q.y), max(line.p.y, line.q.y)
            for y = a:b
                point = Point(line.p.x, y)
                points_frequency[point] = get(points_frequency, point, 0) + 1
            end
        else
            x_step = line.p.x > line.q.x ? -1 : 1
            y_step = line.p.y > line.q.y ? -1 : 1

            for i = 0:abs(line.p.x - line.q.x)
                point = Point(line.p.x + i*x_step, line.p.y + i*y_step)
                points_frequency[point] = get(points_frequency, point, 0) + 1
            end
        end
    end

    result = mapreduce(n -> Int(n > 1), +, values(points_frequency))
    println("Part II: ", result)
end

part1()
part2()