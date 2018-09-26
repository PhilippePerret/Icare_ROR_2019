class ApplicationMailer < ActionMailer::Base
  default from: 'Atelier Icare <admin@atelier-icare.net>'
  default to:   'Atelier Icare <admin@atelier-icare.net>'
  layout 'mailer'
end
