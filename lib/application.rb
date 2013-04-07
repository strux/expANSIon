require_relative 'sprite_factory'
require_relative 'world_generator'
require_relative 'renderer'

terrain = SpriteFactory.new(yaml: 'objects/terrain.yml')
world = WorldGenerator.new(terrain, size: 60)
renderer = Renderer.new(world.map)

