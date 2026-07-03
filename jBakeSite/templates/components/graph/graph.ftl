<#function getComponnentInfo>
	<#return {"componnentVersion":2, "name":"Graph", "description":"Allow strcutured Graphs based on content", "version":"0.1.0", "recommandedNamespace":"graph", "require":[{"value":"stripe", "type":"contentHeader"}, {"value":"webleger.component.stripe.apiKey", "type":"config"}], "uses":[{"value":"langHelper", "type":"lib"}, {"value":"logHelper", "type":"lib"}]}>
</#function>

<#function init>
	<#return "" />
</#function>

<#function registerDefaultHooks()>
	<#local registerComponnentHooks = true>
	<#if registerComponnentHooks>
		${hookHelper.registerHook("afterBody", "graph.build", false)}
	</#if>
</#function>

<#function addHeaderScripts()>
	<#return "" />
</#function>

<#function addFooterScripts()>
	<#return "" />
</#function>

<#macro build theContent>
	<#if (theContent.graph)?? && theContent.graph?has_content>
		<#local type = "">
		<#if (theContent.graph.data)?? && theContent.graph.data?has_content>
			<#if theContent.graph.data?is_hash && (theContent.graph.data.type)?? && theContent.graph.data.type?has_content>
				<#local type = theContent.graph.data.type>
			</#if>
			<#if logHelper??>
				${logHelper.stackDebugMessage("Graph.build : (level:1) START PROCESSING graph DATA root type : " + type)}
			</#if>
			
			<#list theContent.graph.data as firstLevelElement>
				<@recursiveStruture firstLevelElement type 1 />
			</#list>
			
		<#elseif (theContent.graph.query)?? && theContent.graph.query?has_content>
			<#if theContent.graph.query?is_hash && (theContent.graph.query.type)?? && theContent.graph.query.type?has_content>
				<#local type = theContent.graph.query.type>
			</#if>
			<#local contentCategory = theContent.graph.query.in.category>
			<#local filterValue =  theContent.graph.query.value>
			<#if logHelper??>
				${logHelper.stackDebugMessage("Graph.build : START PROCESSING graph QUERY root type : " + type +", in "  + contentCategory + ", filtring value : " + filterValue)}
			</#if>
			
			<#local extendedContents = getContent(type, contentCategory, filterValue)>
			<#if (extendedContents?size >1)>
				<@handleElementTypeMembres extendedContents 1/>
			</#if>
		<#else>
			<#if logHelper??>
			${logHelper.stackDebugMessage("Graph.build ERROR : graph in contentHeader found but not supported, should be data or query")}
		</#if>
		</#if>
	<#else>
		<#if logHelper??>
			${logHelper.stackDebugMessage("Graph.build : no graph in contentHeader")}
		</#if>
	</#if>
</#macro>

<#macro recursiveStruture element parentType="" level=1>
	<#local elementType = parentType>
	<#if (element.type)?? && element.type?has_content>
		<#local elementType = element.type>
	</#if>
	<#local elementCode = element.code!"MISSING_CODE">
	
	<#if logHelper??>
		${logHelper.stackDebugMessage("Graph.recursiveStruture : (level:"+level+") PROCESSING type : " + elementType + ", code : " + elementCode + ", data : " + common.toString(element))}
	</#if>
	
	<#switch elementType>
		<#case "structure">
			<@handleElementTypeStructure element level/>
		<#break>
		<#case "membreCommission">
			<@handleElementTypeMembreCommission element level/>
		<#break>
	</#switch>
	
	<#if (element.group)?? && element.group?has_content>
		<#if logHelper??>
			${logHelper.stackDebugMessage("Graph.recursiveStruture : (level:"+level+") group found, processing...., data : " + common.toString(element.group))}
		</#if>
			
		<#list element.group as theGroup>
			<#if theGroup?is_hash>
				<#if (theGroup.type)?? && theGroup.type?has_content>
					<#local elementType = theGroup.type>
				</#if>
				
				<#switch elementType>
					<#case "structure">
						<@handleElementTypeStructure theGroup level/>
					<#break>
					<#case "membreCommission">
						<@handleElementTypeMembreCommission theGroup level/>
					<#break>
				</#switch>
			<#else>
				<#list theGroup as element>
				<@recursiveStruture element elementType level+1 />
			</#list>
			</#if>
		</#list>
	</#if>
</#macro>

<#macro handleElementTypeStructure element level>
	<#local titleLevel = level+1>
	
	<#local structure = getChildElement(element.type, element.code)>
	<#local structureName = element.type + " - " + element.code>
	<#if structure?has_content && structure?size == 1>
		<#local structureName = structure[0].title>
	</#if>
	
	<h${titleLevel}>${structureName}</h${titleLevel}>
	<span>Fonction : ${element.fonction}</span>
</#macro>

<#macro handleElementTypeMembreCommission element level>
	<#local titleLevel = level+1>
	
	<h${titleLevel}>Membre des comissions : </h${titleLevel}>
	<table>
		<thead>
			<th>Commission</th>
			<th>statut</th>
		</thead>
		<#list element.elements as membreCommission>
			<#local commissionType = membreCommission.type!"commission">
			<#local commission = getChildElement(commissionType, membreCommission.code)>
			<#local commissionName = membreCommission.code!"MISSING_CODE">
			<#if commission?has_content && commission?size == 1>
				<#local commissionName = "<a href=\"" + common.buildRootPathAwareURL(commission[0].uri)  + "\">" + commission[0].title + "</a>">
			</#if>
			
			<tr>
				<td>${commissionName}</td>
				<td>${membreCommission.statut}</td>
			</tr>
		</#list>
	</table>
</#macro>

<#macro handleElementTypeMembres extendedContents level>

	<#if logHelper??>
		${logHelper.stackDebugMessage("Graph.handleElementTypeMembres : (level:"+level+") displaying members based on extracted contents : " + common.toString(extendedContents))}
	</#if>
	<#local titleLevel = level+1>
	
	<h${titleLevel}>Membres : </h${titleLevel}>
	<table>
		<thead>
			<th>Nom</th>
			<th>statut</th>
		</thead>
		<#list extendedContents as anExtendedContent>
			<#if (anExtendedContent.data)?? && (anExtendedContent.data.content) ?? && (anExtendedContent.data.related)??>
				<tr>
					<td><a href=\"${common.buildRootPathAwareURL(anExtendedContent.data.content.uri)}">${anExtendedContent.data.content.title}</a></td>
					<td>${anExtendedContent.data.related.statut}</td>
				</tr>
			<#else>
				<#if logHelper??>
					${logHelper.stackDebugMessage("Graph.handleElementTypeMembres ERROR : (level:"+level+") invalid extendedContent structure " + common.toString(anExtendedContent))}
				</#if>
			</#if>
		</#list>
	</table>
</#macro>

<#function getChildElement structureType="MISSING_TYPE" code="MISSING_CODE">
	<#local structure = db.getPublishedContent("org_openCiLife_post")?filter(b -> (b.category)?? && b.category?has_content && b.category==structureType)?filter(b -> (b.code)?? && b.code?has_content && b.code==code)>
	<#if (langHelper)??>
		<#local structure = structure?filter(ct -> langHelper.isCorectLang(ct, langHelper.getLang(content)))>
	</#if>
	<#if logHelper??>
		${logHelper.stackDebugMessage("Graph.getChildElement : type : " + structureType + ", code : " + code + " (published, filtered by lang if resquired) used with " + structure?size + " childs found")}
	</#if>
	<#return structure>
</#function>


<#function getContent type inCategory filterValue>
	<#local extendsContent = []>
	<#local contents = db.getPublishedContent("org_openCiLife_post")?filter(b -> (b.category)?? && b.category?has_content && b.category==inCategory)>
		
	<#if (langHelper)??>
		<#local contents = contents?filter(ct -> langHelper.isCorectLang(ct, langHelper.getLang(content)))>
	</#if>
	
	<#list contents as aContent>
		<#local relatedContent = getRelated(aContent type filterValue)>
		<#if (relatedContent?size>0)>
			<#local contentId = aContent.category+"/"+aContent.code!"MISSING_CODE">
			<#local extendsContent = extendsContent + [{"id":contentId, "data":relatedContent}]>
		</#if>
	</#list>
	
	<#if logHelper??>
		${logHelper.stackDebugMessage("Graph.getContent : type : " + type + ", in : " + inCategory + ", filterBy : " + filterValue + " (published, filtered by lang if resquired) used with " + extendsContent?size + " childs found")}
	</#if>
	<#return extendsContent>
</#function>

<#function getRelated theContent inCategory filterValue>
	<#local extendedContent = {}>
		<#if (theContent.graph)?? && theContent.graph?has_content && (theContent.graph.data)?? && theContent.graph.data?has_content>
			<#if logHelper??>
				${logHelper.stackDebugMessage("Graph.isRelated : " + theContent.title + ", checking graph.data")}
			</#if>
			<#local related = searchInList(theContent.graph.data inCategory filterValue)>
			<#local extendedContent = {"content":theContent, "related":related}>
		<#else>
			<#if logHelper??>
				${logHelper.stackDebugMessage("Graph.isRelated : " + theContent.title + ", has no graph.data in contentHeader ==> rejected")}
			</#if>
		</#if>
	<#return extendedContent>
</#function>

<#function searchInList elements structureType filterValue>
	<#local related = {}>
	<#list elements as element>
		<#local related = search(element structureType filterValue)>
		<#if ((related)?? && related?size >1)>
			<#break>
		</#if>
	</#list>
	<#return related>
</#function>

<#function search element structureType filterValue parentType="">
	<#local related = {}>
	<#local found = false>
	<#local elementType = parentType>
	<#if (element.type)?? && element.type?has_content>
		<#local elementType = element.type>
	</#if>
	
	<#local found = elementType == structureType
					&& (element.code)?? && element.code?has_content && element.code == filterValue>
	<#if found>
		<#local related = element>
		<#if logHelper??>
			${logHelper.stackDebugMessage("Graph.search : match for " + structureType + ", filter : " + filterValue + "(parentTYpe : " + parentType)}
		</#if>
	<#else>	
		<#if logHelper??>
			${logHelper.stackDebugMessage("Graph.search : element NOT match("+structureType+"/"+filterValue+",parentType="+parentType+"), seaching for gorups in : " + common.toString(element))}
		</#if>		
		<#if (element.group)?? && element.group?has_content && (element.group?size>0)>
			<#local parentType = "">
			<#list element.group as theGroup>
				<#local elementsList = theGroup>
				<#if theGroup?is_hash>
					<#local elementsList = theGroup.elements>
					<#if (theGroup.type)??>
						<#local parentType = theGroup.type>
					</#if>
				</#if>
				
				<#list elementsList as element>
					<#local related = search(element structureType filterValue parentType)>
					<#if (related)?? && (related?size>0)>
						<#local related = element>
						<#break>
					</#if> 
				</#list>
			</#list>
		</#if>
		</#if>
	<#return related>
</#function>