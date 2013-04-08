require 'perlin'

class WorldGenerator
  attr_reader :elevation_sprites, :biome_sprites, :elevations, :heats, :wets, :map, :size

  def initialize(sprites, args={})
    @elevation_sprites = sprites.select{ |k| k.respond_to? :noise_range }.sort_by{ |k| k.noise_range }.reverse
    @biome_sprites = sprites.select{ |k| k.respond_to?(:heat_range) && k.respond_to?(:wet_range) }.sort_by{ |k| k.wet_range }.reverse
    defaults.merge(args)
    .each { |k,v| instance_variable_set("@#{k}",v) }

    # TODO Inject dependency
    perlin_elevation  = Perlin::Generator.new(200, 1, 4)
    perlin_wet        = Perlin::Generator.new(202, 1, 2)
    perlin_heat       = Perlin::Generator.new(201, 1, 2)
    @wet_map          = perlin_wet.chunk(1, 1, @size, @size, 0.007)
    @heat_map         = perlin_heat.chunk(1, 1, @size, @size, 0.007)
    @elevation_map    = perlin_elevation.chunk(1, 1, @size, @size, 0.008)
    @wets             = @wet_map.flatten.sort
    @heats            = @heat_map.flatten.sort
    @elevations       = @elevation_map.flatten.sort
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
        sprite_klass = elevation_sprite_from_height(value)
        if sprite_klass.class == Biome
          wet  = @wet_map[row][column]
          heat = @heat_map[row][column]
          @map[row][column] = biome_sprite_from_conditions(wet, heat)
        else
          @map[row][column] = sprite_klass
        end
      end
    end
  end

  def biome_sprite_from_conditions(wet, heat)
    tmp = []
    biome_sprites.each do |klass|
      tmp << klass if wet >= value_from_percent(klass.wet_range, wets)
    end
    tmp.each do |klass|
      return klass.new if heat  >= value_from_percent(klass.heat_range, heats)
    end
  end

  def elevation_sprite_from_height(height)
    elevation_sprites.each do |klass|
      return klass.new if height >= value_from_percent(klass.noise_range, elevations)
    end
  end

  def value_from_percent(percent, list)
    list[(list.length * percent * 0.01).floor]
  end

end
