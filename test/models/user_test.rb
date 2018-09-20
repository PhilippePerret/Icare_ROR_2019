require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: 'Un utilisateur', email: "sonemailvalidea#{Time.now.to_i}@chez.com")
  end

  test "L'utilisateur créé est valide" do
    assert @user.valid?
  end

  test "L'utilisateur doit avoir un nom" do
    @user.name = '     '
    assert_not @user.valid?
  end

  test "Le nom ne doit pas dépasser 50 caractères" do
    @user.name = 'x' * 51
    assert_not @user.valid?
  end

  test "L'utilisateur doit avoir un mail" do
    @user.email = '    '
    assert_not @user.valid?
  end
  test "L'email ne doit pas dépasser 255 caractères" do
    @user.email = 'x'*240 + '@admigrtudfA.com'
    assert_not @user.valid?
  end
  test "L'email doit être valide" do
    goodmails = %w[mon.mail@chez.lui mon-mail@chez.lui]
    badmails  = %w[mon.mailchez.lui @chez.lui monmail@ monmail@chez,lui !monmail@chez.lui monmail@chez..com]

    goodmails.each do |mail|
      @user.email = mail
      assert @user.valid?, "#{mail.inspect} est un mail valide"
    end
    badmails.each do |mail|
      @user.email = mail
      assert_not @user.valid?, "#{mail.inspect} n'est pas un mail valide"
    end
  end

  test "Un utilisateur doit avoir un email unique" do
    dupuser = @user.dup
    dupuser.email = @user.email.upcase
    @user.save
    assert_not dupuser.valid?
  end
end
