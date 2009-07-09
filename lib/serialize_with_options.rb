module SerializeWithOptions
  def serialize_with_options(&block)
    config = Config.new
    config.instance_eval(&block)
    @configuration = config.data

    include InstanceMethods
  end

  def serialization_configuration
    @configuration.try(:dup) || {}
  end

  def serialization_options
    @options ||= returning(serialization_configuration) do |opts|
      includes = opts.delete(:includes)

      if includes
        opts[:include] = includes.inject({}) do |hash, class_name|
          klass = class_name.to_s.singularize.capitalize.constantize
          hash[class_name] = klass.serialization_configuration
          hash[class_name][:include] = nil if hash[class_name].delete(:includes)
          hash
        end
      end
    end
  end

  class Config
    undef_method :methods

    attr_reader :data

    def initialize
      @data = {}
    end

    def method_missing(method, *args)
      @data[method] = args
    end
  end

  module InstanceMethods
    def to_xml(opts = {})
      super(self.class.serialization_options.merge(opts))
    end

    def to_json(opts = {})
      super(self.class.serialization_options.merge(opts))
    end
  end
end
