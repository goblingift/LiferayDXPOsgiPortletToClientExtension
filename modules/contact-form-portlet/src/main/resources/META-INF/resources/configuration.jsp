<%@ include file="/init.jsp" %>

<%@ page import="com.liferay.portal.kernel.util.Constants" %>

<%
String successMessage = portletPreferences.getValue(
	"successMessage",
	LanguageUtil.get(request, "success-message-default"));
%>

<liferay-portlet:actionURL portletConfiguration="<%= true %>" var="configurationActionURL" />
<liferay-portlet:renderURL portletConfiguration="<%= true %>" var="configurationRenderURL" />

<%-- The form and Save button must live here — Liferay 7.4 does NOT inject them automatically. --%>
<aui:form action="<%= configurationActionURL %>" method="post" name="fm">

	<aui:input name="<%= Constants.CMD %>" type="hidden" value="<%= Constants.UPDATE %>" />
	<aui:input name="redirect" type="hidden" value="<%= configurationRenderURL %>" />

	<div class="form-group">

		<label class="control-label" for="<portlet:namespace />successMessage">
			<liferay-ui:message key="success-message-label" />
		</label>

		<textarea
			class="form-control"
			id="<portlet:namespace />successMessage"
			maxlength="500"
			name="<portlet:namespace />successMessage"
			rows="5"
			style="resize: vertical;"
		><%= HtmlUtil.escape(successMessage) %></textarea>

		<p class="help-block" style="margin-top: 6px; font-size: 12px; color: #888;">
			<span class="glyphicon glyphicon-info-sign"></span>
			Displayed to the user after a successful form submission. Max 500 characters.
		</p>

	</div>

	<aui:button-row>
		<aui:button type="submit" value="save" />
		<aui:button href="<%= configurationRenderURL %>" type="cancel" />
	</aui:button-row>

</aui:form>