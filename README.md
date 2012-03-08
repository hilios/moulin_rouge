Moulin Rouge
============

In simple words **Moulin Rouge** is a DSL to declare and manage permissions and groups of access, and a wrapper to the [CanCan](https://github.com/ryanb/cancan) authorization system. It will help organize and declare your permissions with plain ruby code, and manage this permissions inside your model.

There are a bunch of examples bellow to show you how to implement.

Installation
------------

Add the gem to your Gemfile:

    gem 'moulin_rouge'
  
And install it

    bundle install

Run the generator to install the roles and permissions structure:

    rails g moulinrouge:install
  
Generate a permission file:

    rails g moulinrouge:permission <name>
    
Add your permissions to newly created file:
  
```ruby
role :name do
  can :read, :something
end
```
  
Finally include to your model that will have roles:

```ruby
class User < ActiveRecord::Base
  include MoulinRouge::RoleSystem
  ...
end
```

Usage
-----

First of all, you have to accept that the role registering belongs to the ruby code. Organizing this ruby files  it's a really important issue to any large application.

When you run:

      bundle g moulinrouge:install
    
This will create the following folder structure:

      root
      | app/
      | | permissions/
      | config/
      | | initalizers
      | | | moulin_rouge.rb
    
### Defining roles ###
    
All your permission files will be stored in the `app/permissions` folder, this is nothing less. There is a custom syntax to help you in the process, but first, you must understand what are Groups and Roles.
  
```ruby
role :superuser do
  can :manage, :all
end

role :editors do
  can :manage, Articles
end

role :authors do
  can :manage, Article do |article|
    article.user_id == user.id
  end
end
```

Note that the `can` method is the *same* for setting the permissions in CanCan, and will be passed as they are on the Ability class. See [Defining Abilities](https://github.com/ryanb/cancan/wiki/defining-abilities) for more information on what you `can` do.
  
### Groups ###
  
A group is an easy way to organize your permissions, no matter where file the definition is. All groups with the same name, will have their abilities and permissions nested together.

```ruby
group :managers do
  role :marketing do
    can :manage, Sales
  end
end

group :managers do
  role :project do
    can :manage, Project
  end
end
```

### Nested roles ###

You can go even further and nest all your rules, the parent will have the abilities defined in their children, but the children won't have the parent ones.
  
```ruby
role :marketing do
  can :manage, :all

  group :salesman do
    role :representatives do
      can :read, Proposal
    end
  end
end
```

To avoid name conflicts, whenever you have a nested roles or groups, their name on the `roles_list` will be prefixed with the parent name separeted by a `_` underscore.

Following the example above, will generate three different roles:

```ruby
model.roles_list  # => [:marketing, :marketing_salesman, :marketing_salesman_representatives]
```

And so on.

### Extending ###

Many times you want to extend a group from another one, in this cases the `include` method will provided such functionality, note that *all* your abilities and nested roles will be append to your target, also, you should provide the full permission name.

```ruby
group :marketing do
  role :admin do
    can :do, :something
  end
end

role :super do
  include :marketing_admin
end
```

Inside your model
-----------------

After defining all your roles, groups and abilities for your application, it's time to assign them to your model. You just need include the `MoulinRouge::Role::Base` to any class and it's done.

```ruby
class User < ActiveRecord::Base
  include MoulinRouge::RoleSystem
  ...
end
```

```ruby
user = User.new
user.roles            # => MoulinRouge::Role::Array[]
user.roles += :admin
user.roles            # => [:admin]
user.role? :admin     # => true
user.role? :marketing # => false
user.roles -= :admin
user.roles            # => []
user.roles_list       # => [:admin, :marketing, :managers, ...]
```

Strategy
--------

This plugin relies on the [bitmask](http://en.wikipedia.org/wiki/Mask_(computing)) strategy to allow has_many roles functionality. The mais problem with this approach, is the fact you can't change the order of itens in the permission array, this is no good.

#### Persistency #####

Goodies
-------

For those who like I dislikes the `load_and_authorize_resource` method from CanCan, here is provided a cleaner and more flexible solution through `ActionController::Responder`, the `MoulinRouge::CanCan::Responder` bellow there are instruction to activate them.

Create the file `lib/application_responder.rb` with the following:

```ruby
require 'moulin_rouge/cancan/responder'

class ApplicationResponder < ActionController::Responder
  include MoulinRouge::CanCan::Responder
end
```

And on your `application_controller.rb` just add the responder:

```ruby
require 'application_responder'

class ApplicationController < ActionController::Base
  protect_from_forgery
  self.responder = ApplicationResponder
  ...
end
```

More about the `Responder`:

*   http://blog.plataformatec.com.br/2009/08/embracing-rest-with-mind-body-and-soul/
*   http://archives.ryandaigle.com/articles/2009/8/6/what-s-new-in-edge-rails-cleaner-restful-controllers-w-respond_with/

Credits
=======

*   [Troles](https://github.com/kristianmandrup/trole)
*   [CanTango](https://github.com/kristianmandrup/cantango)
*   [Declarative Authorization](https://github.com/stffn/declarative_authorization)

### A little of history ###

Mouling Rouge is a cabaret in Paris best know as the birthplace on modern [CanCan](https://github.com/ryanb/cancan) second to [Wikipedia](http://en.wikipedia.org/wiki/Moulin_Rouge).