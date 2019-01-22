# encoding: UTF-8
=begin

  DESCRIPTION DU MODULE

=end
class Icare
class << self
  def exec_open
    unless CLI.options[:online]
      puts "... Ouverture de l'atelier en local"
      `cd "#{ICARE_FOLDER}";rails server -d`
      `open http:localhost:3000/`
    else
      open_online
    end
  end

  # Méthode qui ouvre le site en online
  #
  # On utilise la faculté d'autologin pour aller plus vite
  def open_online
    puts '... Ouverture de l’atelier distant'
    require 'digest/md5'
    digest1 = Digest::MD5.hexdigest(Time.now.to_s)
    digest2 = Digest::MD5.hexdigest("pour autoconnecter l'administrateur#{Time.now.to_i}")
    # TODO Créer un fichier ./tmp/_adm/<digest> avec la session
    fpath = File.join(APPFOLDER,digest1)
    File.open(fpath,'wb'){|f| f.write(digest2)}
    puts "Préparation de l'autoconnection"
    puts "Création du fichier #{digest1} pour autoconnection"
    puts "Contenu : #{digest2}"
    File.exist?(fpath) || raise("Le fichier `#{fpath}` devrait exister")
    # On copie le fichier en ligne
    fpath_online = "www/tmp/_adm/#{digest1}"
    puts "Autoconnection. Merci de patienter…"
    cmd_mkdir = "ssh #{ssh_server} 'mkdir -p \"#{File.dirname(fpath_online)}\"'"
    # puts cmd_mkdir
    # return
    `#{cmd_mkdir}`
    # cmd_scp = "scp \"#{fpath}\" #{ssh_server}: #{fpath_online}"
    cmd_scp = "scp -p \"#{fpath}\" #{ssh_server}:#{File.dirname(fpath_online)}"
    # puts "Command de copy : #{cmd_scp}"
    `#{cmd_scp}`
    `open "http://www.atelier-icare.net/bureau?_adm=#{digest1}&ssid=#{digest2}&uid=1"`
  rescue Exception => e
    raise e
  ensure
    File.unlink(fpath) if File.exist?(fpath)
  end

  def ssh_server
    @ssh_server ||= 'icare@ssh-icare.alwaysdata.net'
  end
end #/<< self
end #/Icare
