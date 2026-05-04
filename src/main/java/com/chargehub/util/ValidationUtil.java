package com.chargehub.util;

/**
 * Utility class providing common input validation helpers for user-submitted data.
 *
 * <p>All methods are static and perform lightweight, regex-based or null-safe
 * checks. This class is not intended to be instantiated.</p>
 *
 * <p><strong>Usage pattern:</strong></p>
 * <pre>{@code
 * if (ValidationUtil.isBlank(name)) {
 *     // reject empty input
 * }
 * if (!ValidationUtil.isEmail(email)) {
 *     // reject invalid email
 * }
 * if (!ValidationUtil.isPhone(phone)) {
 *     // reject invalid phone number
 * }
 * }</pre>
 */
public class ValidationUtil {

    /**
     * Private constructor to prevent instantiation of this utility class.
     *
     * <p>All members of this class are static. This class should never
     * be instantiated directly.</p>
     */
    private ValidationUtil() {}

    /**
     * Checks whether a string is blank — that is, {@code null}, empty,
     * or containing only whitespace characters.
     *
     * <p>This method is null-safe and will not throw a
     * {@link NullPointerException} if {@code value} is {@code null}.</p>
     *
     * <p>Typical usage is to validate required form fields before
     * further processing:</p>
     * <pre>{@code
     * if (ValidationUtil.isBlank(username)) {
     *     throw new IllegalArgumentException("Username must not be blank.");
     * }
     * }</pre>
     *
     * @param value the string to check; may be {@code null}
     * @return {@code true} if {@code value} is {@code null}, empty,
     *         or contains only whitespace; {@code false} otherwise
     */
    public static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    /**
     * Checks whether a string is a valid email address format.
     *
     * <p>Validation is performed against the following regular expression:</p>
     * <pre>{@code ^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$ }</pre>
     *
     * <p>This pattern accepts the most commonly used email formats but is
     * intentionally simplified — it does not cover the full RFC 5322 specification.
     * Edge cases such as quoted local parts, IP address domains, or internationalised
     * addresses will not be matched and will return {@code false}.</p>
     *
     * <p>Returns {@code false} immediately if {@code email} is {@code null},
     * without attempting the regex match.</p>
     *
     * <p>Examples of accepted values: {@code user@example.com},
     * {@code first.last@domain.org}, {@code user+tag@mail.co.np}.</p>
     *
     * <p>Examples of rejected values: {@code plainaddress}, {@code @domain.com},
     * {@code user@}, {@code null}.</p>
     *
     * @param email the string to validate as an email address; may be {@code null}
     * @return {@code true} if {@code email} is non-null and matches the expected
     *         email format; {@code false} otherwise
     */
    public static boolean isEmail(String email) {
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");
    }

    /**
     * Checks whether a string is a valid 10-digit phone number.
     *
     * <p>Validation is performed against the following regular expression:</p>
     * <pre>{@code ^[0-9]{10}$ }</pre>
     *
     * <p>Only strings consisting of exactly 10 numeric digits are accepted.
     * Spaces, hyphens, parentheses, country code prefixes (e.g. {@code +977}),
     * and any other non-digit characters will cause the check to return {@code false}.</p>
     *
     * <p>Returns {@code false} immediately if {@code phone} is {@code null},
     * without attempting the regex match.</p>
     *
     * <p>Examples of accepted values: {@code 9812345678}, {@code 0123456789}.</p>
     *
     * <p>Examples of rejected values: {@code 981-234-5678}, {@code +9779812345678},
     * {@code 98123456} (too short), {@code 98123456789} (too long), {@code null}.</p>
     *
     * @param phone the string to validate as a phone number; may be {@code null}
     * @return {@code true} if {@code phone} is non-null and consists of exactly
     *         10 numeric digits; {@code false} otherwise
     */
    public static boolean isPhone(String phone) {
        return phone != null && phone.matches("^[0-9]{10}$");
    }
}