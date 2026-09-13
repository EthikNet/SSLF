<#function getComponnentInfo>
	<#return {"componnentVersion":1, "name":"sequenceHelper", "description":"Helper for sequences", "recommandedNamespace":"sequenceHelper", "version":"0.1.0"}>
</#function>

<#function init>
	<#return "" />
</#function>

<#-- Search if an element on a list, belong to another list 
param : aSequence : the sequence to search for matches
param : lookupItems : item or items to search for
param : **default** : , : autoSplitChar : String containing this Char will be converted to Sequence with autoSplitChar as separator
return : true in a least one lookupItems is found in aSequence
-->
<#function seq_containsOne aSequence lookupItems = "" autoSplitChar = ",">
	<#assign found=false>
	
	<#assign transformedASequence=aSequence>
	<#assign transformedLookupItems=lookupItems>
	
	<#if autoSplitChar?? && autoSplitChar != "">
		<#if (aSequence?is_string && aSequence?contains(autoSplitChar))>
			<#assign transformedASequence = splitStringToSequence(aSequence)>
		</#if>
		
		<#if (lookupItems?is_string && lookupItems?contains(autoSplitChar))>
			<#assign transformedLookupItems=splitStringToSequence(lookupItems)>
		</#if>
	
	</#if>
	
	<#if (transformedLookupItems?is_sequence)>
		<#if (transformedASequence?is_sequence)>
			<#list transformedLookupItems as item>
				<#if (!found)>
					<#assign found = transformedASequence?seq_contains(item)>
				</#if>
			</#list>
		<#else> <#-- transformedASequence is not a Sequence, but transformedLookupItems IS -->
			<#assign found = transformedLookupItems?seq_contains(transformedASequence)>
		</#if>
	<#else> <#-- transformedLookupItems is not a Sequence -->
		<#if (transformedASequence?is_sequence)>
			<#assign found = transformedASequence?seq_contains(transformedLookupItems)>
		<#else> <#-- both params are NOT lists -->
			<#assign found = transformedLookupItems == transformedASequence>
		</#if>>
	</#if>
	
	<#if logHelper??>
		<#if found>
			${logHelper.stackDebugMessage("seq_containsOne (data) " + common.toString(aSequence) + "  contains at least one (filter) : " + common.toString(lookupItems))}
		<#else>
			${logHelper.stackDebugMessage("seq_containsOne (data) " + common.toString(aSequence) + " NOT contains any (filter) : " + common.toString(lookupItems))}
		</#if>
	</#if>
	
	<#return found>
</#function>

<#-- convert a String to a Sequence
param : value : the String to convert
param : **default** : , : autoSplitChar : String containing this Char will be converted to Sequence with autoSplitChar as separator
return : A sequence with all elements after splitting
-->
<#function splitStringToSequence stringValue autoSplitChar = ",">
	<#if (stringValue?is_string && stringValue?contains(autoSplitChar))>
		<#assign sequence=stringValue?split(r"\s*,\s*", "r")>
	<#else>
		<#assign sequence=[stringValue]>
	</#if>
	
	<#return sequence>
</#function>

<#-- Search a value in sequence containing object with key:value
param : list : the list to search
param : serarchKey : the key to search
param : **default** : "" : default : the default value to return if not found
return : the value assoicaited with the key or the default value
-->
<#function getValue list serarchKey default="" attributKey="" attributToReturn="">
	<#local returnValue = default>
	<#if (list)?? && list?has_content>
		<#list list as element>
			<#if element?is_hash>
				<#if attributKey="" && attributToReturn="">
					<#-- The list contains only key/paire data -->
					<#list element as optionKey, optionValue>
						<#if optionKey == serarchKey>
							<#local returnValue = optionValue>
							<#if logHelper??>
								${logHelper.stackDebugMessage("Graph.getValue : " + optionKey + " FOUND wil return : " + common.toString(returnValue))}
							</#if>
							<#break>
						</#if>
						<#if logHelper??>
							${logHelper.stackDebugMessage("Graph.getValue : " + optionKey + " NOT eq " + serarchKey)}
						</#if>
					</#list>
				<#else>
					<#-- The list contain complexe structure  -->
					<#if (element[attributKey])??>
						 <#if element[attributKey] == serarchKey>
							<#if logHelper??>
								${logHelper.stackDebugMessage("Graph.getValue : " + serarchKey + " FOUND from : " + attributKey)}
							</#if>
							<#if (element[attributToReturn])??>
								<#local returnValue = element[attributToReturn]>
								<#if logHelper??>
									${logHelper.stackDebugMessage("Graph.getValue : " + attributToReturn + " wil return : " + common.toString(returnValue))}
								</#if>
							</#if>
						<#else>
							<#if logHelper??>
								${logHelper.stackDebugMessage("Graph.getValue : '" + attributKey + "'==>" + element[attributKey] + " NOT eq " + serarchKey)}
							</#if>
						</#if>
					<#else>
						<#if logHelper??>
							${logHelper.stackDebugMessage("Graph.getValue : NO '" + attributKey + "' to compare value with : " + serarchKey + " in : " + common.toString(element))}
						</#if>
					</#if>
				</#if>
			</#if>
		</#list>
	</#if>
	<#return returnValue>
</#function>

<#function appendToListInHash hash property newVal createIfNotExist=true>
	<#return upateHash(hash, property, newVal, createIfNotExist, true)>
</#function>

<#function upateHash hash property newVal createIfNotExist=true isInList=true recursiveProperty="__NONE__">
	<#local returnHash = hash>
	<#if createIfNotExist || (returnHash[property])??>
		<#if logHelper??>
			${logHelper.stackDebugMessage("Graph.upateHash : creating NEW element : " +  property + ", on hash")}
		</#if>
		<#if isInList>
			<#local currentPropValue = returnHash[property]>
			<#local appendedProperty =  currentPropValue + [newVal]>
			<#local returnHash = returnHash + {property:appendedProperty}>
		<#else>
			<#local returnHash = returnHash + {property:newVal}>
		</#if>
	</#if>
	<#if recursiveProperty != "__NONE__">
		<#if (returnHash[recursiveProperty])??>
			<#if returnHash[recursiveProperty]?is_sequence>
				<#local childsAfterUpdate = []>
				<#list returnHash[recursiveProperty] as aChild>
					<#--  FILTER if *anAttribute*=== *aVallue* then update *AnOtherAttribute* -->
					<#local childsAfterUpdate = childsAfterUpdate + [upateHash(aChild, "data", extendedContent, true, true, "childreen")]>
				</#list>
				<#local returnHash = returnHash + {recursiveProperty:childsAfterUpdate}>
			</#if>
		</#if>
	</#if>
	<#return returnHash>
</#function>

<#function removeInHash hash property inList=false searchKey="">
	<#local returnHash = {}>
	<#if inList>
		<#list hash as element>
			<#if (element[property])?? && element[property] == searchKey>
				<#-- ignore -->
			<#else>
				<#local returnHash = [element]>
			</#if>
		</#list>
	<#else>
		<#list hash as key, value>
			<#if key != property>
				<#local returnHash = returnHash + {key:value}>
			</#if>
		</#list>
	</#if>
	
	<#return returnHash>
</#function>
