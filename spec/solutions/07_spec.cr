require "../spec_helper"

describe Aoc2021::Seven do
  describe "#part1" do
    it "equals 333755" do
      s7.part1(s7.real_input).should eq 333755
    end
    context "example input" do
      it "equals 37" do
        s7.part1(s7.example_input).should eq 37
      end
    end
  end
  describe "#part2" do
    it "equals 94017638" do
      s7.part2(s7.real_input).should eq 94017638
    end
    context "example input" do
      it "equals 168" do
        s7.part2(s7.example_input).should eq 168
      end
    end
  end
end
