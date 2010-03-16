module Koinonia
  module StiFactory
    def self.included(base)
      base.extend Koinonia::StiFactory::ClassMethods
    end
    
    module ClassMethods
      def has_sti_factory
        extend Koinonia::StiFactory::StiClassMethods
        class << self
          alias_method_chain :new, :factory unless method_defined?(:new_without_factory)
        end
      end
    end
    
    module StiClassMethods
      def subclass_names
        subclasses.map(&:name).push(self.name)
      end

      def new_with_factory(*args)
        options = args.last.is_a?(Hash) ? args.last : {}
        
        klass_name = identify_target_class options
        klass = self.subclass_names.include?(klass_name) ? klass_name.constantize : self
        
        klass.new_without_factory(*args)
      end

      private
      def identify_target_class( options )
        class_name = options.delete(self.inheritance_column.to_sym) 
        class_name ||= options.delete(self.inheritance_column) 
        class_name ||= self.name 
      end
    end
  end
end
