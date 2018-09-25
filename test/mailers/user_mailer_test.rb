require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  def setup
    @phil = User.find_by(email: 'phil@atelier-icare.net')
  end
  test "activation_compte" do

    mail = @phil.create_activation_digest
    assert_equal I18n.t('user_mailer.activation_compte.subject'), mail.subject
    assert_equal [@phil.email], mail.to
    assert_equal ['admin@atelier-icare.net'], mail.from
    body = mail.body.encoded.gsub(/=\n/, '')
    assert_match "Bonjour #{@phil.name}", body
    # assert_match I18n.t('user_mailer.activation_compte.link_confirm'), body
    assert_match @phil.ticket_token, body
  end

  # test "reset_password" do
  #   mail = UserMailer.reset_password
  #   assert_equal "Reset password", mail.subject
  #   assert_equal ["to@example.org"], mail.to
  #   assert_equal ["from@example.com"], mail.from
  #   assert_match "Hi", mail.body.encoded
  # end

end
