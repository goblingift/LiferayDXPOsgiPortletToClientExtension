<%@ include file="/init.jsp" %>

<%
boolean submitted = "true".equals(renderRequest.getParameter("submitted"));
String successMessage = portletPreferences.getValue(
	"successMessage",
	LanguageUtil.get(request, "success-message-default"));
%>

<portlet:actionURL name="/contact_form/submit" var="submitURL" />
<portlet:renderURL var="resetURL" />
<portlet:resourceURL var="countriesURL" />
<portlet:resourceURL id="countryDetail" var="countryDetailURL" />

<liferay-util:html-top>
	<link href="<%= request.getContextPath() %>/css/contact-form.css" rel="stylesheet" type="text/css" />
</liferay-util:html-top>

<c:choose>

<%-- ===== SUCCESS STATE ===== --%>
<c:when test="<%= submitted %>">
<div class="cfp-wrap">

	<div class="cfp-header">
		<h2>
			<span class="glyphicon glyphicon-envelope"></span>
			<liferay-ui:message key="contact-form-portlet" />
		</h2>
	</div>

	<div class="cfp-success-card">

		<%-- Animated checkmark --%>
		<div class="cfp-checkmark-wrap">
			<div class="cfp-checkmark-circle">
				<span class="glyphicon glyphicon-ok cfp-checkmark-icon"></span>
			</div>
		</div>

		<%-- Title --%>
		<h2 class="cfp-success-title">
			<liferay-ui:message key="form-submitted-title" />
		</h2>

		<%-- Configurable message in a green callout --%>
		<div class="cfp-success-message-box">
			<p><%= HtmlUtil.escape(successMessage) %></p>
		</div>

		<hr class="cfp-success-divider" />

		<%-- Button to start over --%>
		<a class="btn btn-primary cfp-btn-reset" href="<%= resetURL %>">
			<span class="glyphicon glyphicon-plus"></span>
			<liferay-ui:message key="submit-another" />
		</a>

	</div>
</div>
</c:when>

<%-- ===== FORM STATE ===== --%>
<c:otherwise>

<div class="cfp-wrap">

	<%-- Form header --%>
	<div class="cfp-header">
		<h2>
			<span class="glyphicon glyphicon-envelope"></span>
			<liferay-ui:message key="contact-form-portlet" />
		</h2>
		<p>Complete all three sections below. Fields marked <strong>*</strong> are required.</p>
	</div>

	<%-- Step tracker (visual only) --%>
	<ul class="cfp-steps">
		<li class="active">
			<span class="cfp-step-num">1</span>
			<span class="glyphicon glyphicon-user"></span>
			<liferay-ui:message key="personal-info" />
		</li>
		<li>
			<span class="cfp-step-num">2</span>
			<span class="glyphicon glyphicon-home"></span>
			<liferay-ui:message key="address-info" />
		</li>
		<li>
			<span class="cfp-step-num">3</span>
			<span class="glyphicon glyphicon-briefcase"></span>
			<liferay-ui:message key="employment-info" />
		</li>
	</ul>

	<aui:form action="<%= submitURL %>" method="post" name="fm">

		<%-- ===== SECTION 1: PERSONAL INFORMATION ===== --%>
		<div class="panel panel-info">
			<div class="panel-heading">
				<h4 class="panel-title">
					<span class="cfp-step-badge">1</span>
					<span class="glyphicon glyphicon-user"></span>
					<liferay-ui:message key="personal-info" />
				</h4>
			</div>
			<div class="panel-body">

				<div class="row">
					<div class="col-sm-6">
						<aui:input label="first-name" name="firstName" required="<%= true %>" type="text">
							<aui:validator errorMessage='<%= LanguageUtil.get(request, "validation-required") %>' name="required" />
							<aui:validator name="maxLength">100</aui:validator>
						</aui:input>
					</div>
					<div class="col-sm-6">
						<aui:input label="last-name" name="lastName" required="<%= true %>" type="text">
							<aui:validator errorMessage='<%= LanguageUtil.get(request, "validation-required") %>' name="required" />
							<aui:validator name="maxLength">100</aui:validator>
						</aui:input>
					</div>
				</div>

				<div class="row">
					<div class="col-sm-6">
						<aui:input label="email" name="email" required="<%= true %>" type="email">
							<aui:validator errorMessage='<%= LanguageUtil.get(request, "validation-required") %>' name="required" />
							<aui:validator errorMessage='<%= LanguageUtil.get(request, "validation-email") %>' name="email" />
						</aui:input>
					</div>
					<div class="col-sm-6">
						<aui:input label="phone" name="phone" required="<%= true %>" type="text">
							<aui:validator errorMessage='<%= LanguageUtil.get(request, "validation-required") %>' name="required" />
							<aui:validator errorMessage='<%= LanguageUtil.get(request, "validation-phone") %>' name="custom">
								function(val) {
									return /^[+]?[0-9\s\-\(\)]{7,20}$/.test(val.trim());
								}
							</aui:validator>
						</aui:input>
					</div>
				</div>

				<div class="row">
					<div class="col-sm-5">
						<aui:input label="date-of-birth" name="dateOfBirth" required="<%= true %>" type="date">
							<aui:validator errorMessage='<%= LanguageUtil.get(request, "validation-required") %>' name="required" />
							<aui:validator errorMessage='<%= LanguageUtil.get(request, "validation-min-age") %>' name="custom">
								function(val) {
									if (!val) return false;
									var dob = new Date(val);
									var today = new Date();
									var age = today.getFullYear() - dob.getFullYear();
									var m = today.getMonth() - dob.getMonth();
									if (m < 0 || (m === 0 && today.getDate() < dob.getDate())) age--;
									return age >= 18;
								}
							</aui:validator>
						</aui:input>
					</div>
				</div>

			</div><%-- /panel-body --%>
		</div><%-- /panel-info --%>

		<%-- ===== SECTION 2: ADDRESS ===== --%>
		<div class="panel panel-success">
			<div class="panel-heading">
				<h4 class="panel-title">
					<span class="cfp-step-badge">2</span>
					<span class="glyphicon glyphicon-home"></span>
					<liferay-ui:message key="address-info" />
				</h4>
			</div>
			<div class="panel-body">

				<div class="row">
					<div class="col-sm-8">
						<aui:input label="street" name="street" required="<%= true %>" type="text">
							<aui:validator errorMessage='<%= LanguageUtil.get(request, "validation-required") %>' name="required" />
							<aui:validator name="maxLength">200</aui:validator>
						</aui:input>
					</div>
					<div class="col-sm-4">
						<aui:input label="house-number" name="houseNumber" required="<%= true %>" type="text">
							<aui:validator errorMessage='<%= LanguageUtil.get(request, "validation-required") %>' name="required" />
							<aui:validator name="maxLength">20</aui:validator>
						</aui:input>
					</div>
				</div>

				<div class="row">
					<div class="col-sm-3">
						<aui:input label="postal-code" name="postalCode" required="<%= true %>" type="text">
							<aui:validator errorMessage='<%= LanguageUtil.get(request, "validation-required") %>' name="required" />
							<aui:validator errorMessage='<%= LanguageUtil.get(request, "validation-postal-code") %>' name="custom">
								function(val) {
									return /^[A-Za-z0-9\s\-]{3,10}$/.test(val.trim());
								}
							</aui:validator>
							<%-- Germany PLZ blocking handled via submit listener in the PLZ IIFE below --%>
						</aui:input>
					</div>
					<div class="col-sm-9">
						<aui:input label="city" name="city" required="<%= true %>" type="text">
							<aui:validator errorMessage='<%= LanguageUtil.get(request, "validation-required") %>' name="required" />
							<aui:validator name="maxLength">100</aui:validator>
						</aui:input>
					</div>
				</div>

				<%-- Country dropdown --%>
				<div class="form-group">
					<label class="control-label" for="<portlet:namespace />country">
						<liferay-ui:message key="country" />
						<span class="text-danger"> *</span>
					</label>
					<div id="<portlet:namespace />countriesLoader" class="cfp-fetching">
						<span class="glyphicon glyphicon-refresh spinning"></span>
						<liferay-ui:message key="fetching-countries" />
					</div>
					<select
						class="form-control"
						id="<portlet:namespace />country"
						name="<portlet:namespace />country"
						required
						style="display: none;"
					>
						<option value=""><liferay-ui:message key="select-placeholder" /></option>
					</select>
				</div>

				<%-- Country detail panel --%>
				<div id="<portlet:namespace />countryPanel" class="cfp-country-detail" style="display: none;">

					<div id="<portlet:namespace />detailLoading" class="panel-body text-center" style="padding: 24px;">
						<span class="cfp-fetching">
							<span class="glyphicon glyphicon-refresh spinning"></span>
							Loading country details...
						</span>
					</div>

					<div id="<portlet:namespace />detailContent" style="display: none;">

						<div class="cfp-detail-header">
							<img id="<portlet:namespace />flag" class="cfp-flag" src="" alt="" />
							<div>
								<strong id="<portlet:namespace />cName" style="font-size: 16px;"></strong><br />
								<small id="<portlet:namespace />cOfficialName" class="text-muted"></small>
							</div>
							<div id="<portlet:namespace />coatWrap" class="cfp-coat-wrap" style="display: none;">
								<img id="<portlet:namespace />coat" class="cfp-coat" src="" alt="Coat of Arms" />
								<div><small class="text-muted">Coat of Arms</small></div>
							</div>
						</div>

						<div class="panel-body" style="padding: 12px 18px;">
							<table class="table table-condensed cfp-info-table">
								<tbody>
									<tr>
										<td><span class="glyphicon glyphicon-map-marker text-muted"></span> Capital</td>
										<td id="<portlet:namespace />capital"></td>
									</tr>
									<tr>
										<td><span class="glyphicon glyphicon-user text-muted"></span> Population</td>
										<td id="<portlet:namespace />population"></td>
									</tr>
									<tr>
										<td><span class="glyphicon glyphicon-globe text-muted"></span> Region</td>
										<td id="<portlet:namespace />region"></td>
									</tr>
									<tr>
										<td><span class="glyphicon glyphicon-indent-left text-muted"></span> Subregion</td>
										<td id="<portlet:namespace />subregion"></td>
									</tr>
									<tr>
										<td><span class="glyphicon glyphicon-comment text-muted"></span> Languages</td>
										<td id="<portlet:namespace />languages"></td>
									</tr>
									<tr>
										<td><span class="glyphicon glyphicon-usd text-muted"></span> Currencies</td>
										<td id="<portlet:namespace />currencies"></td>
									</tr>
									<tr>
										<td><span class="glyphicon glyphicon-time text-muted"></span> Timezones</td>
										<td id="<portlet:namespace />timezones"></td>
									</tr>
									<tr id="<portlet:namespace />bordersRow">
										<td><span class="glyphicon glyphicon-resize-horizontal text-muted"></span> Borders</td>
										<td id="<portlet:namespace />borders"></td>
									</tr>
								</tbody>
							</table>

							<a
								id="<portlet:namespace />mapsLink"
								href="#"
								target="_blank"
								rel="noopener noreferrer"
								class="btn btn-xs btn-default"
								style="display: none;"
							>
								<span class="glyphicon glyphicon-map-marker"></span>
								View on Google Maps
							</a>
						</div>
					</div>
				</div><%-- /cfp-country-detail --%>

			</div><%-- /panel-body --%>
		</div><%-- /panel-success --%>

		<%-- ===== SECTION 3: EMPLOYMENT & FINANCES ===== --%>
		<div class="panel panel-warning">
			<div class="panel-heading">
				<h4 class="panel-title">
					<span class="cfp-step-badge">3</span>
					<span class="glyphicon glyphicon-briefcase"></span>
					<liferay-ui:message key="employment-info" />
				</h4>
			</div>
			<div class="panel-body">

				<div class="row">
					<div class="col-sm-6">
						<aui:select label="employment-type" name="employmentType" required="<%= true %>">
							<aui:option label="select-placeholder" value="" />
							<aui:option label="employment-employed"      value="employed" />
							<aui:option label="employment-self-employed" value="self-employed" />
							<aui:option label="employment-unemployed"    value="unemployed" />
							<aui:option label="employment-student"       value="student" />
							<aui:option label="employment-retired"       value="retired" />
							<aui:validator errorMessage='<%= LanguageUtil.get(request, "validation-required") %>' name="required" />
						</aui:select>
					</div>
					<div class="col-sm-6">
						<%-- aui:input preserves AUI validators; JS wraps it in an input-group addon after render --%>
						<aui:input label="annual-income" min="0" name="annualIncome" required="<%= true %>" step="0.01" type="number">
							<aui:validator errorMessage='<%= LanguageUtil.get(request, "validation-required") %>' name="required" />
							<aui:validator errorMessage='<%= LanguageUtil.get(request, "validation-number") %>' name="number" />
							<aui:validator errorMessage='<%= LanguageUtil.get(request, "validation-income") %>' name="custom">
								function(val) {
									return parseFloat(val) >= 0;
								}
							</aui:validator>
						</aui:input>
					</div>
				</div>

			</div><%-- /panel-body --%>
		</div><%-- /panel-warning --%>

		<%-- ===== SUBMIT ===== --%>
		<div class="cfp-submit-row">
			<button class="btn btn-primary btn-submit" type="submit">
				<span class="glyphicon glyphicon-send"></span>
				<liferay-ui:message key="submit" />
			</button>
			<p class="cfp-required-note">
				<span class="text-danger">*</span> Required fields
			</p>
		</div>

	</aui:form>
</div><%-- /cfp-wrap --%>

</c:otherwise>
</c:choose>

<aui:script>
(function () {
	var ns = '<portlet:namespace />';

	function el(id) {
		return document.getElementById(ns + id);
	}

	// --- Wrap the aui:input for annualIncome in a Bootstrap input-group with a Euro addon ---
	(function () {
		var incomeInput = el('annualIncome');
		if (!incomeInput) return;
		var wrapper = document.createElement('div');
		wrapper.className = 'input-group';
		incomeInput.parentNode.insertBefore(wrapper, incomeInput);
		wrapper.appendChild(incomeInput);
		var addon = document.createElement('span');
		addon.className = 'input-group-addon';
		addon.innerHTML = '<span class="glyphicon glyphicon-euro"></span>';
		wrapper.insertBefore(addon, incomeInput);
	})();

	// --- Highlight step tabs as user focuses in each section ---
	(function () {
		var steps = document.querySelectorAll('.cfp-steps li');
		var panels = [
			document.querySelector('.panel-info'),
			document.querySelector('.panel-success'),
			document.querySelector('.panel-warning')
		];

		panels.forEach(function (panel, idx) {
			if (!panel) return;
			panel.addEventListener('focusin', function () {
				steps.forEach(function (s) { s.classList.remove('active'); });
				if (steps[idx]) steps[idx].classList.add('active');
			});
		});
	})();

	// --- Fetch countries list on load ---
	fetch('<%= countriesURL %>')
		.then(function (res) { return res.json(); })
		.then(function (countries) {
			var select = el('country');
			countries.forEach(function (name) {
				var opt = document.createElement('option');
				opt.value = name;
				opt.textContent = name;
				select.appendChild(opt);
			});
			el('countriesLoader').style.display = 'none';
			select.style.display = 'block';
		})
		.catch(function () {
			el('countriesLoader').innerHTML = '<span class="text-danger">Failed to load countries.</span>';
		});

	// --- Fetch country detail on selection ---
	document.addEventListener('change', function (e) {
		if (e.target.id !== ns + 'country') return;

		var countryName = e.target.value;
		var panel       = el('countryPanel');
		var loading     = el('detailLoading');
		var content     = el('detailContent');

		if (!countryName) {
			panel.style.display = 'none';
			return;
		}

		panel.style.display   = 'block';
		loading.style.display = 'block';
		content.style.display = 'none';

		var detailUrl = 'https://restcountries.com/v3.1/name/' +
			encodeURIComponent(countryName) +
			'?fullText=true&fields=name,capital,population,region,subregion,' +
			'languages,currencies,timezones,flags,coatOfArms,maps,borders';

		fetch(detailUrl)
			.then(function (res) { return res.text(); })
			.then(function (rawText) {
				var arr;
				try { arr = JSON.parse(rawText); }
				catch (e) {
					loading.innerHTML = '<span class="text-danger">Failed to parse country data.</span>';
					return;
				}

				var d = Array.isArray(arr) ? arr[0] : arr;

				var flagEl = el('flag');
				flagEl.src = (d.flags && d.flags.png) ? d.flags.png : '';
				flagEl.alt = (d.flags && d.flags.alt) ? d.flags.alt : '';

				el('cName').textContent         = d.name ? d.name.common   : '';
				el('cOfficialName').textContent = d.name ? d.name.official : '';

				var coatWrap = el('coatWrap');
				if (d.coatOfArms && d.coatOfArms.png) {
					el('coat').src         = d.coatOfArms.png;
					coatWrap.style.display = 'block';
				} else {
					coatWrap.style.display = 'none';
				}

				el('capital').textContent    = (d.capital   && d.capital.length)   ? d.capital.join(', ')   : '—';
				el('population').textContent = d.population                          ? d.population.toLocaleString() : '—';
				el('region').textContent     = d.region    || '—';
				el('subregion').textContent  = d.subregion || '—';
				el('languages').textContent  = d.languages ? Object.values(d.languages).join(', ') : '—';
				el('timezones').textContent  = (d.timezones && d.timezones.length)  ? d.timezones.join(', ') : '—';
				el('currencies').textContent = d.currencies
					? Object.values(d.currencies).map(function (c) {
						return c.name + (c.symbol ? ' (' + c.symbol + ')' : '');
					}).join(', ')
					: '—';

				var bordersRow = el('bordersRow');
				var bordersEl  = el('borders');
				if (d.borders && d.borders.length) {
					bordersEl.innerHTML = d.borders.map(function (code) {
						return '<span class="cfp-border-badge">' + code + '</span>';
					}).join('');
					bordersRow.style.display = '';
				} else {
					bordersRow.style.display = 'none';
				}

				var mapsLink = el('mapsLink');
				if (d.maps && d.maps.googleMaps) {
					mapsLink.href          = d.maps.googleMaps;
					mapsLink.style.display = 'inline-block';
				} else {
					mapsLink.style.display = 'none';
				}

				loading.style.display = 'none';
				content.style.display = 'block';
			})
			.catch(function (err) {
				console.error('[ContactForm] Fetch error:', err);
				loading.innerHTML = '<span class="text-danger">Failed to load country details.</span>';
			});
	});

	// --- PLZ (postal code) live validation for Germany via OpenPLZ API ---
	(function () {
		var PLZ_COUNTRY  = 'Germany';
		var PLZ_API_BASE = 'https://openplzapi.org/de/Localities?postalCode=';
		var plzTimeout   = null;
		var plzLastCode  = '';

		window[ns + '_plzValid'] = null; // null=unchecked | true=valid | false=invalid

		// Overlay the PLZ status icon inside the input using position:absolute.
		// Using a plain wrapper div (not input-group) so the input keeps its full width
		// and AUI required-error messages render correctly below it.
		var postalInput = el('postalCode');
		if (postalInput) {
			var plzWrap = document.createElement('div');
			plzWrap.className = 'cfp-plz-wrap';
			postalInput.parentNode.insertBefore(plzWrap, postalInput);
			plzWrap.appendChild(postalInput);

			var plzIcon = document.createElement('span');
			plzIcon.id        = ns + 'plzStatus';
			plzIcon.className = 'cfp-plz-icon';
			plzWrap.appendChild(plzIcon);

			var plzLocality = document.createElement('small');
			plzLocality.id        = ns + 'plzLocality';
			plzLocality.className = 'cfp-plz-locality';
			plzWrap.parentNode.insertBefore(plzLocality, plzWrap.nextSibling);
		}

		function setPlzStatus(state, localityName) {
			window[ns + '_plzValid'] = (state === 'valid') ? true
				: (state === 'invalid') ? false : null;

			var icon     = document.getElementById(ns + 'plzStatus');
			var locality = document.getElementById(ns + 'plzLocality');

			if (!icon) return;

			icon.className = 'cfp-plz-icon';

			if (state === 'idle') {
				icon.innerHTML = '';
				if (locality) {
					locality.className    = 'cfp-plz-locality';
					locality.style.display = 'none';
					locality.textContent  = '';
				}
			}
			else if (state === 'checking') {
				icon.classList.add('cfp-plz-checking');
				icon.innerHTML = '<span class="glyphicon glyphicon-refresh spinning"></span>';
				if (locality) { locality.style.display = 'none'; locality.textContent = ''; }
			}
			else if (state === 'valid') {
				icon.classList.add('cfp-plz-valid');
				icon.innerHTML = '<span class="glyphicon glyphicon-ok-sign"></span>';
				if (locality) {
					locality.className    = 'cfp-plz-locality cfp-plz-locality--valid';
					locality.textContent  = localityName || '';
					locality.style.display = localityName ? 'block' : 'none';
				}
			}
			else if (state === 'invalid') {
				icon.classList.add('cfp-plz-invalid');
				icon.innerHTML = '<span class="glyphicon glyphicon-remove-sign"></span>';
				if (locality) {
					locality.className    = 'cfp-plz-locality cfp-plz-locality--error';
					locality.textContent  = '<%= LanguageUtil.get(request, "validation-postal-code-de") %>';
					locality.style.display = 'block';
				}
			}
		}

		function checkPlz(code) {
			setPlzStatus('checking');

			fetch(PLZ_API_BASE + encodeURIComponent(code))
				.then(function (res) { return res.json(); })
				.then(function (data) {
					if (Array.isArray(data) && data.length > 0) {
						var cityName = data[0].name || '';
						setPlzStatus('valid', cityName);

						// Auto-fill city field with the first locality name from the API
						var cityInput = el('city');
						if (cityInput && cityName) {
							cityInput.value = cityName;
							cityInput.dispatchEvent(new Event('input',  { bubbles: true }));
							cityInput.dispatchEvent(new Event('change', { bubbles: true }));
						}
					}
					else {
						setPlzStatus('invalid');
					}
				})
				.catch(function () {
					setPlzStatus('idle'); // API unreachable — don't block user
				});
		}

		function triggerPlzCheck() {
			var countryEl = document.getElementById(ns + 'country');
			var postal    = el('postalCode');

			if (!countryEl || !postal) return;

			var country = countryEl.value;
			var code    = postal.value.trim();

			if (country !== PLZ_COUNTRY) {
				setPlzStatus('idle');
				return;
			}

			if (!code || code.length < 3) {
				setPlzStatus('idle');
				return;
			}

			if (code === plzLastCode) return;
			plzLastCode = code;

			clearTimeout(plzTimeout);
			plzTimeout = setTimeout(function () { checkPlz(code); }, 550);
		}

		document.addEventListener('change', function (e) {
			var id = e.target.id;
			if (id === ns + 'country' || id === ns + 'postalCode') {
				plzLastCode = ''; // reset so same code re-triggers when country switches
				triggerPlzCheck();
			}
		});

		document.addEventListener('input', function (e) {
			if (e.target.id === ns + 'postalCode') {
				triggerPlzCheck();
			}
		});

		// Block form submission when Germany is selected and PLZ is confirmed invalid.
		// This replaces the aui:validator approach to avoid showing a duplicate message.
		var formEl = document.getElementById(ns + 'fm');
		if (formEl) {
			formEl.addEventListener('submit', function (e) {
				var countryEl = document.getElementById(ns + 'country');
				var isGermany = countryEl && countryEl.value === 'Germany';

				if (isGermany && window[ns + '_plzValid'] === false) {
					e.preventDefault();
					e.stopImmediatePropagation();

					// Re-assert the error state so the indicator is clearly visible
					setPlzStatus('invalid');

					var postalInput = el('postalCode');
					if (postalInput) {
						postalInput.scrollIntoView({ behavior: 'smooth', block: 'center' });
						postalInput.focus();
					}
				}
			});
		}
	})();

})();
</aui:script>