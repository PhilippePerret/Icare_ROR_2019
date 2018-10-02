=begin

  Pour pouvoir féminiser les textes.

  On utilise la méthode String.sexize(<user>)

  Si <user> n'est pas fourni, c'est l'user courant qui est pris.

=end
class String
  def sexize(user = nil)
    user ||= current_user
    self % hash_feminin_masculin(user)
  end
  def hash_feminin_masculin(user)
    is_f = user.femme?
    {
      belle:  is_f ? 'belle'  : 'beau',
      e:      is_f ? 'e'      : '',
      le:     is_f ? 'le'     : '',       # quel/quelle
      ne:     is_f ? 'ne'     : '',
      trice:  is_f ? 'trice'  : 'teur',
      ve:     is_f ? 've'     : 'f',      # actif/active
    }
  end
end
