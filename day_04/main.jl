# Common

mutable struct Board_Element
    number :: Int64
    marked :: Bool
end

function read_board(input) :: Matrix{Board_Element}
    readline(input) # delimiter

    boards = [
        [Board_Element(parse(Int64, x), false) for x = split(readline(input))],
        [Board_Element(parse(Int64, x), false) for x = split(readline(input))],
        [Board_Element(parse(Int64, x), false) for x = split(readline(input))],
        [Board_Element(parse(Int64, x), false) for x = split(readline(input))],
        [Board_Element(parse(Int64, x), false) for x = split(readline(input))]
    ]

    result = Matrix{Board_Element}(undef, 5, 5)
    result[1, :] = boards[1]
    result[2, :] = boards[2]
    result[3, :] = boards[3]
    result[4, :] = boards[4]
    result[5, :] = boards[5]
    return result
end

# Part I

open("input.txt") do input
    numbers = [parse(Int64, x) for x = split(readline(input), ',')]

    boards :: Vector{Matrix{Board_Element}} = []
    winning_number :: Int64 = 0
    winner = Matrix{Board_Element}(undef, 5, 5)

    while !eof(input)
        push!(boards, read_board(input))
    end

    for number in numbers
        found_winner = false

        for board in boards
            for element in board
                element.marked = element.marked || number == element.number
            end

            bingo =
                mapreduce(element -> Int64(element.marked), +, board[1,:]) == 5 ||
                mapreduce(element -> Int64(element.marked), +, board[2,:]) == 5 ||
                mapreduce(element -> Int64(element.marked), +, board[3,:]) == 5 ||
                mapreduce(element -> Int64(element.marked), +, board[4,:]) == 5 ||
                mapreduce(element -> Int64(element.marked), +, board[5,:]) == 5 ||
                mapreduce(element -> Int64(element.marked), +, board[:,1]) == 5 ||
                mapreduce(element -> Int64(element.marked), +, board[:,2]) == 5 ||
                mapreduce(element -> Int64(element.marked), +, board[:,3]) == 5 ||
                mapreduce(element -> Int64(element.marked), +, board[:,4]) == 5 ||
                mapreduce(element -> Int64(element.marked), +, board[:,5]) == 5

            if bingo
                winner = board
                found_winner = true
                break
            end
        end

        if found_winner
            winning_number = number
            break
        end
    end

    unmarked_numbers_sum = mapreduce(element -> element.marked ? 0 : element.number, +, winner)

    println("Part I:")
    println("  Winning Number: ", winning_number)
    println("  Unmarked Numbers Sum: ", unmarked_numbers_sum)
    println("  Answer: ", winning_number * unmarked_numbers_sum)
end

# Part II

open("input.txt") do input
    numbers = [parse(Int64, x) for x = split(readline(input), ',')]

    boards :: Vector{Matrix{Board_Element}} = []
    winning_number :: Int64 = 0
    previous_winners = Set{Matrix{Board_Element}}()
    winner = Matrix{Board_Element}(undef, 5, 5)

    while !eof(input)
        push!(boards, read_board(input))
    end

    for number in numbers
        for board in boards
            if board in previous_winners
                continue
            end

            for element in board
                element.marked = element.marked || number == element.number
            end

            bingo =
                mapreduce(element -> Int64(element.marked), +, board[1,:]) == 5 ||
                mapreduce(element -> Int64(element.marked), +, board[2,:]) == 5 ||
                mapreduce(element -> Int64(element.marked), +, board[3,:]) == 5 ||
                mapreduce(element -> Int64(element.marked), +, board[4,:]) == 5 ||
                mapreduce(element -> Int64(element.marked), +, board[5,:]) == 5 ||
                mapreduce(element -> Int64(element.marked), +, board[:,1]) == 5 ||
                mapreduce(element -> Int64(element.marked), +, board[:,2]) == 5 ||
                mapreduce(element -> Int64(element.marked), +, board[:,3]) == 5 ||
                mapreduce(element -> Int64(element.marked), +, board[:,4]) == 5 ||
                mapreduce(element -> Int64(element.marked), +, board[:,5]) == 5

            if bingo
                winning_number = number
                winner = board
                push!(previous_winners, board)
            end
        end
    end

    unmarked_numbers_sum = mapreduce(element -> element.marked ? 0 : element.number, +, winner)

    println("Part II:")
    println("  Winning Number: ", winning_number)
    println("  Unmarked Numbers Sum: ", unmarked_numbers_sum)
    println("  Answer: ", winning_number * unmarked_numbers_sum)
end