require 'paint'

class Sprite
  attr_accessor :chars, :random_chars, :bg_color, :color

  def initialize(args={})
    defaults.merge(args)
    .each { |k,v| instance_variable_set("@#{k}",v) }
  end

  def defaults
    {
      bg_color: :black,
      color: :white,
      chars: [' ', ' ', ' '],
      random_chars: false,
    }
  end

  def draw
    Paint[chars, @color, @bg_color]
  end

  private

  def chars
    chars =  random_chars ? @chars.sample(3) : @chars[0,3]
    chars.join('')
  end
end
