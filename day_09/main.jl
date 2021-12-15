# Common

function parse_input(path) :: Vector{Vector{Int8}}
    input = open(path)
    result :: Vector{Vector{Int8}} = []

    while !eof(input)
        push!(result, map(e -> parse(Int8, e), collect(readline(input))))
    end

    close(input)
    return result
end

# Part I

function part1() :: Int
    height_map = parse_input("input.txt")
    result = 0

    rows_count = length(height_map)
    cols_count = length(height_map[1])

    for i = 1:rows_count
        for j = 1:cols_count
            height = height_map[i][j]

            # up
            if i != 1 && height >= height_map[i-1][j]
                continue
            end

            # down
            if i != rows_count && height >= height_map[i+1][j]
                continue
            end

            # left
            if j != 1 && height >= height_map[i][j-1]
                continue
            end

            # right
            if j != cols_count && height >= height_map[i][j+1]
                continue
            end

            result += height + 1
        end
    end

    return result
end

# Part II

function calculate_basin_set(height_map :: Vector{Vector{Int8}}, x :: Int, y :: Int) :: Set{Tuple{Int, Int}}
    rows_count = length(height_map)
    cols_count = length(height_map[1])

    height = height_map[x][y]
    basin = Set([(x, y)])

    if x != 1 && height_map[x-1][y] != 9 && height < height_map[x-1][y]
        basin = union(basin, calculate_basin_set(height_map, x-1, y))
    end

    if x != rows_count && height_map[x+1][y] != 9 && height < height_map[x+1][y]
        basin = union(basin, calculate_basin_set(height_map, x+1, y))
    end

    if y != 1 && height_map[x][y-1] != 9 && height < height_map[x][y-1]
        basin = union(basin, calculate_basin_set(height_map, x, y-1))
    end

    if y != cols_count && height_map[x][y+1] != 9 && height < height_map[x][y+1]
        basin = union(basin, calculate_basin_set(height_map, x, y+1))
    end

    return basin
end

function  part2() :: Int
    height_map = parse_input("input.txt")
    rows_count = length(height_map)
    cols_count = length(height_map[1])

    first_basin_size = -Inf
    second_basin_size = -Inf
    third_basin_size = -Inf

    for i = 1:rows_count
        for j = 1:cols_count
            height = height_map[i][j]

            # up
            if i != 1 && height >= height_map[i-1][j]
                continue
            end

            # down
            if i != rows_count && height >= height_map[i+1][j]
                continue
            end

            # left
            if j != 1 && height >= height_map[i][j-1]
                continue
            end

            # right
            if j != cols_count && height >= height_map[i][j+1]
                continue
            end

            basin = calculate_basin_set(height_map, i, j)
            basin_size = length(basin)

            if basin_size > first_basin_size
                third_basin_size = second_basin_size
                second_basin_size = first_basin_size
                first_basin_size = basin_size
                continue
            end

            if basin_size > second_basin_size
                third_basin_size = second_basin_size
                second_basin_size = basin_size
                continue
            end

            if basin_size > third_basin_size
                third_basin_size = basin_size
            end
        end
    end

    return first_basin_size * second_basin_size * third_basin_size
end

# Result

println("Part I: ", part1())
println("Part II: ", part2())
