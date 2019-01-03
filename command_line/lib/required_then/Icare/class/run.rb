# encoding: UTF-8
class Icare
class << self

  # Initialisation de la commande
  def init
    puts "= J'initialise Icare"
    return true
  end

  # Jeu de la commande
  def run
    puts "= Je run Icare"
    CLI.analyse_command_line || return # (1)

  end

end #/<< self
end #/Icare
