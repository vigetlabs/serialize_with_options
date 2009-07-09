require 'test_helper'

class SerializeWithOptionsTest < Test::Unit::TestCase
  context "An instance of a class with serialization options" do
    setup do
      @user = User.create(:name => "John User", :email => "john@example.com")
      @post = @user.posts.create(:title => "Hello World!", :content => "Welcome to my blog.")
      @comment = @post.comments.create(:content => "Great blog!")
    end

    context "being converted to XML" do
      setup do
        @user_xml = Hash.from_xml(@user.to_xml)["user"]
        @post_xml = Hash.from_xml(@post.to_xml)["post"]
      end

      should "include active_record attributes" do
        assert_equal @user.name, @user_xml["name"]
      end

      should "include specified methods" do
        assert_equal @user.post_count, @user_xml["post_count"]
      end

      should "exclude specified attributes" do
        assert_equal nil, @user_xml["email"]
      end

      should "include specified associations" do
        assert_equal @post.title, @user_xml["posts"].first["title"]
      end

      should "include specified methods on associations" do
        assert_equal @user.post_count, @post_xml["user"]["post_count"]
      end

      should "exclude specified methods on associations" do
        assert_equal nil,  @post_xml["user"]["email"]
      end

      should "not include associations of associations" do
        assert_equal nil, @user_xml["posts"].first["comments"]
      end

      should "include association without serialization options properly" do
        assert_equal @comment.content, @post_xml["comments"].first["content"]
      end
    end

    context "being converted to JSON" do
      setup do
        @user_json = JSON.parse(@user.to_json)
        @post_json = JSON.parse(@post.to_json)
      end

      should "include active_record attributes" do
        assert_equal @user.name, @user_json["name"]
      end

      should "include specified methods" do
        assert_equal @user.post_count, @user_json["post_count"]
      end

      should "exclude specified attributes" do
        assert_equal nil, @user_json["email"]
      end

      should "include specified associations" do
        assert_equal @post.title, @user_json["posts"].first["title"]
      end

      should "include specified methods on associations" do
        assert_equal @user.post_count, @post_json["user"]["post_count"]
      end

      should "exclude specified methods on associations" do
        assert_equal nil,  @post_json["user"]["email"]
      end

      should "not include associations of associations" do
        assert_equal nil, @user_json["posts"].first["comments"]
      end

      should "include association without serialization options properly" do
        assert_equal @comment.content, @post_json["comments"].first["content"]
      end
    end
  end
end
