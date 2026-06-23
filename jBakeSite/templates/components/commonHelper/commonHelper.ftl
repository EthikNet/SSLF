<#function getComponnentInfo>
	<#return {"componnentVersion":1, "name":"commonHelper", "description":"general purpose tools", "recommandedNamespace":"common", "version":"0.1.0", "uses":[{"value":"logHelper", "type":"lib"}]}>
</#function>

<#function init>
	<#return "" />
</#function>

<#-- Build URL, using the root.path if required 
param : relativeUrl : the relative URL to adapt
return : URL prepend with rootPath (if configured)
-->
<#function buildRootPathAwareURL relativeUrl>
	<#assign rootPathAwareURL = relativeUrl>
	
	<#if (content.rootpath)??>
		<#assign rootPathAwareURL = content.rootpath + relativeUrl>
	</#if>
	
	<#return rootPathAwareURL>
</#function>

<#function buildAbsoluteURL relativeUrl>
	<#assign absoluteURL = relativeUrl>
	
	<#if (content.rootpath)??>
		<#assign absoluteURL = "${webleger.build.host}/"+relativeUrl>
	</#if>
	
	<#return absoluteURL>
</#function>

<#-- search for absolute URL in content and preprend the RootPath
param : text : the teh text to search for relative URL
param : rootPath : default ${content.rootpath} : the rootPath of teh webSite
return : text with URL transformed
-->
<#-- 
<#function findAndReplaceUrlAddAwareRootPath text rootPath = content.rootpath>
	<#assign contentRootPathAwareURL = text>
	
	<#if (config.rootPath)??>
		<#assign contentRootPathAwareURL = text?replace("/images/", rootPath + "/images/", "r")>
	</#if>
	
	<#return contentRootPathAwareURL>
</#function>
 -->

<#-- 
<#function functionExists namespace functionName>
	<#local exists = false>
	<#local includeNameSpace = .vars[namespace]>
	<#local namespaceExists = (includeNameSpace)??>
	
	<#local functionExistsInNamespace = false>
	<#if namespaceExists>
		<#local functionExistsInNamespace = ("${namespace}.${functionName}"?interpret)??>
		<#if functionExistsInNamespace>
			<#local exists = true>
		</#if>
	</#if>
	
	<#if logHelper??>
		${logHelper.stackDebugMessage("functionExists : namespace '" +namespace +"' exists : " + namespaceExists?string('yes', 'no') + " ==> '" + functionName + "()' exists ? " + functionExistsInNamespace?string('yes', 'no'))}
	</#if>
	<#return exists>
</#function>


<#function callFunctionIfExists namespace functionName>
	<#if functionExists(namespace, functionName)>
		<#if logHelper??>
			${logHelper.stackDebugMessage("callFunctionIfExists : calling '" +namespace +"." + functionName + "' (==>" + "${namespace}.${functionName}()" +")")}
		</#if>
		<#assign tempAutoLoadVar = "${namespace}.${functionName}"?interpret>
	</#if>
	<#return "">
</#function>
 -->
 
 <#-- determine if a String is an embeded svg or not -->
 <#function isSvg stringData>
	<#local isSvg = false>
	<#if stringData?starts_with("<svg")>
		<#local isSvg = true>
	</#if>
	<#return isSvg>
</#function>

<#macro addImageIcon image cssClass="" alternativeText="" wrapTo="__default__">
	<#if (image)??>
		<#if wrapTo == "__default__">
			<#local wrapToCssClass = cssClass+ "_wraper">
			<#local allClassesSeq = cssClass?split(" ")>
			<#if (allClassesSeq?size>1)>
				<#local wrapToCssClass = allClassesSeq[0] + "_wrapper">
				<#list allClassesSeq[1..allClassesSeq?size-1] as aWrappCssClass>
				<#local wrapToCssClass = wrapToCssClass + " " + aWrappCssClass>
				</#list>
			</#if>
			
			<#local wrapTo="span class=\""+wrapToCssClass+"\"">
		</#if>
	
		<#if common.isSvg(image)>
			<@wrap wrapTo>
				<span <#if cssClass?has_content>class="${cssClass}"</#if><#if alternativeText?has_content> alt="${alternativeText}"</#if>>
					${image}
				</span>
			</@wrap>
		<#else>
			<@wrap wrapTo>
				<img src="${common.buildRootPathAwareURL(image)}"<#if cssClass?has_content> class="${cssClass}"</#if><#if alternativeText?has_content> alt="${alternativeText}"</#if>>
			</@wrap>
		</#if>
	</#if>
</#macro>

<#macro wrap wrapTo="">
	<#if (wrapTo)?? && wrapTo?has_content>
		<#local endTag = wrapTo>
		<#if (endTag?contains(" "))>
			<#local endTag = endTag?keep_before(" ")>
		</#if>
		<${wrapTo}><#nested></${endTag}>
	<#else>
		<#nested>
	</#if>
</#macro>
 
<#-- convert hash, sequence, boolean to String
param : theObject : object to transform in String
-->
<#function toString theObject>
	<#local stringVal = "">
	<#if theObject?is_string>
		<#local stringVal = "\"" + theObject + "\"">
	<#elseif (theObject?is_hash)>
		<#local stringVal = stringVal + "{" />
		<#local separator = "">
		<#list theObject as key, value>
			<#local stringVal = stringVal + separator + toString(key!"NO_KEY") + ":"/>
			<#local stringVal = stringVal + toString(value!"NO_VALUE")/>
			<#local separator = ",">
		</#list>
		<#local stringVal = stringVal + "}" />
	<#elseif (theObject?is_sequence)>
		<#local stringVal = stringVal + "[" />
		<#local separator = "">
		<#list theObject as value>
			<#local stringVal = stringVal + separator + toString(value!"NO_VALUE")/>
			<#local separator = ",">
		</#list>
		<#local stringVal = stringVal + "]" />
	<#elseif (theObject?is_boolean)>
		<#local stringVal = stringVal + theObject?string('true', 'false') />
	<#elseif (theObject?is_number)>
		<#local stringVal = stringVal + theObject  />
	<#elseif (theObject?is_date)>
		<#local stringVal = stringVal + theObject?date  />
	<#else>
		<#local stringVal = stringVal + "\"" + theObject + "\"" />
	</#if>
	<#return stringVal>
</#function>

<#assign oldRdnValues = []>
<#function randomNumber salt = 7>
    <#local str= .now?long />
    <#local str = (str * salt)/3 />
    <#local random = str[(str?string?length-13)..] />
    <#local returnVal = random?replace("\\D+", "1", "r") />
    <#list 0..100 as _>
    	<#if  !oldRdnValues?seq_contains(returnVal)>
    		<#break>
    	</#if>
    	<#if logHelper??>
			${logHelper.stackDebugMessage("common.randomNumber : (" + _?counter + ") " + returnVal + " already used, adding 1")}
		</#if>
    	<#local returnVal += 1>
    </#list>
    <#assign oldRdnValues = oldRdnValues + [returnVal]>
    <#return returnVal/>	
</#function>

<#assign allGeneratedAnchorIdByTitle = []>

<#function generatedAnchorId blockTitle>
	<#if logHelper??>
 		${logHelper.stackDebugMessage("generatedAnchorId : generating and storing an id for : " + blockTitle)}
 	</#if>
	<#local generatedAnchorId = common.randomNumber()>
	<#assign allGeneratedAnchorIdByTitle = allGeneratedAnchorIdByTitle + [{"title":blockTitle, "anchorId":generatedAnchorId}]>
	<#return generatedAnchorId>
</#function>

<#function getGeneratedAnchorId blockTitle>
	<#if logHelper??>
 		${logHelper.stackDebugMessage("getGeneratedAnchorId : searching for the eventually generated ID for : '${blockTitle}' in ${allGeneratedAnchorIdByTitle?size} generatedIds")}
 	</#if>
	<#local anchorId = "">
	<#list allGeneratedAnchorIdByTitle as  generatedAnchorIdByTitle>
		<#if generatedAnchorIdByTitle.title == blockTitle>
			<#local anchorId = generatedAnchorIdByTitle.anchorId>
			<#break>
		</#if>
	</#list>
	<#return anchorId>
</#function>

<#function clearGeneratedAnchorId>
	<#if logHelper??>
 		${logHelper.stackDebugMessage("clearGeneratedAnchorId : Clearing generated AnchorsIds")}
 	</#if>
	<#assign allGeneratedAnchorIdByTitle = []>
	<#return "">
</#function>

<#function getCanonicalUrl>
	<#local canonicalUri="" />
	<#if (content.uri)??>
		<#local canonicalUri="${webleger.build.host}/${content.uri}" />
	</#if>
	<#return canonicalUri>
</#function>

<#function isTodayOrAfter theContent>
	<#local returnVal = false>
	<#if (theContent.date)?? && (.now?date <= theContent.date?date)>
		<#local returnVal = true>
	</#if>
	<#return returnVal>
</#function>

<#function appendIfNoExits theList newVal>
	<#if ! theList?seq_contains(newVal)>
		<#local theList = theList + [newVal]>
	</#if>
	<#return theList>
</#function>


<#macro buildLocation theContent>
	<#if (theContent.location)?? && theContent.location?has_content>
		<div class="elementWithIconSmallWrap">
			<div class="iconWrap">
				<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-muted-foreground" aria-hidden="true">
					<path d="M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0"></path><circle cx="12" cy="10" r="3"></circle>
				</svg>
			</div>
			<div class="location">${theContent.location}</div>
		</div>
	</#if>
</#macro>

<#macro buildPhone theContent>
	<#if (theContent.phone)?? && theContent.phone?has_content>
		<div class="elementWithIconSmallWrap">
			<div class="iconWrap">
				<img src="${buildRootPathAwareURL("images/icones/telephone.svg")}">
			</div>
			<div class="phone">${theContent.phone}</div>
		</div>
	</#if>
</#macro>

<#macro buildHours theContent>
	<#if (theContent.hours)?? && theContent.hours?has_content>
		<#local hoursItems = theContent.hours?split(",")>
		<#list hoursItems as anHour>
			<div class="elementWithIconSmallWrap">
				<div class="iconWrap">
					<img src="${buildRootPathAwareURL("images/icones/horloge.svg")}">
				</div>
				<div class="hours">${anHour}</div>
			</div>
		</#list>
	</#if>
</#macro>

<#macro buildFiles theContent>
	<#if (theContent.files)?? && theContent.files?has_content && (theContent.files.data)?? && theContent.files.data?has_content>
		<#list theContent.files.data as aFile>
			<div class="elementWithIconSmallWrap">
				<a class="btn btn-default" href="${buildRootPathAwareURL(aFile.location)}" target="_blank">
					<#if (aFile.icone)?? && aFile.icone?has_content>
						<#local customCssClass="">
						<#if (aFile.specificClass)?? && aFile.specificClass?has_content>
							<#local customCssClass=aFile.specificClass>
						</#if>
						<span class="iconWrap">
							<@common.addImageIcon aFile.icone customCssClass aFile.label/>
						</span>
					</#if>
					<span class="label">${aFile.label}</span>
				</a>
			</div>
		</#list>
	</#if>
</#macro>

<#macro buildDates theContent>
	<#if (theContent.dates)?? && theContent.dates?has_content>
		<#local datesItems = theContent.dates?split(",")>
		<#list datesItems as dateItem>
			<div class="elementWithIconSmallWrap">
				<div class="iconWrap">
					<img src="${buildRootPathAwareURL("images/icones/horloge.svg")}">
				</div>
				<div class="hours">${dateItem?date("yyyy-MM-dd")?string("'le 'dd MMM yyyy")}</div>
			</div>
		</#list>
	</#if>
</#macro>

<#macro buildDateTimes theContent>
	<#if (theContent.dateTimes)?? && theContent.dateTimes?has_content>
		<#local dateTimesItems = theContent.dateTimes?split(",")>
		<#list dateTimesItems as dateTimeItem>
			<div class="elementWithIconSmallWrap">
				<div class="iconWrap">
					<img src="${buildRootPathAwareURL("images/icones/horloge.svg")}">
				</div>
				<div class="hours">${dateTimeItem?datetime.iso?string("'le 'dd MMM yyyy' à 'HH:mm")}</div>
			</div>
		</#list>
	</#if>
</#macro>