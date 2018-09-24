require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:benoit)
    log_in_as(@user)
    @marion = users(:marion)
  end

  test "Avec de bonnes données, le profil est modifié" do
    new_email = 'bonemail@example.com'

    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {user:{
      email: new_email, sexe: 0, birthyear: 1987,
      password: '', password_confirmation: ''
      }}
    assert_redirected_to profil_path
    @user.reload
    assert_equal new_email, @user.email
  end

  test "Avec de mauvaises données, le profil n'est pas modifié" do

    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {user:{
      email: 'foo@invalid',
      birthyear: '1990', sexe: '2',
      password: 'mot de passe', password_confirmation: 'mot de passe'
      }}
    assert_template 'users/edit' # on reste sur la même page
    assert_select 'div.alert', /Votre adresse mail est invalide/
  end

  test "Un simple user ne peut pas modifier le profil d'un autre user" do
    get edit_user_path(@marion) # note : c'est benoit qui est loggué
    assert_redirected_to login_path
  end

  test "L'user est redirigé après identification" do
    get edit_user_path(@marion)
    assert_redirected_to login_path
    log_in_as(@marion)
    assert_redirected_to edit_user_path(@marion)
  end

end
