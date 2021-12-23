require "../spec_helper"

describe Aoc2021::TwentyTwo do
  describe "#part1" do
    it "equals 16489" do
      s22.part1(s22.real_input).should eq 16489
    end
    context "example input" do
      it "23b equals 12521" do
        s22.part1(s22.example_input("23b")).should eq 12521
      end
    end
  end
  describe "#part2" do
    it "equals 43413" do
      s22.part2(s22.real_input).should eq 43413
    end
    context "example input" do
      it "23b equals 44169" do
        s22.part2(s22.example_input("23b")).should eq 44169
      end
    end
  end
end
