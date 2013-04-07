class RenderEngine

  def initialize(map, args={})
    @map = map
    defaults.merge(args)
    .each { |k,v| instance_variable_set("@#{k}",v) }
  end

  def defaults
    {
      size: 30,
    }
  end

  def render_center
    # math half etc
    render_chunk(x: x, y: y)
  end

  def render_chunk(args={x: 0, y: 0})
    args = defaults.merge(args)
    t = Time.now
    print "\e[2J\e[f"
    (args[:y]..(args[:y] + args[:size])).each do |col|
      (args[:x]..(args[:x] + args[:size])).each do |row|
        print @map[row][col].draw
      end
      puts
    end
    puts "Rendered in: #{Time.now - t}" if $DEBUG
  end

end
