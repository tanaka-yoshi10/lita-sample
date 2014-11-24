Lita.configure do |config|
  config.robot.name = "lita-idobata"
  config.robot.log_level = :info
  config.robot.adapter = :idobata
  config.adapter.api_token = ''
  
  require './wrbb_handler.rb'
end

