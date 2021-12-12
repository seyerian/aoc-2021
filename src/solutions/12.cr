class Aoc2021::Twelve < Aoc2021::Solution
  class Cave
    getter id : String
    property connections : Array(Cave)
    getter start : Bool
    getter stop : Bool
    getter big : Bool
    getter small : Bool

    def initialize(@id : String)
      @connections = [] of Cave
      @start = @id == "start"
      @stop = @id == "end"
      @big = @id.matches?(/\A[[:upper:]]+\z/)
      @small = @id.matches?(/\A[[:lower:]]+\z/) && !@id.in?(["start", "end"])
    end

    def add_connection(cave : Cave)
      connections << cave
    end

  end

  class CaveSystem
    property caves : Array(Cave)
    def initialize(connections)
      @caves = connections.flatten.uniq.map { |id| Cave.new(id) }
      connections.each do |conn|
        next unless (cave1 = caves.find { |c| c.id == conn[0] })
        next unless (cave2 = caves.find { |c| c.id == conn[1] })
        cave1.add_connection cave2
        cave2.add_connection cave1
      end
    end

    alias Path = Array(String)
    def paths(single_small_twice : Bool = false)
      start = caves.find(&.start)
      raise "no start" unless start
      subpath(start, Path.new, single_small_twice)
    end

    def subpath(cave : Cave, ids : Path, single_small_twice : Bool = false)
      new_ids = ids + [cave.id]
      return [new_ids] if cave.stop
      paths = [] of Path
      cave.connections.each do |conn|
        next if conn.start
        if conn.small && new_ids.includes?(conn.id)
          next if !single_small_twice
          small_ids = new_ids.select { |id| small_id?(id) }
          next if small_ids.size != small_ids.uniq.size
        end
        subpath(conn, new_ids, single_small_twice).compact.each do |path|
          paths << path
        end
      end
      paths
    end

    def small_id?(id : String)
      id.matches?(/\A[[:lower:]]+\z/) && !id.in?(["start", "end"])
    end
  end

  def parse_input(file)
    CaveSystem.new(File.read_lines(file).map { |l| l.split('-') })
  end

  def part1(cave_sys)
    cave_sys.paths.size
  end

  def part2(cave_sys)
    paths = cave_sys.paths(single_small_twice: true)
    #paths.each { |p| debug p }
    paths.size
  end
end
