title=Aide sur les listes de personnes
date=2026-08-17
type=org_openCiLife_block
category=aide,aide_personnes
status=published
imageHero={"category":"imageHeroAgenda"}
robots=noindex, nofollow
anchorId=aide_personnes
order=9998
~~~~~~
## Aide sur les listings de personnes

Le contenu **personne/personnes.md** affiche la liste de toutes les personnes référencées sur le site.
Chaque personne est décrite dans un contenu avec comme category "personne".
Chaque personne peut avoir des liens avec des structures, permettant de naviguer entre les personens et les structures.

### graph

Ces relations **personne <-> structure** sont configurées pour chaque personne via l'attribut d'entête de contenu ``graph``. Pour aider à comprendre il faut comprendre le graph comme étant les liens que possède le contenu avec d'autre contenus.

Pour effectuer un lien, il faut 2 éléments : 

- le type ou la category (par exemple "structure" ou "commission")
- un code (par exemple : "commune_SSLF" ou "ados et jeunes")

Les liens sont bi-directionnelles.

### graph.data
Pour créer un lien, il faut qu'il soit défini dans un contenu avec ``graph.data``.

#### Cas Simple

Voici un exemple provenant du contenu : **Ambrella_ZONCA.md**.

``graph={"data":[{"type":"structure","code":"commune_SSLF","role":"Conseil des Jeunes"}]}``

Ceci indique que le contenu Ambrella ZONCA de ``category`` **personne** est lié à la ``strcuture`` : ``commune_SSLF`` (avec comme rôle "Conseil des Jeunes").


#### Les "sous-structures"

Une structure peut contenir des "sous-structures", notamment des commissions. Ces sous-structures sont définies via ``graph.data[element].group``. Voici un exemple avec le contenu **Philippe_JULLIARD.md**.

``graph={"data":[{"type":"structure","code":"commune_SSLF","fonction":"Conseiller","role":"Conseil municipal","sousRole":"conseiller","group":[{"type":"commission","elements":[{"code":"personnel communal","statut":"suppléant"},{"code":"affaires scolaires","statut":"titulaire"},{"code":"villages agriculture et developpement durable","statut":"suppléant"}]}]}]}``

Chaque ``elements`` doit contenir un identifiant de contenu soit : un ``type`` et un ``code``. Pour éviter de répéter le type, il est possible de le définir une seule fois, en tant que frère de l'attribut elements.

Ceci indique que le contenu Philippe JULLIARD de ``category`` **personne** est lié à la ``strcuture`` : ``commune_SSLF`` (avec comme rôle "Conseil municipal") et qu'il est lié au contenus de ``type``: ``commission`` : "personnel communal" (avec le statut "suppléant"), "affaires scolaires" (avec le statut "titulaire") et "villages agriculture et développement durable" (avec le statut "suppléant").

#### Liens avec plusieurs autre contenus (de type différent)

Il est possible de lier un contenu à plusieurs autres de type différents (chacun possédant ou pas une sous-structure).
Voici un exemple avec **Catherine_NILLES.md**.

``graph={"data":[{"type":"structure","code":"commune_SSLF","fonction":"4ème adjointe","role":"Conseil municipal","sousRole":"adjoint","group":[{...}]}]},{"type":"structure","code":"CCHLEM","fonction":"Référent biodiversité", "statut":"titulaire"}]}``

La partie "group" a été masquée ici pour faciliter la compréhension.

Ceci indique que le contenu Catherine NILLES de ``category`` **personne** est lié : 
-  à la ``strcuture`` : ``commune_SSLF`` (avec comme rôle "Conseil municipal" et sous-rôle "adjoint") et qu'elle participe à différentes commissions (liens vers des contenus)
- et à la ``strcuture`` : ``CCHLEM`` avec la fonction de "Référent biodiversité" et le statut "titulaire".

#### graph.data créé et strcuture les liens

Via l'attribut "data" de l'attribut de contenu "graph", des liens sont **créés** entre les contenus. C'est aussi le bon endroit pour **qualifier** les liens. Les template gère les qualificatifs suivants pour une **structure** : 
- fonction
- role
- sousRole
- statut
 
Certains de ces qualificatifs sont affiché, ou utilisés pour filtrer ou grouper les liens.

### graph.query

Il est possible d'afficher à un contenu existant les liens qu'ils possèdent avec d'autre contenu sans pour autant **définir** de nouveau liens. Cela est possible via ``graph.query``.

Il faut préciser : 

- ce que l'on recherche
- où
- éventuellement des options d'affichage

Voici un exemple à partir du contenu **personnes.md** : 

``graph={"query":{"type":"structure", "filter":"code:*", "in":{"category":"personne", "order":"order"}, "groupBy":"related.code"}, "subTemplate":"sslf.personneParStructureGraphSubTemplate"}``

Le contenu affichera : tous les contenus définissant un lien (graph.data) de ``type`` : ``structure`` ayant un code (n'importe lequel), défini dans des contenus de ``category`` : ``personne``. Les personnes seront ordonnées via leur attribut d'entête ``order`` et seront regroupées par ``code``. Les détails d'affichage seront traités par le sous-template ``sslf.personneParStructureGraphSubTemplate``.

Voici un autre exemple provenant de **personnel_communal.md**

``graph={"query":{"type":"structure", "filter":"role:personnel communal", "in":{"category":"personne", "order":"order"}, "groupBy":"related.fonction"}, "subTemplate":"sslf.personneParFonctionGraphSubTemplate"}``

Il est similaire au précédent sauf qu'on ne veut afficher que les contenus définissant une relation de type strucutre avec un ``role`` égale à ``personnel communal`` et le regroupement se fera par ``fonction``.

Un aute exemple, pour une commission : **affaires_scolaires.md**.

``graph={"query":{"type":"commission", "filter":"code:affaires scolaires", "in":{"category":"personne", "order":"order"}, "groupBy":"related.statut"}, "subTemplate":"sslf.comissionsMembresGraphSubTemplate"}``