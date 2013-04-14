require 'perlin'

class WorldGenerator
  attr_reader :sprites, :map, :size

  def initialize(sprites, args={})
    @sprites = sprites
    defaults.merge(args)
    .each { |k,v| instance_variable_set("@#{k}",v) }

    perlin_elevation  = Perlin::Generator.new(@seed, 1, 4)
    @elevation_noise  = perlin_elevation.chunk(1, 1, @size, @size, 0.008)
    @elevation_range  = @elevation_noise.flatten.sort

    generate_map
  end

  def elevation_lookup
    return @elevation_lookup if @elevation_lookup
    @elevation_lookup = {}
    sprites.each do |s|
      @elevation_lookup[value_from_percent(s.elevation_range, @elevation_range)] = s if s.respond_to? :elevation_range
    end
    @elevation_lookup
  end

  def closest_fixnum_key(value, hash)
    min = -100000000000000
    hash.keys.sort.each do |k|
      return k if min < value and value <= k
      min = k
    end
  end

  def value_from_percent(percent, list)
    list[(list.length * percent * 0.01).floor - 1]
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
    @elevation_noise.each_index do |row|
      @map << []
      @elevation_noise[row].each_with_index do |value, column|
        sprite_klass = elevation_lookup[closest_fixnum_key(value, elevation_lookup)]
        #if sprite_klass.class == Biome
        #  wet  = @wet_noise[row][column]
        #  heat = @heat_noise[row][column]
        #  @map[row][column] = biome_sprite_from_conditions(wet, heat)
        #else
          @map[row][column] = sprite_klass.new
        #end
      end
    end
  end

end
