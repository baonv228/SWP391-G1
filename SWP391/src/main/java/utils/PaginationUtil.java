package utils;

import dto.PaginationDTO;

public class PaginationUtil {

    public static final int DEFAULT_PAGE_SIZE = 10;

    /**
     * Builds a PaginationDTO from total records and current page.
     */
    public static PaginationDTO buildPagination(int totalRecords, int currentPage, int pageSize) {
        if (pageSize <= 0) pageSize = DEFAULT_PAGE_SIZE;
        if (currentPage < 1) currentPage = 1;
        PaginationDTO pagination = new PaginationDTO(currentPage, totalRecords, pageSize);
        // Clamp current page to valid range
        if (pagination.getTotalPages() > 0 && currentPage > pagination.getTotalPages()) {
            pagination = new PaginationDTO(pagination.getTotalPages(), totalRecords, pageSize);
        }
        return pagination;
    }

    /**
     * Convenience overload with default page size.
     */
    public static PaginationDTO buildPagination(int totalRecords, int currentPage) {
        return buildPagination(totalRecords, currentPage, DEFAULT_PAGE_SIZE);
    }
}
