require 'perlin'

class WorldGenerator
  attr_reader :sprites, :map, :size

  def initialize(sprites, args={})
    @sprites = sprites
    defaults.merge(args)
    .each { |k,v| instance_variable_set("@#{k}",v) }
    @perlin = {}
    @noise = {}
    @range = {}

    @perlin[:elevation] = Perlin::Generator.new(@seed, 1, 4)
    @noise[:elevation]  = @perlin[:elevation].chunk(1, 1, @size, @size, 0.008)
    @range[:elevation]  = @noise[:elevation].flatten.sort

    @perlin[:temp]   = Perlin::Generator.new(@seed, 1, 2)
    @noise[:temp]    = @perlin[:temp].chunk(1, 1, @size, @size, 0.001)
    @range[:temp]    = @noise[:temp].flatten.sort

    @perlin[:precip]   = Perlin::Generator.new((@seed + 1), 1, 2)
    @noise[:precip]    = @perlin[:precip].chunk(1, 1, @size, @size, 0.001)
    @range[:precip]    = @noise[:precip].flatten.sort

    generate_map
  end

  def sprite_map
    return @sprite_map if @sprite_map
    @sprite_map = { elevation: {}, climate: {} }
    sprites.each do |s|
      @sprite_map[:elevation][key_map[:elevation][s.elevation]] = s if s.respond_to? :elevation
      if s.respond_to? :temp and s.respond_to? :precip
        @sprite_map[:climate]["#{key_map[:temp][s.temp]},#{key_map[:precip][s.precip]}"] = s
      end
    end
    @sprite_map
  end

  def key_map
    return @key_map if @key_map
    @key_map = { elevation: {}, temp: {}, precip: {} }
    sprites.each do |s|
      @key_map[:elevation][s.elevation] = value_from_percent(s.elevation, @range[:elevation]) if s.respond_to? :elevation
      @key_map[:temp][s.temp]           = value_from_percent(s.temp, @range[:temp])        if s.respond_to? :temp
      @key_map[:precip][s.precip]       = value_from_percent(s.precip, @range[:precip])      if s.respond_to? :precip
    end
    @key_map
  end

  def closest_key(map_key, input)
    min = -10000000000000
    sorted = key_map[map_key].values.sort
    sorted.each do |value|
      return value if min < input and input <= value
      return value if value == sorted.last
      min = value
    end
  end

  def defaults
    {
      map: [],
      seed: rand(1000),
      size: 200,
    }
  end

  def value_from_percent(percent, list)
    list[(list.length * percent * 0.01).floor - 1]
  end

  def width
    size / 2
  end

  def height
    size / 2
  end

  def generate_map
    @noise[:elevation].each_index do |row|
      @map << []
      @noise[:elevation][row].each_with_index do |value, column|
        sprite_klass = sprite_map[:elevation][closest_key(:elevation, value)]
        if sprite_klass == Biome
          temp =    @noise[:temp][row][column]
          precip =  @noise[:precip][row][column]
          @map[row][column] = sprite_map[:climate]["#{closest_key(:temp, temp)},#{closest_key(:precip, precip)}"].new
        else
          @map[row][column] = sprite_klass.new
        end
      end
    end
  end

end
