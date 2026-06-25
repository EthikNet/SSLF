<#function getComponnentInfo>
	<#return {"componnentVersion":2, "name":"panneauPocket", "description":"Allow to embed Panneau Pocket", "version":"0.1.0", "recommandedNamespace":"panneauPocket", "require":[{"value":"stripe", "type":"contentHeader"}, {"value":"webleger.component.stripe.apiKey", "type":"config"}], "uses":[{"value":"langHelper", "type":"lib"}, {"value":"logHelper", "type":"lib"}]}>
</#function>

<#function init>
	<#return "" />
</#function>

<#function registerDefaultHooks()>
	<#return "" />
</#function>

<#function addHeaderScripts()>
	<#return "" />
</#function>

<#function addFooterScripts()>
	<#return "" />
</#function>

<#macro build theContent>
	<#if (theContent.panneauPocket)?? && (theContent.panneauPocket.townId)??>
		<#local townId = theContent.panneauPocket.townId>
		<#local townName = theContent.panneauPocket.townName!"">
		<#local loadingMode = theContent.panneauPocket.loadingMode!"Lazy">
		<#local referrerPolicy = theContent.panneauPocket.referrerPolicy!"no-referrer-when-downgrade">
		<#local height = theContent.panneauPocket.height!"748px">
		<#local width = theContent.panneauPocket.width!"100%">
		<#local specificClass = theContent.panneauPocket.specificClass!"">
		
		<#local frameTitle = "PanneauPocket">
		<#if townName?has_content>
			<#local frameTitle = frameTitle + " — " + townName>
		</#if>
		<#local frameStyle = "border:0;display:block;overflow: hidden">
		<#if height?has_content>
			<#local frameStyle = frameStyle + ";height:" + height>
		</#if>
		<#if width?has_content>
			<#local frameStyle = frameStyle + ";width:" + width>
		</#if>
		<#local frameClass = "panneauPocketFrame">
		<#if specificClass?has_content>
			<#local frameClass = frameStyle + " " + specificClass>
		</#if>
		
		<iframe title="${frameTitle}" scrolling="no" src="https://app.panneaupocket.com/ville/${townId}" 
		style="${frameStyle}" loading="${loadingMode}" referrerpolicy="${referrerPolicy}"></iframe>
	<#else>
		<#if logHelper??>
			<#local panneauPocketInfo = "NO panneauPocket content Header">
			<#if (theContent.panneauPocket)??>
				<#local panneauPocketInfo = common.toString(theContent.panneauPocket)>
			</#if>
			${logHelper.stackDebugMessage("panneauPocket.build : ERROR : content does NOT contain panneauPocket ID : " + panneauPocketInfo + ", for content URI : " + theContent.uri!"NO_URI")}
		</#if>
	</#if>
</#macro>
