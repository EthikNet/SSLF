<#function getComponnentInfo>
	<#return {"componnentVersion":2, "name":"Graph", "description":"extract OrgChart Data from Graph", "version":"0.1.0", "recommandedNamespace":"graphToOrgChart", "require":[{"value":"sequenceHelper", "type":"lib"}], "uses":[ {"value":"logHelper", "type":"lib"}]}>
</#function>

<#-- NOT finished work -->

<#macro buildOrgChartHierarchyGraphSubTemplate extendedContents level isGrouped options>
	<#global pageUseHierarchy=true />
	
	<#local graphId=sequenceHelper.getValue(options, "graphId", "hierarchyChart")>
	<#if logHelper??>
		${logHelper.stackDebugMessage("Graph.buildOrgChartHierarchyGraphSubTemplate Building heirarchy graph, graphId : " + graphId)}
	</#if>
	<#local graphData = buildHierarchy(extendedContents, isGrouped, options)>
	<div id="${graphId}" class="hierarchyGraph" data-graph-data="${graphData}"></div>
</#macro>



<#function buildHierarchy extendedContents isGrouped options>
	<#local hierarchicalExtendedContents = {"childToParentCache":[], "data":[], "notAddedChild":[]}>
	<#local graphData = "{
    'name': 'Lao Lao',
    'title': 'general manager',
    'children': [
      { 'name': 'Bo Miao', 'title': 'department manager' },
      { 'name': 'Su Miao', 'title': 'department manager',
        'children': [
          { 'name': 'Tie Hua', 'title': 'senior engineer' },
          { 'name': 'Hei Hei', 'title': 'senior engineer',
            'children': [
              { 'name': 'Dan Dan', 'title': 'engineer' }
            ]
          },
          { 'name': 'Pang Pang', 'title': 'senior engineer' }
        ]
      },
      { 'name': 'Hong Miao', 'title': 'department manager' }
    ]
  }">
	<#local groupedData = extendedContents>
	<#if !isGrouped>
		<#local groupedData = {"NOT_GROUPED", extendedContents}>
	</#if>
	
	<#list groupedData as groupName, extendedContents>
		<#if (extendedContents?size > 0)>
			<#list extendedContents as extendedContent>
				<#local hierarchicalExtendedContents = handleExtendedContent(hierarchicalExtendedContents, extendedContent, options)>
			</#list>
		</#if>
	</#list>
	
	<#local hierarchicalExtendedContents = handleNotAddedChild(hierarchicalExtendedContents, options)>
	
	<#local graphData = common.toString(hierarchicalExtendedContents)?replace("\"","'")>
	
  <#return graphData>
</#function>

<#function handleNotAddedChild hierarchicalExtendedContents options maxLoop = 10>
	<#local updatedHierarchicalExtendedContents = hierarchicalExtendedContents>
	<#list 0..maxLoop as _>
		<#if (hierarchicalExtendedContents.notAddedChild)??>
			<#if hierarchicalExtendedContents.notAddedChild?size==0>
				<#if logHelper??>
					${logHelper.stackDebugMessage("Graph.handleNotAddedChild : all Child handled !")}
				</#if>
				<#break>
			</#if>
			<#if logHelper??>
				${logHelper.stackDebugMessage("Graph.handleNotAddedChild : handling child, remaning : " + hierarchicalExtendedContents.notAddedChild?size)}
			</#if>
			<#list hierarchicalExtendedContents.notAddedChild as extendedContent>
				<#local updatedHierarchicalExtendedContents = handleExtendedContent(hierarchicalExtendedContents, extendedContent, options)>
			</#list>
		</#if>
	</#list>
	<#return updatedHierarchicalExtendedContents>
</#function>

<#function toOrgChart extendedContents>
	<#local orgChartData = "">
	<#if (extendedContents)?? && (extendedContents.data)??>
		<#list extendedContents.data as aContent>
			<#local name = aContent.data[1].code>
			<#local title=aContent.data[1].fonction>
			<#local childreen = "[]">
			<#list aContent.related as related>
				
			</#list>
			<#local orgChartData = orgChartData + ", {'name':'"+name+"', 'title':'"+title+"', 'childreen':"+childreen+"}">
		</#list>
	</#if>
</#function>

<#function handleExtendedContent hierarchicalExtendedContents extendedContent options>
	<#local hierarchyCode = sequenceHelper.getValue(options, "hierarchyCode", "__NOT_SPECIFIED__")>>
	<#if (extendedContent.data.related)?? && extendedContent.data.related?has_content && (extendedContent.data.related?size > 0)>
		<#list extendedContent.data.related as related>
			<#if (related.hierarchy)?? && related.hierarchy?is_sequence && (related.hierarchy?size >0)>
				<#list related.hierarchy as aHierarchy>
					<#if aHierarchy.code == hierarchyCode>
						<#local parent = {"type":"__TOP__", "code":"__NONE__"}>
							<#if (aHierarchy.parent)?? && (aHierarchy.parent.type)?? && (aHierarchy.parent.code)??>
								<#local parent = aHierarchy.parent>
							</#if>
						<#if logHelper??>
							${logHelper.stackDebugMessage("Graph.buildHierarchy : for : " + aHierarchy.code + ", adding : " + extendedContent.id + " as a child of : " + common.toString(parent))}
						</#if>
						<#local hierarchicalExtendedContents = handleChildreeen(hierarchicalExtendedContents, extendedContent, related, parent, options)>
					</#if>
				</#list>
			<#else>
				<#if logHelper??>
					${logHelper.stackDebugMessage("Graph.buildHierarchy : (INVALID) " + extendedContent.id + " as no VALID hierarchy attribute : " + common.toString(related.hierarchy))}
				</#if>
			</#if>
		</#list>
	</#if>
	<#return hierarchicalExtendedContents>
</#function>

<#function handleChildreeen(currentList, extendedContent, related, parent, options)>
	<#local returnList = currentList>
	<#local parentId = parent.type+"/"+parent.code>
	<#if (currentList?size > 0)>
		<#local alreadyAddedParentHierarchy = sequenceHelper.getValue(returnList.childToParentCache, parentId)>
		<#if parent.code == "__NONE__"> <#-- ROOT -->
			<#if logHelper??>
				${logHelper.stackDebugMessage("Graph.addChildreeen : " + extendedContent.id + " added as TOP level element")}
			</#if>
			<#local returnList = returnList  + {"data":returnList.data + [extendedContent]}>
			<#local returnList = returnList  + {"childToParentCache":returnList.childToParentCache + [{extendedContent.id:"__TOP__"}]}>
			<#local returnList = handleNotAddedChild(returnList, options)>
		<#elseif alreadyAddedParentHierarchy == ""> <#-- Parent not added-->
			<#if logHelper??>
				${logHelper.stackDebugMessage("Graph.addChildreeen : " + extendedContent.id + " parent not exists (yet ?) : " + common.toString(parent) + ", stored to be handled later")}
			</#if>
			<#local returnList = returnList  + {"childToParentCache":returnList.childToParentCache + [{extendedContent.id:parentId}]}>
			<#local returnList = returnList + {"notAddedChild":returnList.notAddedChild + [{extendedContent.id:extendedContent}]}>
		<#else>
			<#if logHelper??>
				${logHelper.stackDebugMessage("Graph.addChildreeen : " + extendedContent.id + " adding to his parent (ParentHierarchy : " + parentId + " -> " + common.toString(alreadyAddedParentHierarchy)+")")}
			</#if>
			
			<#local parentData = sequenceHelper.getValue(returnList.data, parentId, "", "id", "data")>
			<#if logHelper??>
				${logHelper.stackDebugMessage("Graph.addChildreeen : parent already exists : " + parentId + " adding : " + extendedContent.id + " as a child")}
			</#if>
				
			<#if alreadyAddedParentHierarchy =="__TOP__">
				<#--  add the child -->
				<#local parentData = sequenceHelper.appendToListInHash(parentData, "childreen", extendedContent, true)>
				<#if logHelper??>
					${logHelper.stackDebugMessage("Graph.addChildreeen : parentData " + parentData.childreen?size + " childs after modification : " + common.toString(parentData))}
				</#if>
				<#local returnList = sequenceHelper.upateHash(returnList, "data", parentData, true, true)> -->
				<#-- update childToParentCache, -->
				<#local returnList = returnList  + {"childToParentCache":returnList.childToParentCache + [{extendedContent.id:parent}]}>
				<#-- remove from "notAddedChild" -->
				<#local notAddedChild = sequenceHelper.removeInHash(returnList.notAddedChild, "id", extendedContent.id)>
				<#local returnList = returnList + {"notAddedChild":notAddedChild}>
				<#local returnList = handleNotAddedChild(returnList, options)>
			<#else>
				 <#--   --local returnList = sequenceHelper.upateHash(returnList, "data", extendedContent, true, true, "childreen") -->
				 
				 <#-- update childToParentCache, -->
				<#local returnList = returnList  + {"childToParentCache":returnList.childToParentCache + [{extendedContent.id:parent}]}>
				<#-- remove from "notAddedChild" -->
				<#local notAddedChild = sequenceHelper.removeInHash(returnList.notAddedChild, "id", extendedContent.id)>
				<#local returnList = returnList + {"notAddedChild":notAddedChild}>
			</#if>
		</#if>
	</#if>
	<#if logHelper??>
		${logHelper.stackDebugMessage("Graph.addChildreeen : hierarchical list after adding handling child : childToParentCache?size : " 
			+returnList.childToParentCache?size + ", data?size : " + returnList.data?size + ", notAddedChild?size : " + returnList.notAddedChild?size
			+ " Full data : " + common.toString(returnList))}
	</#if>
	<#return returnList>
</#function>