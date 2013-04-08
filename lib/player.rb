class Player
  include Drawable

  attr_accessor :x, :y

  def initialize(args={})
    defaults.merge(args)
    .each { |k,v| instance_variable_set("@#{k}",v) }
    @color = "#733c00"
    @bg_color = "#9c671a"
    @string = "`X`"
  end

  def defaults
    {
      x: 0,
      y: 0,
    }
  end
  
end
