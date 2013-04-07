class RenderEngine

  def initialize(map)
    @map = map
  end

  def render_chunk(args={})
    args = {size: 8, x: 0, y: 0}.merge(args)

    t = Time.now
    print "\e[2J\e[f"
    (args[:y]..(args[:y] + args[:size])).each do |col|
      (args[:x]..(args[:x] + args[:size])).each do |row|
        print @map[row][col].draw
      end
      puts
    end
    puts "Rendered in: #{Time.now - t}"
  end

end
