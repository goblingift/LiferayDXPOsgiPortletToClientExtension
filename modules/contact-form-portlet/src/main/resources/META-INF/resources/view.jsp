<%@ include file="/init.jsp" %>

<portlet:actionURL name="/contact_form/submit" var="submitURL" />
<portlet:resourceURL var="countriesURL" />
<portlet:resourceURL id="countryDetail" var="countryDetailURL" />

<style>
	/* ---------- animations ---------- */
	@keyframes cfp-pulse {
		0%, 100% { opacity: 1; }
		50%       { opacity: 0.3; }
	}

	/* ---------- scope everything under .cfp-wrap ---------- */
	.cfp-wrap {
		max-width: 900px;
	}

	/* ---------- form header ---------- */
	.cfp-header {
		background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);
		color: #fff;
		border-radius: 8px 8px 0 0;
		padding: 28px 32px 24px;
		margin-bottom: 0;
	}
	.cfp-header h2 {
		margin: 0 0 6px;
		font-size: 22px;
		font-weight: 700;
		color: #fff;
		border: none;
	}
	.cfp-header p {
		margin: 0;
		opacity: 0.82;
		font-size: 13px;
	}
	.cfp-header .glyphicon {
		margin-right: 8px;
		font-size: 20px;
		vertical-align: middle;
	}

	/* ---------- step tracker ---------- */
	.cfp-steps {
		display: flex;
		background: #ecf0f1;
		border-left: 1px solid #dce1e4;
		border-right: 1px solid #dce1e4;
		padding: 0;
		margin: 0 0 20px;
		list-style: none;
	}
	.cfp-steps li {
		flex: 1;
		text-align: center;
		padding: 10px 8px;
		font-size: 12px;
		font-weight: 600;
		color: #95a5a6;
		border-bottom: 3px solid transparent;
		transition: border-color 0.2s;
	}
	.cfp-steps li.active {
		color: #2c3e50;
		border-bottom-color: #3498db;
		background: #fff;
	}
	.cfp-steps li .cfp-step-num {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 20px;
		height: 20px;
		border-radius: 50%;
		background: #bdc3c7;
		color: #fff;
		font-size: 11px;
		margin-right: 6px;
		vertical-align: middle;
	}
	.cfp-steps li.active .cfp-step-num {
		background: #3498db;
	}

	/* ---------- panels ---------- */
	.cfp-wrap .panel {
		border-radius: 6px;
		box-shadow: 0 2px 8px rgba(0, 0, 0, 0.07);
		border: 1px solid #dde3e8;
		margin-bottom: 20px;
	}
	.cfp-wrap .panel-heading {
		padding: 13px 20px;
		border-radius: 5px 5px 0 0;
	}
	.cfp-wrap .panel-title {
		font-size: 14px;
		font-weight: 700;
		letter-spacing: 0.3px;
		display: flex;
		align-items: center;
		gap: 8px;
	}
	.cfp-wrap .panel-title .cfp-step-badge {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 20px;
		height: 20px;
		border-radius: 50%;
		background: rgba(255, 255, 255, 0.35);
		font-size: 11px;
		font-weight: 700;
		flex-shrink: 0;
	}
	.cfp-wrap .panel-body {
		padding: 20px 24px 8px;
	}

	/* Section accent colours */
	.cfp-wrap .panel-info    { border-top: 3px solid #5bc0de; }
	.cfp-wrap .panel-success { border-top: 3px solid #5cb85c; }
	.cfp-wrap .panel-warning { border-top: 3px solid #f0ad4e; }

	/* ---------- input group addons ---------- */
	.cfp-wrap .input-group-addon {
		background: #f5f5f5;
		color: #777;
		border-color: #ccc;
		min-width: 38px;
		text-align: center;
	}

	/* ---------- country dropdown ---------- */
	.cfp-fetching {
		animation: cfp-pulse 1.2s ease-in-out infinite;
		color: #888;
		font-style: italic;
		font-size: 0.9em;
		padding: 6px 0;
	}

	/* ---------- country detail panel ---------- */
	.cfp-country-detail {
		margin-top: 16px;
		border: 1px solid #d6e4ef;
		border-radius: 5px;
		overflow: hidden;
	}
	.cfp-detail-header {
		display: flex;
		align-items: center;
		gap: 16px;
		padding: 14px 18px;
		background: #eaf4fb;
		border-bottom: 1px solid #d6e4ef;
	}
	.cfp-detail-header .cfp-coat-wrap {
		margin-left: auto;
		text-align: center;
	}
	.cfp-flag {
		height: 52px;
		object-fit: contain;
		border: 1px solid #c9d9e8;
		border-radius: 3px;
		box-shadow: 0 1px 3px rgba(0,0,0,0.12);
	}
	.cfp-coat {
		max-height: 72px;
		object-fit: contain;
	}
	.cfp-info-table {
		margin-bottom: 0;
	}
	.cfp-info-table > tbody > tr > td:first-child {
		font-weight: 600;
		white-space: nowrap;
		padding-right: 20px;
		color: #555;
		width: 110px;
	}
	.cfp-border-badge {
		display: inline-block;
		background: #e8eef3;
		color: #4a6278;
		font-size: 0.72em;
		font-weight: 700;
		padding: 2px 8px;
		border-radius: 10px;
		margin: 2px 2px 2px 0;
		letter-spacing: 0.4px;
		border: 1px solid #ccd9e3;
	}

	/* ---------- submit row ---------- */
	.cfp-submit-row {
		text-align: center;
		padding: 12px 0 28px;
		margin-top: 4px;
	}
	.cfp-submit-row .btn-submit {
		min-width: 200px;
		font-size: 15px;
		font-weight: 600;
		padding: 12px 32px;
		border-radius: 5px;
		letter-spacing: 0.4px;
	}
	.cfp-submit-row .btn-submit .glyphicon {
		margin-right: 8px;
	}
	.cfp-required-note {
		font-size: 12px;
		color: #888;
		margin-top: 10px;
	}
</style>

<div class="cfp-wrap">

	<%-- ===== FORM HEADER ===== --%>
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

<aui:script>
(function () {
	var ns = '<portlet:namespace />';

	function el(id) {
		return document.getElementById(ns + id);
	}

	// --- Spinning glyphicon helper ---
	var style = document.createElement('style');
	style.textContent =
		'@-webkit-keyframes spin { 0%{-webkit-transform:rotate(0deg)} 100%{-webkit-transform:rotate(360deg)} }' +
		'@keyframes spin { 0%{transform:rotate(0deg)} 100%{transform:rotate(360deg)} }' +
		'.spinning { -webkit-animation: spin 1s linear infinite; animation: spin 1s linear infinite; margin-right: 4px; }';
	document.head.appendChild(style);

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
})();
</aui:script>