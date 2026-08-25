title=Aide sur la page contact
date=2026-08-17
type=org_openCiLife_block
category=aide,aide_calendrier
status=published
imageHero={"category":"imageHeroAgenda"}
robots=noindex, nofollow
anchorId=aide_contact
order=9994
~~~~~~
## Aide sur la page contact

Cette page contient 3 zones.

### Infos mairie

Les contenus sont dans le dossier **marie** qui contient 3 contenus : 

- 953_mairie_SSLF : l'attribut de contenue **order** (953) permet de positionner ce bloque juste après le titre (en premier). Permet d'afficher les 2 sous bloques (ayant la catégorie **contact_mairie_detail**). 
- 955_infos : contient les infos de contact de la marie via les attributs de page.
- 957_carte : contient la carte grâce à l'attribut de page **map**.

### Numéro d'urgence

Les contenus sont dans le dossier **num_urgence**.

960_numero_urgence : permet de les sous bloques (ayant la catégorie **contact_mairie_num_urgence**). Les contenus avec cette catégorie peuvent être n'importe où dans le projet, mais ils sont regroupés dans le sous-dossier **list**.


Pour chaque numéro d'urgence, il faut : 

- un titre : **title**
- la catégorie : **category=contact_mairie_num_urgence**
- Le télépghone : **phone**
- l'ordre d'affichage : **order**
- un contenu : en général simplement le nom (en titre de niveau 3)

 
### Les autre contacts utiles
 
Les contenus sont dans le dossier **autre_contacts_utiles**.
 
970_autres_contacts_utiles : permet de les sous bloques (ayant la catégorie **contact_utile**). Les contenus avec cette catégorie peuvent être n'importe où dans le projet, si le contenu n'est pas déjà présent, il est possible d'en ajouté des spécifique dans le sous-dossier **list**. 