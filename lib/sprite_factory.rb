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
      if properties.has_key? :elevation
        klass.send(:define_singleton_method, :elevation) do
          properties[:elevation]
        end
      end
      if properties.has_key? :temp
        klass.send(:define_singleton_method, :temp) do
          properties[:temp]
        end
      end
      if properties.has_key? :precip
        klass.send(:define_singleton_method, :precip) do
          properties[:precip]
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
