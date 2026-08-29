title=Aide sur les Projets
date=2026-08-28
type=org_openCiLife_block
category=aide,aide_projets
status=published
imageHero={"category":"imageHeroAgenda"}
robots=noindex, nofollow
anchorId=aide_projets
order=9998
~~~~~~
## Aide sur les Projets

La page des projets, définie par **projets.md** contient le bloque ("projetsBlock").
Le contenu **803_liste_projets.md** contient un listing des contenus de category "projet".

### Structure d'un projet

![Structure d'une association](${webleger.build.host}/images/aide/projet_exemple.jpg)

**title=Lotissement communal** <= Nom du projet : est affiché en gras et en vert.
**date=2026-07-29** <= date de création du contenu. N'est pas affiché.
**type=org_openCiLife_block** <= type de contenu. Doit rester **org_openCiLife_block** pour être affiché.
**category=projet** <= category de contenu : doit rester **projet** pour être affiché.
**projetDuree** <= durée du projet : est affiché dans les filtres.
**status=published** <= le status du contenu. **published** pour être affiché. **Draft** si le contenu ne doit plus être affiché.
**exerpt=** <= résumé de l'association, est affiché juste en dessous de la zone de titre.
**contentImage** <= image du projet. Est affichée en petit près du titre.
**beneficiaires=Nouveaux habitants** <= Bénéficiaires du projet. Est affiché dans la zone en dessous du titre.
**porteur=Commune de Saint-Sulpice-les-Feuilles** <= porteur du projet. Est affiché dans la zone en dessous du titre.
**partenaires=CCHLEM, Conseil départemental 87** <= partenaires du projet. Il est possible d'en préciser plusieurs séparés par une virgule.
**financeurs** <= financeurs du projet. Il est possible d'en préciser plusieurs séparés par une virgule.
**chronology** <= JSON définissant la chronlogy (voir plus bas).
**files={"data":[{"location":"fichiers/sante/residence_du_cedre_mai2026.pdf", "label":"Infos lotissements.pdf", "main":true}]}** <= fichiers associés au projet. Affiché en bas.
**order=802** <= Ordre d'affichage du projet par rapport aux autres.

Si un contenu est présent, il sera affiché juste avant les fichiers.

#### chronology

Permet d'afficher les principales étapes du projet et leur état.
Il s'agit d'un objet JSON. Chaque étape est affichée dans l'ordre où elle est présente dans l'objet.

``{"data":[{"date":"2024","state":"passé","label":"Étude de faisabilité"},{"date":"2025","state":"en cours","label":"Acquisitions foncières"},{"date":"2026","state":"à venir","label":"Démarrage des travaux"},{"date":"2027","state":"à venir","label":"Mise en vente des parcelles"}]}``

**date** <= date de l'étape (juste l'année).
** state** <= etat de cette étape. Trois valeurs sont reconnues : "passé" : coche verte, "en cours" : point orange, "à venir" (par défaut) : cercle vide en pointillés.
**label** <= breve description de l'étape