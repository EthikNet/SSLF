<#function getComponnentInfo>
	<#return {"componnentVersion":2, "name":"calendar", "description":"Display calendar", "version":"0.0.1", "recommandedNamespace":"calendar", "require":[{"value":"commonHelper", "type":"lib"}], "uses":[{"value":"logHelper", "type":"lib"}]}>
</#function>

<#function init>
	<#return "" />
</#function>

<#function registerDefaultHooks()>
	<#local registerComponnentHooks = true>
	<#if registerComponnentHooks>
		${hookHelper.registerHook("afterBody", "calendar.build", false)}
		${hookHelper.registerHook("afterBlockBody", "calendar.build", false)}
	</#if>
</#function>

<#function addHeaderScripts()>
	<#return "" />
</#function>

<#function addFooterScripts()>
	<#return "" />
</#function>

<#macro build theContent>
	<#if (theContent)??>
		<#if (theContent.calendar)??>
			<#if (theContent.calendar.calendarId)??>
				<#local width = "${webleger.component.calendar.container.width.mobile}">
				<#local height = "${webleger.component.calendar.container.height.mobile}">
				<#local provider = "Google">
				<#local variant = "OnlyOneCalendar">
				<#local timeZone = "Europe%2FParis">
				<#local mode="">
				<#if (theContent.calendar.width)??>
					<#local width = theContent.calendar.width>
				</#if>
				<#if (theContent.calendar.height)??>
					<#local height = theContent.calendar.height>
				</#if>
				<#if (theContent.calendar.provider)??>
					<#local provider = theContent.calendar.provider>
				</#if>
				<#if (theContent.calendar.variant)??>
					<#local variant = theContent.calendar.variant>
				</#if>
				<#if (theContent.calendar.timeZone)??>
					<#local timeZone = theContent.calendar.timeZone>
				</#if>
				<#if (theContent.calendar.mode)??>
					<#local mode = theContent.calendar.mode>
				</#if>
				
				<@displayCalendar theContent.calendar.calendarId width height provider variant timeZone mode/>
			<#else>
				<#if logHelper??>
					<@logHelper.debug "calendar.display : ERROR : Missing required calendar.calendarId"/>
				</#if>
			</#if>
		<#else>
			<#if logHelper??>
				<@logHelper.debug "No Calendar Data for this content, content headers : " + common.toString(theContent)/>
			</#if>
		</#if>
	</#if>
</#macro>

<#-- 
Display the calendar
@param calendarId : Id of the caledar from he provider.
@param width : width of the widget (default : 800)
@param height : height of the widget (default : 600)
@param provider : provider of the calendar (default "Google")
@param variant : a display varaite (provider speicific" (default "OnlyOneCalendar")
@param timeZone : calendar time Zone (default "Europe%2FParis")
@param mode : calendar Display mode (default "")
  -->
<#macro displayCalendar calendarId width="800" height="600" provider="Google" variant="OnlyOneCalendar" timeZone="Europe%2FParis" mode="">
	<#if provider == "Google">
		<#if variant = "OnlyOneCalendar">
			<iframe src="https://calendar.google.com/calendar/embed?src=${calendarId}&ctz=${timeZone}<#if mode?has_content>&mode=${mode}</#if>" 
			class="calendarFrame"
			style="border: 0" width="${width}" height="${height}" frameborder="0" scrolling="no"></iframe>
		<#elseif variant = "Custom">
			<iframe src="https://calendar.google.com/calendar/embed?${calendarId}" style="border:solid 1px #777" 
				class="calendarFrame"
				width="${width}" height="${height}" frameborder="0" scrolling="no"></iframe>
		<#else>
			<#if logHelper??>
				${logHelper.stackDebugMessage("calendar.display : ERROR : Unknow variant : " + variant)}
			</#if>
		</#if>
	<#else>
		<#if logHelper??>
			${logHelper.stackDebugMessage("calendar.display : ERROR : Unknow provider : " + provider)}
		</#if>
	</#if>
</#macro>
