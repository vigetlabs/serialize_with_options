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

class User < ActiveRecord::Base
  has_many :posts

  serialize_with_options do
    methods   :post_count
    includes  :posts
    except    :email
  end

  def post_count
    self.posts.count
  end
end

class Post < ActiveRecord::Base
  has_many :comments
  belongs_to :user

  serialize_with_options do
    includes :user, :comments
  end
end

class Comment < ActiveRecord::Base
  belongs_to :post
end