require "../spec_helper"

describe Aoc2021::Eleven do
  describe "#part1" do
    it "equals 3738" do
      s12.part1(s12.real_input).should eq 3738
    end
    context "example input" do
      it "equals 10,19,226" do
        s12.part1(s12.example_input("12a")).should eq 10
        s12.part1(s12.example_input("12b")).should eq 19
        s12.part1(s12.example_input("12c")).should eq 226
      end
    end
  end
  describe "#part2" do
    it "equals 120506" do
      s12.part2(s12.real_input).should eq 120506
    end
    context "example input" do
      it "equals 16,103,3509" do
        s12.part2(s12.example_input("12a")).should eq 36
        s12.part2(s12.example_input("12b")).should eq 103
        s12.part2(s12.example_input("12c")).should eq 3509
      end
    end
  end
end
