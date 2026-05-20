package com.example.contactform.portlet.configuration;

import com.example.contactform.constants.ContactFormPortletKeys;

import com.liferay.portal.kernel.portlet.ConfigurationAction;
import com.liferay.portal.kernel.portlet.DefaultConfigurationAction;
import com.liferay.portal.kernel.util.ParamUtil;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletConfig;

import org.osgi.service.component.annotations.Component;

@Component(
	immediate = true,
	property = {
		"javax.portlet.name=" + ContactFormPortletKeys.CONTACT_FORM
	},
	service = ConfigurationAction.class
)
public class ContactFormConfigurationAction extends DefaultConfigurationAction {

	@Override
	public void processAction(
			PortletConfig portletConfig, ActionRequest actionRequest,
			ActionResponse actionResponse)
		throws Exception {

		setPreference(
			actionRequest, "successMessage",
			ParamUtil.getString(actionRequest, "successMessage"));

		super.processAction(portletConfig, actionRequest, actionResponse);
	}

}