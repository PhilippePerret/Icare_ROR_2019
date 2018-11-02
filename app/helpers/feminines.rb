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
    if user.femme?
      @hash_feminines_feminin   ||= get_hash_feminin_masculin(true)
    else
      @hash_feminines_masculin  ||= get_hash_feminin_masculin(false)
    end
  end
  def get_hash_feminin_masculin(is_f)
    {
      belle:  is_f ? 'belle'  : 'beau',
      e:      is_f ? 'e'      : '',
      eur:    is_f ? 'rice'   : 'eur',    # lect{eur}/lect{rice}
      le:     is_f ? 'le'     : '',       # quel/quelle
      ne:     is_f ? 'ne'     : '',
      rice:   is_f ? 'rice'   : 'eur',    # lect{eur}/lect{rice}
      te:     is_f ? 'te'     : '',       # cet/cette
      ve:     is_f ? 've'     : 'f'       # actif/active
    }
  end
end
