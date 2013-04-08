require 'io/console'
require_relative 'sprite_factory'
require_relative 'world_generator'
require_relative 'render_engine'
require_relative 'player'
require_relative 'game_console'
$DEBUG = true

terrain = SpriteFactory.new(yaml: 'objects/terrain.yml')
world   = WorldGenerator.new(terrain, size: 200)
engine  = RenderEngine.new(world.map)
player  = Player.new({x: world.width / 2, y: world.height / 2})
engine.register(player)
console = GameConsole.new(player: player, engine: engine)
console.start
