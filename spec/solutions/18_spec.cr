require "../spec_helper"

describe Aoc2021::Eighteen do
  describe "#part1" do
    it "equals 4435" do
      s18.part1(s18.real_input).should eq 4435
    end
    context "example input" do
      it "equals 4140" do
        s18.part1(s18.example_input("18e")).should eq 4140
      end
    end
  end
  describe "#part2" do
    it "equals 4802" do
      s18.part2(s18.real_input).should eq 4802
    end
    context "example input" do
      it "equals 3993" do
        s18.part2(s18.example_input("18e")).should eq 3993
      end
    end
  end
end
