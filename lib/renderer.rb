class Renderer

  def initialize(map)
    t = Time.now
    #print "\e[2J\e[f""]]"
    map.each do |row|
      row.each do |sprite|
         print sprite.draw
      end
      puts
    end
    puts "Rendered in: #{Time.now - t}"
  end

end
