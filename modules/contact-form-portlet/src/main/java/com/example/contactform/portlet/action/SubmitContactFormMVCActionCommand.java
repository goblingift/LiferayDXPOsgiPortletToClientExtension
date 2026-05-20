package com.example.contactform.portlet.action;

import com.example.contactform.constants.ContactFormPortletKeys;
import com.example.contactform.dto.ContactApplicationDTO;
import com.example.contactform.dto.ContactFormDTO;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.portlet.bridges.mvc.BaseMVCActionCommand;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCActionCommand;
import com.liferay.portal.kernel.util.ParamUtil;

import java.time.LocalDate;
import java.time.Period;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;

import org.osgi.service.component.annotations.Component;

@Component(
	immediate = true,
	property = {
		"javax.portlet.name=" + ContactFormPortletKeys.CONTACT_FORM,
		"mvc.command.name=/contact_form/submit"
	},
	service = MVCActionCommand.class
)
public class SubmitContactFormMVCActionCommand extends BaseMVCActionCommand {

	@Override
	protected void doProcessAction(
			ActionRequest actionRequest, ActionResponse actionResponse)
		throws Exception {

		// Step 1 — map raw request parameters into the form DTO
		ContactFormDTO formDTO = _buildFormDTO(actionRequest);

		_log.info("=== Raw ContactFormDTO ===");
		_log.info(formDTO.toString());

		// Step 2 — convert / enrich into the application DTO
		ContactApplicationDTO applicationDTO = _toApplicationDTO(formDTO);

		// Step 3 — log the fully converted application DTO
		_logApplicationDTO(applicationDTO);
	}

	// ---- Step 1: form DTO assembly ----

	private ContactFormDTO _buildFormDTO(ActionRequest actionRequest) {
		ContactFormDTO dto = new ContactFormDTO();

		dto.setFirstName(ParamUtil.getString(actionRequest, "firstName"));
		dto.setLastName(ParamUtil.getString(actionRequest, "lastName"));
		dto.setEmail(ParamUtil.getString(actionRequest, "email"));
		dto.setPhone(ParamUtil.getString(actionRequest, "phone"));
		dto.setDateOfBirth(ParamUtil.getString(actionRequest, "dateOfBirth"));
		dto.setStreet(ParamUtil.getString(actionRequest, "street"));
		dto.setHouseNumber(ParamUtil.getString(actionRequest, "houseNumber"));
		dto.setCity(ParamUtil.getString(actionRequest, "city"));
		dto.setPostalCode(ParamUtil.getString(actionRequest, "postalCode"));
		dto.setCountry(ParamUtil.getString(actionRequest, "country"));
		dto.setEmploymentType(ParamUtil.getString(actionRequest, "employmentType"));
		dto.setAnnualIncome(ParamUtil.getString(actionRequest, "annualIncome"));

		return dto;
	}

	// ---- Step 2: conversion / enrichment ----

	private ContactApplicationDTO _toApplicationDTO(ContactFormDTO formDTO) {
		ContactApplicationDTO dto = new ContactApplicationDTO();

		// Combine names into a single display name
		dto.setFullName(
			(formDTO.getFirstName() + " " + formDTO.getLastName()).trim());

		// Normalise email to lower-case
		dto.setEmail(formDTO.getEmail().toLowerCase().trim());

		// Strip formatting characters from phone for storage
		dto.setPhone(formDTO.getPhone().replaceAll("[\\s\\-\\(\\)]+", ""));

		// Derive age and minor flag from ISO date string (yyyy-MM-dd)
		int age = _calculateAge(formDTO.getDateOfBirth());
		dto.setAge(age);
		dto.setMinor(age >= 0 && age < 18);

		// Build a single-line formatted address
		dto.setFormattedAddress(
			formDTO.getStreet() + " " + formDTO.getHouseNumber() + ", " +
			formDTO.getPostalCode() + " " + formDTO.getCity());

		dto.setCountry(formDTO.getCountry());

		// Map UI employment value to internal category code
		dto.setEmploymentCategory(
			_mapEmploymentCategory(formDTO.getEmploymentType()));

		// Parse income and convert EUR → USD with a dummy exchange rate
		double incomeEur = _parseIncome(formDTO.getAnnualIncome());
		dto.setAnnualIncomeEur(incomeEur);
		dto.setAnnualIncomeUsd(incomeEur * _EUR_TO_USD_RATE);

		return dto;
	}

	private int _calculateAge(String dateOfBirthStr) {
		if ((dateOfBirthStr == null) || dateOfBirthStr.isEmpty()) {
			return -1;
		}

		try {
			LocalDate dob = LocalDate.parse(
				dateOfBirthStr, DateTimeFormatter.ISO_LOCAL_DATE);

			return Period.between(dob, LocalDate.now()).getYears();
		}
		catch (DateTimeParseException e) {
			_log.warn("Could not parse date of birth: " + dateOfBirthStr);

			return -1;
		}
	}

	private String _mapEmploymentCategory(String employmentType) {
		if (employmentType == null) {
			return "UNKNOWN";
		}

		switch (employmentType) {
			case "employed":
				return "ACTIVE_WORKFORCE";
			case "self-employed":
				return "ACTIVE_WORKFORCE_INDEPENDENT";
			case "unemployed":
				return "NON_ACTIVE";
			case "student":
				return "IN_EDUCATION";
			case "retired":
				return "POST_WORKFORCE";
			default:
				return "UNKNOWN";
		}
	}

	private double _parseIncome(String raw) {
		if ((raw == null) || raw.isEmpty()) {
			return 0;
		}

		try {
			return Double.parseDouble(raw);
		}
		catch (NumberFormatException e) {
			_log.warn("Could not parse annualIncome: " + raw);

			return 0;
		}
	}

	// ---- Step 3: structured log output ----

	private void _logApplicationDTO(ContactApplicationDTO dto) {
		_log.info("=== ContactApplicationDTO (converted) ===");
		_log.info("Full Name:           " + dto.getFullName());
		_log.info("Email (normalised):  " + dto.getEmail());
		_log.info("Phone (normalised):  " + dto.getPhone());
		_log.info("Age:                 " + dto.getAge());
		_log.info("Is Minor:            " + dto.isMinor());
		_log.info("Address:             " + dto.getFormattedAddress());
		_log.info("Country:             " + dto.getCountry());
		_log.info("Employment Category: " + dto.getEmploymentCategory());
		_log.info(String.format(
			"Annual Income (EUR): %.2f EUR", dto.getAnnualIncomeEur()));
		_log.info(String.format(
			"Annual Income (USD): %.2f USD  [rate: %.2f]",
			dto.getAnnualIncomeUsd(), _EUR_TO_USD_RATE));
		_log.info("=========================================");
	}

	// Dummy EUR→USD exchange rate for demo purposes
	private static final double _EUR_TO_USD_RATE = 1.08;

	private static final Log _log = LogFactoryUtil.getLog(
		SubmitContactFormMVCActionCommand.class);

}