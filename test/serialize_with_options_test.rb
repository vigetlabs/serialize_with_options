require 'test_helper'

class User < ActiveRecord::Base
  has_many :posts

  serialize_with_options do
    methods   :post_count
    includes  :posts
    except    :email
  end

  serialize_with_options(:with_email) do
    methods   :post_count
    includes  :posts
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

  serialize_with_options(:with_email) do
    includes :user, :comments
  end
end

class Comment < ActiveRecord::Base
  belongs_to :post
end

class SerializeWithOptionsTest < Test::Unit::TestCase
  def self.should_serialize_with_options
    should "include active_record attributes" do
      assert_equal @user.name, @user_hash["name"]
    end

    should "include specified methods" do
      assert_equal @user.post_count, @user_hash["post_count"]
    end

    should "exclude specified attributes" do
      assert_equal nil, @user_hash["email"]
    end

    should "include specified associations" do
      assert_equal @post.title, @user_hash["posts"].first["title"]
    end

    should "include specified methods on associations" do
      assert_equal @user.post_count, @post_hash["user"]["post_count"]
    end

    should "exclude specified methods on associations" do
      assert_equal nil,  @post_hash["user"]["email"]
    end

    should "not include associations of associations" do
      assert_equal nil, @user_hash["posts"].first["comments"]
    end

    should "include association without serialization options properly" do
      assert_equal @comment.content, @post_hash["comments"].first["content"]
    end
  end

  context "An instance of a class with serialization options" do
    setup do
      @user = User.create(:name => "John User", :email => "john@example.com")
      @post = @user.posts.create(:title => "Hello World!", :content => "Welcome to my blog.")
      @comment = @post.comments.create(:content => "Great blog!")
    end

    context "being converted to XML" do
      setup do
        @user_hash = Hash.from_xml(@user.to_xml)["user"]
        @post_hash = Hash.from_xml(@post.to_xml)["post"]
      end

      should_serialize_with_options
    end

    context "with a secondary configuration" do
      should "use it" do
        user_hash = Hash.from_xml(@user.to_xml(:with_email))["user"]
        assert_equal @user.email, user_hash["email"]
      end

      should "pass it through to included models" do
        post_hash = Hash.from_xml(@post.to_xml(:with_email))["post"]
        assert_equal @user.email, post_hash["user"]["email"]
      end
    end

    context "being converted to JSON" do
      setup do
        @user_hash = JSON.parse(@user.to_json)
        @post_hash = JSON.parse(@post.to_json)
      end

      should_serialize_with_options
    end
  end
end
