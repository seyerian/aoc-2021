require "../spec_helper"

describe Aoc2021::Four do
  describe "#part1" do
    it "equals 49860" do
      s4.part1(s4.real_input).should eq 49860
    end
  end
  describe "#part2" do
    it "equals 24628" do
      s4.part2(s4.real_input).should eq 24628
    end
  end
end
