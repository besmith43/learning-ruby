$: << "../lib"
require 'yaml'
require 'entity'
require 'inflector'
require 'constructor'
require 'animated'
require 'attribute'

class EntityBuilder
  constructor :resource_manager
  
  def setup()
    @gameplay_config = @resource_manager.load_gameplay_config "entity_defs"
    build_dynamic_classes
  end

  def build_dynamic_classes
    p "building entities.."
    for entity_type, unit_def in @gameplay_config
      components = unit_def[:components].collect{|c|require c.to_s;Object.const_get(Inflector.camelize(c))}
      properties = unit_def.keys.dup
      
      klass = Class.new(Entity){
        components.each do |c|
          include c
        end

        properties.each do |prop|
          attribute prop => unit_def[prop]
        end
      }
      klass_name = Inflector.camelize(entity_type)
      Object.const_set klass_name, klass

      # feel weird to do this here
      if components.include? Animated
        klass.animated_class_setup @resource_manager, entity_type
      end
    end
    p "done."
  end
end
