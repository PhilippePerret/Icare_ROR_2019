class User
  # NOTE : ce module est appelé quand les actions UsersController#new et
  # UsersController#create sont invoqués. Donc lors de l'inscription de l'user.


  def mail_activation_sent?
    self.option(4) == 1
  end

  def candidature_complete?
    self.option(3) == 1
  end

  # Le watcher de candidature
  def watcher_candidature
    @watcher_candidature ||= begin
      self.action_watchers.where(action: 'user/candidature').last
    end
  end

  # Méthode utilisée par le formulaire pour savoir si les documents
  # de présentation obligatoires ont été transmis
  def documents_ok?
    presentation_ok? && motivation_ok?
  end
  # Le détail
  def presentation_ok?
    self.other_documents.exists?(dtype: 'PRES')
  end
  def motivation_ok?
    self.other_documents.exists?(dtype: 'MOTI')
  end
  def extraits_ok?
    self.other_documents.exists?(dtype: 'EXTR')
  end

  # Modules optionnés
  attr_writer :modules_optionned
  def modules_optionned
    @modules_optionned ||= begin
      unless watcher_candidature.nil?
        watcher_candidature.data
      end
    end
  end

end
