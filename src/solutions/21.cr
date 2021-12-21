require "big"

class Aoc2021::TwentyOne < Aoc2021::Solution
  def parse_input(file)
    lines = File.read_lines(file)
    [
      lines[0].split(' ').last.to_i32,
      lines[1].split(' ').last.to_i32
    ]
  end

  def part1(players)
    rolls = 0
    die = 0
    current = 0
    scores = [0,0]
    loop do
      puts "-------- player #{0+1}"
      3.times do
        die += 1
        puts "...rolls #{die}"
        rolls += 1
        players[current] += die
        until players[current] <= 10
          players[current] -= 10
        end
        puts "@ #{players[current]}"
        die = 0 if die == 100
      end
      scores[current] += players[current]
      puts "score #{scores[current]}"
      if scores[current] >= 1000
        return scores[current == 0 ? 1 : 0] * rolls
      end
      current = current == 0 ? 1 : 0
    end
  end

  def part2(players)
    roll_freqs = {
      3 => 1,
      4 => 3,
      5 => 6,
      6 => 7,
      7 => 6,
      8 => 3,
      9 => 1
    }
    wins = [BigInt.new(0), BigInt.new(0)]
    roll_freqs.each do |r1, f1|

      track = players.clone
      scores = [0, 0]

      track1, scores1 = part2_roll(0, r1, track, scores)
      if scores1[0] >= 21
        wins[0] += BigInt.new(1) * f1
        next
      end
      roll_freqs.each do |r2, f2|
        track2, scores2 = part2_roll(1, r2, track1, scores1)
        if scores2[1] >= 21
          wins[1] += BigInt.new(1) * f1 * f2
          next
        end
        roll_freqs.each do |r3, f3|
          track3, scores3 = part2_roll(0, r3, track2, scores2)
          if scores3[0] >= 21
            wins[0] += BigInt.new(1) * f1 * f2 * f3
            next
          end
          roll_freqs.each do |r4, f4|
            track4, scores4 = part2_roll(1, r4, track3, scores3)
            if scores4[1] >= 21
              wins[1] += BigInt.new(1) * f1 * f2 * f3 * f4
              next
            end
            roll_freqs.each do |r5, f5|
              track5, scores5 = part2_roll(0, r5, track4, scores4)
              if scores5[0] >= 21
                wins[0] += BigInt.new(1) * f1 * f2 * f3 * f4 * f5
                next
              end
              roll_freqs.each do |r6, f6|
                track6, scores6 = part2_roll(1, r6, track5, scores5)
                if scores6[1] >= 21
                  wins[1] += BigInt.new(1) * f1 * f2 * f3 * f4 * f5 * f6
                  next
                end
                roll_freqs.each do |r7, f7|
                  track7, scores7 = part2_roll(0, r7, track6, scores6)
                  if scores7[0] >= 21
                    wins[0] += BigInt.new(1) * f1 * f2 * f3 * f4 * f5 * f6 * f7
                    next
                  end
                  roll_freqs.each do |r8, f8|
                    track8, scores8 = part2_roll(1, r8, track7, scores7)
                    if scores8[1] >= 21
                      wins[1] += BigInt.new(1) * f1 * f2 * f3 * f4 * f5 * f6 * f7 * f8
                      next
                    end
                    roll_freqs.each do |r9, f9|
                      track9, scores9 = part2_roll(0, r9, track8, scores8)
                      if scores9[0] >= 21
                        wins[0] += BigInt.new(1) * f1 * f2 * f3 * f4 * f5 * f6 * f7 * f8 * f9
                        next
                      end
                      roll_freqs.each do |r10, f10|
                        track10, scores10 = part2_roll(1, r10, track9, scores9)
                        if scores10[1] >= 21
                          wins[1] += BigInt.new(1) * f1 * f2 * f3 * f4 * f5 * f6 * f7 * f8 * f9 * f10
                          next
                        end
                        roll_freqs.each do |r11, f11|
                          track11, scores11 = part2_roll(0, r11, track10, scores10)
                          if scores11[0] >= 21
                            wins[0] += BigInt.new(1) * f1 * f2 * f3 * f4 * f5 * f6 * f7 * f8 * f9 * f10 * f11
                            next
                          end
                          roll_freqs.each do |r12, f12|
                            track12, scores12 = part2_roll(1, r12, track11, scores11)
                            if scores12[1] >= 21
                              wins[1] += BigInt.new(1) * f1 * f2 * f3 * f4 * f5 * f6 * f7 * f8 * f9 * f10 * f11 * f12
                              next
                            end
                            roll_freqs.each do |r13, f13|
                              track13, scores13 = part2_roll(0, r13, track12, scores12)
                              if scores13[0] >= 21
                                wins[0] += BigInt.new(1) * f1 * f2 * f3 * f4 * f5 * f6 * f7 * f8 * f9 * f10 * f11 * f12 * f13
                                next
                              end
                              roll_freqs.each do |r14, f14|
                                track14, scores14 = part2_roll(1, r14, track13, scores13)
                                if scores14[1] >= 21
                                  wins[1] += BigInt.new(1) * f1 * f2 * f3 * f4 * f5 * f6 * f7 * f8 * f9 * f10 * f11 * f12 * f13 * f14
                                  next
                                end
                                roll_freqs.each do |r15, f15|
                                  track15, scores15 = part2_roll(0, r15, track14, scores14)
                                  if scores15[0] >= 21
                                    wins[0] += BigInt.new(1) * f1 * f2 * f3 * f4 * f5 * f6 * f7 * f8 * f9 * f10 * f11 * f12 * f13 * f14 * f15
                                    next
                                  end
                                  roll_freqs.each do |r16, f16|
                                    track16, scores16 = part2_roll(1, r16, track15, scores15)
                                    if scores16[1] >= 21
                                      wins[1] += BigInt.new(1) * f1 * f2 * f3 * f4 * f5 * f6 * f7 * f8 * f9 * f10 * f11 * f12 * f13 * f14 * f15 * f16
                                      next
                                    end
                                    roll_freqs.each do |r17, f17|
                                      track17, scores17 = part2_roll(0, r17, track16, scores16)
                                      if scores17[0] >= 21
                                        wins[0] += BigInt.new(1) * f1 * f2 * f3 * f4 * f5 * f6 * f7 * f8 * f9 * f10 * f11 * f12 * f13 * f14 * f15 * f16 * f17
                                        next
                                      end
                                      roll_freqs.each do |r18, f18|
                                        track18, scores18 = part2_roll(1, r18, track17, scores17)
                                        if scores18[1] >= 21
                                          wins[1] += BigInt.new(1) * f1 * f2 * f3 * f4 * f5 * f6 * f7 * f8 * f9 * f10 * f11 * f12 * f13 * f14 * f15 * f16 * f17 * f18
                                          next
                                        end
                                        roll_freqs.each do |r19, f19|
                                          track19, scores19 = part2_roll(0, r19, track18, scores18)
                                          if scores19[0] >= 21
                                            wins[0] += BigInt.new(1) * f1 * f2 * f3 * f4 * f5 * f6 * f7 * f8 * f9 * f10 * f11 * f12 * f13 * f14 * f15 * f16 * f17 * f18 * f19
                                            next
                                          else
                                            puts scores19
                                            raise "no winner yet"
                                          end
                                        end
                                      end
                                    end
                                  end
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    wins.max
  end
  
  def part2_roll(player, roll, track, scores)
    track = track.dup
    scores = scores.dup
    track[player] += roll
    until track[player] <= 10
      track[player] -= 10
    end
    scores[player] += track[player]
    [track, scores]
  end
end
