require "../spec_helper"

describe Aoc2021::TwentyFour do
  describe "#part1" do
    it "equals 65984919997939" do
      s24.part1(s24.real_input).should eq 65984919997939
    end
  end
  describe "#part2" do
    it "equals 11211619541713" do
      s24.part2(s24.real_input).should eq 11211619541713
    end
  end
end
