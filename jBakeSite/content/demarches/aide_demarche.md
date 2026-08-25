title=Aide sur la page démarches
date=2026-08-17
type=org_openCiLife_block
category=aide,aide_demarches
status=published
imageHero={"category":"imageHeroAgenda"}
robots=noindex, nofollow
anchorId=aide_demarches
order=9996
~~~~~~
## Aide sur la page démarches

La page **demarches** permet de regrouper les contenus (ayant la catégorie **demarches**).

Chaque démarche est rangé dans le sous dossier **list**. Chaque contenu de démarche doit avoir les élément suivants : 

 - *title* : titre de la démarche, afficher en haut du bloque.
 - *date* : nom affiché.
 - *type" : doit etre **org_openCiLife_post**
 - *category* : doit être **demarches**
 - *subTemplate* : doit être **sslf.servicesSubTemplate**
 - *demarcheCategory* : category de la démarche, permet de filtrer les démarches.
 - *status* : **published** la démarche sera affiché, **draft** la démarche ne sera pas visible.
 - *exerpt* : résumé de la démarche est affiché dans le bloque.
 - *order* : ordre d'affichage des démarches (bloques)
 - *body* : le corps de la démrche. Contient du MarkDown. Chaque démarche est affiché dans une popin il faut éviter que ca soit trop long.