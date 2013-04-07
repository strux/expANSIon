class GameConsole
  attr_accessor :player, :engine, :start_location

  def initialize(args={})
    defaults.merge(args)
    .each { |k,v| instance_variable_set("@#{k}",v) }
  end

  def defaults
    {
      start_location: :center,
    }
  end

  def start
    engine.render_chunk(x: player.x, y: player.y)
    loop do
      ch = STDIN.getch
      return  if ch == "x"
      player.x += 1 if ch == "l"
      player.x -= 1 if ch == "h"
      player.y += 1 if ch == "j"
      player.y -= 1 if ch == "k"
      engine.render_chunk(x: player.x, y: player.y)
    end
  end
end
