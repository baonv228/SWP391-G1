package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Role;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import service.UserService;

@WebServlet(name = "AdminRoleServlet", urlPatterns = {"/admin/roles"})
public class AdminRoleServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if ("export".equalsIgnoreCase(request.getParameter("action"))) {
            exportRoles(response);
            return;
        }

        List<Role> roles = userService.getAllRoles();
        request.setAttribute("roles", roles);
        request.getRequestDispatcher("/view/admin_roles.jsp").forward(request, response);
    }

    private void exportRoles(HttpServletResponse response) throws IOException {
        List<Role> roles = userService.getAllRoles();
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=tpms-roles.xlsx");

        try (XSSFWorkbook workbook = new XSSFWorkbook()) {
            XSSFSheet sheet = workbook.createSheet("Roles");
            String[] headers = {"ID", "Role Name", "Description"};
            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerStyle.setFont(headerFont);

            org.apache.poi.ss.usermodel.Row headerRow = sheet.createRow(0);
            for (int column = 0; column < headers.length; column++) {
                Cell cell = headerRow.createCell(column);
                cell.setCellValue(headers[column]);
                cell.setCellStyle(headerStyle);
            }

            int rowIndex = 1;
            for (Role role : roles) {
                org.apache.poi.ss.usermodel.Row row = sheet.createRow(rowIndex++);
                row.createCell(0).setCellValue(role.getRoleId());
                row.createCell(1).setCellValue(excelSafe(role.getRoleName()));
                row.createCell(2).setCellValue(excelSafe(role.getDescription()));
            }
            for (int column = 0; column < headers.length; column++) {
                sheet.autoSizeColumn(column);
            }
            workbook.write(response.getOutputStream());
        }
    }

    private String excelSafe(String value) {
        if (value == null) {
            return "";
        }
        return value.startsWith("=") || value.startsWith("+") || value.startsWith("-") || value.startsWith("@")
                ? "'" + value : value;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
