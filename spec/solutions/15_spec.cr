require "../spec_helper"

describe Aoc2021::Fifteen do
  describe "#part1" do
    it "equals 398" do
      s15.part1(s15.real_input).should eq 398
    end
    context "example input" do
      it "equals 40" do
        s15.part1(s15.example_input).should eq 40
      end
    end
  end
  describe "#part2" do
    # took about 2 hours to run
    #it "equals 2817" do
    #  s15.part2(s15.real_input).should eq 2817
    #end
    context "example input" do
      it "equals 315" do
        s15.part2(s15.example_input).should eq 315
      end
    end
  end
end
