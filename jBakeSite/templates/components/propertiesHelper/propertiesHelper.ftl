<#import "../../components/commonHelper/commonHelper.ftl" as common>
<#import "../../components/logHelper/logHelper.ftl" as logHelper>
<#function getComponnentInfo>
	<#return {"componnentVersion":1, "name":"propertiesHelper", "description":"Help retrieve and interpret config file data", "recommandedNamespace":"propertiesHelper", "version":"0.1.0", "require":[{"value":"common", "type":"lib"}], "uses":[{"value":"site.langs", "type":"config"}, {"value":"logHelper", "type":"lib"}]}>
</#function>

<#function init>
	<#return "" />
</#function>

<#function secureStringJsonData theJsonText>
	<#local prop = theJsonText>
	<#if theJsonText?is_sequence>
		<#local prop = theJsonText?join(", ")>
	</#if>
	<#return prop>
</#function>

<#--Read and display text from config file. Handle corectly when coma "," in text.
param : theProperty : the text to display (may be a "sequence")
param : usePropAsTextIfNotFound : if true the "theProperty" param will be return, else a warning message
return : a text (with original coma ",")
-->
<#function retrieveAndDisplayConfigText theProperty usePropAsTextIfNotFound=false comaReplacement=", ">
	<#local prop = secureStringJsonData(theProperty)>
	<#local prop = prop?replace(".", "_")>
	
	<#if (config["site_langs"])??>
		<#if (content.lang)?? && (config[content.lang + "_" + prop])??>
			<#local prop = content.lang + "_" + prop>
		</#if>
	</#if>
	
	<#if config[prop]??>
		<#local text = displayConfigText(config[prop], comaReplacement)>
	<#else>
		<#if usePropAsTextIfNotFound>
			<#local text = theProperty>
		<#else>
			<#local text = "no '" + prop + "' in config file">
		</#if>
	</#if>
	<#return text>
</#function>

<#-- display text from config file. Handle corectly when coma "," in text
param : theText : the text to display (may be a "sequence")
param : comaReplacement : separator to use for sequences
return : a text (with original coma "," replaced with comaReplacement param)
-->
<#function displayConfigText theText comaReplacement=", ">
	<#return sequenceToString(theText, comaReplacement)>
</#function>

<#function sequenceToString sequence comaReplacement=", ">
	<#local text = "">
	<#if (sequence)??>
		<#if sequence?is_sequence>
			<#local text = sequence?join(comaReplacement)>
		<#else>
			<#local text = sequence>
		</#if>
	</#if>
	<#return text>
</#function>

<#-- Check if a config value exists.
param : theKey : the config key ethier with . separator.
-->
<#function hasConfigValue theKey>
	<#local hasValue = false>
	<#if (theKey)??>
		<#local foundValue = "">
		<#local theConfigKey = sequenceToString(theKey?replace(".", "_"))>
		<#local pomNotReplacedVar = "$\{webleger."+theKey+"}">
		<#if (config[theConfigKey])??>
			<#local foundValue = config[theConfigKey]>
		</#if>
		<#if (foundValue)?? && (sequenceToString(foundValue) != pomNotReplacedVar)>
			<#local hasValue = true>
		</#if>
	</#if>
	<#return hasValue>
</#function>


<#-- Parse a config property has JSON
param : propValue : Config property containing the JSON
-->
<#function parseJsonProperty propValue>
	<#local jsonContent = {"error":"invalidValue", "parsedVal":"no value"}>
	
	<#if (propValue)??>
		<#assign fullContent = propValue>
		<#if propValue?is_sequence>
			<#assign fullContent = "">
			<#assign separator = "">
			<#list propValue as fakeItem>
				<#assign fullContent = fullContent + separator + fakeItem>
				<#assign separator = ",">
			</#list>
		</#if>
		
		<#local jsonContent = {"error":"invalidValue", "parsedVal":fullContent}>
		<#attempt>
			<#local jsonContent = fullContent?eval_json>
		<#recover>
			${logHelper.stackDebugMessage("propertiesHelper.parseJsonProperty : ERROR while trying to parse JSON value : " + common.toString(fullContent) + " with error : " + .error)}
		</#attempt>
	</#if>
	<#return jsonContent>
</#function>

<#function displayParseJsonError jsonContent>
	<#local message = "Parsing is valid">
	
	<#if (jsonContent)?? && (jsonContent.error)??>
		<#local message = "JSON error : " + jsonContent.error>
		<#if (jsonContent.parsedVal)??>
			<#local message = message + "value : " + jsonContent.parsedVal>
		</#if>
	</#if>
	<#return toString(jsonContent)>
</#function>


<#-- Find the **displayName** of a custom document type
param : postType : the name of the document type
return : a text, the configured display name (in jbake.properties) or the original post type name
-->
<#function getDisplayName postType>
	<#assign postTypeDisplayName = postType>
	<#assign postTypeDisplayNameProp = "ecoweb_type_" + postType + "_displayName">
	
	<#if (config[postTypeDisplayNameProp])??>
		<#assign postTypeDisplayName = config[postTypeDisplayNameProp]>
	</#if>
	
	<#return postTypeDisplayName>
</#function>
