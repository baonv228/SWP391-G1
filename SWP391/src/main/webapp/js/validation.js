/**
 * FPT University Learning Materials - Client-Side Validation
 * Handles: empty input, max length, XSS, SQL injection detection
 */

const MAX_LENGTH = 200;

const SQL_INJECTION_PATTERNS = [
    /('|--|;|\/\*|\*\/|xp_)/i,
    /\b(exec|execute|insert|update|delete|drop|create|alter|union|select|from|where)\b/i,
    /(or\s+1\s*=\s*1|or\s+'1'\s*=\s*'1')/i
];

const XSS_PATTERNS = [
    /<script[\s\S]*?>/i,
    /<\/script>/i,
    /javascript:/i,
    /on(load|error|click|mouseover)\s*=/i,
    /<(iframe|object|embed)/i,
    /alert\s*\(/i,
    /document\.cookie/i,
    /window\.location/i
];

/**
 * Shows an error under a form field.
 */
function showSearchError(errorElementId, message) {
    const el = document.getElementById(errorElementId);
    if (el) {
        el.textContent = message;
        el.style.display = 'block';
    }
    return false;
}

/**
 * Clears search error.
 */
function clearSearchError(errorElementId) {
    const el = document.getElementById(errorElementId);
    if (el) {
        el.textContent = '';
        el.style.display = 'none';
    }
}

/**
 * Validates the main search form (searchType + keyword).
 * @param {string} inputId - ID of the keyword input
 * @param {string} errorId - ID of the error display element
 * @returns {boolean}
 */
function validateSearchForm(inputId, errorId) {
    clearSearchError(errorId);
    const input = document.getElementById(inputId);
    if (!input) return true;

    const value = input.value.trim();

    // Allow empty – server will return all results
    if (value.length === 0) return true;

    // Max length
    if (value.length > MAX_LENGTH) {
        return showSearchError(errorId, `Search input is too long (maximum ${MAX_LENGTH} characters).`);
    }

    // XSS detection
    for (const pattern of XSS_PATTERNS) {
        if (pattern.test(value)) {
            return showSearchError(errorId, 'Invalid input: HTML/script tags are not allowed.');
        }
    }

    // SQL Injection detection
    for (const pattern of SQL_INJECTION_PATTERNS) {
        if (pattern.test(value)) {
            return showSearchError(errorId, 'Invalid input: special SQL keywords or characters are not allowed.');
        }
    }

    return true;
}

/**
 * Validates a simple subject code search field.
 * @param {string} inputId
 * @param {string} errorId
 * @returns {boolean}
 */
function validateSimpleSearch(inputId, errorId) {
    clearSearchError(errorId);
    const input = document.getElementById(inputId);
    if (!input) return true;

    const value = input.value.trim();

    if (value.length === 0) {
        return showSearchError(errorId, 'Please enter a subject code.');
    }

    if (value.length > 50) {
        return showSearchError(errorId, 'Subject code is too long (maximum 50 characters).');
    }

    for (const pattern of XSS_PATTERNS) {
        if (pattern.test(value)) {
            return showSearchError(errorId, 'Invalid input detected.');
        }
    }

    for (const pattern of SQL_INJECTION_PATTERNS) {
        if (pattern.test(value)) {
            return showSearchError(errorId, 'Invalid input: special characters are not allowed.');
        }
    }

    return true;
}

/**
 * Auto-clear error when user starts typing.
 */
document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('input[type="text"]').forEach(function (input) {
        input.addEventListener('input', function () {
            const form = input.closest('form');
            if (form) {
                const errorEl = form.querySelector('.search-error-msg');
                if (errorEl) {
                    errorEl.textContent = '';
                    errorEl.style.display = 'none';
                }
            }
        });
    });
});
