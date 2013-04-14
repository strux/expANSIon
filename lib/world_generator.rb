require 'perlin'

class WorldGenerator
  attr_reader :elevation_sprites, :wet_sprites, :heat_sprites, :elevations, :heats, :wets, :map, :size

  def initialize(sprites, args={})
    @elevation_sprites = sprites.select{ |k| k.respond_to? :noise_range }.sort_by{ |k| k.noise_range }.reverse
    @wet_sprites = sprites.select{ |k| k.respond_to?(:wet_range) }.sort_by{ |k| k.wet_range }
    @heat_sprites = sprites.select{ |k| k.respond_to?(:heat_range) }.sort_by{ |k| k.heat_range }
    defaults.merge(args)
    .each { |k,v| instance_variable_set("@#{k}",v) }

    perlin_wet        = Perlin::Generator.new(@seed, 1, 2)
    perlin_heat       = Perlin::Generator.new(@seed, 1, 2)
    perlin_elevation  = Perlin::Generator.new(@seed, 1, 4)
    @wet_noise        = perlin_wet.chunk(1, 1, @size, @size, 0.007)
    @heat_noise       = perlin_heat.chunk(1, 1, @size, @size, 0.007)
    @elevation_noise  = perlin_elevation.chunk(1, 1, @size, @size, 0.008)
    @wets             = @wet_noise.flatten.sort
    @heats            = @heat_noise.flatten.sort
    @elevations       = @elevation_noise.flatten.sort

    @elevation_lookup = {}
    @elevation_sprites.each{ |s| @elevation_lookup[value_from_percent(s.noise_range, @elevations)] = s }

    generate_map
  end

  def ranged_fixnum_hash_lookup(value, hash, range)
    min = range.first - 1
    hash.keys.sort.each do |k|
      return hash[k] if min < value and value <= k
      min = k
    end
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
        #sprite_klass = elevation_sprite_from_height(value)
        sprite_klass = ranged_fixnum_hash_lookup(value, @elevation_lookup, @elevations)
        require 'debug'
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

  def biome_sprite_from_conditions(wet, heat)
    wet_klasses = wet_sprites.select{ |klass| value_from_percent(klass.wet_range, wets) <= wet }
    heat_klasses = heat_sprites.select{ |klass| value_from_percent(klass.heat_range, heats) <= heat }
    heat_klasses.reverse.each{ |klass| return klass.new if wet_klasses.include? klass }
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
