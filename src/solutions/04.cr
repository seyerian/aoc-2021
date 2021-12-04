class Aoc2021::Four < Aoc2021::Solution
  alias Grid = Array(Array(Int32))
  class BingoBoard
    property id : Int32,
             marks : Grid,
             board : Grid,
             width : Int32,
             did_bingo : Bool,
             score : Int32

    def initialize(@id, @board)
      @marks = @board.clone
      @marks.each { |row| row.fill(0) }
      @width = @board[0].size
      @did_bingo = false
      @score = 0
    end

    def each_square
      board.each.with_index do |row, y|
        row.each.with_index do |square, x|
          yield square, y, x
        end
      end
    end

    # `marks` is array of 0/1 indicating number drawn
    def mark(num : Int32)
      each_square { |s, y, x| marks[y][x] = 1 if s == num }
    end

    def bingo?
      return true if did_bingo
      marks.each do |row|
        if row.none?(&.zero?)
          return self.did_bingo = true
        end
      end
      width.times do |x|
        if marks.map { |row| row[x] }.none?(&.zero?)
          return self.did_bingo = true
        end
      end
    end

    def calc_score(num)
      sum = 0 
      each_square do |square, y, x|
        sum += square if marks[y][x].zero?
      end
      self.score = sum * num
    end

    def print
      puts "Board #{id}"
      each_square do |square, y, x|
        puts if x.zero? # new line
        mark = marks[y][x] == 1 ? '*' : ""
        print (mark + square.to_s).to_s.rjust(4,' ')
      end
      puts
    end
  end # BingoBoard

  def parse_input(file)
    groups = InputParsers.groups(file)
    draws = groups[0][0].split(',').map(&.to_i32)
    boards = (1..(groups.size-1)).map do |i|
      ints = groups[i].map do |row|
        row.split(' ').reject(&.blank?).map(&.to_i32)
      end
      BingoBoard.new(i, ints)
    end
    {draws: draws, boards: boards}
  end

  def part1(input)
    input[:draws].each do |draw|
      debug "=======", "draw: #{draw}"
      input[:boards].each do |board|
        board.mark(draw)
        board.print if debug?
        return board.calc_score(draw) if board.bingo?
      end
    end
    
    raise "no bingo"
  end

  def part2(input)
    winners = [] of BingoBoard

    input[:draws].each do |draw|
      break if input[:boards].all?(&.did_bingo)
      debug "=======", "draw: #{draw}"
      input[:boards].each do |board|
        next if board.did_bingo
        board.mark(draw)
        board.print if debug?
        if board.bingo?
          board.calc_score(draw)
          winners << board
        end
      end
    end

    raise "no winners" if winners.empty?
    winners.last.score
  end
end
