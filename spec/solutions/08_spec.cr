require "../spec_helper"

describe Aoc2021::Eight do
  describe "#part1" do
    it "equals 392" do
      s8.part1(s8.real_input).should eq 392
    end
    context "example input" do
      it "equals 26" do
        s8.part1(s8.example_input).should eq 26
      end
    end
  end
  describe "#part2" do
    it "equals 1004688" do
      s8.part2(s8.real_input).should eq 1004688
    end
    context "example input" do
      it "equals 61229" do
        s8.part2(s8.example_input).should eq 61229
      end
    end
  end
end
