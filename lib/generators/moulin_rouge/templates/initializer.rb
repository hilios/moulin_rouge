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

MoulinRouge.run! # Creates the Ability class