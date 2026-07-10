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
			
			<@block.generateBodyContent theBlock/>
		</div>
	</div>
</#macro>

<#macro personneSubTemplate theContent>
	<div <@block.generateAnchor theContent/> <@block.generateCssClass theContent "imageBeforeTitleSubTemplate"/>>
		<@block.generateTitle theContent true/>
		<div class="blockBody">
			<@block.generateBodyContent theContent/>
		</div>
	</div>
</#macro>

<#macro comissionsParMembresGraphSubTemplate extendedContents level isGrouped>
	<@graph.displayGroupOfRelations extendedContents level isGrouped "Membres"; groupContent>
		<table>
			<thead>
				<th>Nom</th>
				<th>commision</th>
				<th>statut</th>
			</thead>
			<@graph.displayRelations groupContent ; content, relations>
				<tr>
					<td rowspan="${relations?size}"><a href="${common.buildRootPathAwareURL(content.uri)}">${content.title}</a></td>
					<@graph.displayARelation relations; relation>
						<td><@graph.buildLink relation.type relation.code/></td>
						<td>${relation.statut!relation.fonction!"MISSING_STATUT"}</td>
					</tr>
					</@graph.displayARelation>
				</tr>
			</@graph.displayRelations>
		</table>
	</@graph.displayGroupOfRelations>
</#macro>

<#macro commissionForMemberGraphSubTemplate extendedContents level isGrouped>
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
	<@graph.displayGroupOfRelations extendedContents level+1 isGrouped "Membres"; groupContent>
			<@graph.displayRelations groupContent ; theContent, relations>
				<div <@block.generateAnchor theContent/> <@block.generateCssClass theContent "imageBeforeTitleSubTemplate PersonneSynthese"/>>
					<div <@block.generateAnchor theContent/> <@block.generateCssClass theContent "imageBeforeTitleSubTemplate"/>>
						<#local customCssClass = "block_title_image">
						<span class="blockTitle">
							<@common.addImageIcon theContent.contentImage customCssClass theContent.title/>
							<span class="personneDetail">
								<a href="${common.buildRootPathAwareURL(theContent.uri)}"><#escape x as x?xml>${theContent.title}</#escape></a>
								
								<span class="personneFonctions">
									<@graph.displayARelation relations; relation>
										<span>${relation.fonction!"MISSING_FONCTION"}</span>
									</@graph.displayARelation>
								</span>
							</span>
						</span>
					</div>
				</div>
			</@graph.displayRelations>
	</@graph.displayGroupOfRelations>
</#macro>
