=begin

Classe fictive pour une IcEtape, lorsqu'il n'y en a pas.
Elle est utile lorsque l'administrateur visualise les étapes absolues, pour
afficher les textes qui ont besoin de connaitre l'ic-étape courante.

=end
class IcEtapeNone

  def user
    @user ||= User.find(1)
  end

  def bind
    binding()
  end


  def travail_propre
    @travail_propre ||= begin
      <<-HTML
      <div>Un travail propre purement fictif, juste pour voir dans un &lt;DIV&gt;.</div>
      <p>Ou ici dans un &lt;P&gt;.</p>
      HTML
    end
  end

end
