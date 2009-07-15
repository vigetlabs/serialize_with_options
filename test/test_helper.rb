require 'rubygems'
require 'active_record'
require 'test/unit'
require 'shoulda'
require 'json'

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'serialize_with_options'
require File.dirname(__FILE__) + "/../init"

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :dbfile => 'test.db'
)

ActiveRecord::Base.connection.drop_table :users rescue nil
ActiveRecord::Base.connection.drop_table :posts rescue nil
ActiveRecord::Base.connection.drop_table :comments rescue nil
ActiveRecord::Base.connection.drop_table :check_ins rescue nil

ActiveRecord::Base.connection.create_table :users do |t|
  t.string :name
  t.string :email
end

ActiveRecord::Base.connection.create_table :posts do |t|
  t.string :title
  t.text :content
  t.integer :user_id
end

ActiveRecord::Base.connection.create_table :comments do |t|
  t.text :content
  t.integer :post_id
end

ActiveRecord::Base.connection.create_table :check_ins do |t|
  t.integer :user_id
  t.string :code_name
end

