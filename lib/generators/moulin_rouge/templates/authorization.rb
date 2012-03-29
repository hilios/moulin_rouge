class <%= name.camelize %>Authorization < MoulinRouge::Authorization
  # can :read, Post
  # can :read, Comment
  # can :manage, Comment do |comment|
  #   comment.user_id == current_user.id
  # end
  # 
  # role :admin do
  #   can :manage, :all
  # end
  # 
  # group :main do
  #   role :editor do
  #     can :manage, Post
  #   end
  # 
  #   role :author do
  #     can :manage, Post, :user_id => current_user.id
  #   end
  # end
end