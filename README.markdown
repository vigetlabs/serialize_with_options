SerializeWithOptions
====================

This plugin is designed to make creating XML and JSON APIs for your Rails apps dead simple. We noticed a lot of repetition when creating API responses in our controllers. With this plugin, you can set the serialization options for a model with a simple DSL, rather than repeating them in every controller that includes it.


Example
-------

Here is a simple example of SerializeWithOptions in action:

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

With these directives in place, we can call `@post.to_xml` (or `@post.to_json`) and it's as if we entered:

    @post.to_xml(:include => { :user => { :methods => :post_count, :except => :email }, :comments => { } })

In our controller, we can just say:

    def show
      @post = Post.find(params[:id])

      respond_to do |format|
        format.html
        format.xml { render :xml => @post }
        format.json { render :json => @post }
      end
    end

All serialization options are enclosed in a `serialize_with_options` block. There are three options, lifted directly from ActiveRecord's [serialization API][ser]: `methods` are the methods to add to the default attributes, `includes` are the associated models, and `except` are the methods/attributes to leave out.

If an included model has its own `serialize_with_options` block, its `methods` and `except` will be respected. However, the included model's `includes` directive will be ignored (only one level of nesting is supported).


Installation
------------

From your app root:

    script/plugin install git://github.com/vigetlabs/serialize_with_options.git

* * *

Copyright (c) 2009 David Eisinger ([Viget Labs][vgt]), released under the MIT license.

[ser]: http://api.rubyonrails.org/classes/ActiveRecord/Serialization.html
[vgt]: http://www.viget.com/
