package com.example.contactform.dto;

/**
 * Application-level DTO — derived from ContactFormDTO after conversion and
 * enrichment (name combining, age calculation, income currency conversion,
 * employment category mapping, address formatting).
 */
public class ContactApplicationDTO {

	public int getAge() {
		return _age;
	}

	public double getAnnualIncomeEur() {
		return _annualIncomeEur;
	}

	public double getAnnualIncomeUsd() {
		return _annualIncomeUsd;
	}

	public String getCountry() {
		return _country;
	}

	public String getEmail() {
		return _email;
	}

	public String getEmploymentCategory() {
		return _employmentCategory;
	}

	public String getFormattedAddress() {
		return _formattedAddress;
	}

	public String getFullName() {
		return _fullName;
	}

	public String getPhone() {
		return _phone;
	}

	public boolean isMinor() {
		return _minor;
	}

	public void setAge(int age) {
		_age = age;
	}

	public void setAnnualIncomeEur(double annualIncomeEur) {
		_annualIncomeEur = annualIncomeEur;
	}

	public void setAnnualIncomeUsd(double annualIncomeUsd) {
		_annualIncomeUsd = annualIncomeUsd;
	}

	public void setCountry(String country) {
		_country = country;
	}

	public void setEmail(String email) {
		_email = email;
	}

	public void setEmploymentCategory(String employmentCategory) {
		_employmentCategory = employmentCategory;
	}

	public void setFormattedAddress(String formattedAddress) {
		_formattedAddress = formattedAddress;
	}

	public void setFullName(String fullName) {
		_fullName = fullName;
	}

	public void setMinor(boolean minor) {
		_minor = minor;
	}

	public void setPhone(String phone) {
		_phone = phone;
	}

	@Override
	public String toString() {
		return "ContactApplicationDTO{" +
			"fullName='" + _fullName + '\'' +
			", email='" + _email + '\'' +
			", phone='" + _phone + '\'' +
			", age=" + _age +
			", minor=" + _minor +
			", formattedAddress='" + _formattedAddress + '\'' +
			", country='" + _country + '\'' +
			", employmentCategory='" + _employmentCategory + '\'' +
			", annualIncomeEur=" + _annualIncomeEur +
			", annualIncomeUsd=" + _annualIncomeUsd +
			'}';
	}

	private int _age;
	private double _annualIncomeEur;
	private double _annualIncomeUsd;
	private String _country;
	private String _email;
	private String _employmentCategory;
	private String _formattedAddress;
	private String _fullName;
	private boolean _minor;
	private String _phone;

}