<!---
* Produces a calendar for a given month and year.
* 
* @param curMonth - The month to display. 
* @param curYear - The year to display. * @return - a string. 
*
* original logic by William Steiner (2002)
* improved by Randy H. Drisgill (2006)
* converted to cfml + improvements by Eric Hynds (2008) ---> 
<cffunction name="createCalendar" output="false" returntype="string">
	<cfargument name="curMonth" required="true" type="numeric">
	<cfargument name="curYear" required="true" type="numeric">	<cfset var filename = cgi.script_name>
	<cfset var return = "">
	<cfset var firstDay = createDate(curYear, curMonth, 1)>
	<cfset var firstDayDigit = dayOfWeek(FirstDay)>
	<cfset var thisDay = 1>
	<cfset var x = "">
	
	<!--- build the basic structure --->
	<cfoutput>
	<cfsavecontent variable="return">
		<table border="0" id="calendar">
		<tr>
			<td colspan="7" id="calendar-form-container">
				<form action="#filename#" method="get">
					<select name="thisMonth">
						<cfloop from="1" to="12" index="x">
						<option value="#x#"<cfif arguments.curMonth eq x> selected="selected"</cfif>>#monthasstring(x)#</option>
						</cfloop>
					</select>
					<select name="thisYear">
						<cfloop from="#year(now())#" to="#year(now())-20#" step="-1" index="x">
						<option value="#x#"<cfif arguments.curYear eq x> selected="selected"</cfif>>#x#</option>
						</cfloop>
					</select>
					<input type="submit" name="change" value="Change" />
				</form>
			</td>
		</tr>
		<tr>
			<th><a class="calendar-nav-month" href="#filename#?thisMonth=#month(dateadd("M",-1,firstDay))#&amp;thisYear=#year(dateadd("Y",-1,firstDay))#">&laquo; Previous</a></th>
			<th colspan="5">#DateFormat(firstDay, "mmmm yyyy")#</th>
			<th><a class="calendar-nav-year" href="#filename#?thisMonth=#month(dateadd("M",1,firstDay))#&amp;thisYear=#year(dateadd("M",1,firstDay))#">Next &raquo;</a></th>
		</tr>
		<tr>
			<td class="calendar-subheader">Sunday</td>
			<td class="calendar-subheader">Monday</td>
			<td class="calendar-subheader">Tuesday</td>
			<td class="calendar-subheader">Wednesday</td>
			<td class="calendar-subheader">Thursday</td>
			<td class="calendar-subheader">Friday</td>
			<td class="calendar-subheader">Saturday</td>
		</tr>
	</cfsavecontent>
	</cfoutput>
	
	<cfif firstDayDigit neq 1>
		<cfloop from="1" to="#dayOfWeek(FirstDay)-1#" index="x">
			<cfset return &= '<td>&nbsp;</td>'>
		</cfloop>
	</cfif>
	
	<!--- loop through all the dates in this month --->
	<cfloop from="1" to="#DaysInMonth(firstDay)#" index="thisDay">
	
		<!--- is it Sunday? if so start new row. --->
		<cfif DayOfWeek(CreateDate(curYear, curMonth, thisDay)) eq 1><cfset return &= '<tr>'></cfif>
		
		<!--- insert a day --->
		<cfset return &= '<td class="calendar-day-all "'>
		
		<!--- is it today? append correct classes to above td --->
		<cfif CreateDate(curYear, curMonth, thisDay) eq CreateDate(year(now()),month(now()),day(now()))>
			<cfset return &= 'calendar-day-current">'>
		<cfelse>
			<cfset return &= 'calendar-day-notcurrent">'>
		</cfif>
		<cfset return &= '<div class="day-digit">#thisDay#</div>'>
		
		<!--- begin insert data for this day --->
		<cfset return &= "calendar data here">
		<!--- end insert data for this day --->
		
		<!--- close out this day --->
		<cfset return &= '</td>'>
		
		<!--- is it the last day of the month?  if so, fill row with blanks. --->
		<cfif thisDay eq DaysInMonth(firstDay)>
			<cfloop from="1" to="#(7-DayOfWeek(CreateDate(curYear, curMonth, thisDay)))#" index="x">
				<cfset return &= '<td>&nbsp;</td>'>
			</cfloop>
		</cfif>

		<cfif DayOfWeek(CreateDate(curYear, curMonth, thisDay)) eq 7>
			<cfset return &= '</tr>'>
		</cfif>
	</cfloop>
	
	<cfset return &= '</table>'>
	<cfreturn return />
</cffunction>
