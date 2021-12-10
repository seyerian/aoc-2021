require "../spec_helper"

describe Aoc2021::Nine do
  describe "#part1" do
    it "equals 506" do
      s9.part1(s9.real_input).should eq 506
    end
    context "example input" do
      it "equals 15" do
        s9.part1(s9.example_input).should eq 15
      end
    end
  end
  describe "#part2" do
    it "equals 931200" do
      s9.part2(s9.real_input).should eq 931200
    end
    context "example input" do
      it "equals 1134" do
        s9.part2(s9.example_input).should eq 1134
      end
    end
  end
end
