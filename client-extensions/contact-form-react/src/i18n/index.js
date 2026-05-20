import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';

import en from './locales/en/translation.json';
import de from './locales/de/translation.json';
import fr from './locales/fr/translation.json';
import da from './locales/da/translation.json';

const SUPPORTED = ['de', 'fr', 'da'];

function detectLocale() {
	// Liferay sets <html lang="de_DE"> — fall back to browser language.
	const raw = document.documentElement.lang || navigator.language || 'en';
	const code = raw.split(/[-_]/)[0].toLowerCase();
	return SUPPORTED.includes(code) ? code : 'en';
}

i18n
	.use(initReactI18next)
	.init({
		resources: {
			en: { translation: en },
			de: { translation: de },
			fr: { translation: fr },
			da: { translation: da },
		},
		lng: detectLocale(),
		fallbackLng: 'en',
		interpolation: { escapeValue: false },
	});

export default i18n;
