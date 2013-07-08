require 'factory_girl_rails'

RSpec.configure do |config|
  # FactoryGirl http://railscasts.com/episodes/158-factories-not-fixtures-revised
  config.include FactoryGirl::Syntax::Methods
end
