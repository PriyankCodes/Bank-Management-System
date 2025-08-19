package com.bank.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Account {
    private long id;
    private String accountNumber;
    private long customerId;
    private String type;
    private String status;
    private BigDecimal balance;
    private Timestamp openedAt;

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public String getAccountNumber() { return accountNumber; }
    public void setAccountNumber(String accountNumber) { this.accountNumber = accountNumber; }

    public long getCustomerId() { return customerId; }
    public void setCustomerId(long customerId) { this.customerId = customerId; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public BigDecimal getBalance() { return balance; }
    public void setBalance(BigDecimal balance) { this.balance = balance; }

    public Timestamp getOpenedAt() { return openedAt; }
    public void setOpenedAt(Timestamp openedAt) { this.openedAt = openedAt; }
}
