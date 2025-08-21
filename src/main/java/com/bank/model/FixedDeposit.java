package com.bank.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class FixedDeposit {
	private long id;
	private long customerId;
	private BigDecimal principal;
	private int tenureMonths;
	private String status;
	private String startDate;
	private Timestamp maturityDate;
	private BigDecimal interestRate;
	private long accountId;

	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	private String fd_number;

	public String getFd_number() {
		return fd_number;
	}

	public void setFd_number(String fd_number) {
		this.fd_number = fd_number;
	}

	public long getAccountId() {
		return accountId;
	}

	public void setAccountId(long accountId) {
		this.accountId = accountId;
	}

	// Getters and setters
	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public long getCustomerId() {
		return customerId;
	}

	public void setCustomerId(long customerId) {
		this.customerId = customerId;
	}

	public BigDecimal getPrincipal() {
		return principal;
	}

	public void setPrincipal(BigDecimal principal) {
		this.principal = principal;
	}

	public int getTenureMonths() {
		return tenureMonths;
	}

	public void setTenureMonths(int tenureMonths) {
		this.tenureMonths = tenureMonths;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Timestamp getMaturityDate() {
		return maturityDate;
	}

	public void setMaturityDate(Timestamp maturityDate) {
		this.maturityDate = maturityDate;
	}

	public BigDecimal getInterestRate() {
		return interestRate;
	}

	// In FixedDeposit.java

	private String fdNumber;

	public String getFdNumber() {
		return fdNumber;
	}

	public void setFdNumber(String fdNumber) {
		this.fdNumber = fdNumber;
	}

	public void setInterestRate(BigDecimal interestRate) {
		this.interestRate = interestRate;
	}

	private String customerName;

	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

}
