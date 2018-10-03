Description de l'action-watcher
===============================

Watcher permettant à l'administrateur de charger le document de travail de l'icarien envoyé pour une étape de travail.

Il permet de télécharger les documents et d'indiquer la date de remise des commentaires.

`objet` est l'ic-étape pour lequel le travail est envoyé.

`objet.ic_documents` contient donc tous les documents de l'étape.

`objet.ic_documents.first.original` correspond au document (original) envoyé par l'icarien(ne).
