import React from 'react';

export default function SuccessView({ message, onReset }) {
	return (
		<div className="cfp-wrap">

			<div className="cfp-success-page-header">
				<h2>Contact Form</h2>
			</div>

			<div className="cfp-success-card">

				{/* Animated checkmark */}
				<div className="cfp-checkmark-wrap">
					<div className="cfp-checkmark-circle">
						<span className="glyphicon glyphicon-ok cfp-checkmark-icon" />
					</div>
				</div>

				{/* Title */}
				<h2 className="cfp-success-title">Form Submitted Successfully!</h2>

				{/* Configurable message in green callout */}
				<div className="cfp-success-message-box">
					<p>{message}</p>
				</div>

				<hr className="cfp-success-divider" />

				{/* Reset button */}
				<button className="cfp-btn-reset" onClick={onReset} type="button">
					<span className="glyphicon glyphicon-plus" />
					{' '}Submit Another Response
				</button>

			</div>
		</div>
	);
}
