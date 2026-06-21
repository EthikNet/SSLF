<#function getComponnentInfo>
	<#return {"componnentVersion":1, "name":"action", "description":"Add button in content", "recommandedNamespace":"action", "version":"0.1.0", "require":[{"value":"sequenceHelper", "type":"lib"}, {"value":"hookHelper", "type":"lib"}, {"value":"common", "type":"lib"}, {"value":"subTemplate", "type":"action"}], "uses":[{"value":"langHelper", "type":"lib"}, {"value":"logHelper", "type":"lib"}]}>
</#function>

<#function init>
	<#return "" />
</#function>


<#macro build content>
	<#if (content.action)??>
		<#if logHelper??>
			<@logHelper.debug "Action : bulding actions for : " + content.uri/>
		</#if>
		<#if (content.action.data)??>
			<#if logHelper??>
				<@logHelper.debug "Action : NbActions :  " + content.action.data?size/>
			</#if>
			<#local actionListDisposition = content.action.disposition!"center">
			<#local actionListSpecificClass = "actions_list">
			<#switch actionListDisposition>
				<#case "center">
					<#local actionListSpecificClass = actionListSpecificClass + " action_centered">
					<#break>
				<#case "left">
					<#local actionListSpecificClass = actionListSpecificClass + " action_left">
					<#break>
				<#case "right">
					<#local actionListSpecificClass = actionListSpecificClass + " action_right">
					<#break>
				<#break>
			</#switch>
			<#if (content.action.specificClass)??>
				<#local actionListSpecificClass = actionListSpecificClass + " " + content.action.specificClass>
			</#if>
			<div class="${actionListSpecificClass}">
			<#list content.action.data as anAction>
				<#if logHelper??>
					<@logHelper.debug "Action : buliding action : " + common.toString(anAction)/>
				</#if>
				<#local actionType = anAction.type!"button">
				<#local target = "#">
				<#local specificClass = "">
				
				<#if (anAction.specificClass)??>
					<#local specificClass = specificClass + anAction.specificClass>
				</#if>
				
				<#local customAttributs = "">
				<#switch anAction.operation.type>
					<#case "anchor">
						<#local target = "#"+anAction.operation.to>
					<#break>
					<#case "link">
						<#local target = anAction.operation.to>
					<#break>
					<#case "mailto">
						<#local target = "mailto:"+anAction.operation.to>
						<#if obfuscator?? && (anAction.operation.obfuscationMask)??>
							<#local customAttributs = "data-obfuscatedkey=\"" + anAction.operation.obfuscationMask + "\"">
						</#if>
					<#break>
				</#switch>
				<#switch actionType>
					<#case "button">
						<#local specificClass = "btn " + specificClass>
					<#break>
				</#switch>
				<a href="${target}" ${customAttributs} class="action_${actionType} ${specificClass}">${anAction.label}</a>
			</#list>
			</div>
		<#else>
			<span>Action present dans l'entête de contenu, mais pas de "data" détecté</span>
		</#if>
	</#if>
</#macro>
