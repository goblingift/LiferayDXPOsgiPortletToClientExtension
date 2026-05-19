<%@ include file="/init.jsp" %>

<portlet:actionURL name="/contact_form/submit" var="submitURL" />
<portlet:resourceURL var="countriesURL" />

<style>
	@keyframes cfp-pulse {
		0%, 100% { opacity: 1; }
		50% { opacity: 0.3; }
	}
	.cfp-fetching {
		animation: cfp-pulse 1.2s ease-in-out infinite;
		color: #6c757d;
		font-style: italic;
		font-size: 0.9em;
		margin-bottom: 8px;
	}
</style>

<div class="contact-form-portlet">
	<h2><liferay-ui:message key="contact-form-portlet" /></h2>

	<aui:form action="<%= submitURL %>" method="post" name="fm">
		<aui:input
			label="first-name"
			name="firstName"
			required="<%= true %>"
			type="text"
		/>

		<aui:input
			label="last-name"
			name="lastName"
			required="<%= true %>"
			type="text"
		/>

		<aui:input
			label="email"
			name="email"
			required="<%= true %>"
			type="email"
		/>

		<div class="form-group">
			<label class="control-label" for="<portlet:namespace />country">Country</label>
			<div id="<portlet:namespace />countriesLoader" class="cfp-fetching">Fetching countries...</div>
			<select
				class="form-control"
				id="<portlet:namespace />country"
				name="<portlet:namespace />country"
				required
				style="display: none;"
			>
				<option value="">-- Select a Country --</option>
			</select>
		</div>

		<aui:button-row>
			<aui:button
				type="submit"
				value="submit"
			/>
		</aui:button-row>
	</aui:form>
</div>

<aui:script>
	(function () {
		var loader = document.getElementById('<portlet:namespace />countriesLoader');
		var select = document.getElementById('<portlet:namespace />country');

		fetch('<%= countriesURL %>')
			.then(function (response) {
				return response.json();
			})
			.then(function (countries) {
				countries.forEach(function (name) {
					var option = document.createElement('option');
					option.value = name;
					option.textContent = name;
					select.appendChild(option);
				});

				loader.style.display = 'none';
				select.style.display = 'block';
			})
			.catch(function () {
				loader.textContent = 'Failed to load countries.';
			});
	})();
</aui:script>