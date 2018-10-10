=begin

User fictif, quand le visiteur n'est pas identifié

=end
class UserNone
  def id            ; 0         end
  def name          ; 'Dude'    end
  alias :pseudo :name
  def super_admin?  ; false     end
  def admin?        ; false     end
  def postulant?    ; false     end
  def accepted?     ; false     end
  def actif?        ; false     end
  def en_pause?     ; false     end
  def ancien?       ; false     end
  def detruit?      ; false     end
  def femme?        ; false     end
  def compte_actif? ; false     end
end#/Class UserNone
