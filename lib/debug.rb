require 'io/console'
require_relative 'sprite_factory'
require_relative 'world_generator'
require_relative 'render_engine'
require_relative 'player'
require_relative 'game_console'
$DEBUG = true

sprite_path = File.expand_path(File.join(File.dirname(__FILE__), "objects/sprites.yml"))
terrain = SpriteFactory.new(yaml: sprite_path)
world   = WorldGenerator.new(terrain, size: 200)#, seed: 200)
engine  = RenderEngine.new(world.map, size: 20)
engine.render_chunk
