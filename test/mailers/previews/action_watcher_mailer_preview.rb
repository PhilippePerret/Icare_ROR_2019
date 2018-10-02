# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class ActionWatcherMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/activation_compte
  def send_to_admin
    user = User.first
  end

  # Preview this email at http://localhost:3000/rails/mailers/action_watcher_mailer/send_to_user?aw=<nom du watcher>
  #
  # On peut passer les paramètres suivants à l'url ci-dessus :
  #   uid=<id de l'user à prendre>
  #   awid=<id de l'action-watcher à voir>
  #   mail_name=<nom complet du fichier mail à voir>
  #   before=<1 => le mail "before">, sinon, c'est le mail "after" qui est
  #   affiché, s'il existe bien sûr
  def send_to_user
    user =
      if params[:uid].blank?
        User.find_by(email: 'benoit.ackerman@yahoo.fr')
      else
        User.find(params[:uid])
      end
    action_watcher =
      if params[:awid].blank?
        user.action_watchers.create(name: 'user/candidature', objet: user)
      else
        ActionWatcher.find(params[:awid])
      end
    mail_name =
      if params[:mail_name].blank?
        "mailto_user_#{params[:before] == '1' ? 'before' : 'after'}.html.erb"
      else
        params[:mail_name].strip
      end

    action_watcher.params = params
    body, subject = action_watcher.rend_if_exist(mail_name)
    body || raise("Le message du fichier #{mail_name} n'existe pas.")
    ActionWatcherMailer.send_to_user(action_watcher, body, subject)
  end

end
