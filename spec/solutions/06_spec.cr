require "../spec_helper"

describe Aoc2021::Six do
  describe "#part1" do
    it "equals 383160" do
      s6.part1(s6.real_input).should eq 383160
    end
    context "example input" do
      it "equals 5934" do
        s6.part1(s6.example_input).should eq 5934
      end
    end
  end
  describe "#part2" do
    it "equals 1721148811504" do
      s6.part2(s6.real_input).should eq 1721148811504
    end
    context "example input" do
      it "equals 26984457539" do
        s6.part2(s6.example_input).should eq 26984457539
      end
    end
  end
end
