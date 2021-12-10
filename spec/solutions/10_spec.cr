require "../spec_helper"

describe Aoc2021::Ten do
  describe "#part1" do
    it "equals 392367" do
      s10.part1(s10.real_input).should eq 392367
    end
    context "example input" do
      it "equals 26397" do
        s10.part1(s10.example_input).should eq 26397
      end
    end
  end
  describe "#part2" do
    it "equals 2192104158" do
      s10.part2(s10.real_input).should eq 2192104158
    end
    context "example input" do
      it "equals 288957" do
        s10.part2(s10.example_input).should eq 288957
      end
    end
  end
end
