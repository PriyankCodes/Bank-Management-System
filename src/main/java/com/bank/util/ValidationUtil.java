package com.bank.util;

import java.util.regex.Pattern;

public class ValidationUtil {

    private static final Pattern EMAIL_PATTERN =
        Pattern.compile("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$");

    /**
     * Check if a string is not null and not empty after trim.
     */
    public static boolean isRequired(String value) {
        return value != null && !value.trim().isEmpty();
    }

    /**
     * Validate email format.
     */
    public static boolean isValidEmail(String email) {
        if (email == null) return false;
        return EMAIL_PATTERN.matcher(email).matches();
    }

    /**
     * Check if string is a valid positive integer.
     */
    public static boolean isPositiveInteger(String value) {
        if (value == null) return false;
        try {
            int num = Integer.parseInt(value.trim());
            return num > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    /**
     * Check if string is a valid positive decimal number.
     */
    public static boolean isPositiveDecimal(String value) {
        if (value == null) return false;
        try {
            double num = Double.parseDouble(value.trim());
            return num > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    /**
     * Check if string length is within min and max inclusive.
     */
    public static boolean isLengthBetween(String value, int min, int max) {
        if (value == null) return false;
        int len = value.trim().length();
        return len >= min && len <= max;
    }
}
