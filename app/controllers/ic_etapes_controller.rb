class IcEtapesController < ApplicationController

  before_action :legal_current_user?, except: []

  # Méthode appelée pour définir le partage des documents de l'étape.
  #
  # C'est notamment la méthode qui est appelée avec le ticket, après le dépôt
  # des documents sur le QdD, pour tout partager.
  def document_sharing
    icetape     = IcEtape.find(params[:id])
    @icetape = icetape # seulement pour l'erreur, pour le moment
    document_id = params[:did].to_i # mis ici pour l'erreur RecordNotFound
    if params[:shared].blank?
      # <= pas de paramètre shared
      # => on fait le détail d'un document (original et commentaire)
      # etape_id        = params[:id]
      original_shared = params[:osh] == '1' # :osh pour "original shared"
      comments_shared = params[:csh] == '1' # :csh pour "comments shared"

      # On prend le document
      icdoc = IcDocument.find(document_id)

      if icdoc.ic_etape == icetape
        # <= C'est bien un document de l'étape
        # => On définit son partage

        icdoc.send(original_shared ? :share : :dont_share, :original, dont_save = true)
        icdoc.send(comments_shared ? :share : :dont_share, :comments, dont_save = true)
        icdoc.save_options

        mess = [I18n.t('documents.sharing.defined', name: icdoc.original_name)]

        if original_shared || comments_shared
          # <= Un au moins des documents est partagé
          if original_shared && comments_shared
            mess << I18n.t('documents.sharing.thanks_for_all')
          elsif original_shared
            mess << I18n.t('documents.sharing.only_original')
          else
            mess << I18n.t('documents.sharing.only_comments')
          end
        else
          # <= Si aucun des deux n'a été partagé
          # => Petit message de regret
          mess << I18n.t('documents.sharing.regret_none')
          mess << I18n.t('documents.sharing.read_charte')
          # mess << 'Je vous invite à (re)lire la <a href="%{url}" target="_new">Charte de partage</a> de l’atelier' % {url: aide_path('partage')}
        end
        flash[:success] = mess.join('<br>')

      else
        flash[:danger] = 'Le document %{did} n’appartient pas à l’étape spécifiée.'
      end
    else
      # <= paramètre shared défini
      # => traitement en gros de tous les document
      # params[:shared] peut avoir la valeur :all ou :none
      icetape.share_documents(params[:shared].to_sym)
    end

  rescue ActiveRecord::RecordNotFound => e
    classe  = @icetape.nil? ? 'IcEtape' : 'IcDocument'
    id      = @icetape.nil? ? params[:id].inspect : params[:did].inspect
    flash[:danger] = I18n.t('activerecord.errors.models.record_not_found', {classe: classe, id: id})
  ensure
    redirect_back(fallback_location: root_path)
  end
  # /share

  private

    def legal_current_user?
      return if current_user && (current_user.admin? || IcEtape.find(params[:id]).user == current_user)
      flash[:danger] = I18n.t('action.errors.not_autorised')
      redirect_to home_path
    end
end
