require "../spec_helper"

describe Aoc2021::Seventeen do
  describe "#part1" do
    it "equals 4753" do
      s17.part1(s17.real_input).should eq 4753
    end
    context "example inputs" do
      it "equals 45" do
        s17.part1(s17.example_input).should eq 45
      end
    end
  end
  describe "#part2" do
    it "equals 1546" do
      s17.part2(s17.real_input).should eq 1546
    end
    context "example input" do
      it "equals 112" do
        s17.part2(s17.example_input).should eq 112
      end
    end
  end
end
