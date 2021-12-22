require "big"

class Aoc2021::TwentyTwo < Aoc2021::Solution
  alias Cuboid = NamedTuple(
    x1: Int32, x2: Int32,
    y1: Int32, y2: Int32,
    z1: Int32, z2: Int32
  )

  def parse_input(file)
    InputParsers.pattern(
      file,
      /(on|off) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)/
    ) do |m|
      {
        state: m[1],
        x1: m[2].to_i32,
        x2: m[3].to_i32,
        y1: m[4].to_i32,
        y2: m[5].to_i32,
        z1: m[6].to_i32,
        z2: m[7].to_i32
      }
    end
  end

  def intersect?(c1, c2)
    (
      (c1[:x1]..c1[:x2]).includes?(c2[:x1]) ||
      (c1[:x1]..c1[:x2]).includes?(c2[:x2]) ||
      (c2[:x1] < c1[:x1] && c2[:x2] > c1[:x2])
    ) && (
      (c1[:y1]..c1[:y2]).includes?(c2[:y1]) ||
      (c1[:y1]..c1[:y2]).includes?(c2[:y2]) ||
      (c2[:y1] < c1[:y1] && c2[:y2] > c1[:y2])
    ) && (
      (c1[:z1]..c1[:z2]).includes?(c2[:z1]) ||
      (c1[:z1]..c1[:z2]).includes?(c2[:z2]) ||
      (c2[:z1] < c1[:z1] && c2[:z2] > c1[:z2])
    )
  end

  # cut cuboid `b` out of `a`, returning a list of cuboids that fill the remaining space
  def cut(a, b)
    # coordinates of the cuboid we need to cut out of a
    cx1 = nil
    cx2 = nil
    cy1 = nil
    cy2 = nil
    cz1 = nil
    cz2 = nil

    if (a[:x1]..a[:x2]).includes?(b[:x1])
      cx1 = b[:x1]
    elsif b[:x1] < a[:x1]
      cx1 = a[:x1]
    end

    if (a[:x1]..a[:x2]).includes?(b[:x2])
      cx2 = b[:x2]
    elsif b[:x2] > a[:x2]
      cx2 = a[:x2]
    end

    if (a[:y1]..a[:y2]).includes?(b[:y1])
      cy1 = b[:y1]
    elsif b[:y1] < a[:y1]
      cy1 = a[:y1]
    end

    if (a[:y1]..a[:y2]).includes?(b[:y2])
      cy2 = b[:y2]
    elsif b[:y2] > a[:y2]
      cy2 = a[:y2]
    end

    if (a[:z1]..a[:z2]).includes?(b[:z1])
      cz1 = b[:z1]
    elsif b[:z1] < a[:z1]
      cz1 = a[:z1]
    end

    if (a[:z1]..a[:z2]).includes?(b[:z2])
      cz2 = b[:z2]
    elsif b[:z2] > a[:z2]
      cz2 = a[:z2]
    end

    # any nil means no intersection. return a
    if [cx1, cx2, cy1, cy2, cz1, cz2].any?(&.nil?)
      raise "#cut: no intersection of #{b} and #{a}"
      # return [a]
    end

    remaining = [] of Cuboid

    # iterate on pairs of x/y/z, constructing the 26 cuboids
    # touching the faces of the cuboid we're cutting out.
    [ a[:x1], cx1, cx2, a[:x2] ].each_cons(2).with_index do |(x1, x2), i|
      raise "x nil" if x1.nil? || x2.nil?
      # adding/subtracting 1 on the first/last pairs prevents duplicate cubes on the edges & faces
      x2 -= 1 if i == 0
      x1 += 1 if i == 2
      next if x2 < x1 || x1 > x2
      [ a[:y1], cy1, cy2, a[:y2] ].each_cons(2).with_index do |(y1, y2), j|
        raise "y nil" if y1.nil? || y2.nil?
        y2 -= 1 if j == 0
        y1 += 1 if j == 2
        next if y2 < y1 || y1 > y2
        [ a[:z1], cz1, cz2, a[:z2] ].each_cons(2).with_index do |(z1, z2), k|
          next if i==1 && j==1 && k==1
          raise "z nil" if z1.nil? || z2.nil?
          z2 -= 1 if k == 0
          z1 += 1 if k == 2
          next if z2 < z1 || z1 > z2
          # center square is region being cut out
          remaining << { x1: x1, x2: x2, y1: y1, y2: y2, z1: z1, z2: z2 }
        end
      end
    end

    remaining
  end

  def init(steps)
    on = [] of Cuboid

    steps.each do |step|
      state = step[:state]
      cuboid = Cuboid.from( step.to_h.reject(:state) )
      new_on = [] of Cuboid
      # iterate on all existing "on" cuboids. if there is an intersection, cut it out.
      # for the case of the current cuboid being "on", this removes overlap,
      # so that we don't overcount individual "on" cubes later.
      on.each do |on_cuboid|
        if intersect?(on_cuboid, cuboid)
          remaining = cut(on_cuboid, cuboid)
          remaining.each do |r|
            new_on << r
          end
        else
          new_on << on_cuboid
        end
      end
      new_on << cuboid if state == "on"
      on = new_on
    end

    on
  end

  def part1(steps)
    cuboids = init(steps)
    num_on = BigInt.new(0)
    cuboids.each do |c|
      if (
        c[:x1] > 50 || c[:x2] < -50 ||
        c[:y1] > 50 || c[:y2] < -50 ||
        c[:z1] > 50 || c[:z2] < -50
      )
        next
      end
      x1 = [c[:x1],-50].max
      x2 = [c[:x2],50].min
      y1 = [c[:y1],-50].max
      y2 = [c[:y2],50].min
      z1 = [c[:z1],-50].max
      z2 = [c[:z2],50].min
      num_on += (x2 - x1 + 1) * (y2 - y1 + 1) * (z2 - z1 + 1)
    end
    num_on
  end

  def part2(steps)
    cuboids = init(steps)
    num_on = BigInt.new(0)
    cuboids.each do |c|
      x = BigInt.new(1) + c[:x2] - c[:x1]
      y = BigInt.new(1) + c[:y2] - c[:y1]
      z = BigInt.new(1) + c[:z2] - c[:z1]
      num_on += x * y * z
    end
    num_on
  end
end
