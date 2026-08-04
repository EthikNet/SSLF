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
		
		<#local imageData = getImageData(image)>
		<@wrap wrapTo>
			<#if common.isSvg(image)>
				<span <#if cssClass?has_content>class="${cssClass}"</#if><#if alternativeText?has_content> alt="${alternativeText}"</#if>>${imageData}</span>
			<#else>
				<img src="${imageData}"<#if cssClass?has_content> class="${cssClass}"</#if><#if alternativeText?has_content> alt="${alternativeText}"</#if>>
			</#if>
		</@wrap>
	</#if>
</#macro>
<#function getImageData(image="")>
	<#local imageData = image>
	<#if image?has_content>
		<#if !common.isSvg(image)>
			<#local imageData = common.buildRootPathAwareURL(image) >
		</#if>
	</#if>
	<#return imageData>
</#function>

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
		<#local phoneItems = theContent.phone?split(",")>
		<#list phoneItems as phoneItem>
			<#local phoneDatas = phoneItem?split("|")>
				<#local phoneLabel = phoneDatas[0]?trim>
				<#local phoneNumber = phoneDatas[0]?trim>
				<#if logHelper??>
			 		${logHelper.stackDebugMessage("common.buildPhone : phoneDatas : " + toString(phoneDatas))}
			 	</#if>
				<#if phoneDatas?size == 2>
					<#local phoneNumber = phoneDatas[1]?trim>
				</#if>
			<div class="elementWithIconSmallWrap">
				<div class="iconWrap">
					<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-muted-foreground" aria-hidden="true"><path d="M13.832 16.568a1 1 0 0 0 1.213-.303l.355-.465A2 2 0 0 1 17 15h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2A18 18 0 0 1 2 4a2 2 0 0 1 2-2h3a2 2 0 0 1 2 2v3a2 2 0 0 1-.8 1.6l-.468.351a1 1 0 0 0-.292 1.233 14 14 0 0 0 6.392 6.384"></path></svg>
				</div>
				<div class="phone"><a href="tel:${phoneNumber}"><#if phoneDatas?size == 2>${phoneLabel} (</#if>${phoneNumber}<#if phoneDatas?size == 2>)</#if></a></div>
			</div>
		</#list>
	</#if>
</#macro>

<#macro buildHours theContent>
	<#if (theContent.hours)?? && theContent.hours?has_content>
		<#local hoursItems = theContent.hours?split(",")>
		<#list hoursItems as anHour>
			<div class="elementWithIconSmallWrap">
				<div class="iconWrap">
					<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><path d="M12 6v6l4 2"></path></svg>
				</div>
				<div class="hours">${anHour}</div>
			</div>
		</#list>
	</#if>
</#macro>

<#macro buildWebsites theContent>
	<#if (theContent.websites)?? && theContent.websites?has_content>
		<#local websitesItems = theContent.websites?split(",")>
		<#list websitesItems as aWebsite>
			<#if logHelper??>
		 		${logHelper.stackDebugMessage("common.buildWebsites : Building a WebSite URL with data : " + aWebsite)}
		 	</#if>
			<div class="elementWithIconSmallWrap">
				<div class="iconWrap">
					<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><path d="M12 2a14.5 14.5 0 0 0 0 20 14.5 14.5 0 0 0 0-20"></path><path d="M2 12h20"></path></svg>
				</div>
				<#local webSiteDatas = aWebsite?split("|")>
				<#local websiteText = webSiteDatas[0]?trim>
				<#local websiteUrl = webSiteDatas[0]?trim>
				<#if logHelper??>
			 		${logHelper.stackDebugMessage("common.buildWebsites : webSiteDatas : " + toString(webSiteDatas))}
			 	</#if>
				<#if webSiteDatas?size == 2>
					<#local websiteUrl = webSiteDatas[1]?trim>
				</#if>
				<div class="website"><a href="${websiteUrl}">site web</a></div>
			</div>
		</#list>
	</#if>
</#macro>

<#macro buildFiles theContent beforeList="">
	<#if (theContent.files)?? && theContent.files?has_content && (theContent.files.data)?? && theContent.files.data?has_content>
		<#if beforeList?? && beforeList?has_content>${beforeList}</#if>
		<#list theContent.files.data as aFile>
			<#local specificClass="">
			<#if (aFile.specificClass)?? && (aFile.specificClass?has_content)>
				<#local specificClass=aFile.specificClass>
			</#if>
			<#local btnSpecificClass="btn-default dowloadLink">
			<#if (aFile.main)?? && (aFile.main?has_content) && (aFile.main == true)>
				<#local btnSpecificClass="btn-primary dowloadLink">
			</#if>
			<div class="elementWithIconSmallWrap<#if specificClass?has_content> ${specificClass}</#if>">
				<a class="btn ${btnSpecificClass}" href="${buildRootPathAwareURL(aFile.location)}" target="_blank">
					<#if (aFile.icon)?? && aFile.icon?has_content>
						<#local customCssClass="dowloadLink">
						<#if (aFile.iconSpecificClass)?? && aFile.iconSpecificClass?has_content>
							<#local customCssClass=customCssClass + " " + aFile.iconSpecificClass>
						</#if>
						<span class="iconWrap">
							<@common.addImageIcon aFile.icon customCssClass aFile.label/>
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
			<@createDateElement dateItem?date("yyyy-MM-dd")?string("'le 'dd MMM yyyy") />
		</#list>
	</#if>
</#macro>

<#macro buildDateTimes theContent>
	<#if (theContent.dateTimes)?? && theContent.dateTimes?has_content>
		<#local dateTimesItems = theContent.dateTimes?split(",")>
		<#list dateTimesItems as dateTimeItem>
			<@createDateElement dateTimeItem?datetime.iso?string("'le 'dd MMM yyyy' à 'HH:mm") />
		</#list>
	</#if>
</#macro>

<#macro buildFreeDate theContent>
	<#if (theContent.freeDate)?? && theContent.freeDate?has_content>
		<#local freeDateItems = theContent.freeDate?split(",")>
		<#list freeDateItems as freeDateItem>
			<@createDateElement freeDateItem />
		</#list>
	</#if>
</#macro>

<#macro createDateElement formatedDate>
	<div class="elementWithIconSmallWrap">
		<div class="iconWrap">
			<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><path d="M12 6v6l4 2"></path></svg>
		</div>
		<div class="hours">${formatedDate}</div>
	</div>
</#macro>

<#macro buildEmail theContent>
	<#if (theContent.email)?? && theContent.email?has_content>
		<#local emailItems = theContent.email?split(",")>
		<#list emailItems as emailItem>
			<div class="elementWithIconSmallWrap">
				<div class="iconWrap"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="m22 7-8.991 5.727a2 2 0 0 1-2.009 0L2 7"></path><rect x="2" y="4" width="20" height="16" rx="2"></rect></svg></div>
				<div class="email"><a href="mailto:${emailItem}">${emailItem}</a></div>
			</div>
		</#list>
	</#if>
</#macro>

<#macro buildFaceBook theContent>
	<#if (theContent.facebook)?? && theContent.facebook?has_content>
		<#local facebookItems = theContent.facebook?split(",")>
		<#list facebookItems as facebookItem>
			<div class="elementWithIconSmallWrap">
				<div class="iconWrap"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M18 2h-3a5 5 0 0 0-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 0 1 1-1h3z"></path></svg></div>
				<div class="facebook"><a href="${facebookItem}">Facebook</a></div>
			</div>
		</#list>
	</#if>
</#macro>

<#macro buildInstagram theContent>
	<#if (theContent.instagram)?? && theContent.instagram?has_content>
		<#local instagramItems = theContent.instagram?split(",")>
		<#list instagramItems as instagramItem>
			<div class="elementWithIconSmallWrap">
				<div class="iconWrap"><img src="${buildRootPathAwareURL("images/common/instagram.png")}"/></div>
				<div class="facebook"><a href="${instagramItem}">Instagram</a></div>
			</div>
		</#list>
	</#if>
</#macro>

<#macro buildResponsable theContent>
	<#if (theContent.responsable)?? && theContent.responsable?has_content>
		<#local responsableItems = theContent.responsable?split(",")>
		<#list responsableItems as responsableItem>
			<div class="elementWithIconSmallWrap">
				<div class="iconWrap"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg></div>
				<div class="responsable">${responsableItem}</div>
			</div>
		</#list>
	</#if>
</#macro>
