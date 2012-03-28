Moulin Rouge
============

**Moulin Rouge** offers a custom and easy DSL to manage your authorizations and groups of access with [CanCan](https://github.com/ryanb/cancan). The main feature is the ability to split your authorizations in many ruby files, that are automatically pushed to CanCan authorization system. It is also decoupled from any role system giving you flexibility.

There are a bunch of examples bellow to show you how to get started and explaining all features.

Installation
------------

Add the gem to your Gemfile:

    gem 'moulin_rouge'
  
And install it

    bundle install

Run the generator to install the roles and permissions structure:

    rails g moulin_rouge:install
  
Generate a permission file:

    rails g moulin_rouge:auth <name>
    
Add your permissions to newly created file:
  
```ruby
class UserAuthorization < MoulinRouge::Authorization
  role :name do
    can :read, :something
  end
end
```

By default your `current_user` method should respond to `is?`, but you can change this method to match your role system at the configuration.

Usage
-----

First of all, you have to accept that the role registering belongs to the ruby code. Organizing this ruby files  it's a really important issue to any large application.

When you run:

      bundle g moulin_rouge:install
    
This will create the following folder structure:

      root
      | app/
      | | authorizations/
      | config/
      | | initalizers
      | | | moulin_rouge.rb
    
### Defining roles ###
    
All your authorization files will be stored inside the `app/authorizations` folder. Just create a ruby file inside and the definitions will be automatically defined.
  
```ruby
class UserAuthorization < MoulinRouge::Authorization
  role :superuser do
    can :manage, :all
  end

  role :editors do
    can :manage, Articles
  end

  role :authors do
    can :manage, Article do |article|
      article.user_id == current_user.id
    end
  end
end
```

Note that the `can` method is the **same** for defining abilities in CanCan, and will be passed as they are on the Ability class. See [Defining Abilities](https://github.com/ryanb/cancan/wiki/defining-abilities) for more information on what you `can` do. 

Also, the others CanCan methods are avaliable (`cannot`, `can?`, `cannot?`) and will act like expected.
  
### Groups ###
  
A group is an easy way to organize your authorization. All groups with the same name, will have their abilities and authorizations nested together.

The group will delegate all abilities defined inside of it, to their childrens, so any role or group  will have the same abilities defined in the parent. Also the group is not an avaliable role, they only serve has namespaces.

```ruby
class UserAuthorization < MoulinRouge::Authorization
  group :marketing do
    can :read, Dashboard

    role :manager do
      can :manage, Proposal
    end

    role :salesman do
      can :manage, Proposal, :user_id => current_user.id
    end
  end
end
```

To avoid name conflicts, whenever you have a nested roles or groups, their name will be prefixed with the parent name separeted by a `_` underscore just like they were namespaced.

Following the example above, will generate two roles:

```ruby
MoulinRouge::Authorization.defined_roles
# => [:marketing_manager, :marketing_salesman]
# => :marketing_manager   => can :read, Dashboard, can :manage, Proposal
# => :marketing_salesman  => can :read, Dashboard, can :manage, Proposal, :user_id => current_user.id
```

### Nested roles ###

When you have nested rules, they will act has namespaces, no ability will be shared unless is explicited with the `include` method.
  
```ruby
class UserAuthorization < MoulinRouge::Authorization
  role :marketing do
    can :manage, Proposal

    role :salesman do
      can :read, Proposal
    end
  end
end
```

Following the example above, this will generate two roles with the abilities:

```ruby
MoulinRouge::Authorization.defined_roles
# => [:marketing, :marketing_salesman]
# => :marketing            => can :manage, Proposal
# => :marketing_salesman   => can :read, Proposal
```

### Extending ###

If you want extend the abilities from a role to another, **MoulinRouge** let you `include` them automatically. All the abilities from the target will be appended to the caller.

Only roles can be included, and if you provide a name that is not defined, a `RoleNotFound` will be raised. *Notice* by the example bellow, that you should provide the full name of the role in order to find them.

```ruby
class UserAuthorization < MoulinRouge::Authorization
  group :marketing do
    role :admin do
      can :do, :something
    end
  end

  role :super do
    include :marketing_admin
  end
end
```

Configuration
-------------

```ruby
MoulinRouge.configure do |config|
  # Cache authorizations
  config.cache = Rails.env.production?
  # Path for search the authorizations files
  config.path = 'app/authorizations/**/*.rb'
  # Method name that will send to the user to test if the role is assigned to him
  config.test_method = :is?
  # Your user model
  config.model = User
  # The method name that will access the current user information
  config.model_instance = :current_user
end
```

Goodies
-------

For those who does not like the `load_and_authorize_resource` method from CanCan, here is provided a cleaner and more flexible solution through `ActionController::Responder`, the `MoulinRouge::CanCan::Responder` bellow there are instruction to activate them.

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

More about the `Responder` class:

*   http://blog.plataformatec.com.br/2009/08/embracing-rest-with-mind-body-and-soul/
*   http://archives.ryandaigle.com/articles/2009/8/6/what-s-new-in-edge-rails-cleaner-restful-controllers-w-respond_with/

Testing
=======

This gem uses the [RSpec-2](https://www.relishapp.com/rspec) lib for BDD testing, with the help of [Guard](https://github.com/guard/guard) to autotest. For development just execute the following line:

    bundle exec guard

And it will perform all tests, and reload every time you implement something new.

Thanks
======

*   [Troles](https://github.com/kristianmandrup/trole)
*   [CanTango](https://github.com/kristianmandrup/cantango)
*   [Declarative Authorization](https://github.com/stffn/declarative_authorization)

### A little of history ###

Mouling Rouge is a cabaret in Paris best know as the birthplace on modern [CanCan](https://github.com/ryanb/cancan) second to [Wikipedia](http://en.wikipedia.org/wiki/Moulin_Rouge).

Credits
=======

**Edson Hilios** <edson (at) hilios (dot) com (dot) br>