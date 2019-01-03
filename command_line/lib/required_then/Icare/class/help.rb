# encoding: UTF-8
=begin
  Affichage de l'aide pour la commande icare
=end
class Icare
AIDE_GENERALE = <<-AIDE
  AIDE DE LA COMMANDE `icare` (CLI)
  ---------------------------------

  La commande `icare` permet de gérer l'atelier, son implémentation,
  directement en ligne de commande.

  Cette aide apparait lorsqu'on utilise la commande `icare` seule ou
  avec `icare help` ou encore avec l'option `-h/--help`
  (`icare -h/--help`).

  #{'icare help'.jaune}     Affichage de cette aide.

  #{'icare open'.jaune}     Ouvre le site dans le navigateur par défaut.
                      Ajouter l'option #{'--online'.jaune} pour ouvrir le site
                      en ligne.

  #{'icare kill[ num]'.jaune}   Affiche les processus-serveur (puma) ouverts ou
                      détruit celui de numéro `num`.

  #{'icare todo'.jaune}     Comme pour toute application CLI, gère la todo liste.

AIDE
class << self
  def display_help str = nil
    CLI::Screen.clear
    puts (str ||= AIDE_GENERALE)
  end
end #/<< self
end #/Icare
