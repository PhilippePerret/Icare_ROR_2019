# Extension de l'ActionMailer

Cette extension permet de faciliter les tests.

Usage simple :


```ruby

  mail_found = assert_mail_exists?(
    {
      # Les paramètres de la recherche
      subject:  'Le sujet recherché',
      to:       'Le mail du destinataire',
      from:     'Le mail de l’expéditeur',
      messages:  ['portion de mail', 'autre portion de mail']
    },
    {
      # Les options de recherche
      lasts:    3, # pour prendre seulement les 3 derniers messages
      trace:    true, # pour retourner en console le détail des rejets
      failure:  'Le message en cas d’échec'
    }
  )
```

## Pour trouver un simple message par le sujet :


```ruby

  mail_found = assert_mail_exists?(subject: 'Le sujet du message')

```

## Retour

La méthode `assert_mail_exists?` retourne le premier message trouvé, le cas échéant.

## Options

### lasts: `<nombre>`

Pour prendre les `<nombre>` derniers messages.

### last: true

Pour ne considérer que le dernier message.

### trace: true

Pour afficher en console le check des mails et pourquoi ils ont été rejetés.
