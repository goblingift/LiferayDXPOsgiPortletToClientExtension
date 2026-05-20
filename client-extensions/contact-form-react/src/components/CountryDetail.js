import React from 'react';

export default function CountryDetail({ detail, loading }) {
	if (loading) {
		return (
			<div className="cfp-country-detail">
				<div className="panel-body text-center" style={{ padding: '24px' }}>
					<span className="cfp-fetching">
						<span className="glyphicon glyphicon-refresh spinning" />
						{' '}Loading country details...
					</span>
				</div>
			</div>
		);
	}

	if (!detail) return null;

	const langs = detail.languages
		? Object.values(detail.languages).join(', ')
		: '—';

	const currencies = detail.currencies
		? Object.values(detail.currencies)
			.map(c => `${c.name}${c.symbol ? ` (${c.symbol})` : ''}`)
			.join(', ')
		: '—';

	return (
		<div className="cfp-country-detail">

			{/* Header: flag + name + coat of arms */}
			<div className="cfp-detail-header">
				{detail.flags?.png && (
					<img
						alt={detail.flags?.alt || ''}
						className="cfp-flag"
						src={detail.flags.png}
					/>
				)}
				<div>
					<strong style={{ fontSize: '16px' }}>{detail.name?.common}</strong>
					<br />
					<small className="text-muted">{detail.name?.official}</small>
				</div>
				{detail.coatOfArms?.png && (
					<div className="cfp-coat-wrap" style={{ marginLeft: 'auto', textAlign: 'center' }}>
						<img alt="Coat of Arms" className="cfp-coat" src={detail.coatOfArms.png} />
						<div><small className="text-muted">Coat of Arms</small></div>
					</div>
				)}
			</div>

			{/* Detail table */}
			<div className="panel-body" style={{ padding: '12px 18px' }}>
				<table className="table table-condensed cfp-info-table">
					<tbody>
						<tr>
							<td><span className="glyphicon glyphicon-map-marker text-muted" /> Capital</td>
							<td>{detail.capital?.join(', ') || '—'}</td>
						</tr>
						<tr>
							<td><span className="glyphicon glyphicon-user text-muted" /> Population</td>
							<td>{detail.population?.toLocaleString() || '—'}</td>
						</tr>
						<tr>
							<td><span className="glyphicon glyphicon-globe text-muted" /> Region</td>
							<td>{detail.region || '—'}</td>
						</tr>
						<tr>
							<td><span className="glyphicon glyphicon-indent-left text-muted" /> Subregion</td>
							<td>{detail.subregion || '—'}</td>
						</tr>
						<tr>
							<td><span className="glyphicon glyphicon-comment text-muted" /> Languages</td>
							<td>{langs}</td>
						</tr>
						<tr>
							<td><span className="glyphicon glyphicon-usd text-muted" /> Currencies</td>
							<td>{currencies}</td>
						</tr>
						<tr>
							<td><span className="glyphicon glyphicon-time text-muted" /> Timezones</td>
							<td>{detail.timezones?.join(', ') || '—'}</td>
						</tr>
						{detail.borders?.length > 0 && (
							<tr>
								<td>
									<span className="glyphicon glyphicon-resize-horizontal text-muted" /> Borders
								</td>
								<td>
									{detail.borders.map(code => (
										<span key={code} className="cfp-border-badge">{code}</span>
									))}
								</td>
							</tr>
						)}
					</tbody>
				</table>

				{detail.maps?.googleMaps && (
					<a
						className="btn btn-xs btn-default"
						href={detail.maps.googleMaps}
						rel="noopener noreferrer"
						target="_blank"
					>
						<span className="glyphicon glyphicon-map-marker" />
						{' '}View on Google Maps
					</a>
				)}
			</div>

		</div>
	);
}
