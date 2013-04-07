require_relative 'sprite_factory'
require_relative 'world_generator'
require_relative 'render_engine'

terrain = SpriteFactory.new(yaml: 'objects/terrain.yml')
world = WorldGenerator.new(terrain, size: 200)
re = RenderEngine.new(world.map)

