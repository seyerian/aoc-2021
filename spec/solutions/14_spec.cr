require "../spec_helper"

describe Aoc2021::Fourteen do
  describe "#part1" do
    it "equals 2657" do
      s14.part1(s14.real_input).should eq 2657
    end
    context "example input" do
      it "equals 1588" do
        s14.part1(s14.example_input).should eq 1588
      end
    end
  end
  describe "#part2" do
    it "equals 2911561572630" do
      s14.part2(s14.real_input).should eq 2911561572630
    end
    context "example input" do
      it "equals 2188189693529" do
        s14.part2(s14.example_input).should eq 2188189693529
      end
    end
  end
end
