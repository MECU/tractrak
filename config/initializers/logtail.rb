# if ENV['LOGTAIL_SKIP_LOGS'].blank? && !Rails.env.test?
#   http_device = Logtail::LogDevices::HTTP.new('1HbrVKTmoMA8j2z7Veje34vY')
#   Rails.logger = Logtail::Logger.new(http_device)
# else
#   Rails.logger = Logtail::Logger.new(STDOUT)
# end
