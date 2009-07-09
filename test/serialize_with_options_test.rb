require 'test_helper'

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

    context "being converted to JSON" do
      setup do
        @user_hash = JSON.parse(@user.to_json)
        @post_hash = JSON.parse(@post.to_json)
      end

      should_serialize_with_options
    end
  end
end
