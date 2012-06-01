ActiveCrudify
=======

A dynamic resource controller for Rails > 3.0 that keeps your controllers nice and skinny.

ActiveCrudify was inspired from Crudify.


Installation
------------

It's best to install ActiveCrudify by adding your Rails project's Gemfile:

    # Gemfile
    source "http://rubygems.org"
    gem 'active_crudify', '>= 0.1.0'

Now run:

    bundle install


Usage
-----

In its most basic form, active_crudify is designed to be used like this:

    class PostsController < ApplicationController
      crudify :post
    end


Say you want to customize an action that's being defined by crudify, simply overwrite it!

    class PostsController < ApplicationController
      crudify :post

      def create
        @post = Post.new(params[:post])
        # ... the rest of your custom action
      end
    end


Ok that seems easy enough, but what if my action is just a tiny bit different? That's where the _hook methods_ come in...

### Hook Methods

    `before_create`
    `before_update`
    `before_destroy`
    `before_action`

You can define hook_methods in your controller just like this:

    def before_create
      do_something
      supre
    end

Notice: that `before_create` calls a second hook; `before_action`. This is a generic hook that fires before every crud method's call to `save`, `update` or `destroy`. This means it might be helpful for you to call `super` when overwriting this method so that the chain of hooks keeps firing.

Notice: if hook_methods return false, the action will return. Because in action it call hook_methods just like this:

    def create
      ...
      return if before_create === false
      ...
    end

Here's an example of a `before_create` hook:

    class PostsController < ApplicationController
      crudify :post

      def before_create
        @post.author == current_user
        super
      end

    end

### MIT License
