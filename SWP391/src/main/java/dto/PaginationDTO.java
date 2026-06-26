package dto;

public class PaginationDTO {
    private int currentPage;
    private int totalPages;
    private int totalRecords;
    private int pageSize;
    private int offset;

    public PaginationDTO() {}

    public PaginationDTO(int currentPage, int totalRecords, int pageSize) {
        this.currentPage = currentPage;
        this.pageSize = pageSize;
        this.totalRecords = totalRecords;
        this.totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        this.offset = (currentPage - 1) * pageSize;
    }

    public boolean hasPrevious() { return currentPage > 1; }
    public boolean hasNext() { return currentPage < totalPages; }
    public int getPreviousPage() { return currentPage - 1; }
    public int getNextPage() { return currentPage + 1; }

    public int getCurrentPage() { return currentPage; }
    public void setCurrentPage(int currentPage) { this.currentPage = currentPage; }
    public int getTotalPages() { return totalPages; }
    public void setTotalPages(int totalPages) { this.totalPages = totalPages; }
    public int getTotalRecords() { return totalRecords; }
    public void setTotalRecords(int totalRecords) { this.totalRecords = totalRecords; }
    public int getPageSize() { return pageSize; }
    public void setPageSize(int pageSize) { this.pageSize = pageSize; }
    public int getOffset() { return offset; }
    public void setOffset(int offset) { this.offset = offset; }
}
