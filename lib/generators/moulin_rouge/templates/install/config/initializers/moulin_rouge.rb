MoulinRouge.configure do |config|
  # Cache permissions
  config.cache = Rails.env.production?
  # The search path for permissions
  config.path = 'app/permissions/**/*.rb'
  # The method that will test the permission
  config.test_method = :is?
  # The class of the model
  config.model = User
  # How you like to call the active user model
  config.model_instance = :current_user
end

# Creates the Ability class
MoulinRouge.run!