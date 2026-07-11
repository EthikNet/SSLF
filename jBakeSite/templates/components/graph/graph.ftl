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
			<#local inFilter = theContent.graph.query.in>
			<#local filterValue =  theContent.graph.query.value>
			
			<#local groupByValue = "">
			<#if (theContent.graph.query.groupBy)??>
				<#local groupByValue = theContent.graph.query.groupBy>
			</#if>
			
			<#if logHelper??>
				${logHelper.stackDebugMessage("Graph.build : START PROCESSING graph QUERY root type : " + type +", in "  + common.toString(inFilter) + ", filtring value : " + filterValue + ", grouping by : " + groupByValue)}
			</#if>
			
			<#local extendedContents = getContent(type, inFilter, filterValue)>
			<#if groupByValue?has_content>
				<#local extendedContents = groupBy(extendedContents, groupByValue)>
			</#if>
			<#if (extendedContents?size >1)>
				<#local subTemplateName = "handleElementGenericRelationTable">
				<#if (theContent.graph.subTemplate??)>
					<#local subTemplateName=theContent.graph.subTemplate>
				</#if>
				<#if logHelper??>
					${logHelper.stackDebugMessage("Graph.build : generating a graph with template : " + subTemplateName + " (gouped by : " + groupByValue + "), for : " + extendedContents?size + " related contents")}
				</#if>
				<#local subTemplateInterpretation = "<@${subTemplateName} extendedContents 1 groupByValue?has_content/>"?interpret>
				<@subTemplateInterpretation/>
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
		<#case "commission">
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
					<#case "commission">
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
	
	<h${titleLevel}><@buildLink element.type element.code /></h${titleLevel}>
	<#if (element.fonction)?? && element.fonction?has_content>
		<span>Fonction : ${element.fonction}</span>
	</#if>
	<#if (element.statut)?? && element.statut?has_content>
		<span>${element.statut}</span>
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

<#macro handleElementGenericRelationTable extendedContents level isGrouped>
	<#if logHelper??>
		${logHelper.stackDebugMessage("Graph.handleElementGenericRelationTable : (level:"+level+") grouped="+isGrouped+", displaying members based on extracted contents : " + common.toString(extendedContents))}
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
		<h${titleLevel}>${tableTitle}</h${titleLevel}>
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


<#macro buildLink(structureType="" code="" defaultToLabel=true)>
	<#if logHelper??>
		${logHelper.stackDebugMessage("Graph.buildLink : trying to build link for : type : " + structureType + ", code : " + code)}
	</#if>
	<#if structureType?has_content>
		<#if code?has_content>
			<#local structureInfos = getChildElement(structureType, code)>
			<#if structureInfos?has_content && structureInfos?size == 1>
				<a href="${common.buildRootPathAwareURL(structureInfos[0].uri)}">${structureInfos[0].title}</a>
			<#else>
				<#if defaultToLabel>
					${code!"MISSING_CODE"}
				</#if>
			</#if>
		<#else>
			<#if defaultToLabel>
				${code!"MISSING_CODE"}
			</#if>
		</#if>
	<#else>
		${code!"MISSING_STRUCUTRE_AND_CODE"}
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
	
	<#if !(groupedElements[orderElementValue])??>
		<#if logHelper??>
			${logHelper.stackDebugMessage("Graph.addElement : " + orderElementValue + ", does NOT exists yet : creating group")}
		</#if>
		<#local groupOfEelements = {orderElementValue, [anExtendedContent]}>
	<#else>
		<#if logHelper??>
			${logHelper.stackDebugMessage("Graph.addElement : " + orderElementValue + ", exists addind to existing group")}
		</#if>
		<#local groupOfEelements = {orderElementValue, groupedElements[orderElementValue] + [anExtendedContent]}>
	</#if>
	<#assign groupedElements = groupedElements + groupOfEelements>
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

<#function searchInList elements structureType filterValue>
	<#local related = []>
	<#local parentType = "">
	<#if (elements.type)?? && elements.type?has_content>
		<#local parentType = elements.type>
	</#if>
	<#list elements as element>
		<#local related = related + search(element, structureType, filterValue, parentType)>
	</#list>
	<#return related>
</#function>

<#function search element structureType filterValue parentType="">
	<#local related = []>
	<#local match = false>
	<#local elementType = parentType>
	<#if (element.type)?? && element.type?has_content>
		<#local elementType = element.type>
	</#if>
	
	<#local match = elementType == structureType
					&& (element.code)?? && element.code?has_content && (filterValue == "*" || element.code == filterValue)>
	<#if match>
	<#local enchancedElement = element>
		<#if !(element.type)??>
			<#local theGroup = []>
			<#if (element.group)??>
				<#local theGroup = element.goup>
			</#if>
			<#local theFonction = "">
			<#if (element.fonction)??>
				<#local theFonction = element.fonction>
			</#if>
			<#local enchancedElement = {"type":elementType, "code":element.code, "group":theGroup, "fonction":theFonction, "statut":element.statut}>
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
				<#local related = related + search(element structureType filterValue elementType)>
			</#list>
		</#list>
	</#if>
	<#return related>
</#function>

<#function debugExtendedContent extendedContents level=1 baseTitle="NO_BASE_TITLE">
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
		${logHelper.stackDebugMessage("Graph.displayGroupOfRelations : (level:"+level+") displaying \""+baseTitle+"\" based on extracted contents : " + common.toString(debugInfos))}
	</#if>
</#function>

<#macro displayGroupOfRelations extendedContents level isGrouped baseTitle="">
	${debugExtendedContent(extendedContents level baseTitle)}
	
	<#local titleLevel = level+1>
	<#local title = baseTitle + " : ">
	
	<#local groupedData = extendedContents>
	<#if !isGrouped>
		<#local groupedData = {"NOT_GROUPED", extendedContents}>
	</#if>
	
	<#list groupedData as groupName, extendedContents>
		<#if isGrouped>
			<#local title = baseTitle + " de " + groupName + " :">
		</#if>
		<h${titleLevel}>${title}</h${titleLevel}>
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