package com.bank.model;

import java.math.BigDecimal;

public class FixedDepositRate {
    private long id;
    private String accountType;   // e.g., "SAVINGS", "CURRENT", etc.
    private BigDecimal ratePercent;
    private String status;        // e.g., "ACTIVE", "INACTIVE"
    
    // Getters and setters
    public long getId() {
        return id;
    }
    public void setId(long id) {
        this.id = id;
    }
    public String getAccountType() {
        return accountType;
    }
    public void setAccountType(String accountType) {
        this.accountType = accountType;
    }
    public BigDecimal getRatePercent() {
        return ratePercent;
    }
    public void setRatePercent(BigDecimal ratePercent) {
        this.ratePercent = ratePercent;
    }
    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }
}
