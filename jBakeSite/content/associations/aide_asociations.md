title=Aide sur les Associations
date=2026-08-15
type=org_openCiLife_block
category=aide,aide_associations
status=published
imageHero={"category":"imageHeroAgenda"}
robots=noindex, nofollow
anchorId=aide_associations
order=9992
~~~~~~
## Aide sur les associations

Chaque association possède son propre contenu. Les associations sont rangées dans le dossier **jBakeSite/content/associations/annuaire/list**. Chaque fichier contient le nom de l'association. Le nom du fichier n'est pas utilisé, et sert juste à se repérer.

Le contenu *702_title_associations.md* permet de gérer le titre de la page.
Le contenu **associations.md** est la page principale, qui inclue chacune des associations.

## Structure d'une association

![Structure d'une association](${webleger.build.host}/images/aide/assocation_exemple.jpg)

**title=Foyer rural** <= Nom de l'assoiciation : est afifcher en gras et en Vert
**date=2026-07-28** <= date de création du contenu. N'est pas affiché.
**type=org_openCiLife_block** <= Type de contenu. Doit rester **org_openCiLife_block** pour être afifché.
**category=association** <= Category de contenu : doit rester **association** pour être affiché.
**AssoCategorie=culture & loisirs** <= Type d'addociation. Est affiché en premier dans le bloque.
**status=published** <= Le status du contenu. **published** pour être affiché. **Draft** si le contenu ne doit plus être affiché.
**stickers={"disposition":"right", "data":[{"label":"🏠", "specificClass":"topLeftIcon"}]}** <= Icone de l'association. Changer uniquement le *label*. Il est possible de chercher d'autre emotIcone sur le site : [https://emojipedia.org/fr/emoticons](https://emojipedia.org/fr/emoticons).
**exerpt=** <= résumé de l'association, n'est pas affiché.
**responsable=M. Alain BRUN** <= Nom du resposable de l'association. Est affiché en premier dans la zone de contenu del'assocation
**location=10 Avenue Armand Marsaud, 87160 SAINT SULPICE LES FEUILLES** <= adresse de l'aocciation. Affiché en dessous du responsable.
**phone=05.55.76.79.92,06.40.06.56.37** <= Numéro de téléphonne de l'assoication. Il est possible d'en préciser plusieur séparé par une virgule.
**email=alain.brun84@orange.fr** <= E-mail de contact de l'asociation.
**websites=www.foyer-rural-st-sulpice-les-feuilles.fr** <= Site web de l'association. Est afifcher sous forme de badge en bas du bloque.
**hooks={"data":[{"position":"beginItemSubContent", "action":"sticker.build", "renderOnce":true}]}** <= Ne pas modifié ! Permet d'afficher l'icone.
**order=738** <= Ordre d'affichage de l'association par rapport aux autres.

Si un contenu est présent, il sera affiché entre les infos de contact et les badges.

## Créer une association
Il suffit de copier-coller une autre association et de modifier les informations (y compris le nom du fichier).

## Mise à jour

Une fois les modifications/ajouts/supressions effectuées il faut construire et publier le site.