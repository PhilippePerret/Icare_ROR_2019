# encoding: UTF-8
class Icare
class << self

  # Initialisation de la commande
  def init
    return true # pour runner ensuite
  end

  # Jeu de la commande
  def run
    CLI.analyse_command_line || return # (1)
    if CLI.command == 'help' || CLI.options[:help] || CLI.command.nil?
      display_help and return
    else
      run_by_command
    end
  end

  def run_by_command
    case CLI.command
    when 'open'
      unless CLI.options[:online]
        puts "... Ouverture de l'atelier en local"
        `cd "#{ICARE_FOLDER}";rails server -d`
        `open http:localhost:3000/`
      else
        puts '... Ouverture de l’atelier distant'
        `open http://www.atelier-icare.net`
      end
    when 'kill'
      # TODO Pour tuer les processus ouverts, au cas où
      if CLI.params[1]
        `kill -9 #{CLI.params[1]}`
        puts "Processus #{CLI.params[1]} tué avec succès (normalement)"
      end
      puts `ps aux | grep puma` # spring au départ
    else
      puts ('La commande "%s" n’est pas encore implémentée.' % [CLI.command]).rouge
    end
  end

end #/<< self
end #/Icare
