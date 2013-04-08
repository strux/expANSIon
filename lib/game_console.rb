class GameConsole
  attr_accessor :player, :engine

  def initialize(args={})
    defaults.merge(args)
    .each { |k,v| instance_variable_set("@#{k}",v) }
  end

  def defaults
    {}
  end

  def start
    engine.render_chunk_around(player)
    loop do
      ch = STDIN.getch
      return  if ch == "x"
      player.x += 1 if ch == "l"
      player.x -= 1 if ch == "h"
      player.y += 1 if ch == "j"
      player.y -= 1 if ch == "k"
      engine.render_chunk_around(player)
    end
  end
end
