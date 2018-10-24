class MiniFaqsController < ApplicationController

  before_action :logged_in_user
  before_action :only_for_admin, only: [:edit, :update]

  # Création d'une nouvelle question mini-faq (depuis une étape)
  # Noter que seul un icarien peut le faire. D'autre part, il faut même que ce
  # soit un icarien actif
  def create
    current_user.actif? || raise('Seul un icarien actif peut poser une question mini-faq…')
    @minifaq = current_user.mini_faqs.create(
      abs_etape_id: only_params[:abs_etape_id],
      question:     only_params[:question],
      state:        0
    )
    if @minifaq.valid?
      # Créer un watcher avec un mail-before à Phil
      current_user.action_watchers.create(
        name: 'abs_etapes/question_mini_faq',
        objet: @minifaq
      )
      flash[:success] = I18n.t('mini_faq.question.success.sent_to_phil')
    else
      msg = @minifaq.errors.collect do |k,v|
        "#{I18n.t(k)} #{v}"
      end.join('<br>')
      # msg = render(partial: 'shared/error_messages', handlers: [:haml], locals: {objet: @minifaq})
      raise ('Impossible de créer la question faq :<br>%s' % msg).html_safe
    end
  rescue Exception => e
    flash[:danger] =  e.message
  ensure
    redirect_back(fallback_location: root_path)
  end

  # Édition d'une question mini-faq, pour y répondre ou la corriger
  def edit

  end

  # Enregistrement de la modification de la question minifaq
  # Noter que si le texte est vide, on doit détruire la question
  # Cette méthode peut être appelée soit depuis une notification (admin) soit
  # depuis l'affichage d'une étape de travail absolue lorsque c'est l'admin
  # qui visualise (en fait, depuis l'étape de travail, c'est un lien pour
  # éditer la minifaq)
  def update
    @minifaq = MiniFaq.find(params[:id])
    mf_reponse = params[:mini_faq][:reponse].strip
    flash[:danger] = "Pour le moment je ne passe pas par là pour enregistrer la réponse"
  ensure
    redirect_back(fallback_location: root_path)
  end

  private
    def only_params
      @only_params ||= params.require(:mini_faq).permit(:question, :abs_etape_id)
    end
end
