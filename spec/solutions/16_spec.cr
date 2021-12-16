require "../spec_helper"

describe Aoc2021::Sixteen do
  describe "#part1" do
    it "equals 877" do
      s16.part1(s16.real_input).should eq 877
    end
    context "example inputs" do
      it "equals x" do
        #s16.part1(s16.example_input("16a").should eq 
        #s16.part1(s16.example_input("16b").should eq 
        #s16.part1(s16.example_input("16c").should eq 
        s16.part1(s16.example_input("16d")).should eq 16
        s16.part1(s16.example_input("16e")).should eq 12
        s16.part1(s16.example_input("16f")).should eq 23
        s16.part1(s16.example_input("16g")).should eq 31
      end
    end
  end
  describe "#part2" do
    it "equals 194435634456" do
      s16.part2(s16.real_input).should eq 194435634456
    end
    context "example input" do
      it "equals x" do
        s16.part2(s16.example_input("16-2a")).should eq 3
        s16.part2(s16.example_input("16-2b")).should eq 54
        s16.part2(s16.example_input("16-2c")).should eq 7
        s16.part2(s16.example_input("16-2d")).should eq 9
        s16.part2(s16.example_input("16-2e")).should eq 1
        s16.part2(s16.example_input("16-2f")).should eq 0
        s16.part2(s16.example_input("16-2g")).should eq 0
        s16.part2(s16.example_input("16-2h")).should eq 1
      end
    end
  end
end
