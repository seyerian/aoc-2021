require "../spec_helper"

describe Aoc2021::Twenty do
  describe "#part1" do
    it "equals 5573" do
      s20.part1(s20.real_input).should eq 5573
    end
    context "example input" do
      it "equals 35" do
        s20.part1(s20.example_input).should eq 35
      end
    end
  end
  describe "#part2" do
    # NOTE slow
    #it "equals 20097" do
    #  s20.part2(s20.real_input).should eq 20097
    #end
    context "example input" do
      it "equals 3351" do
        s20.part2(s20.example_input).should eq 3351
      end
    end
  end
end
