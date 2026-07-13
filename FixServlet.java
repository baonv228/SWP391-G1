import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;

public class FixServlet {
    public static void main(String[] args) throws IOException {
        String path = "SWP391/src/main/java/controller/SyllabusServlet.java";
        String content = Files.readString(Paths.get(path), StandardCharsets.UTF_8);
        
        String target1 = "    private void handleAjaxPlos(HttpServletRequest request, HttpServletResponse response) throws IOException {\r\n" +
                         "        int curriculumId = parseInt(request.getParameter(\"curriculumId\"), 0);\r\n" +
                         "        int subjectId = parseInt(request.getParameter(\"subjectId\"), 0);\r\n" +
                         "        response.setContentType(\"application/json\");\r\n" +
                         "        response.setCharacterEncoding(\"UTF-8\");\r\n" +
                         "        List<PLO> plos = new ArrayList<>();\r\n" +
                         "        if (curriculumId > 0) {\r\n" +
                         "            plos = ploDAO.getPLOsByCurriculumId(curriculumId);\r\n" +
                         "        } else if (subjectId > 0) {\r\n" +
                         "            List<Integer> cIds = ploDAO.getCurriculumIdsForSubject(subjectId);\r\n" +
                         "            if (!cIds.isEmpty()) {\r\n" +
                         "                plos = ploDAO.getPLOsByCurriculumId(cIds.get(0));\r\n" +
                         "            }\r\n" +
                         "        }\r\n" +
                         "        response.getWriter().write(new Gson().toJson(plos));\r\n" +
                         "    }";
                         
        String replacement = "    private void handleAjaxPlos(HttpServletRequest request, HttpServletResponse response) throws IOException {\r\n" +
                             "        int curriculumId = parseInt(request.getParameter(\"curriculumId\"), 0);\r\n" +
                             "        int subjectId = parseInt(request.getParameter(\"subjectId\"), 0);\r\n" +
                             "        response.setContentType(\"application/json\");\r\n" +
                             "        response.setCharacterEncoding(\"UTF-8\");\r\n" +
                             "        if (curriculumId > 0) {\r\n" +
                             "            List<PLO> plos = ploDAO.getPLOsByCurriculumId(curriculumId);\r\n" +
                             "            response.getWriter().write(new Gson().toJson(plos));\r\n" +
                             "        } else if (subjectId > 0) {\r\n" +
                             "            List<java.util.Map<String, Object>> data = ploDAO.getCurriculaWithPLOsForSubject(subjectId);\r\n" +
                             "            response.getWriter().write(new Gson().toJson(data));\r\n" +
                             "        } else {\r\n" +
                             "            response.getWriter().write(\"[]\");\r\n" +
                             "        }\r\n" +
                             "    }";

        content = content.replace(target1, replacement);
        content = content.replace(target1.replace("\r\n", "\n"), replacement.replace("\r\n", "\n"));
        
        Files.writeString(Paths.get(path), content, StandardCharsets.UTF_8);
    }
}
