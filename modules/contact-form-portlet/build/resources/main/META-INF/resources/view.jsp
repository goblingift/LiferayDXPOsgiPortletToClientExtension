<%@ include file="/init.jsp" %>

<portlet:actionURL name="/contact_form/submit" var="submitURL" />
<portlet:resourceURL var="countriesURL" />
<portlet:resourceURL id="countryDetail" var="countryDetailURL" />

<style>
	@keyframes cfp-pulse {
		0%, 100% { opacity: 1; }
		50%       { opacity: 0.3; }
	}
	.cfp-fetching {
		animation: cfp-pulse 1.2s ease-in-out infinite;
		color: #6c757d;
		font-style: italic;
		font-size: 0.9em;
	}
	.cfp-flag {
		height: 64px;
		object-fit: contain;
		border: 1px solid #dee2e6;
		border-radius: 4px;
	}
	.cfp-coat {
		max-height: 90px;
		object-fit: contain;
	}
	.cfp-detail-header {
		display: flex;
		align-items: center;
		gap: 16px;
		padding: 16px;
		background: #f8f9fa;
		border-bottom: 1px solid #dee2e6;
		border-radius: 4px 4px 0 0;
	}
	.cfp-detail-header .cfp-coat-wrap {
		margin-left: auto;
		text-align: center;
	}
	.cfp-info-table td:first-child {
		font-weight: 600;
		white-space: nowrap;
		padding-right: 20px;
		color: #495057;
		width: 120px;
	}
	.cfp-border-badge {
		display: inline-block;
		background: #e9ecef;
		color: #495057;
		font-size: 0.75em;
		font-weight: 600;
		padding: 2px 8px;
		border-radius: 12px;
		margin: 2px;
		letter-spacing: 0.5px;
	}
</style>

<div class="contact-form-portlet">
	<h2><liferay-ui:message key="contact-form-portlet" /></h2>

	<aui:form action="<%= submitURL %>" method="post" name="fm">
		<aui:input label="first-name" name="firstName" required="<%= true %>" type="text" />
		<aui:input label="last-name"  name="lastName"  required="<%= true %>" type="text" />
		<aui:input label="email"      name="email"      required="<%= true %>" type="email" />

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
			<aui:button type="submit" value="submit" />
		</aui:button-row>
	</aui:form>

	<%-- Country detail panel (shown after a country is selected) --%>
	<div id="<portlet:namespace />countryPanel" class="card mt-4" style="display: none;">

		<div id="<portlet:namespace />detailLoading" class="card-body text-center py-4">
			<span class="cfp-fetching">Loading country details...</span>
		</div>

		<div id="<portlet:namespace />detailContent" style="display: none;">

			<div class="cfp-detail-header">
				<img id="<portlet:namespace />flag" class="cfp-flag" src="" alt="" />
				<div>
					<h4 id="<portlet:namespace />cName" class="mb-0"></h4>
					<small id="<portlet:namespace />cOfficialName" class="text-muted"></small>
				</div>
				<div id="<portlet:namespace />coatWrap" class="cfp-coat-wrap" style="display: none;">
					<img id="<portlet:namespace />coat" class="cfp-coat" src="" alt="Coat of Arms" />
					<div><small class="text-muted">Coat of Arms</small></div>
				</div>
			</div>

			<div class="card-body">
				<table class="table table-sm cfp-info-table">
					<tbody>
						<tr><td>Capital</td>    <td id="<portlet:namespace />capital"></td></tr>
						<tr><td>Population</td> <td id="<portlet:namespace />population"></td></tr>
						<tr><td>Region</td>     <td id="<portlet:namespace />region"></td></tr>
						<tr><td>Subregion</td>  <td id="<portlet:namespace />subregion"></td></tr>
						<tr><td>Languages</td>  <td id="<portlet:namespace />languages"></td></tr>
						<tr><td>Currencies</td> <td id="<portlet:namespace />currencies"></td></tr>
						<tr><td>Timezones</td>  <td id="<portlet:namespace />timezones"></td></tr>
						<tr id="<portlet:namespace />bordersRow">
							<td>Borders</td>
							<td id="<portlet:namespace />borders"></td>
						</tr>
					</tbody>
				</table>

				<a
					id="<portlet:namespace />mapsLink"
					href="#"
					target="_blank"
					rel="noopener noreferrer"
					class="btn btn-sm btn-outline-primary"
					style="display: none;"
				>
					View on Google Maps &#8599;
				</a>
			</div>
		</div>
	</div>
</div>

<aui:script>
(function () {
	var ns = '<portlet:namespace />';

	function el(id) {
		return document.getElementById(ns + id);
	}

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
			el('countriesLoader').textContent = 'Failed to load countries.';
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
		loading.querySelector('.cfp-fetching').textContent = 'Loading country details...';

		var detailUrl = 'https://restcountries.com/v3.1/name/' +
			encodeURIComponent(countryName) +
			'?fullText=true&fields=name,capital,population,region,subregion,' +
			'languages,currencies,timezones,flags,coatOfArms,maps,borders';

		console.log('[ContactForm] Fetching URL:', detailUrl);

		fetch(detailUrl)
		.then(function (res) { return res.text(); })
		.then(function (rawText) {
			console.log('[ContactForm] Raw response:', rawText.substring(0, 200));

			var arr;
			try {
				arr = JSON.parse(rawText);
			} catch (e) {
				console.error('[ContactForm] JSON parse error:', e);
				loading.querySelector('.cfp-fetching').textContent = 'Failed to parse country data.';
				return;
			}

			var d = Array.isArray(arr) ? arr[0] : arr;
			console.log('[ContactForm] Parsed object:', d);
			console.log('[ContactForm] capital:', d.capital);
			console.log('[ContactForm] population:', d.population);
			console.log('[ContactForm] region:', d.region);
			console.log('[ContactForm] languages:', d.languages);
			console.log('[ContactForm] currencies:', d.currencies);
			console.log('[ContactForm] timezones:', d.timezones);

			// Flag
			var flagEl = el('flag');
			flagEl.src = (d.flags && d.flags.png)  ? d.flags.png : '';
			flagEl.alt = (d.flags && d.flags.alt)  ? d.flags.alt : '';

			// Names
			el('cName').textContent         = d.name ? d.name.common   : '';
			el('cOfficialName').textContent = d.name ? d.name.official : '';

			// Coat of arms
			var coatWrap = el('coatWrap');
			if (d.coatOfArms && d.coatOfArms.png) {
				el('coat').src           = d.coatOfArms.png;
				coatWrap.style.display   = 'block';
			} else {
				coatWrap.style.display   = 'none';
			}

			// Info fields
			el('capital').textContent    = (d.capital    && d.capital.length)    ? d.capital.join(', ')    : '—';
			el('population').textContent = d.population                           ? d.population.toLocaleString() : '—';
			el('region').textContent     = d.region     || '—';
			el('subregion').textContent  = d.subregion  || '—';
			el('languages').textContent  = d.languages  ? Object.values(d.languages).join(', ') : '—';
			el('timezones').textContent  = (d.timezones && d.timezones.length)   ? d.timezones.join(', ')  : '—';

			el('currencies').textContent = d.currencies
				? Object.values(d.currencies).map(function (c) {
					return c.name + (c.symbol ? ' (' + c.symbol + ')' : '');
				}).join(', ')
				: '—';

			// Borders
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

			// Maps link
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
			loading.querySelector('.cfp-fetching').textContent = 'Failed to load country details.';
		});
	});
})();
</aui:script>