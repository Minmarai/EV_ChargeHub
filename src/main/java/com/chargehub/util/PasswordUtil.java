package com.chargehub.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility class for hashing and verifying user passwords using the BCrypt algorithm.
 *
 * <p>BCrypt is a password-hashing function designed to be computationally expensive,
 * making brute-force and rainbow table attacks significantly harder compared to
 * general-purpose hash functions such as MD5 or SHA-256.</p>
 *
 * <p>This class uses the {@link BCrypt} implementation provided by the
 * {@code org.mindrot.jbcrypt} library. All methods are static and this class
 * is not intended to be instantiated.</p>
 *
 * <p><strong>Usage pattern:</strong></p>
 * <pre>{@code
 * // On registration:
 * String hash = PasswordUtil.hashPassword(plainTextPassword);
 * // store hash in the database
 *
 * // On login:
 * boolean valid = PasswordUtil.checkPassword(plainTextPassword, storedHash);
 * }</pre>
 *
 * <p>Author: Denisha Tamang</p>
 */
public class PasswordUtil {

    /**
     * Private constructor to prevent instantiation of this utility class.
     *
     * <p>All members of this class are static. This class should never
     * be instantiated directly.</p>
     */
    private PasswordUtil() {}

    /**
     * Hashes a plain text password using the BCrypt algorithm with a cost factor of {@code 10}.
     *
     * <p>A new random salt is generated on every invocation via {@link BCrypt#gensalt(int)},
     * meaning two calls with the same input will always produce different hash strings.
     * The salt is embedded within the returned hash string and does not need to be
     * stored separately.</p>
     *
     * <p>The cost factor of {@code 10} means the hashing requires {@code 2^10 = 1024}
     * rounds of processing. Higher values increase security but also increase
     * computation time. A value of {@code 10} is the widely accepted default
     * for most web applications.</p>
     *
     * <p><strong>Note:</strong> This method does not validate whether
     * {@code plainPassword} is {@code null}. Passing {@code null} will result
     * in a {@link NullPointerException} thrown by the underlying BCrypt library.
     * Callers should validate input before invoking this method.</p>
     *
     * @param plainPassword the raw plain text password to hash; must not be {@code null}
     * @return a BCrypt hash string containing the embedded salt and hashed password,
     *         suitable for direct storage in the database
     */
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(10));
    }

    /**
     * Verifies a plain text password against a previously stored BCrypt hash.
     *
     * <p>Uses {@link BCrypt#checkpw(String, String)} which internally extracts
     * the salt from the stored hash and re-hashes the plain text password for
     * comparison. This means the original salt does not need to be passed
     * separately — it is already embedded in {@code hashedPassword}.</p>
     *
     * <p>Returns {@code false} immediately if either argument is {@code null},
     * without invoking the BCrypt library. This guards against
     * {@link NullPointerException} that would otherwise be thrown by
     * {@link BCrypt#checkpw(String, String)}.</p>
     *
     * <p><strong>Note:</strong> This method performs a constant-time comparison
     * internally via the BCrypt library, which helps protect against
     * timing-based side-channel attacks.</p>
     *
     * @param plainPassword  the raw plain text password provided by the user at login;
     *                       may be {@code null} (returns {@code false} safely)
     * @param hashedPassword the BCrypt hash string previously stored in the database,
     *                       as returned by {@link #hashPassword(String)};
     *                       may be {@code null} (returns {@code false} safely)
     * @return {@code true} if the plain text password matches the stored hash;
     *         {@code false} if they do not match or if either argument is {@code null}
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) return false;
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }
}
