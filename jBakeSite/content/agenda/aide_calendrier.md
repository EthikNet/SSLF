title=Aide sur le Calendrier
date=2026-08-15
type=org_openCiLife_block
category=aide,aide_calendrier
status=published
imageHero={"category":"imageHeroAgenda"}
robots=noindex, nofollow
anchorId=aide_calendrier
order=9999
~~~~~~
## Aide sur le calendrier

Le calendrier affiché est un agenda Google Agenda.

### Préparation
D'abord, il faut un calendrier à partager. Ces actions sont à réaliser **une seul fois** !

#### Création

Pour cela, il faut un compte Google, l'application Google Agenda est incluse, y compris dans le compte gratuit.
Une fois le compte Google créé, allez sur https://calendar.google.com, puis connectez-vous si nécessaire.

Il est recommandé de créer un calendrier dédié pour ce que vous partagez (vous pouvez aussi partager le calendrier principal *si vous savez* pourquoi vous le faites).
Dans la barre latérale à gauche, cliquez sur le petit « + » à côté de « Autres agendas », puis cliquez sur « créer un agenda ».
![Google Agenda créer un agenda](${webleger.build.host}/images/aide/calendrier_creer_agenda.jpg)
Saisissez un nom et, éventuellement, une description à votre agenda.
Le nouvel agenda apparaîtra dans la partie « Mes agendas ».

#### Partager un calendrier

Pour que vos événements soient visibles sur un nouveau calendrier (ou sur un existant), il faut le « partager ».
Cliquez sur les 3 petits points à côté du calendrier, puis sélectionnez "Paramètres et partages".
Sur la page, descendez un peu pour voir la partie "Autorisations d'accès aux événements".
Cliquez sur "Rendre disponible publiquement", puis choisissez le niveau de visibilité. En général, il est préférable d'afficher les détails des événements.
![Google Agenda créer un agenda](${webleger.build.host}/images/aide/calendrier_partager_agenda.jpg).

Descendez en bas de la page dans la section "Intégrer l'agenda", puis copiez l'ID du calendrier.

#### Ajouter un agenda sur un contenu

Sur le contenu sur lequel vous souhaitez faire apparaître le calendrier, dans l'en-tête du contenu, ajoutez une ligne 
> calendar={"calendarId":"ID à coller ici"}

### Partager un évènnement

À réaliser autant de fois que vous souhaitez partager un événement sur le site web.

#### Créer un évènnement

Dans la barre latérale à gauche, cliquez sur le bouton « Créer », puis sélectionnez « un événement ».
![Google Agenda créer un agenda](${webleger.build.host}/images/aide/calendrier_creer_un_evennement.jpg)
Saisissez un *nom* pour votre événement.
Saisissez la date, ainsi que l'heure de début et de fin (la fin peut être un autre jour que l'heure de début ; cela créera un événement sur plusieurs jours).
**important** : Choissez le bon calendrier pour « stocker » votre événement : choisissez le calendrier que vous avez intégré sur le site.
![Google Agenda créer un agenda](${webleger.build.host}/images/aide/calendrier_creer_un_evennement_détails.jpg)

C'est tout, le nouvel événement apparaîtra automatiquement sur le calendrier affiché sur le site.