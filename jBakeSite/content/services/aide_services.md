title=Aide sur les Services
date=2026-08-28
type=org_openCiLife_block
category=aide,aide_services
status=published
imageHero={"category":"imageHeroAgenda"}
robots=noindex, nofollow
anchorId=aide_projets
order=9998
~~~~~~
## Aide sur les Services

La page des Services, définie par **services.md** contient le bloque ("services").
Chaque bloque est dans un des sous-dossier : autres, dechets, sante_secu, vie_local_famille. Dans chaque sous-dossier il y a un fichier (par exemple **399_autres_services.md**) de **category=services** qui va définir le titre, le contenu (généralement vide, sera afifché avent les services), l'image et les type de contenus à afficher. Il va uassi définir quelles groupe de services seront affiché dans cette zone, via ``includeContent.category``.
Chaque groupe de catégorie sont défini dans un sous-sous-dossier. Dans ce dossier il y a un contenu (par eexemple **transport.md**) qui va définir : le titre, le résumé, l'incone du bloque.
Enfin chaque services est défini dans un contenu rangé dans un sous dossier "list". Par exemple **302_ligne_bus_limoges.md**.

**Important** : la strcuture des dossiers n'est pas très importante pour l'afifchage sur le site, seul les **category** sont utiliser pour inclure els contenus dans une zone ou une autre.

### Structure bloque de services

Sert principalement à regrouper les "groupes de services" et à définir le titre.

**title=Autres services** <= titre de bloque.
**includeContent.category** <= Les block qui seront intégrés dans cette zone.


### Structure d'un "groupe de services"

Sert principalement à définir l'icône, le titre, le résumé et à définir les services de chaque bloque.

**title=Transport** <= titre du bloque.
**category=autres_services** <= permet de définir où sera affiché le service.
**toc={"title":"Sommaire", "displayImg":true}** <= ne pas modifier, permet de créer une table des matières, elle sert pour les listing.
**hooks={"data":[{"position":"beforeContent", "action":"toc.build", "renderOnce":true, "order":80}]}** <= ne pas modifier, sert a défini ou est affiché la ToC.
**contentImage=...** <= image du bloque, il est recommandé d'utiliser du SVG en ligne.
**specificClass=servicesPage** <= à conserver pour que l'affichage soit correct.
### Structure d'un service

![Service : rendu sr la page de vnetilation](${webleger.build.host}/images/aide/service_exemple_ventilation.jpg)
Chaque service est affiché dans la page de ventilation "services". Le titre et l'image sont utilisés pour créer le lien vers les infos du service.

![Structure d'u servicee](${webleger.build.host}/images/aide/service_exemple.jpg)
**title=Mobilité solidaire** <= Nom du service : est affiché en gras et en vert.
**date=2026-07-17** <= date de création du contenu. N'est pas affiché.
**type=org_openCiLife_block** <= type de contenu. Doit rester **org_openCiLife_block** pour être affiché.
**category=transport** <= category du service : permet de l'afficher dans le bon "groupe de service".
**subTemplate=sslf.servicesSubTemplate** <= doit resté ainsi pour être correctement afifché.
**status=published** <= le status du contenu. **published** pour être affiché. **Draft** si le contenu ne doit plus être affiché.
**contentImage** <= image du service. Est affichée en petit près du titre et dans la page de ventilation des services.
**exerpt=** <= résumé du service, est affiché dans la zone de titre.
**anchorId** <= permet de définir une ancre pour le service, si aucune n'est précisée une sera générée. Il est recommandé dans saisir une. **Doit** être unique. L'ancre permet de faire un lien direct vers ce service, via un "#" à la fin de l'URL.
**infos communes** <= Informations générales, comme le téléphone ("phone"), l'e-mail ("email"), le site web ("web"), une date au format libre ("freeDate"), etc. Ces informations sont affichées à la fin de la zone.
**order=802** <= Ordre d'affichage du service par rapport aux autres.

Le contenu occupe la partie principale du bloque. Les citations (lignes commençants par "> ") sont affichées sur fond vert.
