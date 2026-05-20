package com.example.contactform.dto;

/**
 * Raw form data exactly as submitted by the user — all strings, no conversion.
 */
public class ContactFormDTO {

	public String getAnnualIncome() {
		return _annualIncome;
	}

	public String getCity() {
		return _city;
	}

	public String getCountry() {
		return _country;
	}

	public String getDateOfBirth() {
		return _dateOfBirth;
	}

	public String getEmail() {
		return _email;
	}

	public String getEmploymentType() {
		return _employmentType;
	}

	public String getFirstName() {
		return _firstName;
	}

	public String getHouseNumber() {
		return _houseNumber;
	}

	public String getLastName() {
		return _lastName;
	}

	public String getPhone() {
		return _phone;
	}

	public String getPostalCode() {
		return _postalCode;
	}

	public String getStreet() {
		return _street;
	}

	public void setAnnualIncome(String annualIncome) {
		_annualIncome = annualIncome;
	}

	public void setCity(String city) {
		_city = city;
	}

	public void setCountry(String country) {
		_country = country;
	}

	public void setDateOfBirth(String dateOfBirth) {
		_dateOfBirth = dateOfBirth;
	}

	public void setEmail(String email) {
		_email = email;
	}

	public void setEmploymentType(String employmentType) {
		_employmentType = employmentType;
	}

	public void setFirstName(String firstName) {
		_firstName = firstName;
	}

	public void setHouseNumber(String houseNumber) {
		_houseNumber = houseNumber;
	}

	public void setLastName(String lastName) {
		_lastName = lastName;
	}

	public void setPhone(String phone) {
		_phone = phone;
	}

	public void setPostalCode(String postalCode) {
		_postalCode = postalCode;
	}

	public void setStreet(String street) {
		_street = street;
	}

	@Override
	public String toString() {
		return "ContactFormDTO{" +
			"firstName='" + _firstName + '\'' +
			", lastName='" + _lastName + '\'' +
			", email='" + _email + '\'' +
			", phone='" + _phone + '\'' +
			", dateOfBirth='" + _dateOfBirth + '\'' +
			", street='" + _street + '\'' +
			", houseNumber='" + _houseNumber + '\'' +
			", postalCode='" + _postalCode + '\'' +
			", city='" + _city + '\'' +
			", country='" + _country + '\'' +
			", employmentType='" + _employmentType + '\'' +
			", annualIncome='" + _annualIncome + '\'' +
			'}';
	}

	private String _annualIncome;
	private String _city;
	private String _country;
	private String _dateOfBirth;
	private String _email;
	private String _employmentType;
	private String _firstName;
	private String _houseNumber;
	private String _lastName;
	private String _phone;
	private String _postalCode;
	private String _street;

}