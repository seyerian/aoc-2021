require "../spec_helper"

alias Vent = Aoc2021::Five::HtVent

describe Aoc2021::Five do
  describe "#part1" do
    #it "equals 5373" do
    #  s5.part1(s5.real_input).should eq 5373
    #end
    context "example input" do
      it "equals 5" do
        s5.part1(s5.example_input).should eq 5
      end
    end
  end
  describe "#part2" do
    #it "equals 24628" do
    #  s5.part2(s5.real_input).should eq 24628
    #end
    context "example input" do
      it "equals 12" do
        s5.part2(s5.example_input).should eq 12
      end
    end
  end

  describe Vent do
    describe "#diagonal?" do
      it "is" do
        vent = Vent.new(x1: 0, y1: 0, x2: 2, y2: 2)
        vent.diagonal?.should eq true
        vent2 = Vent.new(x1: 0, y1: 0, x2: 2, y2: 0)
        vent2.diagonal?.should eq false
      end
    end
    describe "covers?" do
      context "diagonal" do
        it do
          vent = Vent.new(x1: 0, y1: 0, x2: 2, y2: 2)
          vent.covers?(-1,-1).should eq false
          vent.covers?(0,0).should eq true
          vent.covers?(1,1).should eq true
          vent.covers?(2,2).should eq true
          vent.covers?(3,3).should eq false
          vent.covers?(-1,0).should eq false
          vent2 = Vent.new(x1: -2, y1: -2, x2: 2, y2: 2)
          vent2.covers?(-2,-2).should eq true
          vent2.covers?(-1,-1).should eq true
          vent2.covers?(-1,-2).should eq false
        end
      end
    end
  end
end
