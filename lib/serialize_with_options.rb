module SerializeWithOptions
  def serialize_with_options(set = :default, &block)
    @configuration ||= {}
    @options       ||= {}

    @configuration[set] = Config.new.instance_eval(&block)

    include InstanceMethods
  end

  def serialization_configuration(set)
    conf = if @configuration
      @configuration[set] || @configuration[:default]
    end

    conf.try(:dup) || { :methods => nil, :only => nil, :except => nil }
  end

  def serialization_options(set)
    @options[set] ||= returning serialization_configuration(set) do |opts|
      includes = opts.delete(:includes)

      if includes
        opts[:include] = includes.inject({}) do |hash, class_name|
          if class_name.is_a? Hash
            hash.merge(class_name)
          else
            klass = class_name.to_s.classify.constantize
            hash[class_name] = klass.serialization_configuration(set)
            hash[class_name][:include] = nil if hash[class_name].delete(:includes)
            hash
          end
        end
      end
    end
  end

  class Config
    undef_method :methods
    Instructions = [:skip_instruct, :dasherize, :skip_types, :root_in_json].freeze
    
    def initialize
      @data = { :methods => nil, :only => nil, :except => nil }
    end

    def method_missing(method, *args)
      @data[method] = Instructions.include?(method) ? args.first : args 
      @data
    end
  end

  module InstanceMethods
    def to_xml(opts = {})
      set, opts = parse_serialization_options(opts)
      super(self.class.serialization_options(set).deep_merge(opts))
    end

    def to_json(opts = {})
      set, opts = parse_serialization_options(opts)
      super(self.class.serialization_options(set).deep_merge(opts))
    end

    private

    def parse_serialization_options(opts)
      if opts.is_a? Symbol
        set  = opts
        opts = {}
      else
        set  = :default
      end

      [set, opts]
    end
  end
end
