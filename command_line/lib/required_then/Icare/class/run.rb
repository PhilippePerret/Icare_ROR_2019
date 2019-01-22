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
    require_command(CLI.command)
    send("exec_#{CLI.command}".to_sym)
  end

end #/<< self
end #/Icare
