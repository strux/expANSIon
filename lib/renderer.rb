class Renderer
  t = Time.now
  print "\e[2J\e[f""]]"
  noise.each do |row|
    row.each do |col|
      print terrain.klasses[:water_deep].new.draw if col <= deep_sea_level
      print terrain.klasses[:water_medium].new.draw if col > deep_sea_level and col <= medium_sea_level
      print terrain.klasses[:water_shallow].new.draw if col > medium_sea_level and col <= sea_level
      print terrain.klasses[:beach].new.draw if col > sea_level and col <= forest_level
      print terrain.klasses[:forest].new.draw if col >= forest_level
    end
    puts
  end
  puts "Rendered in: #{Time.now - t}"
end
