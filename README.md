Moulin Rouge
============

For those who don't know, Mouling Rouge (The Red Windmill) is a cabaret in Paris best know as the birthplace on modern [CanCan](https://github.com/ryanb/cancan) second to [Wikipedia](http://en.wikipedia.org/wiki/Moulin_Rouge).

But what you really wants to know, is that **MR** is a simple and organized solution to include a role system into your application and a helper to manage authorizations with [CanCan](https://github.com/ryanb/cancan). It's heavily based on the KISS concept and on the bitmask scheme proposed by Ryan Bates with some of the drawbacks solved to your convinience.

**Moulin Rouge** act has a DSL to declare and manage permissions and groups os access, further in this text there are examples to show you how to do it.

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
    
Add your permissions to newly create file:
  
```ruby
role :name do
  can :read, :something
end
```
  
Finally include to your model that will have role

```ruby
class User < ActiveRecord::Base
  include MoulinRouge::RoleSystem
  ...
end
```

Usage
-----

First of all, you have to accept that the role registering belongs to the ruby code. Organizing this ruby files with the permission it's a really important point to any serious application.

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
  
### Nested Roles ###

You can go even further and nest all your rules, of course the top ones will embed all nested one, but it won't override definitions.
  
```ruby
role :marketing do
  can :manage, :all

  role :salesman do
    can :manage, Proposal

    role :representatives do
      can :read, Proposal
    end
  end
end
```
  
### Groups ###
  
A group is an easy way to organize your permissions, no matter where file the definition is. They are automatically nested together.

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
user.roles -= :admin
user.roles            # => []
user.roles_list       # => [:admin, :marketing, :managers, ...]
```

Nested roles names
------------------

To avoid name conflicts, whenever you have a nested role or group (at this point you should know that they have no difference) the name on the role list will be prefixed with the parent name separeted by a `_` underscore.

If you have a permission like this:

```ruby
group :manager do
  role :marketing do
    can :manage, Sales
    can :manage, Proposals
    ...
  end
  
  role :project do
    can :manage, Projects
    ...
  end
end
```

The role name in the `role_list` will be:

```ruby
user.role_list  # => [:manager_marketing, :manager_project]
```

And so on.

Credits
=======

*   [Troles](https://github.com/kristianmandrup/trole)
*   [CanTango](https://github.com/kristianmandrup/cantango)
*   [Declarative Authorization](https://github.com/stffn/declarative_authorization)