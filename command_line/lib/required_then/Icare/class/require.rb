# encoding: UTF-8
=begin

  Pour requérir des choses

=end
class Icare
class << self

  # Requiert tout le contenu d'un dossier de commande
  def require_command command_name
    fcommand = folder_command(command_name)
    File.exist?(fcommand) || raise("Le dossier `#{fcommand}` est introuvable…")
    Dir["#{fcommand}/**/*.rb"].each{|m|require m}
  end

  def folder_command command_name
    File.join(folder_commands,command_name)
  end
  def folder_commands
    @folder_commands ||= File.join(APPFOLDER,'lib','commands')
  end
end #/<< self
end #/Icare
