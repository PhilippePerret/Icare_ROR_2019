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

  test "reset_password" do
    @ticket = @phil.tickets.create(
      name:     'Réinitialiser le mot de passe',
      action:   '/password_resets/%{token}/edit',
      duree:    2.days
    )

    mail = UserMailer.reset_password(@phil, @ticket)
    assert_equal I18n.t('user_mailer.reset_password.subject'), mail.subject
    assert_equal [@phil.email], mail.to
    assert_equal ["admin@atelier-icare.net"], mail.from
    assert_match "Bonjour Phil", mail.body.encoded
  end

end
