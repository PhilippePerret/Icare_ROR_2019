# encoding: UTF-8
=begin

  DESCRIPTION DU MODULE

=end
class Icare
class << self
  def exec_kill
    # TODO Pour tuer les processus ouverts, au cas où
    if CLI.params[1]
      `kill -9 #{CLI.params[1]}`
      puts "Processus #{CLI.params[1]} tué avec succès (normalement)"
    end
    puts `ps aux | grep puma` # spring au départ
  end
end #/<< self
end #/Icare
