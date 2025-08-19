package com.bank.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Transfer {
    private long id;
    private long fromAccountId;
    private long beneficiaryId;
    private BigDecimal amount;
    private String status;
    private String referenceNo;
    private Timestamp createdAt;

    // Getters and setters
    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public long getFromAccountId() { return fromAccountId; }
    public void setFromAccountId(long fromAccountId) { this.fromAccountId = fromAccountId; }

    public long getBeneficiaryId() { return beneficiaryId; }
    public void setBeneficiaryId(long beneficiaryId) { this.beneficiaryId = beneficiaryId; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getReferenceNo() { return referenceNo; }
    public void setReferenceNo(String referenceNo) { this.referenceNo = referenceNo; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
