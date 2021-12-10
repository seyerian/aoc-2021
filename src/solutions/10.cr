class Aoc2021::Ten < Aoc2021::Solution
  class SyntaxChecker
    getter lines

    def initialize(@lines : Array(String))
    end

    def flip(char)
      case char
      when '(' then ')'
      when '[' then ']'
      when '{' then '}'
      when '<' then '>'
      when ')' then '('
      when ']' then '['
      when '}' then '{'
      when '>' then '<'
      else
        raise "unexpected char #{char} in #flip"
      end
    end

    def analyze_line(line)
      opens = [] of Char
      line.chars.each do |char|
        if char.in? ['(', '[', '{', '<']
          opens << char
        elsif char.in? [')', ']', '}', '>']
          if opens.any? && char == flip(opens.last)
            opens.pop
          else
            return { :error => :unexpected, :expected => flip(opens.last), :found => char }
          end
        else
          raise "unexpected char #{char}"
        end
      end
      if opens.any?
        return { :error => :incomplete, :opens => opens }
      end
      return { :success => true }
    end

    COMPLETE_PTS = { ')' => 1, ']' => 2, '}' => 3, '>' => 4 }
    def complete(result)
      raise "#complete arg is not incomplete" unless result[:error]? == :incomplete
      opens = result[:opens]?
      raise "#complete arg has no `opens` array" unless opens.is_a?(Array(Char))

      closes = opens.map { |c| flip(c) }.reverse
      score = 0_i64
      closes.each do |char|
        score = score * 5 + COMPLETE_PTS[char]
      end
      { :closes => closes, :score => score }
    end

    ERROR_PTS = { ')' => 3, ']' => 57, '}' => 1197, '>' => 25137 }
    def syntax_error_score
      lines
        .map { |l| analyze_line(l) }
        .select { |r| r[:error]? == :unexpected }
        .sum { |r| ERROR_PTS[r[:found]]? || raise "unexpected :found value" }
    end

    def completion_score
      completed =
        lines
          .map { |l| analyze_line(l) }
          .select { |r| r[:error]? == :incomplete }
          .map { |r| complete(r) }
      scores = 
        completed
          .map { |r|
            score = r[:score]?
            raise "invalid score" if !score.is_a?(Int64)
            score
          }
      scores = scores.sort
      scores[ scores.size // 2 ]
    end
  end

  def parse_input(file)
    SyntaxChecker.new(File.read_lines(file))
  end

  def part1(syntax_checker)
    syntax_checker.syntax_error_score
  end

  def part2(syntax_checker)
    syntax_checker.completion_score
  end
end
