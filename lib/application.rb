require 'io/console'
require_relative 'sprite_factory'
require_relative 'world_generator'
require_relative 'render_engine'

terrain = SpriteFactory.new(yaml: 'objects/terrain.yml')
world = WorldGenerator.new(terrain, size: 200)
re = RenderEngine.new(world.map)

@x = @y = 0
while true
  re.render_chunk(x: @x, y: @y, size: 40)
  ch = STDIN.getch
  return if ch == "x"
  @x += 1 if ch == "l"
  @x -= 1 if ch == "h"
  @y += 1 if ch == "j"
  @y -= 1 if ch == "k"
end
