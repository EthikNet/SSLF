title=Facebook
date=2026-06-17
type=org_openCiLife_block
category=en_directe
subTemplate=imageBeforeTitleAndContentWithoutAfterHookSubTemplate
tags=
status=published
specificClass=faceBookNews
contentImage=<svg xmlns="http://www.w3.org/2000/svg" width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"  class="faceBookLogo" aria-hidden="true"><path d="M18 2h-3a5 5 0 0 0-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 0 1 1-1h3z"></path></svg>
action={"disposition":"right", "specificClass":"facebook_cta", "data":[{"type":"button", "label":"Voir la page <svg xmlns='http://www.w3.org/2000/svg' width='24' height='24' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round' aria-hidden='true'><path d='M15 3h6v6'></path><path d='M10 14 21 3'></path><path d='M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6'></path></svg>", "specificClass":"no_state", "operation":{"type":"link", "to":"${webleger.component.meta.facebook.container.url}"}}]}
hooks={"data":[{"position":"beforeBlockContent", "action":"action.build", "renderOnce":true, "order":30}, {"position":"beforeBlockBody", "action":"sticker.build", "renderOnce":true}, {"position":"afterBlockContent", "action":"facebook.buildNews", "renderOnce":true, "order":35}]}
order=120
~~~~~~
Saint-Sulpice-les-Feuilles