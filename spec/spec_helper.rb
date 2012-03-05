require 'rubygems'
require 'bundler/setup'
require 'rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.expand_path("spec/support/**/*.rb")].each {|f| require f}

# Require all files from the project
Dir[File.expand_path("lib/**/*.rb")].each {|f| require f}

def spec_permission
  File.expand_path("spec/support/spec_permission.rb")
end

def permission(content)
  File.open(spec_permission, 'w') do |f|
    f.write content
    f.close
  end
end

RSpec.configure do |config|
  config.mock_with :rspec
  config.before do
    MoulinRouge.configure do |config|
      config.path = "spec/support/**/*.rb"
    end
  end
  # Remove the permission file created by the spec
  config.after do
    FileUtils.rm_rf(spec_permission)
  end
end
