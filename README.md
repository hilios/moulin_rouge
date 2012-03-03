Moulin Rouge
============

For those who don't know, Mouling Rouge (The Red Windmill) is a cabaret in Paris best know as the birthplace on modern [CanCan](https://github.com/ryanb/cancan) second to [Wikipedia](http://en.wikipedia.org/wiki/Moulin_Rouge).

A simple and organized solution to include a role system into your application and a helper to manage authorizations with [CanCan](https://github.com/ryanb/cancan). It's heavily on the KISS concept and based on the bitmask scheme proposed by Ryan Bates with some of the drawbacks resolved for your convinience.

*Moulin Rouge* act has a DSL to declare and manage permissions and groups os access, further in this text there are examples to show you how to do it.

Installation
============

Add the gem to your Gemfile:

  gem 'moulin_rouge'
  
And install it

  bundle install

Run the generator to install the roles and permissions structure:

  rails g moulinrouge:install
  
Generate a permission file:

  rails g moulinrouge:permission <name>
    
Add your permissions to newly create file:
  
  role :name do
    can :read, :something
  end
  
Finally include to your model that will have role

  class User < ActiveRecord::Base
    include MoulinRouge::RoleSystem
    ...
  end

Usage
=====

First of all, you have to accept that the role registering belongs to the ruby code. Organizing this ruby files with the permission it's a really important point to any serious application.

When you run:

    bundle g moulinrouge:install
    
It should create the following folder structure:
    root
    | app/
    | | permissions/
    | config/
    | | initalizers
    | | | moulin_rouge.rb
    
Defining the roles
------------------
    
All your permission files will be stored in the app/permissions folder, this is nothing less. There is a custom syntax to help you in the process, but first, you must understand what are Groups and Roles.
  
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
  
### Nested Roles ###

You can go even further and nest all your rules, of course the top ones will embed all nested one, but it won't override definitions.
  
  role :marketing do
    can :manage, :all
  
    role :salesman do
      can :manage, Proposal

      role :representatives do
        can :read, Proposal
      end
    end
  end
  
  
### Groups ###
  
A group is an easy way to organize your permissions, no matter where file the definition is. They are automatically nested together.

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
  
Credits
=======

*   Troles[https://github.com/kristianmandrup/trole]
*   CanTango[CanTango[https://github.com/kristianmandrup/cantango]
*   Declarative Authorization[https://github.com/stffn/declarative_authorization]