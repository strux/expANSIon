require 'pp'
require 'perlin'
require_relative 'sprite_factory'

terrain = SpriteFactory.new(yaml: 'objects/terrain.yml')
#terrain.sprite_sheet

gen = Perlin::Generator.new(rand(300) + 1, 1, 2)
#gen = Perlin::Generator.new(200, 1, 2)
noise = gen.chunk 1, 1, 40, 40, 0.02
elevations = noise.flatten.sort
sea_level = elevations[(elevations.length * 0.4).floor]
medium_sea_level = elevations[(elevations.length * 0.2).floor]
deep_sea_level = elevations[(elevations.length * 0.1).floor]
forest_level = elevations[(elevations.length * 0.6).floor]

t = Time.now
print "\e[2J\e[f""]]"
noise.each do |row|
  row.each do |col|
    print terrain.klasses[:water_deep].new.draw if col <= deep_sea_level
    print terrain.klasses[:water_medium].new.draw if col > deep_sea_level and col <= medium_sea_level
    print terrain.klasses[:water_shallow].new.draw if col > medium_sea_level and col <= sea_level
    print terrain.klasses[:beach].new.draw if col > sea_level and col <= forest_level
    print terrain.klasses[:forest].new.draw if col >= forest_level
  end
  puts
end
puts "Rendered in: #{Time.now - t}"
