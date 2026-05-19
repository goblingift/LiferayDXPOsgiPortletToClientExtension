package com.example.contactform.client;

import com.example.contactform.portlet.ContactFormPortlet;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;


import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class CountryRestClient {

	private static final Log _log = LogFactoryUtil.getLog(
			CountryRestClient.class);

	private static final String ALL_URL =
		"https://restcountries.com/v3.1/all?fields=name";

	private static final String DETAIL_URL =
		"https://restcountries.com/v3.1/name/%s?fullText=true" +
		"&fields=name,capital,population,region,subregion,languages," +
		"currencies,timezones,flags,coatOfArms,maps,borders";

	private static final int TIMEOUT_SECONDS = 10;

	public List<String> fetchCountryNames() throws Exception {
		String body = _get(ALL_URL);

		List<String> countryNames = new ArrayList<>();

		JSONArray jsonArray = JSONFactoryUtil.createJSONArray(body);

		for (int i = 0; i < jsonArray.length(); i++) {
			JSONObject country = jsonArray.getJSONObject(i);
			JSONObject name = country.getJSONObject("name");

			countryNames.add(name.getString("common"));
		}

		Collections.sort(countryNames);

		return countryNames;
	}

	public String fetchCountryDetails(String countryName) throws Exception {
		String encoded = URLEncoder.encode(countryName, StandardCharsets.UTF_8);
		String body = _get(String.format(DETAIL_URL, encoded)).trim();

		// API returns [{...}] — strip the array wrapper to get the object directly
		if (body.startsWith("[") && body.endsWith("]")) {
			body = body.substring(1, body.length() - 1).trim();
		}

		return body.isEmpty() ? "{}" : body;
	}

	private String _get(String url) throws Exception {
		HttpClient client = HttpClient.newBuilder()
			.connectTimeout(Duration.ofSeconds(TIMEOUT_SECONDS))
			.build();

		_log.info("Executing request " + url);

		HttpRequest request = HttpRequest.newBuilder()
			.uri(URI.create(url))
			.timeout(Duration.ofSeconds(TIMEOUT_SECONDS))
			.GET()
			.build();

		// Explicitly decode as UTF-8 to preserve special characters
		return client.send(
			request,
			HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8)
		).body();
	}

}