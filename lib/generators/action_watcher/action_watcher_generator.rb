class ActionWatcherGenerator < Rails::Generators::NamedBase

  class_option 'mail-admin-before',   type: :boolean, default: false
  class_option 'mail-user-before',    type: :boolean, default: false
  class_option 'no-mail-admin-after', type: :boolean, default: false
  class_option 'no-mail-user-after',  type: :boolean, default: false
  class_option 'mails-before',        type: :boolean, default: false
  class_option 'no-mails-after',      type: :boolean, default: false
  class_option 'no-notifies',         type: :boolean, default: false
  class_option 'no-notify-admin',     type: :boolean, default: false
  class_option 'no-notify-user',      type: :boolean, default: false

  source_root File.expand_path('templates', __dir__)


  def copy_fichiers_initials

    @mail_admin_before    = !!options['mail-admin-before']    || !!options['mails-before']
    @mail_user_before     = !!options['mail-user-before']     || !!options['mails-before']
    @no_mail_admin_after  = !!options['no-mail-admin-after']  || !!options['no-mails-after']
    @no_mail_user_after   = !!options['no-mail-user-after']   || !!options['no-mails-after']
    @no_notify_admin      = !!options['no-notify-admin']      || !!options['no-notifies']
    @no_notify_user       = !!options['no-notify-user']       || !!options['no-notifies']


    puts "Construction du dossier `#{folder}'…"
    `mkdir -p "#{folder}"`

    ext = 'html.haml'

    Dir["#{__dir__}/templates/*.*"].each do |f|
      fname = File.basename(f)
      next if fname == "mailto_admin_before.#{ext}" && !@mail_admin_before
      next if fname == "mailto_user_before.#{ext}"  && !@mail_user_before
      next if fname == "mailto_admin_after.#{ext}"  && @no_mail_admin_after
      next if fname == "mailto_user_after.#{ext}"   && @no_mail_user_after
      next if fname == "notify_admin.#{ext}"        && @no_notify_admin
      next if fname == "notify_user.#{ext}"         && @no_notify_user
      copy_file fname, "#{folder}/#{fname}"
    end
  end

  def folder
    @folder ||= File.join('.','lib','action_watchers',file_path)
  end

end
