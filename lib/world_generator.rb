require 'perlin'

class WorldGenerator
  attr_reader :elevations, :map

  def initialize(args={})
    defaults.merge(args)
    .each { |k,v| instance_variable_set("@#{k}",v) }

    perlin_gen = Perlin::Generator.new(200, 1, 2)
    @noise_map = perlin_gen.chunk(1, 1, @size, @size, 0.02)
    @elevations = @noise_map.flatten.sort
    generate_map
  end

  def defaults
    {
      map: [],
      seed: rand(1000),
      size: 200,
      sea_level: 40,
      shallow_sea_level: 20,
      deep_sea_level: 10,
      forest_level: 60,
    }
  end

  def generate_map
    @noise_map.each_index do |row|
      @map << []
      @noise_map[row].each_with_index do |value, column|
        type = :water_deep    if value <= deep_sea_level
        type = :water_medium  if value >  deep_sea_level    and value <= shallow_sea_level
        type = :water_shallow if value >  shallow_sea_level and value <= sea_level
        type = :beach         if value >  sea_level         and value <= forest_level
        type = :forest        if value <= forest_level
        type ||= :error
        @map[row][column] = type
      end
    end
  end

  def elevation_percent(percent)
    elevations[(elevations.length * percent * 0.01).floor]
  end

  def sea_level
    elevation_percent(@sea_level)
  end

  def shallow_sea_level
    elevation_percent(@shallow_sea_level)
  end

  def deep_sea_level
    elevation_percent(@deep_sea_level)
  end

  def forest_level
    elevation_percent(@forest_level)
  end

end

wg=WorldGenerator.new
puts wg.map
