require_relative 'drawable'

class Sprite
  include Drawable

  def initialize(args={})
    defaults.merge(args)
    .each { |k,v| instance_variable_set("@#{k}",v) }
    @string = chars
  end

  def defaults
    {
      bg_color: :black,
      color: :white,
      chars: [' ', ' ', ' '],
      random_chars: false,
    }
  end

end
