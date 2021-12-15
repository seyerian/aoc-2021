require "./src/aoc2021"

ENV["DEBUG"] = "true"

s = Aoc2021::Fifteen.new
#s.solution
#puts s.part1(s.example_input)
#puts s.part1(s.real_input)
#puts s.part2(s.example_input)
#puts s.part2(s.example_input("12a"))
#puts s.part2(s.example_input("12b"))
#puts s.part2(s.example_input("12c"))
puts s.part2(s.real_input)
