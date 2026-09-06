<#function getComponnentInfo>
	<#return {"componnentVersion":2, "name":"Graph", "description":"Allow strcutured Graphs based on content", "version":"0.1.0", "recommandedNamespace":"graph", "require":[{"value":"stripe", "type":"contentHeader"}, {"value":"webleger.component.stripe.apiKey", "type":"config"}], "uses":[{"value":"langHelper", "type":"lib"}, {"value":"logHelper", "type":"lib"}]}>
</#function>

<#global pageUseHierarchy=false />
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
	<#if pageUseHierarchy>
		<#if ressourcesHelper??>
			${ressourcesHelper.addFooterRessource({"tagType":"script", "src":"templates/components/graph/copyToAssets/noAgregation/orgChart.js", "order":40})}
			${ressourcesHelper.addFooterRessource({"tagType":"link", "href":"templates/components/graph/copyToAssets/noAgregation/orgChart.css", "order":42, "rel":"stylesheet"})}
		<#else>
			<#if logHelper??>
				${logHelper.stackDebugMessage("graph.addFooterScripts : ERROR cannot add footer script, missing 'ressourcesHelper' component")}
			</#if>
		</#if>
		<#else>
		<#if logHelper??>
			${logHelper.stackDebugMessage("graph.addFooterScripts : Graph component are not use in this page, no script added")}
		</#if>
	</#if>
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
		</#if>
		
		<#if (theContent.graph.query)?? && theContent.graph.query?has_content>
			<#if theContent.graph.query?is_hash && (theContent.graph.query.type)?? && theContent.graph.query.type?has_content>
				<#local type = theContent.graph.query.type>
			</#if>
			<#local inFilter = theContent.graph.query.in>
			<#local filterValue =  theContent.graph.query.filter>
			
			<#local groupByAttribute = "">
			<#if (theContent.graph.query.groupBy)??>
				<#local groupByAttribute = theContent.graph.query.groupBy>
			</#if>
			
			<#local graphId="hierarchyChart">
			<#if (theContent.graph.query.graphId)?? && theContent.graph.query.graphId?has_content>
				<#local graphId=theContent.graph.query.graphId>
			</#if>
			
			<#if logHelper??>
				${logHelper.stackDebugMessage("Graph.build : START PROCESSING graph QUERY root type : " + type +", in "  + common.toString(inFilter) + ", filtring value : " + filterValue + ", grouping by : " + groupByAttribute)}
			</#if>
			
			<#local extendedContents = getContent(type, inFilter, filterValue)>
			<#if groupByAttribute?has_content>
				<#local extendedContents = groupBy(extendedContents, groupByAttribute)>
			</#if>
			<#if (extendedContents?size >=1)>
				<#local subTemplateName = "handleElementGenericRelationTable">
				<#if (theContent.graph.subTemplate??)>
					<#local subTemplateName=theContent.graph.subTemplate>
				</#if>
				<#if logHelper??>
					${logHelper.stackDebugMessage("Graph.build : generating a graph with template : " + subTemplateName + " (gouped by : " + groupByAttribute + "), with name = " + graphId + ", for : " + extendedContents?size + " related contents")}
				</#if>
				<#local subTemplateInterpretation = "<@${subTemplateName} extendedContents 1 groupByAttribute?has_content graphId/>"?interpret>
				<@subTemplateInterpretation/>
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
		<#case "commission">
			<@handleElementTypeMembreCommission element level/>
		<#break>
		<#case "délégations">
			<@handleElementTypeDelegation element level />
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
					<#case "commission">
						<@handleElementTypeMembreCommission theGroup level/>
					<#break>
					<#case "délégations">
						<@handleElementTypeDelegation theGroup level />
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
	
	<h${titleLevel}><@buildLink element.type element.code /></h${titleLevel}>
	
	<#if (element.role)?? && element.role?has_content>
		<span class="personneInfo personneRole">Rôle : ${element.role}</span>
	</#if>
	<#if (element.fonction)?? && element.fonction?has_content>
		<span class="personneInfo personneFonction">Fonction : ${element.fonction}</span>
	</#if>
	<#if (element.poste)?? && element.poste?has_content>
		<span class="personneInfo personnePoste">Poste : ${element.poste}</span>
	</#if>
	<#if (element.statut)?? && element.statut?has_content>
		<span class="personneInfo personneStatut">Statut : ${element.statut}</span>
	</#if>
</#macro>

<#macro handleElementTypeMembreCommission element level>
	<#local titleLevel = level+2>
	
	<h${titleLevel}>Membre des comissions : </h${titleLevel}>
	<table>
		<thead>
			<th>Commission</th>
			<th>statut</th>
		</thead>
		<#list element.elements as membreCommission>
			<tr>
				<td><@buildLink membreCommission.type!"commission" membreCommission.code/></td>
				<td>${membreCommission.statut}</td>
			</tr>
		</#list>
	</table>
</#macro>

<#macro handleElementTypeDelegation element level>
	<#local titleLevel = level+2>
	
	<h${titleLevel}>Délégations : </h${titleLevel}>
	<#if (element.elements)??>
		<#if logHelper??>
			${logHelper.stackDebugMessage("Graph.handleElementTypeDelegation (level:"+level+") displaying : " + element.elements?size + " delegations from : " + common.toString(element))}
		</#if>
		<ul class="delegation">
			<#list element.elements as delegateTo>
				<li><@buildLink delegateTo.type!"délégations" delegateTo.code/></li>
			</#list>
		</ul>
		
	<#else>
		<#if logHelper??>
			${logHelper.stackDebugMessage("Graph.handleElementTypeDelegation (level:"+level+") displaying : 1 delegation from : " + common.toString(element))}
		</#if>
		<@buildLink element.type element.code/>
	</#if>
</#macro>

<#macro handleElementGenericRelationTable extendedContents level isGrouped queryName>
	<#if logHelper??>
		${logHelper.stackDebugMessage("Graph.handleElementGenericRelationTable : (level:"+level+") grouped="+isGrouped?string('yes', 'no')+", displaying members based on extracted contents : " + common.toString(extendedContents))}
	</#if>
	<#local titleLevel = level+1>
	
	<#local groupedData = extendedContents>
	<#if !isGrouped>
		<#local groupedData = {"NOT_GROUPED", extendedContents}>
		<#local tableTitle = "Membres : ">
	</#if>
	
	<#list groupedData as groupName, anExtendedContent>
		<#if isGrouped>
			<#local tableTitle = "Membres de " + groupName + " :">
		</#if>
		<#local plurializeTitleChar = "">
		<#if (anExtendedContent?size > 1)>
			<#local plurializeTitleChar = "s">
		</#if>
		<h${titleLevel} class="relationTitle">${tableTitle}${plurializeTitleChar}</h${titleLevel}>
		<table>
			<thead>
				<th>Nom</th>
				<th>Informations</th>
			</thead>
			<#list extendedContents as anExtendedContent>
				<#if (anExtendedContent.data)?? && (anExtendedContent.data.content) ?? && (anExtendedContent.data.related)??>
					<tr>
						<td><a href="${common.buildRootPathAwareURL(anExtendedContent.data.content.uri)}">${anExtendedContent.data.content.title}</a></td>
						<td>
							<#if anExtendedContent.data.related?size == 1>
								<#local extendedContent = []>
								<#if anExtendedContent.data.related?is_sequence>
									<#local extendedContent = anExtendedContent.data.related[0]>
								<#else>
									<#local extendedContent = anExtendedContent.data.related>
								</#if>
								<@buildLink extendedContent.type extendedContent.code/> - ${extendedContent.statut!extendedContent.fonction!"MISSING_STATUT"}
							<#else>
								<#list anExtendedContent.data.related as aRelatedContent>
									<@buildLink aRelatedContent.type aRelatedContent.code/> - ${aRelatedContent.statut!aRelatedContent.fonction!"MISSING_STATUT"} <br/>
								</#list>
							</#if>
						</td>
					</tr>
				<#else>
					<#if logHelper??>
						${logHelper.stackDebugMessage("Graph.handleElementGenericRelationTable ERROR : (level:"+level+") invalid extendedContent structure " + common.toString(anExtendedContent))}
					</#if>
				</#if>
			</#list>
		</table>
	</#list>
</#macro>

<#macro buildOrgChartHierarchyGraphSubTemplate extendedContents level isGrouped graphId>
	<#global pageUseHierarchy=true />
	<#local graphData = "">
	<div id="${graphId}" class="hierarchyGraph" data-graph-data="${graphData}"></div>
</#macro>

<#function getChildElement structureType="MISSING_TYPE" code="MISSING_CODE">
	<#local structure = db.getPublishedContent("org_openCiLife_post")?filter(b -> ((b.category)?? && b.category?has_content && b.category==structureType) || structureType=="*")?filter(b -> (b.code)?? && b.code?has_content && b.code==code)>
	<#if (langHelper)??>
		<#local structure = structure?filter(ct -> langHelper.isCorectLang(ct, langHelper.getLang(content)))>
	</#if>
	<#if logHelper??>
		${logHelper.stackDebugMessage("Graph.getChildElement : type : " + structureType + ", code : " + code + " (published, filtered by lang if resquired) used with " + structure?size + " childs found")}
	</#if>
	<#return structure>
</#function>


<#macro buildLink(structureType="" code="" defaultToLabel=true plurial=false)>
	<#if logHelper??>
		${logHelper.stackDebugMessage("Graph.buildLink : trying to build link for : type : " + structureType + ", code : " + code)}
	</#if>
	
	<#local defaultCodeDisplay = code>
	<#if plurial>
		<#local defaultCodeDisplay = defaultCodeDisplay+"s">
	</#if>
	<#if structureType?has_content>
		<#if code?has_content>
			<#local structureInfos = getChildElement(structureType, code)>
			<#if structureInfos?has_content && structureInfos?size == 1>
				<a href="${common.buildRootPathAwareURL(structureInfos[0].uri)}">${structureInfos[0].title}</a>
			<#else>
				<#if defaultToLabel>
					${defaultCodeDisplay!"MISSING_CODE"}
				</#if>
			</#if>
		<#else>
			<#if defaultToLabel>
				${defaultCodeDisplay!"MISSING_CODE"}
			</#if>
		</#if>
	<#else>
		${defaultCodeDisplay!"MISSING_STRUCTURE_AND_CODE"}
	</#if>
</#macro>

<#function getContent type inFilter filterValue>
	<#local extendsContent = []>
	<#local inCategory = inFilter.category>
	<#local inCategoryOrder = inFilter.order!"">
	<#local inCategoryOrderDir = inFilter.orderDir!"asc">
	<#local contents = db.getPublishedContent("org_openCiLife_post")?filter(b -> (b.category)?? && b.category?has_content && b.category==inCategory)>
		
	<#if (langHelper)??>
		<#local contents = contents?filter(ct -> langHelper.isCorectLang(ct, langHelper.getLang(content)))>
	</#if>
	
	<#if (content?size>0) && (inCategoryOrder)?? && inCategoryOrder?has_content>
		<#local contents = contents?sort_by(inCategoryOrder)>
		<#if inCategoryOrderDir=="desc">
			<#local contents = contents.reverse>
		</#if>
	</#if>
	
	<#list contents as aContent>
		<#local relatedContent = filterRelated(aContent, type, filterValue)>
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

<#function filterRelated theContent inCategory filterValue>
	<#local extendedContent = {}>
		<#if (theContent.graph)?? && theContent.graph?has_content && (theContent.graph.data)?? && theContent.graph.data?has_content>
			<#if logHelper??>
				${logHelper.stackDebugMessage("Graph.filterRelated : " + theContent.title + ", checking graph.data")}
			</#if>
			<#local related = searchInList(theContent.graph.data inCategory filterValue)>
			<#local extendedContent = {"content":theContent, "related":related}>
		<#else>
			<#if logHelper??>
				${logHelper.stackDebugMessage("Graph.filterRelated : " + theContent.title + ", has no graph.data in contentHeader ==> rejected")}
			</#if>
		</#if>
	<#return extendedContent>
</#function>

<#function search element structureType filterData parentType="">
	<#local related = []>
	<#local match = false>
	<#local elementType = parentType>
	<#if (element.type)?? && element.type?has_content>
		<#local elementType = element.type>
	</#if>
	
	<#local filterDataDetails = filterData?split(":")>
	<#local filterAttribute = filterDataDetails[0]>
	<#local filterValue = filterDataDetails[1]>
	<#local matchedElement = "">
	
	<#if (structureType=="*" || elementType == structureType) && (element[filterAttribute])?? && element[filterAttribute]?has_content>
		<#local elementValueToFilterList = element[filterAttribute].split(",")>
		
		<#list elementValueToFilterList as anElementFilterValue>
			
			<#if !match && (filterValue == "*" || anElementFilterValue == filterValue)>
				<#local matchedElement = anElementFilterValue>
				<#local match = true>
				<#if logHelper??>
					${logHelper.stackDebugMessage("Graph.search : matched filter ("+filterAttribute+") on (element) : " + anElementFilterValue + ", against : " + filterValue)}
				</#if>
			<#else>
				<#if logHelper??>
					${logHelper.stackDebugMessage("Graph.search : NONE matching filter ("+filterAttribute+") on (element) : " + anElementFilterValue + ", against : " + filterValue)}
				</#if>
			</#if>
		</#list>
	</#if>
	
	<#if match>
		<#local enchancedElement = element>
		<#if logHelper??>
			${logHelper.stackDebugMessage("Graph.search : preparing enchanced Element, with filter for : " + filterAttribute + ", with value : " + matchedElement)}
		</#if>
		<#local theGroup = []>
		<#if (element.group)??>
			<#local theGroup = element.group>
		</#if>
		<#local theFonction = "">
		<#if (element.fonction)??>
			<#local theFonction = element.fonction>
			<#if filterAttribute == "fonction">
				<#local theFonction = matchedElement>
			</#if>
		</#if>
		<#local theStatut = "">
		<#if (element.statut)??>
			<#local theStatut = element.statut>
			<#if filterAttribute == "statut">
				<#local theStatut = matchedElement>
			</#if>
		</#if>
		<#local theRole = "">
		<#if (element.role)??>
			<#local theRole = element.role>
			<#if filterAttribute == "role">
				<#local theRole = matchedElement>
			</#if>
		</#if>
		<#local theSousRole = "">
		<#if (element.sousRole)??>
			<#local theSousRole = element.sousRole>
			<#if filterAttribute == "sousRole">
				<#local theSousRole = matchedElement>
			</#if>
		</#if>
		<#local thePoste = "">
		<#if (element.poste)??>
			<#local thePoste = element.poste>
			<#if filterAttribute == "poste">
				<#local thePoste = matchedElement>
			</#if>
		</#if>
		<#local enchancedElement = {"type":elementType, "code":element.code, "group":theGroup, "fonction":theFonction, "statut":theStatut, "role":theRole, "sousRole":theSousRole, "poste":thePoste, "notFilteredAttribute":{"attribute":filterAttribute, "match":matchedElement!""}}>
		<#if logHelper??>
			${logHelper.stackDebugMessage("Graph.search : matching (enchanced) element : " + common.toString(enchancedElement))}
		</#if>
		<#local related = related + [enchancedElement]>
	</#if>
		
	<#if (element.group)?? && element.group?has_content && (element.group?size>0)>
		<#if logHelper??>
			${logHelper.stackDebugMessage("Graph.search : ("+structureType+"/"+filterValue+",parentType="+parentType+"), group found, searching for matching relatedContent : " + common.toString(element))}
		</#if>	
		<#local elementType = parentType>
		<#list element.group as theGroup>
			<#local elementsList = theGroup>
			<#if theGroup?is_hash>
				<#local elementsList = theGroup.elements>
				<#if (theGroup.type)??>
					<#local elementType = theGroup.type>
				</#if>
			</#if>
			
			<#list elementsList as element>
				<#local related = related + search(element structureType filterData elementType)>
			</#list>
		</#list>
	</#if>
	<#return related>
</#function>

<#assign groupedElements = {}>
<#function groupBy source orderElement>
	<#if (source?size >0) && orderElement?has_content>
		<#if logHelper??>
			${logHelper.stackDebugMessage("Graph.groupBy : grouping : " + source?size + " elements by : " + orderElement)}
		</#if>
		<#list source as anExtendedContent>
			<#local orderElementValue = "NO_GROUP">
			
			<#if orderElement?starts_with("related")>
				<#list anExtendedContent.data.related as relatedData>
					<#local searchedAttributs = orderElement?keep_after_last(".")>
					<#if (relatedData[searchedAttributs])??>
						<#local orderElementValue = relatedData[searchedAttributs]>
					</#if>
					${addElement(orderElementValue anExtendedContent relatedData)}
				</#list>
			<#else>
			<#if (anExtendedContent.data[orderElement])??>
				<#local orderElementValue = anExtendedContent.data[orderElement]>
			</#if>
				${addElement(orderElementValue anExtendedContent)}
			</#if>
		</#list>
		<#if logHelper??>
			<#local NumberOfGroups = 0>
			<#local debugInfos = []>
			<#list groupedElements as groupName, elements>
				<#local NumberOfGroups +=1>
				<#local debugInfos = debugInfos + [{"groupeName":groupName,"NumberOfRelations":elements?size}]>
			</#list>
			${logHelper.stackDebugMessage("Graph.groupBy : Number of groups : " + NumberOfGroups + ", groupsInfos : " + common.toString(debugInfos))}
		</#if>
	</#if>
	<#return groupedElements>
</#function>

<#function addElement orderElementValue anExtendedContent relatedData="">
	<#if logHelper??>
		<#if (relatedData)?? && relatedData?has_content>
			${logHelper.stackDebugMessage("Graph.addElement : element " + anExtendedContent.data.content.title + " for relation : " + relatedData.code + ", will be grouped IN : " + orderElementValue)}
			<#local anExtendedContent = anExtendedContent + {"matchedDataForGroup":relatedData}>
		<#else>
			${logHelper.stackDebugMessage("Graph.addElement : element " + anExtendedContent.data.content.title + " will be grouped IN : " + orderElementValue)}
		</#if>
	</#if>
	
	<#local splitedOrderElementValue = orderElementValue?split(",")>
	<#list splitedOrderElementValue as anOrderElementValue>
		<#local cleanedOrderElementValue = anOrderElementValue?trim>
		<#if !(groupedElements[cleanedOrderElementValue])??>
			<#if logHelper??>
				${logHelper.stackDebugMessage("Graph.addElement : " + cleanedOrderElementValue + ", does NOT exists yet : creating group")}
			</#if>
			<#local groupOfEelements = {cleanedOrderElementValue, [anExtendedContent]}>
		<#else>
			<#if logHelper??>
				${logHelper.stackDebugMessage("Graph.addElement : " + cleanedOrderElementValue + ", exists addind to existing group")}
			</#if>
			<#local groupOfEelements = {cleanedOrderElementValue, groupedElements[cleanedOrderElementValue] + [anExtendedContent]}>
		</#if>
		<#assign groupedElements = groupedElements + groupOfEelements>
	</#list>
</#function>

<#function searchInList elements structureType filterData>
	<#local related = []>
	<#local parentType = "">
	<#if (elements.type)?? && elements.type?has_content>
		<#local parentType = elements.type>
	</#if>
	<#list elements as element>
		<#local related = related + search(element, structureType, filterData, parentType)>
	</#list>
	<#return related>
</#function>

<#function debugExtendedContent extendedContents level=1 baseTitle="NO_BASE_TITLE" logGroup="debugExtendedContent">
	<#if logHelper??>
		<#local debugInfos = []>
		<#local index = 0>
		<#if extendedContents?is_hash>
			<#list extendedContents as key, value>
				<#if key=="id">
					<#local debugInfos = debugInfos + [{key:value}]>
				<#elseif key=="data">
					<#local debugInfos = debugInfos + [{"contentUri":value.content.uri, "(Filtred)relations":value.related}]>
				<#else>
					<#local debugInfos = debugInfos + [{"key":key, "value":value}]>
				</#if>
			</#list>
		<#elseif extendedContents?is_sequence>
			<#list extendedContents as anExtendContent>
				<#list anExtendContent as key, value>
					<#if key=="id">
						<#local debugInfos = debugInfos + [{"index":index, key:value}]>
					<#elseif key=="data">
						<#local debugInfos = debugInfos + [{"index":index, "contentUri":value.content.uri, "(Filtred)relations":value.related}]>
					<#else>
						<#local debugInfos = debugInfos + [{"index":index, "key":key, "value":value}]>
					</#if>
				</#list>
				<#local index = index+1>
			</#list>
		</#if>
		${logHelper.stackDebugMessage("Graph." + logGroup + " : (level:"+level+") displaying \""+baseTitle+"\" based on extracted contents : " + common.toString(debugInfos))}
	</#if>
</#function>

<#macro displayGroupOfRelations extendedContents level isGrouped baseTitle="" linkToContent=true>
	${debugExtendedContent(extendedContents level baseTitle "displayGroupOfRelations")}
	
	<#local title = "">
	<#local titleLevel = level+1>
	<#if (baseTitle)?? && baseTitle?has_content>
		<#local title = baseTitle>
	</#if>
	
	<#local groupedData = extendedContents>
	<#if !isGrouped>
		<#local groupedData = {"NOT_GROUPED", extendedContents}>
	</#if>
	
	<#list groupedData as groupName, extendedContents>
		<#if isGrouped>
			<#if (baseTitle)?? && baseTitle?has_content>
				<#local title = baseTitle + " de " + groupName>
			<#else>
				<#local title = groupName>
			</#if>
		</#if>
		<#if (title)?? && title?has_content>
			<#local plurial = false>
			<#if (extendedContents?size >1)>
				<#local plurial = true>
				<#local title = title+"s">
			</#if>
			<h${titleLevel} class="relationTitle">
				<#if linkToContent>
					<@buildLink "*" groupName true plurial/>
				<#else>
					${title}
				</#if>
			</h${titleLevel}>
		</#if>
		<#nested extendedContents>
	</#list>
</#macro>

<#macro displayRelations extendedContents>
	<#list extendedContents as anExtendedContent>
		<#if (anExtendedContent.data)?? && (anExtendedContent.data.content) ?? && (anExtendedContent.data.related)??>
			<#local relationsData = anExtendedContent.data.related>
			<#if (anExtendedContent.matchedDataForGroup)?? && anExtendedContent.matchedDataForGroup?has_content>
				<#local relationsData = [anExtendedContent.matchedDataForGroup]>
				<#if logHelper??>
					${logHelper.stackDebugMessage("Graph.displayRelations matchedDataForGroup found, using it for relations : " + common.toString(relationsData))}
				</#if>
			</#if>
			<#nested anExtendedContent.data.content relationsData>
		<#else>
			<#if logHelper??>
				${logHelper.stackDebugMessage("Graph.displayRelations ERROR : (level:"+level+") invalid extendedContent structure " + common.toString(anExtendedContent))}
			</#if>
		</#if>
	</#list>
</#macro>

<#macro displayARelation relations>
	<#local cleanRelations = relations>
	<#if relations?size == 1>
		<#if relations?is_sequence>
			<#local cleanRelations = [relations[0]]>
		</#if>
	</#if>
	
	<#list cleanRelations as aRelation>
		<#nested aRelation>
	</#list>
</#macro>

<#macro filterRelation theContent categoryFilter filters>
	<#local onSyntheseRelations = []>
	<#if (theContent.graph)?? && theContent.graph?has_content>
		<#local onSyntheseRelations = filterRelated(theContent, categoryFilter, filters)>
		<#if logHelper??>
			${logHelper.stackDebugMessage("Graph.displayOnSynthese : Filtering content of " + theContent.title + "(category : " + categoryFilter + ", filters : " + filters +") => " + onSyntheseRelations?size + " matches (details : " + common.toString(onSyntheseRelations) + ")")}
		</#if>
	</#if>
	<#list onSyntheseRelations as content, relateds>
		<#if relateds?is_sequence>
			<#list relateds as related>
				<#nested related>
			</#list>
		</#if>
	</#list>
</#macro>