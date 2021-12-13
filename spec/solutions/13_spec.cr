require "../spec_helper"

describe Aoc2021::Thirteen do
  describe "#part1" do
    it "equals 818" do
      s13.part1(s13.real_input).should eq 818
    end
    context "example input" do
      it "equals 17" do
        s13.part1(s13.example_input).should eq 17
      end
    end
  end
  #describe "#part2" do
  #end
end
