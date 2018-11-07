# Méthode de test
# cf. le fichier READ ME
def assert_mail_exists?(params, options = nil)
  message_failure = options && options[:failure] ? options.delete(:failure) : nil
  assert ActionMailer::Base.exists?(params, options), message_failure
end

# Le mail testé
# Chaque mail contenu par ActionMailer::Base.deliveries appartient à
# cette classe.
module Mail
  class Message

    attr_accessor :searched_error

    def set_erreur(param, erreur)
      self.searched_error = '%s invalide : %s' % [param.inspect, erreur]
      # puts "---- searched_error : #{self.searched_error.inspect}"
      return false
    end

    # Return true si le message répond aux paramètres +params+
    def conforme_a? params
      params.each do |param, expected_value|

        case param
        when :messages
          body_contains(expected_value)
        else
          actual_value_is_ok(param, expected_value)
        end || begin
          return false
        end
      end
      # /fin de boucle sur params
      return true
    end
    # /conforme_a?

    # Retourne true si le body du mail contient les valeurs transmises
    def body_contains expected_values
      expected_values.is_a?(Array) || expected_values = [expected_values]
      expected_values.each do |extrait|
        searched_body.include?(extrait) || begin
          return set_erreur(:body, "Le corps du message devrait contenir #{extrait.inspect}. Il contient : #{searched_body.inspect}.")
        end
      end
      return true
    end
    # /body_contains
    def searched_body
      @searched_body ||= self.body.encoded
    end

    # Vérifie la valeur d'une propriété et retourne true si elle correspond.
    # Seul le body n'est pas testé par cette méthode.
    def actual_value_is_ok(param, expected_value)

      actual_value = self.send(param)
      # puts "---- Est-ce que le paramètre #{param.inspect} (valant #{self.send(param).inspect}) est égal à #{expected_value.inspect} ?"
      #

      case actual_value
      when Array
        if expected_value.is_a?(Array)
          actual_value == expected_value || begin
            return set_erreur(param, "Valeur attendue : #{expected_value.inspect} / valeur courante : #{actual_value.inspect}")
          end
        else
          # Si la donnée est une liste mais que la valeur attendue n'en est
          # pas une.
          actual_value.include?(expected_value) || begin
            return set_erreur(param, "La valeur courante #{actual_value.inspect} ne contient pas #{expected_value.inspect}")
          end
        end
      else
        actual_value == expected_value || begin
          return set_erreur(param, "Valeur attendue : #{expected_value.inspect} / valeur courante : #{actual_value.inspect}")
        end
      end
      return true
    end
    # /actual_value_is_ok

  end
  # /Message
end
# /Mail

module ActionMailer
  # Extension de la base
  class Base
    class << self
      attr_accessor :searched_errors      # les erreurs mineurs rencontrées
      attr_accessor :searched_main_error  # l'erreur principale
      attr_accessor :searched_mail        # le mail trouvé avec exists?

      # Retourne true si un mail contenant les paramètres +params+
      # existe dans deliveries
      # options peut contenir
      #     lasts:  <nombre de derniers mail>
      #             Si last: 4, on ne cherche que dans les 4 derniers
      def exists? params, options = nil
        deliveries.count > 0 || begin
          self.searched_main_error = 'Aucun mail dans lesquels chercher.'
          return false
        end
        options ||= Hash.new
        # Pour tracer l'opération
        trace = !!options.delete(:trace)

        mails =
          if options.key?(:lasts)
            deliveries[-options[:lasts]..-1]
          elsif options[:last]
            deliveries.last
          else
            deliveries
          end

        if trace
          puts "\n\n\n---- RECHERCHE D'UN MAIL AVEC LES PARAMÈTRES : #{params.to_yaml}"
          puts "Nombre de mails checkés : #{mails.count}"
        end

        mails.each do |mail|
          # puts "---- mail : #{mail.inspect}::#{mail.class}"
          mail.conforme_a?(params) && begin
            # On a trouvé un mail qui correspondait à la recherche, on peut
            # retourner true (et on mémorise ce mail)
            if trace
              puts "---- Mail conforme trouvé : #{mail.inspect}"
            end
            self.searched_mail = mail
            return true
          end
          if trace
            puts "---- mail invalide : #{mail.header}"
            puts "---- RAISON: #{mail.searched_error}"
          end
        end
        return false
      end

    end #/<< self
  end #/Base
end #/ActionMailer
