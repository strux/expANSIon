require 'io/console'
require_relative 'sprite_factory'
require_relative 'world_generator_2'
require_relative 'render_engine'
require_relative 'player'
require_relative 'game_console'
$DEBUG = true

sprite_path = File.expand_path(File.join(File.dirname(__FILE__), "objects/terrain.yml"))
terrain = SpriteFactory.new(yaml: sprite_path)
world   = WorldGenerator.new(terrain, size: 20, seed: 200)
engine  = RenderEngine.new(world.map, size: 20)
engine.render_chunk
#player  = Player.new({x: world.width / 2, y: world.height / 2})
#engine.register(player)
#console = GameConsole.new(player: player, engine: engine)
#console.start
