$:.unshift(File.dirname(__FILE__) + '/..')
$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'active_support/version'
if ActiveSupport::VERSION::MAJOR >= 4
  require 'minitest/autorun'
else
  require 'test/unit'
end

require 'sqlite3'
require 'active_record'

if ActiveSupport::VERSION::MAJOR == 3
  ActiveSupport.on_load(:active_record) do
    self.include_root_in_json = false
  end
end

require 'shoulda'
require 'json'
require 'serialize_with_options'
ActiveRecord::Base.extend SerializeWithOptions

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

[:users, :posts, :comments, :check_ins, :reviews].each do |table|
  ActiveRecord::Base.connection.drop_table table rescue nil
end

ActiveRecord::Base.connection.create_table :users do |t|
  t.string :name
  t.string :email
end

ActiveRecord::Base.connection.create_table :posts do |t|
  t.string :title
  t.text :content
  t.integer :user_id
  t.string :type
end

ActiveRecord::Base.connection.create_table :comments do |t|
  t.text :content
  t.integer :post_id
end

ActiveRecord::Base.connection.create_table :check_ins do |t|
  t.integer :user_id
  t.string :code_name
end

ActiveRecord::Base.connection.create_table :reviews do |t|
  t.string :content
  t.integer :reviewable_id
  t.string :reviewable_type
end

