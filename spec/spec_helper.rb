require 'rubygems'
require 'bundler/setup'
require 'rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.expand_path("spec/support/**/*.rb")].each {|f| require f}

# Require all files from the project
Dir[File.expand_path("lib/**/*.rb")].each {|f| require f}

def permission_file
  File.expand_path("spec/fixtures/spec_permission.rb")
end

def create_permission(content)
  f = File.open(permission_file, 'w')
  f.write(content)
ensure
  f.close
end

RSpec.configure do |config|
  config.mock_with :rspec
  config.before do
    MoulinRouge.configure do |config|
      config.path = File.join(File.expand_path(File.dirname(__FILE__)), "/fixtures/**/*.rb")
    end
  end
  # Remove the permission file created by the helper
  config.after(:each) do
    FileUtils.rm_rf(permission_file) if File.exists?(permission_file)
  end
end
