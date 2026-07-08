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

<#macro comissionsParMembresGraphSubTemplate extendedContents level>
	<#if logHelper??>
		${logHelper.stackDebugMessage("Graph.comissionsParMembresGraphSubTemplate : (level:"+level+") displaying members based on extracted contents : " + common.toString(extendedContents))}
	</#if>
	<#local titleLevel = level+1>
	
	<h${titleLevel}>Membres : </h${titleLevel}>
	<table>
		<thead>
			<th>Nom</th>
			<th>commision</th>
			<th>statut</th>
		</thead>
		<#list extendedContents as anExtendedContent>
			<#if (anExtendedContent.data)?? && (anExtendedContent.data.content) ?? && (anExtendedContent.data.related)??>
				<tr>
					<td rowspan="${anExtendedContent.data.related?size}"><a href="${common.buildRootPathAwareURL(anExtendedContent.data.content.uri)}">${anExtendedContent.data.content.title}</a></td>
					<#if anExtendedContent.data.related?size == 1>
						<#local extendedContent = []>
						<#if anExtendedContent.data.related?is_sequence>
							<#local extendedContent = anExtendedContent.data.related[0]>
						<#else>
							<#local extendedContent = anExtendedContent.data.related>
						</#if>
						<td><@graph.buildLink extendedContent.type extendedContent.code/></td>
						<td>${extendedContent.statut!extendedContent.fonction!"MISSING_STATUT"}</td>
					<#else>
						<#list anExtendedContent.data.related as aRelatedContent>
							<td><@graph.buildLink aRelatedContent.type aRelatedContent.code/></td>
							<td>${aRelatedContent.statut!aRelatedContent.fonction!"MISSING_STATUT"}</td>
				</tr>
						</#list>
					</#if>
				</tr>
			<#else>
				<#if logHelper??>
					${logHelper.stackDebugMessage("Graph.comissionsParMembresGraphSubTemplate ERROR : (level:"+level+") invalid extendedContent structure " + common.toString(anExtendedContent))}
				</#if>
			</#if>
		</#list>
	</table>
</#macro>

<#macro commissionForMemberGraphSubTemplate extendedContents level>
	<#local titleLevel = level+2>
	
	<h${titleLevel}>Membres : </h${titleLevel}>
	<table>
		<thead>
			<th>Membre</th>
			<th>statut</th>
		</thead>
		<#list extendedContents as anExtendedContent>
			<#if (anExtendedContent.data)?? && (anExtendedContent.data.content) ?? && (anExtendedContent.data.related)??>
				<tr>
					<td rowspan="${anExtendedContent.data.related?size}"><a href="${common.buildRootPathAwareURL(anExtendedContent.data.content.uri)}">${anExtendedContent.data.content.title}</a></td>
					<#if anExtendedContent.data.related?size == 1>
						<#local extendedContent = []>
						<#if anExtendedContent.data.related?is_sequence>
							<#local extendedContent = anExtendedContent.data.related[0]>
						<#else>
							<#local extendedContent = anExtendedContent.data.related>
						</#if>
						<td>${extendedContent.statut!extendedContent.fonction!"MISSING_STATUT"}</td>
					<#else>
						<#list anExtendedContent.data.related as aRelatedContent>
							<td>${aRelatedContent.statut!aRelatedContent.fonction!"MISSING_STATUT"}</td>
				</tr>
						</#list>
					</#if>
				</tr>
			<#else>
				<#if logHelper??>
					${logHelper.stackDebugMessage("Graph.comissionsParMembresGraphSubTemplate ERROR : (level:"+level+") invalid extendedContent structure " + common.toString(anExtendedContent))}
				</#if>
			</#if>
		</#list>
	</table>
</#macro>