import React from 'react';
import { createRoot } from 'react-dom/client';
import ContactFormApp from './ContactFormApp';
import './css/contact-form.css';
import './i18n/index.js';

/**
 * Web component wrapper for the Contact Form React Client Extension.
 *
 * Liferay renders <contact-form-react> on the page; this class mounts the
 * React app inside it.  Pass configuration via HTML attributes:
 *
 *   data-success-message  — text shown after a successful submission
 */
class ContactFormReact extends HTMLElement {
	connectedCallback() {
		const successMessage =
			this.getAttribute('data-success-message') ||
			'Thank you! Your form has been submitted successfully. We will get back to you shortly.';

		this._root = createRoot(this);
		this._root.render(
			<React.StrictMode>
				<ContactFormApp successMessage={successMessage} />
			</React.StrictMode>
		);
	}

	disconnectedCallback() {
		this._root?.unmount();
	}
}

if (!customElements.get('contact-form-react')) {
	customElements.define('contact-form-react', ContactFormReact);
}
