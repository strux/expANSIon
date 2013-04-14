class RenderEngine
  attr_accessor :entities, :size

  def initialize(map, args={})
    @map = map
    @entities = []
    defaults.merge(args)
    .each { |k,v| instance_variable_set("@#{k}",v) }
  end

  def defaults
    {
      size: 40,
    }
  end

  def register(*entities)
    @entities = @entities | entities
  end

  def render_chunk_around(obj)
    x = obj.x - (size / 2)
    y = obj.y - (size / 2)
    render_chunk({x: x, y: y})
  end

  def render_chunk(args={x: 0, y: 0})
    t = Time.now
    print "\e[2J\e[f"
    (args[:y]..(args[:y] + size - 1)).each do |y|
      (args[:x]..(args[:x] + size - 1)).each do |x|
        draw_tile = true
        @entities.each do |e|
          if e.x == x and e.y == y
            e.draw
            draw_tile = false
          end
        end
        @map[x][y].draw if draw_tile
      end
      puts
    end
    puts "Rendered in: #{Time.now - t}" if $DEBUG
  end

end
