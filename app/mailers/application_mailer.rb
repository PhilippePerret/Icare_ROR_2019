class ApplicationMailer < ActionMailer::Base
  default from: 'Atelier Icare <admin@atelier-icare.net>'
  default to:   'Phil Atelier Icare <phil@atelier-icare.net>'
  layout 'mailer'
end
