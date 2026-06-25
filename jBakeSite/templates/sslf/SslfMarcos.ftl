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

<#macro publicationCompactSubTemplate theContent items>
	<#local className = "publicationCompact">
	<#local maxItemToDisplay = theContent.includeContent.limit!-1>
	<#local orderBy = theContent.includeContent.order!"order">
	<#local orderDirection = theContent.includeContent.orderDirection!"ascending">
	<#local specificContentClass = (theContent.includeContent.display.specificClass)!"">
	<#local displayTitle = true>
	<#if (theContent.includeContent.display.displayTitle)?? && theContent.includeContent.display.displayTitle == false>
		<#local displayTitle = false>
	</#if>
	<#local subContentDisplayContentMode = (theContent.includeContent.display.content)!"link">
	<#local subContentDisplayTags = (theContent.includeContent.display.displayTags)!false>
	<#local filter = theContent.includeContent.filter!"">
	<#local anchorId = theContent.anchorId!"">	
	
	<@subcontent.generateUserFilters theContent items "#"+anchorId+" ."+className/>
	
	<#if (theContent.includeContent.userFilters)?? && (theContent.includeContent.userFilters.filters?size > 0) >
		<#if !anchorId?has_content>
		<#-- UserFilter REQUIRED an AnchorId, generating one as none specified in content header -->
			<#local anchorId = common.generatedAnchorId(content.title)>
			${logHelper.stackDebugMessage("SubContent.build (userFilter) : Generating an anchor because UserFilter REQUIRE one, id generated : " + anchorId)}
		<#else>
			${logHelper.stackDebugMessage("SubContent.build (userFilter) : Anchor ID already set : " + anchorId)}
		</#if>
	</#if>
	
	<div class="${className}_list content_type_${subContentDisplayContentMode}">
		<div class="${className}_items">
			<#list items as subContent>
				<#if (maxItemToDisplay!=-1) && (subContent?counter > maxItemToDisplay) >
					<#break>
				</#if>
				<#local altSubContent = commonInc.propagateContentChain(subContent) />
				
				<#if (altSubContent.featured)??>
					<#local specificContentClass = specificContentClass + " featured">
					<#if (altSubContent.featured.text)??>
						<#local featauredText = altSubContent.featured.text>
					</#if>
				</#if>
				
				<#if (altSubContent.includeContent.hooks)??>
					<#if logHelper??>
						${logHelper.stackDebugMessage("SubContent.build(publicationCompactSubTemplate) : Custom Hooks detected for : " + altSubContent.uri + " : " + common.toString(content.includeContent.hooks))}
					</#if>
					<#if hookHelper??>
						<#if logHelper??>
							${logHelper.stackDebugMessage("SubContent.build(publicationCompactSubTemplate) : Registering Custom Hooks")}
						</#if>
						${hookHelper.registerHookFromJson(altSubContent.includeContent.hooks)}
					</#if>
				</#if>
				
				<div class="${className}">
				<@subcontent.generateUserFiltersElementData theContent subContent />
					<div class="${className}_block">
						<#if featauredText?has_content>
							<span class="featured_label">${featauredText}</span>
						</#if>
						<div class="${className}_body">
						<div class="${className}_identification">
							${altSubContent.date?date?string.long} · <@ecoWeb.displayTags altSubContent "" ", "/>
						</div>
							<#if (altSubContent.contentImage)??>
								<@common.addImageIcon altSubContent.contentImage className+"_image" altSubContent.title/>
							</#if>
							<#if (altSubContent.exerpt??)>
								<div class="${className}_exerpt">
									${altSubContent.exerpt!""}
								</div>
							</#if>
							
							<#if displayTitle>						
								<h3 class="${className}_title"><#rt>
								<#if (subContentBeforeTitleImage?has_content)>
									<img src="${common.buildRootPathAwareURL(subContentBeforeTitleImage)}" class="widget_title_image icon">
								</#if>
									<#t>${altSubContent.title!""}
								<#lt></h3>
							</#if>
							<div class="${className}_content">
								${altSubContent.body!""}
							</div>
						</div> <!-- End Body Item -->
					</div> <!-- end item Wrap Block -->
					</div>
				</#list>
			</div><! -- End internal wrap items -->
		<div> <!-- End Items -->
	</div> <!-- End Main  Block -->
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