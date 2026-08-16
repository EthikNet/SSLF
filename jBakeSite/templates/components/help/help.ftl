<#function getComponnentInfo>
	<#return {"componnentVersion":2, "name":"help", "description":"Display Help in pages", "recommandedNamespace":"help", "version":"0.1.0", "require":[{"value":"sequenceHelper", "type":"lib"}, {"value":"common", "type":"lib"}, {"value":"aide", "type":"contentHeader"}], "uses":[{"value":"langHelper", "type":"lib"}, {"value":"logHelper", "type":"lib"}]}>
</#function>

<#function init>
	<#return "" />
</#function>

<#function registerDefaultHooks()>
	<#local registerComponnentHooks = true>
	<#if registerComponnentHooks>
		${hookHelper.registerHook("afterFooter", "help.build", false)}
	</#if>
</#function>

<#function addHeaderScripts()>
	<#return "" />
</#function>

<#function addFooterScripts()>
	<#return "" />
</#function>


<#macro build theContent>
	<#if ((theContent.help)?? && theContent.help?has_content && (theContent.help.category)?? && theContent.help.category?has_content) || sequenceHelper.seq_containsOne(theContent.category!"__empty_categ__", "help,aide")>
		<@displayHelpLinks (theContent.help.category)!"__NO_CONTEXT_HELP__" theContent />
	</#if>
</#macro>

<#macro displayHelpLinks categoryFilter theContent>
	<#local helpURL = "help/aide.html">
	<#local allHelpContents = published_content?filter(ct -> sequenceHelper.seq_containsOne(ct.category!"__empty_categ__", categoryFilter))>
	<#if (langHelper)??>
		<#local allHelpContents = allHelpContents?filter(ct -> langHelper.isCorectLang(ct, langHelper.getLang(theContent)))>
	</#if>
	
	<#if logHelper??>
		${logHelper.stackDebugMessage("Help.displayHelpLinks : category :" + categoryFilter + " (published, filtered by lang if resquired) used with " + allHelpContents?size + " elements")}
	</#if>
	<#if (allHelpContents?size>0 || categoryFilter=="__NO_CONTEXT_HELP__")>
		<div class="btn-group help-group">
			 <button type="button" class="btn btn-default btn-xs dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
				Aide <span class="caret"></span>
			</button>
			<ul class="dropdown-menu help-menu">
				<#list allHelpContents as helpContent>
					<li><a href="${common.buildRootPathAwareURL(helpURL+"#"+helpContent.anchorId)}">${helpContent.title}</a></li>
				</#list>
				<li role="separator" class="divider"></li>
				<li><a href="${common.buildRootPathAwareURL(helpURL)}">Toutes les aides</a></li>
			</ul>
		</div>
	</#if>
</#macro>
