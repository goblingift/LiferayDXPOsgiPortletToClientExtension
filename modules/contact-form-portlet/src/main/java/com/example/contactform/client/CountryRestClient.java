package com.example.contactform.client;

import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class CountryRestClient {

	private static final String API_URL = "https://restcountries.com/v3.1/all?fields=name";
	private static final int TIMEOUT_SECONDS = 10;

	public List<String> fetchCountryNames() throws Exception {
		HttpClient client = HttpClient.newBuilder()
			.connectTimeout(Duration.ofSeconds(TIMEOUT_SECONDS))
			.build();

		HttpRequest request = HttpRequest.newBuilder()
			.uri(URI.create(API_URL))
			.timeout(Duration.ofSeconds(TIMEOUT_SECONDS))
			.GET()
			.build();

		HttpResponse<String> response = client.send(
			request, HttpResponse.BodyHandlers.ofString());

		List<String> countryNames = new ArrayList<>();

		JSONArray jsonArray = JSONFactoryUtil.createJSONArray(response.body());

		for (int i = 0; i < jsonArray.length(); i++) {
			JSONObject country = jsonArray.getJSONObject(i);
			JSONObject name = country.getJSONObject("name");

			countryNames.add(name.getString("common"));
		}

		Collections.sort(countryNames);

		return countryNames;
	}

}