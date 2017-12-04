# Default module, please refer to official Rails documentation
class ApplicationMailer < ActionMailer::Base

  default from: 'from@example.com'
  layout 'mailer'

end
