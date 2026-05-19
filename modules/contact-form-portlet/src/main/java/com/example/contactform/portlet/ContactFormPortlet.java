package com.example.contactform.portlet;

import com.example.contactform.client.CountryRestClient;
import com.example.contactform.constants.ContactFormPortletKeys;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Collections;
import java.util.List;

import javax.portlet.Portlet;
import javax.portlet.PortletException;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;

import org.osgi.service.component.annotations.Component;

@Component(
	immediate = true,
	property = {
		"com.liferay.portlet.display-category=category.sample",
		"com.liferay.portlet.instanceable=true",
		"javax.portlet.display-name=Contact Form Portlet",
		"javax.portlet.init-param.template-path=/",
		"javax.portlet.init-param.view-template=/view.jsp",
		"javax.portlet.name=" + ContactFormPortletKeys.CONTACT_FORM,
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=power-user,user"
	},
	service = Portlet.class
)
public class ContactFormPortlet extends MVCPortlet {

	@Override
	public void serveResource(
			ResourceRequest resourceRequest, ResourceResponse resourceResponse)
		throws IOException, PortletException {

		resourceResponse.setContentType("application/json");
		resourceResponse.setCharacterEncoding("UTF-8");

		List<String> countries = Collections.emptyList();

		try {
			countries = new CountryRestClient().fetchCountryNames();
		}
		catch (Exception e) {
			_log.error("Failed to fetch countries from REST API", e);
		}

		StringBuilder json = new StringBuilder("[");

		for (int i = 0; i < countries.size(); i++) {
			if (i > 0) {
				json.append(",");
			}

			json.append("\"")
				.append(countries.get(i).replace("\\", "\\\\").replace("\"", "\\\""))
				.append("\"");
		}

		json.append("]");

		PrintWriter writer = resourceResponse.getWriter();

		writer.write(json.toString());
	}

	private static final Log _log = LogFactoryUtil.getLog(
		ContactFormPortlet.class);

}