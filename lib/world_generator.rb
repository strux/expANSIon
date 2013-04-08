require 'perlin'

class WorldGenerator
  attr_reader :elevation_sprites, :elevations, :map, :size

  def initialize(sprites, args={})
    @elevation_sprites = sprites.select{ |k,e| e.respond_to? :noise_range }.sort_by{ |k,e| e.noise_range }.reverse
    defaults.merge(args)
    .each { |k,v| instance_variable_set("@#{k}",v) }

    # TODO Inject dependency
    perlin_gen = Perlin::Generator.new(200, 1, 4)
    @heat_map = perlin_gen.chunk(1, 1, @size, @size, 0.007)
    @wet_map = perlin_gen.chunk(1, 1, @size, @size, 0.007)
    @elevation_map = perlin_gen.chunk(1, 1, @size, @size, 0.008)
    @elevations = @elevation_map.flatten.sort
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
    @elevation_map.each_index do |row|
      @map << []
      @elevation_map[row].each_with_index do |value, column|
        @map[row][column] = elevation_sprite_from_height(value)
      end
    end
  end

  def elevation_sprite_from_height(height)
    elevation_sprites.each do |k, elevation_sprite_klass|
      return elevation_sprite_klass.new if height >= elevation_from_percent(elevation_sprite_klass.noise_range)
    end
  end

  def elevation_from_percent(percent)
    elevations[(elevations.length * percent * 0.01).floor]
  end

end
