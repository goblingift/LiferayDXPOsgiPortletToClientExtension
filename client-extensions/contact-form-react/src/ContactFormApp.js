import React, { useCallback, useEffect, useRef, useState } from 'react';
import { useTranslation } from 'react-i18next';
import CountryDetail from './components/CountryDetail';
import SuccessView from './components/SuccessView';

// --- API endpoints ---
const COUNTRIES_API    = 'https://restcountries.com/v3.1/all?fields=name';
const COUNTRY_DETAIL_API = 'https://restcountries.com/v3.1/name/';
const PLZ_API          = 'https://openplzapi.org/de/Localities?postalCode=';
const EUR_TO_USD_RATE  = 1.08;

// ---- Utility: mirrors Java ContactApplicationDTO conversion logic ----

function calcAge(dateStr) {
	if (!dateStr) return -1;
	const dob   = new Date(dateStr);
	const today = new Date();
	let age = today.getFullYear() - dob.getFullYear();
	const m = today.getMonth() - dob.getMonth();
	if (m < 0 || (m === 0 && today.getDate() < dob.getDate())) age--;
	return age;
}

function mapEmploymentCategory(type) {
	const map = {
		'employed':      'ACTIVE_WORKFORCE',
		'self-employed': 'ACTIVE_WORKFORCE_INDEPENDENT',
		'unemployed':    'NON_ACTIVE',
		'student':       'IN_EDUCATION',
		'retired':       'POST_WORKFORCE',
	};
	return map[type] ?? 'UNKNOWN';
}

// ---- Validation ----

function validate(data, plzValid, t) {
	const errs = {};

	// Personal
	if (!data.firstName.trim())
		errs.firstName = t('error_required');
	if (!data.lastName.trim())
		errs.lastName = t('error_required');
	if (!data.email.trim())
		errs.email = t('error_required');
	else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(data.email))
		errs.email = t('error_email');
	if (!data.phone.trim())
		errs.phone = t('error_required');
	else if (!/^[+]?[0-9\s\-()]{7,20}$/.test(data.phone.trim()))
		errs.phone = t('error_phone');
	if (!data.dateOfBirth)
		errs.dateOfBirth = t('error_required');
	else if (calcAge(data.dateOfBirth) < 18)
		errs.dateOfBirth = t('error_dob_minor');

	// Address
	if (!data.street.trim())
		errs.street = t('error_required');
	if (!data.houseNumber.trim())
		errs.houseNumber = t('error_required');
	if (!data.postalCode.trim())
		errs.postalCode = t('error_required');
	else if (!/^[A-Za-z0-9\s-]{3,10}$/.test(data.postalCode.trim()))
		errs.postalCode = t('error_postalCode_format');
	else if (data.country === 'Germany' && plzValid === false)
		errs.postalCode = t('error_postalCode_notFound');
	if (!data.city.trim())
		errs.city = t('error_required');
	if (!data.country)
		errs.country = t('error_country');

	// Employment
	if (!data.employmentType)
		errs.employmentType = t('error_employment');
	if (data.annualIncome === '')
		errs.annualIncome = t('error_required');
	else if (parseFloat(data.annualIncome) < 0)
		errs.annualIncome = t('error_income');

	return errs;
}

// ---- Reusable text/email/date/number field ----

function Field({ label, name, type = 'text', value, onChange, error, required, ...rest }) {
	return (
		<div className="form-group">
			<label className="control-label">
				{label}
				{required && <span className="text-danger"> *</span>}
			</label>
			<input
				className={`form-control${error ? ' cfp-input-error' : ''}`}
				name={name}
				type={type}
				value={value}
				onChange={onChange}
				{...rest}
			/>
			{error && <small className="cfp-field-error">{error}</small>}
		</div>
	);
}

// ---- Initial form state ----

const INITIAL_FORM = {
	firstName: '', lastName: '', email: '', phone: '', dateOfBirth: '',
	street: '', houseNumber: '', postalCode: '', city: '', country: '',
	employmentType: '', annualIncome: '',
};

// ---- Main app component ----

export default function ContactFormApp({ successMessage }) {
	const { t } = useTranslation();
	const [formData, setFormData]             = useState(INITIAL_FORM);
	const [errors, setErrors]                 = useState({});
	const [submitted, setSubmitted]           = useState(false);
	const [activeSection, setActiveSection]   = useState(0);

	// Country dropdown
	const [countries, setCountries]           = useState([]);
	const [countriesLoading, setCountriesLoading] = useState(true);

	// Country detail panel
	const [countryDetail, setCountryDetail]   = useState(null);
	const [detailLoading, setDetailLoading]   = useState(false);

	// German postal code (PLZ) live validation
	const [plzStatus, setPlzStatus]           = useState('idle'); // idle | checking | valid | invalid
	const [plzLocality, setPlzLocality]       = useState('');
	const [plzValid, setPlzValid]             = useState(null);   // null | true | false

	// ---- Load countries on mount ----
	useEffect(() => {
		fetch(COUNTRIES_API)
			.then(r => r.json())
			.then(data => {
				const names = data
					.map(c => c.name.common)
					.sort((a, b) => a.localeCompare(b));
				setCountries(names);
				setCountriesLoading(false);
			})
			.catch(() => setCountriesLoading(false));
	}, []);

	// ---- Load country detail when selection changes ----
	useEffect(() => {
		if (!formData.country) { setCountryDetail(null); return; }

		setDetailLoading(true);
		setCountryDetail(null);

		const fields = 'name,capital,population,region,subregion,languages,currencies,timezones,flags,coatOfArms,maps,borders';
		fetch(`${COUNTRY_DETAIL_API}${encodeURIComponent(formData.country)}?fullText=true&fields=${fields}`)
			.then(r => r.json())
			.then(data => {
				setCountryDetail(Array.isArray(data) ? data[0] : data);
				setDetailLoading(false);
			})
			.catch(() => setDetailLoading(false));
	}, [formData.country]);

	// ---- German PLZ live validation with debounce ----
	useEffect(() => {
		const code = formData.postalCode.trim();

		if (formData.country !== 'Germany' || !code || code.length < 3) {
			setPlzStatus('idle');
			setPlzValid(null);
			setPlzLocality('');
			return;
		}

		setPlzStatus('checking');

		const timer = setTimeout(() => {
			fetch(`${PLZ_API}${encodeURIComponent(code)}`)
				.then(r => r.json())
				.then(data => {
					if (Array.isArray(data) && data.length > 0) {
						const city = data[0].name || '';
						setPlzStatus('valid');
						setPlzValid(true);
						setPlzLocality(city);
						// Auto-fill city field from API response
						if (city) setFormData(prev => ({ ...prev, city }));
					} else {
						setPlzStatus('invalid');
						setPlzValid(false);
						setPlzLocality('');
					}
				})
				.catch(() => {
					setPlzStatus('idle');
					setPlzValid(null);
				});
		}, 550);

		return () => clearTimeout(timer);
	}, [formData.postalCode, formData.country]);

	// ---- Field change handler ----
	const handleChange = useCallback((e) => {
		const { name, value } = e.target;

		setFormData(prev => ({ ...prev, [name]: value }));

		// Reset PLZ state when postal code or country changes
		if (name === 'postalCode' || name === 'country') {
			setPlzStatus('idle');
			setPlzValid(null);
			setPlzLocality('');
		}

		// Clear the individual field error on change
		if (errors[name]) {
			setErrors(prev => { const n = { ...prev }; delete n[name]; return n; });
		}
	}, [errors]);

	// ---- Form submission ----
	const handleSubmit = (e) => {
		e.preventDefault();

		const errs = validate(formData, plzValid, t);
		if (Object.keys(errs).length > 0) {
			setErrors(errs);
			return;
		}

		// Step 1 — log raw ContactFormDTO (mirrors Java portlet behaviour)
		console.group('[ContactFormReact] === Raw ContactFormDTO ===');
		Object.entries(formData).forEach(([k, v]) => console.log(`${k}: ${v}`));
		console.groupEnd();

		// Step 2 — build ContactApplicationDTO with enrichment/conversion
		const income = parseFloat(formData.annualIncome) || 0;
		const age    = calcAge(formData.dateOfBirth);

		const applicationDTO = {
			fullName:           `${formData.firstName} ${formData.lastName}`.trim(),
			email:              formData.email.toLowerCase().trim(),
			phone:              formData.phone.replace(/[\s\-()]+/g, ''),
			age,
			isMinor:            age >= 0 && age < 18,
			formattedAddress:   `${formData.street} ${formData.houseNumber}, ${formData.postalCode} ${formData.city}`,
			country:            formData.country,
			employmentCategory: mapEmploymentCategory(formData.employmentType),
			annualIncomeEur:    income,
			annualIncomeUsd:    +(income * EUR_TO_USD_RATE).toFixed(2),
		};

		// Step 3 — log converted ApplicationDTO
		console.group('[ContactFormReact] === ContactApplicationDTO (converted) ===');
		Object.entries(applicationDTO).forEach(([k, v]) => console.log(`${k}: ${v}`));
		console.log(`[rate: ${EUR_TO_USD_RATE}]`);
		console.groupEnd();

		setSubmitted(true);
	};

	const handleReset = () => {
		setSubmitted(false);
		setFormData(INITIAL_FORM);
		setErrors({});
		setActiveSection(0);
		setCountryDetail(null);
		setPlzStatus('idle');
		setPlzValid(null);
		setPlzLocality('');
	};

	// ---- Success state ----
	if (submitted) {
		return <SuccessView message={successMessage} onReset={handleReset} />;
	}

	// ---- Form state ----
	return (
		<div className="cfp-wrap">

			{/* Page header */}
			<div className="cfp-page-header">
				<h1 className="cfp-page-title">{t('title')}</h1>
				<p className="cfp-page-subtitle">
					{t('subtitle')}
				</p>
			</div>

			{/* Step tabs */}
			<div className="cfp-tabs">
				{[t('tab_personal'), t('tab_address'), t('tab_employment')].map((label, i) => (
					<span key={i} className={`cfp-tab${activeSection === i ? ' active' : ''}`}>
						<span className="cfp-tab-num">{i + 1}</span>
						{label}
					</span>
				))}
			</div>

			<form noValidate onSubmit={handleSubmit}>

				{/* ===== SECTION 1: PERSONAL INFORMATION ===== */}
				<div className="cfp-section cfp-section-personal" onFocus={() => setActiveSection(0)}>
					<h3 className="cfp-section-title">
						<span className="cfp-section-num">1</span>
						{t('section_personal')}
					</h3>

					<div className="row">
						<div className="col-sm-6">
							<Field label={t('label_firstName')} name="firstName" value={formData.firstName}
								onChange={handleChange} error={errors.firstName} required />
						</div>
						<div className="col-sm-6">
							<Field label={t('label_lastName')} name="lastName" value={formData.lastName}
								onChange={handleChange} error={errors.lastName} required />
						</div>
					</div>

					<div className="row">
						<div className="col-sm-6">
							<Field label={t('label_email')} name="email" type="email" value={formData.email}
								onChange={handleChange} error={errors.email} required />
						</div>
						<div className="col-sm-6">
							<Field label={t('label_phone')} name="phone" value={formData.phone}
								onChange={handleChange} error={errors.phone} required />
						</div>
					</div>

					<div className="row">
						<div className="col-sm-5">
							<Field label={t('label_dob')} name="dateOfBirth" type="date"
								value={formData.dateOfBirth} onChange={handleChange}
								error={errors.dateOfBirth} required />
						</div>
					</div>
				</div>

				{/* ===== SECTION 2: ADDRESS ===== */}
				<div className="cfp-section cfp-section-address" onFocus={() => setActiveSection(1)}>
					<h3 className="cfp-section-title">
						<span className="cfp-section-num">2</span>
						{t('section_address')}
					</h3>

					<div className="row">
						<div className="col-sm-8">
							<Field label={t('label_street')} name="street" value={formData.street}
								onChange={handleChange} error={errors.street} required />
						</div>
						<div className="col-sm-4">
							<Field label={t('label_houseNumber')} name="houseNumber" value={formData.houseNumber}
								onChange={handleChange} error={errors.houseNumber} required />
						</div>
					</div>

					<div className="row">
						<div className="col-sm-3">
							{/* Postal code with German PLZ live validation */}
							<div className="form-group">
								<label className="control-label">
									{t('label_postalCode')} <span className="text-danger">*</span>
								</label>
								<div className="cfp-plz-wrap">
									<input
										className={`form-control${errors.postalCode ? ' cfp-input-error' : ''}`}
										maxLength={10}
										name="postalCode"
										type="text"
										value={formData.postalCode}
										onChange={handleChange}
									/>
									{plzStatus !== 'idle' && (
										<span className={`cfp-plz-icon cfp-plz-${plzStatus}`}>
											{plzStatus === 'checking' &&
												<span className="glyphicon glyphicon-refresh spinning" />}
											{plzStatus === 'valid' &&
												<span className="glyphicon glyphicon-ok-sign" />}
											{plzStatus === 'invalid' &&
												<span className="glyphicon glyphicon-remove-sign" />}
										</span>
									)}
								</div>
								{errors.postalCode && (
									<small className="cfp-plz-locality cfp-plz-locality--error"
										style={{ display: 'block' }}>
										{errors.postalCode}
									</small>
								)}
								{!errors.postalCode && plzLocality && plzStatus === 'valid' && (
									<small className="cfp-plz-locality cfp-plz-locality--valid"
										style={{ display: 'block' }}>
										{plzLocality}
									</small>
								)}
							</div>
						</div>
						<div className="col-sm-9">
							<Field label={t('label_city')} name="city" value={formData.city}
								onChange={handleChange} error={errors.city} required />
						</div>
					</div>

					{/* Country dropdown */}
					<div className="form-group">
						<label className="control-label">
							{t('label_country')} <span className="text-danger">*</span>
						</label>
						{countriesLoading ? (
							<div className="cfp-fetching">
								<span className="glyphicon glyphicon-refresh spinning" />
								{' '}{t('fetching_countries')}
							</div>
						) : (
							<select
								className={`form-control${errors.country ? ' cfp-input-error' : ''}`}
								name="country"
								value={formData.country}
								onChange={handleChange}
							>
								<option value="">{t('placeholder_select')}</option>
								{countries.map(c => <option key={c} value={c}>{c}</option>)}
							</select>
						)}
						{errors.country && <small className="cfp-field-error">{errors.country}</small>}
					</div>

					{/* Country detail panel */}
					{formData.country && (
						<CountryDetail detail={countryDetail} loading={detailLoading} />
					)}
				</div>

				{/* ===== SECTION 3: EMPLOYMENT & FINANCES ===== */}
				<div className="cfp-section cfp-section-employment" onFocus={() => setActiveSection(2)}>
					<h3 className="cfp-section-title">
						<span className="cfp-section-num">3</span>
						{t('section_employment')}
					</h3>

					<div className="row">
						<div className="col-sm-6">
							<div className="form-group">
								<label className="control-label">
									{t('label_employmentType')} <span className="text-danger">*</span>
								</label>
								<select
									className={`form-control${errors.employmentType ? ' cfp-input-error' : ''}`}
									name="employmentType"
									value={formData.employmentType}
									onChange={handleChange}
								>
									<option value="">{t('placeholder_select')}</option>
									<option value="employed">{t('employment_employed')}</option>
									<option value="self-employed">{t('employment_selfEmployed')}</option>
									<option value="unemployed">{t('employment_unemployed')}</option>
									<option value="student">{t('employment_student')}</option>
									<option value="retired">{t('employment_retired')}</option>
								</select>
								{errors.employmentType && (
									<small className="cfp-field-error">{errors.employmentType}</small>
								)}
							</div>
						</div>
						<div className="col-sm-6">
							<div className="form-group">
								<label className="control-label">
									{t('label_annualIncome')} <span className="text-danger">*</span>
								</label>
								<div className="input-group">
									<span className="input-group-addon cfp-income-addon">
										<span className="glyphicon glyphicon-euro" />
									</span>
									<input
										className={`form-control${errors.annualIncome ? ' cfp-input-error' : ''}`}
										min="0"
										name="annualIncome"
										step="0.01"
										type="number"
										value={formData.annualIncome}
										onChange={handleChange}
									/>
								</div>
								{errors.annualIncome && (
									<small className="cfp-field-error">{errors.annualIncome}</small>
								)}
							</div>
						</div>
					</div>
				</div>

				{/* Submit footer */}
				<div className="cfp-form-footer">
					<button className="cfp-btn-senden" type="submit">
						{t('btn_submit')}
					</button>
					<p className="cfp-required-note">
						<span className="text-danger">*</span> {t('required_note')}
					</p>
				</div>

			</form>
		</div>
	);
}
