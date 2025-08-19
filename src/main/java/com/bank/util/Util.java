package com.bank.util;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

public class Util {

    // Validate email format (simple regex)
    public static boolean isValidEmail(String email) {
        if (email == null) return false;
        return email.matches("^[A-Za-z0-9+_.-]+@(.+)$");
    }

    // Validate phone number (digits, optional plus, length 7-15)
    public static boolean isValidPhone(String phone) {
        if (phone == null) return false;
        return phone.matches("^\\+?[0-9]{7,15}$");
    }

    // Validate password (e.g., min length, at least one number; adjust rules)
    public static boolean isValidPassword(String password) {
        if (password == null || password.length() < 6) return false;
        return password.matches(".*\\d.*"); // at least one number
    }

    // Parse date safely, returns null if invalid
    public static LocalDate parseDate(String dateStr) {
        if (dateStr == null || dateStr.isEmpty()) return null;
        try {
            return LocalDate.parse(dateStr);
        } catch (DateTimeParseException e) {
            return null;
        }
    }

    // Validate minimum deposit amount ≥ 1000
    public static boolean isValidInitialDeposit(BigDecimal amount) {
        return amount != null && amount.compareTo(new BigDecimal("1000")) >= 0;
    }

    // Validate positive amount (for transfers/payments)
    public static boolean isValidAmount(BigDecimal amount) {
        return amount != null && amount.compareTo(BigDecimal.ZERO) > 0;
    }

    // Sanitize input string (trim, null safe)
    public static String safeString(String s) {
        return s == null ? null : s.trim();
    }
    

    public static boolean isValidBeneficiaryName(String name) {
        if (name == null) return false;
        return name.trim().length() >= 2; // minimal name length
    }

    public static boolean isValidAccountNumber(String accountNumber) {
        if (accountNumber == null) return false;
        return accountNumber.trim().matches("^[A-Za-z0-9]+$"); // alphanumeric only, adjust as needed
    }

    public static boolean isValidBankName(String bankName) {
        if (bankName == null) return false;
        return bankName.trim().length() >= 2;
    }

}
