<#function getComponnentInfo>
	<#return {"componnentVersion":1, "name":"sslf", "description":"M%airie Saint-Sulpice-les-Feuilles Template", "recommandedNamespace":"sslf", "uses":[{"value":"logHelper", "type":"lib"}]}>
</#function>

<#function init>
	<#setting locale="${webleger.jvm.locale}">
	<#return "" />
</#function>

<#macro vaguesSvg block>
<svg viewBox="0 0 1440 80" class="vaguesSvg" preserveAspectRatio="none" aria-hidden="true">
	<path fill="white" d="M0,40 C240,90 480,0 720,40 C960,80 1200,10 1440,40 L1440,80 L0,80 Z" style=""></path>
</svg>
</#macro>


<#macro publicationCompactSubTemplateItem theContent item specificContentClass featauredText displayTitle className subContentBeforeTitleImage>
	<@publication theContent item specificContentClass featauredText displayTitle className subContentBeforeTitleImage "compact" />
</#macro>

<#macro publicationSubTemplateItem theContent item specificContentClass featauredText displayTitle className subContentBeforeTitleImage>
	<@publication theContent item specificContentClass featauredText displayTitle className subContentBeforeTitleImage "full" />
</#macro>

<#macro publication theContent item specificContentClass featauredText displayTitle className subContentBeforeTitleImage type>
	<div class="${className}_block" data-href="${common.buildRootPathAwareURL(item.uri)}">
		<#if featauredText?has_content>
			<span class="featured_label">${featauredText}</span>
		</#if>
		<div class="${className}_body">
			<div class="${className}_identification">
				<@common.addImageIcon '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M8 2v4"></path><path d="M16 2v4"></path><rect width="18" height="18" x="3" y="4" rx="2"></rect><path d="M3 10h18"></path></svg>' className+"_image" "dates"/>
				${item.date?date?string.long} · ${item.pubCateg!"Général"}
			</div>
			<#if (item.contentImage)??>
				<@common.addImageIcon item.contentImage className+"_image" item.title/>
			</#if>
			
			<#if displayTitle>						
				<h3 class="${className}_title"><#rt>
				<#if (subContentBeforeTitleImage?has_content)>
					<img src="${common.buildRootPathAwareURL(subContentBeforeTitleImage)}" class="widget_title_image icon">
				</#if>
					<#t>${item.title!""}
				<#lt></h3>
			</#if>
			
			<#if (item.exerpt??)>
				<div class="${className}_exerpt">
					${item.exerpt!""}
				</div>
			</#if>
			
			<#if type!="compact">
				<div class="${className}_content">
					${item.body!""}
				</div>
				
				<@common.buildFiles item "<hr/>"/>
			</#if>
		</div>
	</div>
</#macro>

<#macro cardWithDetailsSubTemplate theBlock>
	<@detailsSubTemplate theBlock "cardWithDetailsSubTemplate" />
</#macro>

<#macro detailsSubTemplate theBlock specificClass="">
	<div <@block.generateAnchor theBlock/> <@block.generateCssClass theBlock specificClass/> <#if customCssStyle?has_content>style="${customCssStyle}"</#if>>
		<#if (theBlock.contentImage)?? && theBlock.contentImage?has_content>
			<@block.generateTitle theBlock true/>
		<#else>
			<@block.generateTitle theBlock/>
		</#if>
		<div class="blockBody">
			<@common.buildLocation theBlock/>
			<@common.buildPhone theBlock/>
			<@common.buildEmail theBlock/>
			<@common.buildHours theBlock/>
			<@common.buildFiles theBlock/>
			<@common.buildDates theBlock/>
			<@common.buildDateTimes theBlock/>
			<@common.buildFreeDate theBlock/>
			<@common.buildWebsites theBlock/>
			
			<@block.generateBodyContent theBlock/>
		</div>
	</div>
</#macro>

<#macro minimalCardSubTemplateItem theContent item specificContentClass featauredText displayTitle className subContentBeforeTitleImage>
		<#if (item.contentImage)?? && item.contentImage?has_content>
			<@block.generateTitle item true/>
		<#else>
			<@block.generateTitle item/>
		</#if>
</#macro>

<#macro personneSubTemplate theContent>
	<div <@block.generateAnchor theContent/> <@block.generateCssClass theContent "imageBeforeTitleSubTemplate"/>>
		<@block.generateTitle theContent true/>
		<div class="blockBody">
			<@block.generateBodyContent theContent/>
		</div>
	</div>
</#macro>

<#macro servicesGroupSubTemplateItem theContent item specificContentClass featauredText displayTitle className subContentBeforeTitleImage>
	<div class="${className}_block" data-href="${common.buildRootPathAwareURL(item.uri)}">
		<#if featauredText?has_content>
			<span class="featured_label">${featauredText}</span>
		</#if>
		<div class="${className}_header">
			<#if (item.contentImage)??>
				<@common.addImageIcon item.contentImage className+"_image " item.title ""/>
			</#if>
			<div class="${className}_header_title">
				<#if displayTitle>						
					<${(theContent.includeContent.titleTag)!"h3"} class="${className}_title"><#rt>
						<#if (subContentBeforeTitleImage?has_content)>
							<img src="${common.buildRootPathAwareURL(subContentBeforeTitleImage)}" class="widget_title_image icon">
						</#if>
						<#t>${item.title!""}
					<#lt></${(theContent.includeContent.titleTag)!"h3"}>
				</#if>
				<#if (item.exerpt??)>
					<div class="${className}_exerpt">
						${item.exerpt!""}
					</div>
				</#if>
			</div>
		</div>
		<hr>
		<div class="${className}_body">
			<#if (toc)??>
				<@toc.build item />
			</#if>
		</div>
	</div>
</#macro>

<#macro servicesSubTemplate theBlock>
	<#local className = "service">
	<#local featauredText = "">
	<#if (theBlock.featured)?? && (theBlock.featured.text)?? && theBlock.featured.text?has_content>
		<#local featauredText = theBlock.featured.text>
	</#if>
	<#local displayTitle = true>
	<#if (serviceGroup.displayTitle)?? && serviceGroup.display.displayTitle == false>
		<#local displayTitle = false>
	</#if>
	<div <@block.generateAnchor theBlock/> class="block ${className}_block">
		<#if featauredText?has_content>
			<span class="featured_label">${featauredText}</span>
		</#if>
		<div class="${className}_header">
			<#if (theBlock.contentImage)??>
				<@common.addImageIcon theBlock.contentImage className+"_image " theBlock.title ""/>
			</#if>
			<div class="${className}_header_title">
				<#if displayTitle>						
					<${(theBlock.includeContent.titleTag)!"h3"} class="${className}_title">
						${theBlock.title!""}
					</${(theBlock.includeContent.titleTag)!"h3"}>
				</#if>
				<#if (theBlock.exerpt??)>
					<div class="${className}_exerpt">${theBlock.exerpt!""}</div>
				</#if>
			</div>
		</div>
		<div class="${className}_body">
			<@block.generateBodyContent theBlock/>
			<hr/>
			<div class="metaDataListInLine greenButtonLikeChildDivs">
				<@common.buildLocation theBlock/>
				<@common.buildPhone theBlock/>
				<@common.buildEmail theBlock/>
				<@common.buildHours theBlock/>
				<@common.buildDates theBlock/>
				<@common.buildDateTimes theBlock/>
				<@common.buildFreeDate theBlock/>
				<@common.buildWebsites theBlock/>
			</div>
			<#if (theContent.files)?? && theContent.files?has_content && (theContent.files.data)?? && theContent.files.data?has_content>
				<div class="metaDataListInLine">
					<@common.buildFiles theBlock/>
				</div>
			</#if>
		</div>
	</div>
</#macro>

<#macro comissionsMembresGraphSubTemplate extendedContents level isGrouped>
	<#if logHelper??>
		${logHelper.stackDebugMessage("sslf.comissionsParMembresGraphSubTemplate : displaying data, isGrouped : " + isGrouped?string("true","false"))}
	</#if>
		<@graph.displayGroupOfRelations extendedContents level isGrouped; groupContent>
			<div class="block_wraping fourPerRow">
				<@graph.displayRelations groupContent ; theContent, relations>
					<@personneWithPhoto theContent relations true/>
				</@graph.displayRelations>
			</div>
		</@graph.displayGroupOfRelations>
</#macro>

<#macro commissionForMemberGraphSubTemplate extendedContents level isGrouped>
	<#if logHelper??>
		${logHelper.stackDebugMessage("sslf.commissionForMemberGraphSubTemplate : displaying data, isGrouped : " + isGrouped?string("true","false"))}
	</#if>
	<@graph.displayGroupOfRelations extendedContents level isGrouped "Membres"; groupContent>
		<table>
		<thead>
			<th>Membre</th>
			<th>statut</th>
		</thead>
			<@graph.displayRelations groupContent ; content, relations>
				<tr>
					<td rowspan="${relations?size}"><a href="${common.buildRootPathAwareURL(content.uri)}">${content.title}</a></td>
					<@graph.displayARelation relations; relation>
						<td>${relation.statut!relation.fonction!"MISSING_STATUT"}</td>
					</tr>
					</@graph.displayARelation>
				</tr>
			</@graph.displayRelations>
		</table>
	</@graph.displayGroupOfRelations>
</#macro>

<#macro personneParStructureGraphSubTemplate extendedContents level isGrouped>
	<@personneParStructure extendedContents level isGrouped />
</#macro>

<#macro personneParStructureCompactGraphSubTemplate extendedContents level isGrouped>
	<@personneParStructure extendedContents level isGrouped true/>
</#macro>

<#macro personneParFonctionGraphSubTemplate extendedContents level isGrouped>
	<@personneParStructure extendedContents level isGrouped true false/>
</#macro>

<#macro personneParStructure extendedContents level isGrouped isSmall=false displayFonction=true>
	<#if logHelper??>
		${logHelper.stackDebugMessage("sslf.personneParStructureGraphSubTemplate : displaying data, isGrouped : " + isGrouped?string("true","false"))}
	</#if>
	<@graph.displayGroupOfRelations extendedContents level+1 isGrouped; groupContent>
			<@graph.displayRelations groupContent ; theContent, relations>
				<@personneWithPhoto theContent relations isSmall displayFonction/>
			</@graph.displayRelations>
	</@graph.displayGroupOfRelations>
</#macro>

<#macro personneWithPhoto theContent relations isSmall=false displayFonction=true>
	<#local customClass = "personneSynthese">
	<#if isSmall>
		<#local customClass = "personneSyntheseSmall">
	</#if>
	<div <@block.generateAnchor theContent/> <@block.generateCssClass theContent "imageBeforeTitleSubTemplate "+customClass/>>
		<#local customCssClass = "block_title_image">
		<span class="blockTitle">
			<@common.addImageIcon theContent.contentImage customCssClass theContent.title/>
			<span class="personneDetail">
				<a href="${common.buildRootPathAwareURL(theContent.uri)}"><#escape x as x?xml>${theContent.title}</#escape></a>
				<#if (relations)?? && (relations?size >0)>
					<span class="personneFonctions">
						<@graph.displayARelation relations; relation>
							<#if displayFonction && (relation.fonction)?? && relation.fonction?has_content>
								<span>${relation.fonction}</span>
							</#if>
							<#if (relation.statut)?? && relation.statut?has_content>
								<span>(${relation.statut})</span>
							</#if>
						</@graph.displayARelation>
					</span>
				</#if>
			</span>
		</span>
	</div>
</#macro>

<#macro cardWithImageSubTemplateItem theContent item specificContentClass featauredText displayTitle className subContentBeforeTitleImage>
	<div class="image_cover_wrapper">
		<#if (item.contentImage)??>
			<img src="${common.buildRootPathAwareURL(item.contentImage)}" class="image_cover">
		</#if>
	</div>
	<div class="block_content">
		<@block.generateTitle item/>
		<div class="blockDetail">
			<#if (item.exerpt)??>
				${item.exerpt}
			</#if>
		</div>
		<span class="labelShowMore">En  savoir plus</span>
	</div>
</#macro>

<#macro cardVillageSubTemplateItem theContent item specificContentClass featauredText displayTitle className subContentBeforeTitleImage>
	<div class="image_cover_wrapper">
		<#if (item.contentImage)??>
			<img src="${common.buildRootPathAwareURL(item.contentImage)}" class="image_cover">
		</#if>
	</div>
	<div class="block_content">
		<@block.generateTitle item/>
		<div class="blockDetail">
			<#if (item.exerpt)??>
				${item.exerpt}
			</#if>
		</div>
		<#local subContentModaleShowMoreButton="En savoir plus">
		<#local subContentDisplayTags=false>
		<@modal.extractContentForModal item, "button", className, subContentModaleShowMoreButton, subContentDisplayTags />
	</div>
</#macro>

<#macro cardActeurEcoSubTemplateItem theContent item specificContentClass featauredText displayTitle className subContentBeforeTitleImage>
	<#if (item.contentImage)??>
		<div class="image_cover_wrapper">
			<img src="${common.buildRootPathAwareURL(item.contentImage)}" class="image_cover">
		</div>
	</#if>
	<div class="acteurEcoCategorie ${className}_acteurEcoCategorie">${item.acteurEcoCategorie!""}</div>
	<div class="block_title">
		<${(item.includeContent.titleTag)!"h3"} class="${className}_title">
			${item.title!""}
		</${(item.includeContent.titleTag)!"h3"}>
	</div>
	
	<#if (item.exerpt??)>
		<div class="${className}_exerpt">
			${item.exerpt!""}
		</div>
	</#if>
	<div class="${className}_body">
		<@common.buildResponsable item/>
		<@common.buildLocation item/>
		<@common.buildPhone item/>
		<@common.buildEmail item/>
		<@common.buildHours item/>
		<@common.buildDates item/>
		<@common.buildDateTimes item/>
		<@common.buildFreeDate item/>
	
		<@block.generateBodyContent item/>
	</div>
	<#if acteurEcoHasCustomProperties(item)>
		<hr/>
		<div class="metaDataListInLine greenButtonLikeChildDivs">
			<@common.buildWebsites item/>
			<@common.buildFaceBook item/>
		</div>
		<#if (item.files)?? && item.files?has_content && (item.files.data)?? && item.files.data?has_content>
			<div class="metaDataListInLine">
				<@common.buildFiles item/>
			</div>
		</#if>
	</#if>
</#macro>

<#function acteurEcoHasCustomProperties item>
	<#return ((item.facebook)?? && item.facebook?has_content) || ((item.websites)?? && item.websites?has_content)>
</#function>

<#macro cardAssoSubTemplateItem theContent item specificContentClass featauredText displayTitle className subContentBeforeTitleImage>
	<div class="assoCategorie ${className}_assoCategorie">${item.AssoCategorie!""}</div>
	<div class="block_title">
		<${(item.includeContent.titleTag)!"h3"} class="${className}_title">
			${item.title!""}
		</${(item.includeContent.titleTag)!"h3"}>
	</div>
	
	<#if (item.exerpt??)>
		<div class="${className}_exerpt">
			${item.exerpt!""}
		</div>
	</#if>
	<div class="${className}_body">
	
		<@common.buildResponsable item/>
		<@common.buildLocation item/>
		<@common.buildPhone item/>
		<@common.buildEmail item/>
		<@common.buildHours item/>
		<@common.buildDates item/>
		<@common.buildDateTimes item/>
		<@common.buildFreeDate item/>
	
		<@block.generateBodyContent item/>
	</div>
	<#if acteurEcoHasCustomProperties(item)>
		<hr/>
		<div class="metaDataListInLine greenButtonLikeChildDivs">
			<@common.buildWebsites item/>
			<@common.buildFaceBook item/>
		</div>
		<#if (item.files)?? && item.files?has_content && (item.files.data)?? && item.files.data?has_content>
			<div class="metaDataListInLine">
				<@common.buildFiles item/>
			</div>
		</#if>
	</#if>
</#macro>

<#macro cardProjetSubTemplateItem theContent item specificContentClass featauredText displayTitle className subContentBeforeTitleImage>
	<div class="projetHeader">
		<#if (item.contentImage)??>
			<@common.addImageIcon item.contentImage className+"_image" item.title/>
		</#if>
		<div class="project_infos">
			<div class="projetDuree ${className}_projetDuree">${item.projetDuree!""}</div>
			<div class="block_title">
				<${(item.includeContent.titleTag)!"h3"} class="${className}_title">
					${item.title!""}
				</${(item.includeContent.titleTag)!"h3"}>
			</div>
		</div>
	</div>
	<#if (item.exerpt??)>
		<div class="${className}_exerpt">
			${item.exerpt!""}
		</div>
	</#if>
	<div class="${className}_body">
		<@buildBeneficiaires item/>
		<@buildPorteur item/>
		<@buildPartenaires item/>
		<@buildFinanceurs item/>
		<@buildChronology item/>
		
		<@common.buildResponsable item/>
		<@common.buildLocation item/>
		<@common.buildPhone item/>
		<@common.buildEmail item/>
		<@common.buildHours item/>
		<@common.buildDates item/>
		<@common.buildDateTimes item/>
		<@common.buildFreeDate item/>
		<@common.buildWebsites item/>
		<@common.buildFaceBook item/>
	
		<@block.generateBodyContent item/>
	</div>
	<#if (item.files)?? && item.files?has_content && (item.files.data)?? && item.files.data?has_content>
		<div class="metaDataListInLine">
			<@common.buildFiles item/>
		</div>
	</#if>
</#macro>


<#macro buildBeneficiaires theContent>
	<#if (theContent.beneficiaires)?? && theContent.beneficiaires?has_content>
		<#local beneficiairesItems = theContent.beneficiaires?split(",")>
		<#if (beneficiairesItems?size > 0)>
			<div class="elementWithIconSmallWrap">
				<div class="beneficiaires"><span class="label">Bénéficiaires : </span>
					<#list beneficiairesItems as beneficiairesItem>
						${beneficiairesItem}
					</#list>
				</div>
			</div>
		</#if>
	</#if>
</#macro>

<#macro buildPorteur theContent>
	<#if (theContent.porteur)?? && theContent.porteur?has_content>
		<#local porteursItems = theContent.porteur?split(",")>
		<#if (porteursItems?size > 0)>
			<div class="elementWithIconSmallWrap">
				<div class="iconWrap"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path><path d="M16 3.128a4 4 0 0 1 0 7.744"></path><path d="M22 21v-2a4 4 0 0 0-3-3.87"></path><circle cx="9" cy="7" r="4"></circle></svg></div>
				<div class="porteur"><span class="label">Porteur : </span>
					<#list porteursItems as porteursItem>
						${porteursItem}
					</#list>
				</div>
			</div>
		</#if>
	</#if>
</#macro>

<#macro buildPartenaires theContent>
	<#if (theContent.partenaires)?? && theContent.partenaires?has_content>
		<#local partenairesItems = theContent.partenaires?split(",")>
		<#if (partenairesItems?size > 0)>
			<div class="elementWithIconSmallWrap">
				<div class="iconWrap"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path><path d="M16 3.128a4 4 0 0 1 0 7.744"></path><path d="M22 21v-2a4 4 0 0 0-3-3.87"></path><circle cx="9" cy="7" r="4"></circle></svg></div>
				<div class="partenaires"><span class="label">Partenaires : </span>
					<#list partenairesItems as partenairesItem>
						${partenairesItem}
					</#list>
				</div>
			</div>
		</#if>
	</#if>
</#macro>

<#macro buildFinanceurs theContent>
	<#if (theContent.financeurs)?? && theContent.financeurs?has_content>
		<#local financeursItems = theContent.financeurs?split(",")>
		<#if (financeursItems?size > 0)>
		<div class="elementWithIconSmallWrap">
				<div class="iconWrap"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M13.744 17.736a6 6 0 1 1-7.48-7.48"></path><path d="M15 6h1v4"></path><path d="m6.134 14.768.866-.5 2 3.464"></path><circle cx="16" cy="8" r="6"></circle></svg></div>
				<div class="financeurs"><span class="label">Financeurs : </span>
					<#list financeursItems as financeursItem>
						${financeursItem}
					</#list>
				</div>
			</div>
		</#if>
	</#if>
</#macro>

<#macro buildChronology theContent>
	<#if (theContent.chronology)?? && theContent.chronology?has_content && (theContent.chronology.data)??  && theContent.chronology.data?has_content>
		<div class="chronology">
			<h4>Chronolgie</h4>
			<ol>
				<#list theContent.chronology.data as chronologyItem>
					<#local icone="<svg xmlns='http://www.w3.org/2000/svg' width='24' height='24' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round' aria-hidden='true'><path d='M10.1 2.182a10 10 0 0 1 3.8 0'></path><path d='M13.9 21.818a10 10 0 0 1-3.8 0'></path><path d='M17.609 3.721a10 10 0 0 1 2.69 2.7'></path><path d='M2.182 13.9a10 10 0 0 1 0-3.8'></path><path d='M20.279 17.609a10 10 0 0 1-2.7 2.69'></path><path d='M21.818 10.1a10 10 0 0 1 0 3.8'></path><path d='M3.721 6.391a10 10 0 0 1 2.7-2.69'></path><path d='M6.391 20.279a10 10 0 0 1-2.69-2.7'></path></svg>">
					<#local displayDate = chronologyItem.date!"2026"?date>
					<#local state = chronologyItem.state!"à venir">
					<#local label = chronologyItem.label!"à définir">
					<#switch chronologyItem.state>
						<#case "passé">
							<#local icone="<svg xmlns='http://www.w3.org/2000/svg' width='24' height='24' viewBox='0 0 24 24' fill='none' stroke='green' stroke-width='2' stroke-linecap='round' stroke-linejoin='round' aria-hidden='true'><circle cx='12' cy='12' r='10'></circle><path d='m9 12 2 2 4-4'></path></svg>">
							<#break>
						<#case "en cours">
							<#local icone="<svg xmlns='http://www.w3.org/2000/svg' width='24' height='24' viewBox='0 0 24 24' fill='none' stroke='orange' stroke-width='2' stroke-linecap='round' stroke-linejoin='round' aria-hidden='true'><circle cx='12' cy='12' r='10'></circle><circle cx='12' cy='12' r='1'></circle></svg>">
							<#break>
					</#switch>
					<li>
						<span class="chronolgy_icone">${icone}</span>
						<div class="chronolgy_date">${displayDate} · ${state}</div>
						<div class="chronolgy_label">${label}</div>
					</li>
				</#list>
			</ol>
		</div>
	</#if>
</#macro>
