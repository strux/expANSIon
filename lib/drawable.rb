require 'paint'

module Drawable
  attr_accessor :chars, :random_chars, :bg_color, :color


  def draw
    print Paint[@string, @color, @bg_color]
  end

  private

  def chars
    chars =  random_chars ? @chars.sample(3) : @chars[0,3]
    chars.join('')
  end
end

