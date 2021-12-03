require "../spec_helper"

describe Aoc2021::Three do
  describe "#part1" do
    it "equals 775304" do
      s3.part1(s3.real_input).should eq 775304
    end
  end
  describe "#part2" do
    it "equals 1370737" do
      s3.part2(s3.real_input).should eq 1370737
    end
  end
end
