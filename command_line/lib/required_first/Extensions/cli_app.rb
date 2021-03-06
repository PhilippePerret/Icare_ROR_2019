# encoding: UTF-8
=begin

  Module fonctionnement avec le module cli.rb qui permet de définir, pour
  l'application propre, la conversion des diminutifs.

=end

class CLI
  # Raccourcis pour les commandes
  DIM_CMD_TO_REAL_CMD = {
    'stats'       => 'data',
    'update'      => ['build', {update: true}]
  }

  # Liste des correspondances, que ce soit au niveau des commandes,
  # des options ou des paramètres, un mot trouvé en clé sera toujours
  # transformé en sa valeur.
  APP_CORRESPONDANCES = {
    'derniers'    => 'last',
    'dernières'   => 'last',
    'metadata'    => 'metadatas'
  }
  # Les versions courtes communes à toutes les applications
  # Attention, cette table ne travaille qu'avec les options
  # définies par un seul trait.
  # S'il faut transformer une valeur donnée par '--', il faut
  # utiliser la table LANG_OPT_TO_REAL_OPT
  DIM_OPT_TO_REAL_OPT = {
    'h'               => 'help',
    'i'               => 'interactive',
    'o'               => 'output',
    's'               => 'simulate',
    'u'               => 'update',
    'v'               => 'verbose',
    'w'               => 'warning',
  }

  LANG_OPT_TO_REAL_OPT = {
    'delimiteur'      => 'delimitor',
    'profondeur'      => 'depth',
    'depuis'          => 'from'
  }
  # Les versions courtes propres à l'application courante
  # Elles peuvent surclasser des options précédemment définies
  DIM_OPT_TO_REAL_OPT.merge!({
    'bm'              => 'benchmark',
    'doc'             => 'document',
    'del'             => 'delimitor',
    'f'               => 'force',
    'fc'              => 'force_calcul',
    'fdc'             => 'final-draft-coefficient',
    'k'               => 'keys_mode_test',
    'l'               => 'local',
    'm2m'             => 'maxtomin',
    'N'               => 'no_count',
    'sep'             => 'delimitor',
    't'               => 'tableau',

    'now'             => 'today'
  })
end#/CLI
