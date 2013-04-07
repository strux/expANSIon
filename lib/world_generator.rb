require 'perlin'

class WorldGenerator
  attr_reader :entities, :elevations, :map, :size

  def initialize(entities, args={})
    @entities = entities.sort_by{ |k,e| e.terrain_height }.reverse
    defaults.merge(args)
    .each { |k,v| instance_variable_set("@#{k}",v) }

    # TODO Inject dependency
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
    }
  end

  def width
    size / 2
  end

  def height
    size / 2
  end

  def generate_map
    @noise_map.each_index do |row|
      @map << []
      @noise_map[row].each_with_index do |value, column|
        @map[row][column] = entity_from_height(value)
      end
    end
  end

  def entity_from_height(height)
    entities.each do |k, entity_klass|
      return entity_klass.new if height >= elevation_from_percent(entity_klass.terrain_height)
    end
  end

  def elevation_from_percent(percent)
    elevations[(elevations.length * percent * 0.01).floor]
  end

end
