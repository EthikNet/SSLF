title=Aide sur la page d'accueil (Home Page, ou hp)
date=2026-08-17
type=org_openCiLife_block
category=aide,aide_hp
status=published
imageHero={"category":"imageHeroAgenda"}
robots=noindex, nofollow
anchorId=aide_hp
order=9998
~~~~~~
## Aide sur la page d'accueil

La page d'accueil est une page complexe, qu'il n'est pas simple de modifier (dans sa structure). Il n'est pas évident d'ajouter de nouvelle zones.
Il est possible de modifier celle existante, en étant prudent, car chaque bloque contient souvent des composants évolué (Facebook, ...).

### Zone "en direct"

Contient 2 bloques : Facebook et PanneauPocket, chacun affiche des contenus provenant de l'extérieur, configuré via le contenu **120_en_direct/120_en_dierct.md**.

#### Facebook
Il n'y a pas grand-chose à modifier, les modifications s'effectuent dans le contenu **home_page/120_en_direct/list/120_facebook.md**.

- **title** le titre du bloque
- **contentImage** l'image affichée avant le titre
- **action** : l'attribut "label" : permet de changer le texte et l'image, l'attribut "operation.to" permet de changer la destination du lien.
- **body** : le texte affiché entre le titre et l'aperçut des dernier messages Facebook.

#### PanneauPocket
Contient 2 bloques. 

Les derniers messages : configuré via le contenu **home_page/120_en_direct/list/panneauPocketList/122_panneauPocket.md** : 

- **panneauPocket** : permet d'indiquer quelles données de panneuaPocket afficher via ``townId`` et ``townName``.

Le panneau d'information : configuré via le contenu **home_page/120_en_direct/list/panneauPocketList/123_panneauPocket_info.md** : 

- **title** : titre du bloque
- **action** : configuration des boutons : "label" : contient le texte du bouton, "operation" : l'action effectuée lors de l'activation de l'action. Il y a 2 boutons de pré-configuré.
- **body** le contenu affiché entre le titre et les boutons.

### zone "A la une"

Contient 2 bloques : les dernières publications, et l'agenda, configuré via le contenu **130_actus/130_a_la_une.md**.

#### dernière publication

Hormis le **title** il n'y a pas grand-chose à modifier dans ce contenu **130_actus/list/131_dernière_publications.md**. Ce contenu liste automatiquement les 4 (``includeContent.limit``) dernières publications (``includeContent.category=publication``).

#### Agenda

Affiche automatiquement les événements présents dans l'agenda ``calendar.calendarId`` (voir l'aide sur la page Agenda pour plus d'infos).


### Zone "Notre territoire"

Il s'agit d'un bloque configuré via le contenu : **140_notre_teritoire.md** : 

- **title** : titre du bloque : affiché en premier en bleu
- **action** : contient 2 boutons
- **contentImage** : images affichées en gros à droite (ou en bas) du bloque
- **body** : texte du bloque en MarkDown.
 
 
### Zone "Au quotidien"

Affiche une liste de petits bloque d'informations utiles. Il s'agit des contenus ayant la catégorie "infos_utiles" (par défaut ranger dans le dossier **content/info_utiles**)