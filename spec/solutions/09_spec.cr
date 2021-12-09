require "../spec_helper"

describe Aoc2021::Nine do
  describe "#part1" do
    it "equals 392" do
      s9.part1(s9.real_input).should eq 506
    end
    context "example input" do
      it "equals 26" do
        s9.part1(s9.example_input).should eq 15
      end
    end
  end
  describe "#part2" do
    it "equals 1004688" do
      s9.part2(s9.real_input).should eq 931200
    end
    context "example input" do
      it "equals 61229" do
        s9.part2(s9.example_input).should eq 1134
      end
    end
  end
end
