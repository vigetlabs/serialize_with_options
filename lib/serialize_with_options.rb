module SerializeWithOptions
  def serialize_with_options(&block)
    config = Config.new
    config.instance_eval(&block)

    @serialization_options = config.options

    extend ClassMethods
    include InstanceMethods
  end

  def serialization_options
    @serialization_options || {}
  end

  class Config
    attr_accessor :options

    def initialize
      @options = {}
    end

    def methods(*args)
      @options[:methods] = args
    end

    def includes(*args)
      @options[:include] = args
    end

    def except(*args)
      @options[:except] = args
    end
  end

  module ClassMethods
    def configure_includes
      opts = serialization_options

      if opts[:include].is_a? Array
        opts[:include] = opts[:include].inject({}) do |hash, class_name|
          klass = class_name.to_s.singularize.capitalize.constantize
          hash[class_name] = klass.serialization_options.dup.merge(:include => nil)
          hash
        end
      end
    end
  end

  module InstanceMethods
    def to_xml(opts = {})
      self.class.configure_includes
      super(self.class.serialization_options.merge(opts))
    end

    def to_json(opts = {})
      self.class.configure_includes
      super(self.class.serialization_options.merge(opts))
    end
  end
end
