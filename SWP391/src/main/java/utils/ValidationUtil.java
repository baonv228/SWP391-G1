package utils;

public class ValidationUtil {

    private static final int MAX_SEARCH_LENGTH = 200;

    // Patterns that suggest SQL injection attempts
    private static final String[] SQL_INJECTION_PATTERNS = {
        "'", "\"", "--", ";", "/*", "*/", "xp_", "exec", "execute",
        "insert", "update", "delete", "drop", "create", "alter", "union",
        "select", "from", "where", "or 1=1", "or '1'='1'"
    };

    // Patterns that suggest XSS attempts
    private static final String[] XSS_PATTERNS = {
        "<script", "</script>", "javascript:", "onload=", "onerror=",
        "onclick=", "onmouseover=", "<iframe", "<object", "<embed",
        "alert(", "document.cookie", "window.location"
    };

    /**
     * Sanitizes input by escaping HTML special characters to prevent XSS.
     */
    public static String sanitizeInput(String input) {
        if (input == null) return null;
        return input.trim()
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#x27;")
                .replace("/", "&#x2F;");
    }

    /**
     * Validates a search keyword. Returns an error message or null if valid.
     */
    public static String validateSearchInput(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return null; // Empty is acceptable (show all)
        }

        String trimmed = keyword.trim();

        if (trimmed.length() > MAX_SEARCH_LENGTH) {
            return "Search input is too long (maximum " + MAX_SEARCH_LENGTH + " characters).";
        }

        String lower = trimmed.toLowerCase();

        for (String pattern : SQL_INJECTION_PATTERNS) {
            if (lower.contains(pattern.toLowerCase())) {
                return "Invalid search input detected. Please remove special characters.";
            }
        }

        for (String pattern : XSS_PATTERNS) {
            if (lower.contains(pattern.toLowerCase())) {
                return "Invalid search input detected. HTML/script tags are not allowed.";
            }
        }

        return null; // Valid
    }

    /**
     * Validates that a search type is one of the allowed values.
     */
    public static boolean isValidSearchType(String searchType, String... allowedValues) {
        if (searchType == null || searchType.trim().isEmpty()) return false;
        for (String allowed : allowedValues) {
            if (allowed.equalsIgnoreCase(searchType.trim())) return true;
        }
        return false;
    }

    /**
     * Validates page number parameter.
     */
    public static int parsePageNumber(String pageParam) {
        try {
            int page = Integer.parseInt(pageParam);
            return page < 1 ? 1 : page;
        } catch (NumberFormatException e) {
            return 1;
        }
    }

    /**
     * Returns true if the given value looks like an integer ID.
     */
    public static boolean isValidId(String idStr) {
        if (idStr == null || idStr.trim().isEmpty()) return false;
        try {
            int id = Integer.parseInt(idStr.trim());
            return id > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    /**
     * Alias for sanitizeInput() — returns HTML-escaped string.
     */
    public static String sanitize(String input) {
        return sanitizeInput(input);
    }

    /**
     * Returns true if the input contains any dangerous SQL/XSS pattern.
     */
    public static boolean containsDangerousPattern(String input) {
        return validateSearchInput(input) != null;
    }
}
