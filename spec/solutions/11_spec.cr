require "../spec_helper"

describe Aoc2021::Eleven do
  describe "#part1" do
    it "equals 1591" do
      s11.part1(s11.real_input).should eq 1591
    end
    context "example input" do
      it "equals 1656" do
        s11.part1(s11.example_input).should eq 1656
      end
    end
  end
  describe "#part2" do
    it "equals 314" do
      s11.part2(s11.real_input).should eq 314
    end
    context "example input" do
      it "equals 195" do
        s11.part2(s11.example_input).should eq 195
      end
    end
  end
end
