import React from 'react';
import { useTranslation } from 'react-i18next';

export default function SuccessView({ message, onReset }) {
	const { t } = useTranslation();

	return (
		<div className="cfp-wrap">

			<div className="cfp-success-page-header">
				<h2>{t('success_header')}</h2>
			</div>

			<div className="cfp-success-card">

				{/* Animated checkmark */}
				<div className="cfp-checkmark-wrap">
					<div className="cfp-checkmark-circle">
						<span className="glyphicon glyphicon-ok cfp-checkmark-icon" />
					</div>
				</div>

				{/* Title */}
				<h2 className="cfp-success-title">{t('success_title')}</h2>

				{/* Configurable message in green callout */}
				<div className="cfp-success-message-box">
					<p>{message}</p>
				</div>

				<hr className="cfp-success-divider" />

				{/* Reset button */}
				<button className="cfp-btn-reset" onClick={onReset} type="button">
					<span className="glyphicon glyphicon-plus" />
					{' '}{t('btn_reset')}
				</button>

			</div>
		</div>
	);
}
