<#function getComponnentInfo>
	<#return {"componnentVersion":1, "name":"tableOfContent", "description":"Add subContent in content", "recommandedNamespace":"toc", "version":"0.1.0", "require":[{"value":"toc", "type":"contentHeader"}, {"value":"block", "type":"componnent"}], "uses":[{"value":"langHelper", "type":"lib"}, {"value":"logHelper", "type":"lib"}]}>
</#function>

<#function init>
	<#return "" />
</#function>

<#-- build aa table of content
param : content : content to search for include content
-->
<#macro build theContent>
	<#if (theContent.toc)??>
		<#local displayToc=theContent.toc>
		<#local displayImg = false>
		<#if displayToc?has_content>
			<#if logHelper??>
		 		${logHelper.stackDebugMessage("ToC : display TOC for ${content.uri} with value " + common.toString(displayToc))}
		 	</#if>
		 	<#if (theContent.toc.displayImg)?? && theContent.toc.displayImg?has_content>
		 		<#local displayImg = true>
		 	</#if>
		 	<#if block??>
				<#local subTemplateName = "defaultTocSubTemplate">
				<#if (displayToc.subTemplate??)>
					<#local subTemplateName=displayToc.subTemplate>
				</#if>
				<#local subTemplateInterpretation = "<@${subTemplateName} displayToc block.getBlocks(theContent) displayImg theContent.uri/>"?interpret>
				<@subTemplateInterpretation/>
			</#if>
		</#if>
	</#if>
</#macro>

<#macro defaultTocSubTemplate displayToc blocks displayImg mainPageUrl>
	<@blockTocUlLiWithLinkSubTemplate displayToc blocks displayImg mainPageUrl/>
</#macro>

<#macro blockTocUlLiWithLinkSubTemplate displayToc blocks displayImg mainPageUrl>
	<#if logHelper??>
 		${logHelper.stackDebugMessage("ToC : Building a UL/LI ToC")}
 	</#if>
	<div class="toc">
		<#local endTag="">
		<@displayTocTitle displayToc />
		
		<ul class="toc_list">
		<#list blocks as blockForToc>
			<#local uri = buildTocUri(blockForToc mainPageUrl)>
			<li class="toc_item">
				<#if uri?has_content>
					<a href="${uri}">
					<#local endTag="</a>">
				</#if>
				
				<#if displayImg && (blockForToc.contentImage)?? && blockForToc.contentImage?has_content>
					<@common.addImageIcon blockForToc.contentImage "toc_image"/>
				</#if>
				<span>${blockForToc.title}</span>
				${endTag}
			</li>
		</#list>
		</ul>
	</div>
</#macro>

<#macro blockTocSelectSubTemplate displayToc blocks mainPageUrl>
	<#if logHelper??>
 		${logHelper.stackDebugMessage("ToC : Building a Select ToC")}
 	</#if>
	<div class="toc" role="navigation" aria-label="Table des matières">
		<#local endTag="">
		<select id="toc-select" class="toc_list toc-select">
		<option value="">--${displayToc.title!"Naviguation"}--</option>
		<#list blocks as blockForToc>
			<#local uri = buildTocUri(blockForToc)>
			<option value="${uri}" class="toc_item">
				<#if displayImg && (blockForToc.contentImage)?? && blockForToc.contentImage?has_content>
					<@common.addImageIcon blockForToc.contentImage "toc_image"/>
				</#if>
				<span>${blockForToc.title}</span>
			</option>
			${endTag}
		</#list>
		</select>
	</div>
</#macro>

<#macro displayTocTitle displayToc>
	<#local tocTitle = displayToc.title!"">
	<#if tocTitle?has_content>
		<h3 class="toc_title">${tocTitle}</h3>
	</#if>
</#macro>

<#function buildTocUri block mainPageUrl=content.uri>
	<#local uri = "">
	<#if (block.anchorId)??>
		<#local uri = mainPageUrl + "#" + block.anchorId>
	<#else>
		<#local uri = mainPageUrl + "#" + common.generatedAnchorId(block.title)>
	</#if>
	<#local uri = common.buildRootPathAwareURL("/" + uri)>
	<#return uri>
</#function>