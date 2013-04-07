class Player
  attr_accessor :x, :y

  def initialize(args={})
    defaults.merge(args)
    .each { |k,v| instance_variable_set("@#{k}",v) }
  end

  def defaults
    {
      x: 0,
      y: 0,
    }
  end
end
