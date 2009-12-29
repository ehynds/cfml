<!---

This is a simple site-wide message handling system designed to emulate Rail's flash.  Messages types are error, success, and notice.
Written by Eric Hynds 5/19/08.

Usage:

	1. Make sure the correct CSS classes (below) are added to your stylesheet.
	
	2. Create this object in your Application.cfc|cfm file.
		
		<cfset notify = createObject('component', 'notify')>
	 
	2. On your site template or wherever you want the notice to consistently appear, compile and display it:
	
		<cfset message = notify.compile()>
		<cfif len(trim(message)) gt 0><cfoutput>#message#</cfoutput></cfif>
	
	3. Call the notify.set(type,title,message) method then redirect the user to a new page.  The message is saved
	   into the session.notify namespace, is compiled/displayed, and then cleared from the session.
	   
	4. Alternatively, you can create a message on the fly by passing compile() a struct with the type, title, and message keys:
	   
		<cfset error = {
			type = 'error',
			title = 'The following errors occured:',
			message = 'Invalid e-mail address'
		}>
		<cfset message = notify.compile(error)>
	
	   The variable 'error' now contains all the HTML for you to display it wherever makes sense.
	   
	 5. Finally, the 'message' argument can take an array, and if one is passed in each element will appear in a unordered list:

		<cfset error = {
			type = 'error',
			title = 'The following errors occured',
			message = [
				'Invalid e-mail address',
				'Please enter your first name'
			]
		}>
		<cfset message = notify.compile(error)>
		

	/* message styles */
	.message { padding:10px; margin:15px 0; display:block; text-align:left }
	.message-title { font-weight:bold; font-size:1.25em }
	.message-body { margin-top:4px }
	.error, .notice, .success { padding:.8em; margin-bottom:1em; border:2px solid #ddd }
	.error { background:#FBE3E4; color:#8a1f11; border-color:#FBC2C4 }
	.notice { background:#FFF6BF; color:#514721; border-color:#FFD324 }
	.success { background:#E6EFC2; color:#264409; border-color:#C6D880 }
	.error a { color:#8a1f11 }
	.notice a { color:#514721 }
	.success a { color:#264409 }
--->

<cfcomponent name="notify" output="false">

	<cffunction name="set" output="false">
		<cfargument name="type" type="string" required="true" hint="error, success, or notice">
		<cfargument name="title" type="string" required="false" default="">
		<cfargument name="message" type="any" required="false" default="">
	
		<cflock scope="session" type="exclusive" timeout="15">
			<cfset session.notify = {
				type = arguments.type,
				title = arguments.title,
				message = arguments.message
			}>
		</cflock>
	</cffunction>

	<cffunction name="get" output="false" returntype="struct">
		<cfset var return = {}>
		
		<cflock scope="session" type="exclusive" timeout="15">
			<cfif structkeyexists(session, "notify") and structcount(session.notify) gte 2>
				<cfset return = {
					type = session.notify.type,
					title = session.notify.title,
					message = session.notify.message
				}>
				
				<cfset structclear(session.notify)>
			</cfif>
		</cflock>
	
		<cfreturn return />
	</cffunction>

	<cffunction name="compile" output="false" returntype="string">
		<cfargument name="overrides" type="struct" required="false">
		<cfset var return = "">
		<cfset var i = "">
		<cfset var message = "">
	
		<!--- get message from session if one wasn't passed in --->
		<cfif not isDefined("arguments.overrides")>
			<cfset message = get()>
		<cfelse>
			<cfset message = arguments.overrides>
		</cfif>
		
	
		<cfif structcount(message) gte 2>
			<cfoutput>
				<cfset return &= '<div class="message #message.type#">'>
				<cfif len(trim(message.title)) gt 0><cfset return &= '<div class="message-title">#message.title#</div>'></cfif>
				<cfif isarray(message.message) or len(trim(message.message)) gt 0>
					<cfset return &= '<div class="message-body">'>
					<cfif isarray(message.message)>
						<cfset return &= '<ul>'>
						<cfloop from="1" to="#arraylen(message.message)#" index="i">
							<cfset return &= '<li>#message.message[i]#</li>'>
						</cfloop>
						<cfset return &= '</ul>'>
					<cfelse>
						<cfset return &= message.message>
					</cfif>
					<cfset return &= '</div>'>
				</cfif>
				<cfset return &= '</div>'>
			</cfoutput>
		</cfif>
	
		<cfreturn return />
	</cffunction>
</cfcomponent>
