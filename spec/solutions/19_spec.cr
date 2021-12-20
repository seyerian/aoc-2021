require "../spec_helper"

describe Aoc2021::Nineteen do
  describe "#part1" do
    it "equals 342" do
      s19.part1(s19.real_input).should eq 342
    end
    context "example input" do
      it "equals 79" do
        s19.part1(s19.example_input).should eq 79
      end
    end
  end
  describe "#part2" do
    it "equals 9668" do
      s19.part2(s19.real_input).should eq 9668
    end
    context "example input" do
      it "equals 3621" do
        s19.part2(s19.example_input).should eq 3621
      end
    end
  end
end
