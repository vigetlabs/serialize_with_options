module SerializeWithOptions
  class Railtie < Rails::Railtie
    initializer 'serialize_with_options.extend_active_record', :after => 'active_record.initialize_database' do |app|
      ActiveSupport.on_load(:active_record) do
        self.extend SerializeWithOptions
      end
    end
  end
end
