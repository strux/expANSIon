require_relative 'sprite'
require 'yaml'
require 'active_support/inflector'

class SpriteFactory
  include Enumerable
  attr_accessor :klasses


  def initialize(args)
    @klasses = []
    objs = YAML.load_file(args[:yaml]) if args[:yaml]
    objs = args[:objects] if args[:objects]
    manufactur_classes(objs) if objs
  end

  def <<(val)
    @klasses << val
  end

  def each(&block)
    @klasses.each(&block)
  end

  def manufactur_classes(objs)
    objs.each do |obj, properties|
      klass = Object.const_set(obj.to_s.camelize, Class.new(Sprite))
      klass.send(:define_method, :defaults) do
        super().merge(properties)
      end
      if properties.has_key? :noise_range
        klass.send(:define_singleton_method, :noise_range) do
          properties[:noise_range]
        end
      end
      if properties.has_key? :heat_range
        klass.send(:define_singleton_method, :heat_range) do
          properties[:heat_range]
        end
      end
      if properties.has_key? :wet_range
        klass.send(:define_singleton_method, :wet_range) do
          properties[:wet_range]
        end
      end
      @klasses << klass
    end
  end

  def sprite_sheet
    3.times do 
      klasses.each do |klass|
        3.times { print klass.new.draw }
      end
      puts
    end
  end

end
