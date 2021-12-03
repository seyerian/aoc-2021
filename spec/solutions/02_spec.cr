require "../spec_helper"

describe Aoc2021::Two do
  describe "#part1" do
    it "equals 1924923" do
      s2.part1(s2.real_input).should eq 1924923
    end
  end
  describe "#part2" do
    it "equals 1982495697" do
      s2.part2(s2.real_input).should eq 1982495697
    end
  end
end
