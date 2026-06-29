import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class MergeDao {
    public static void main(String[] args) throws IOException {
        String tmContent = Files.readString(Paths.get("teammate_dao.java"), StandardCharsets.UTF_8);
        String myContent = Files.readString(Paths.get("SWP391/src/main/java/dao/SyllabusDAO.java"), StandardCharsets.UTF_8);

        String p1 = "(?s)(    // =========================================================\\r?\\n    // SEARCH SYLLABI\\r?\\n    // =========================================================\\r?\\n    public List<SyllabusDTO> searchSyllabi.*?)    // =========================================================\\r?\\n    // DETAIL";
        String p2 = "(?s)(    public SyllabusDTO getSyllabusById.*?)\\r?\\n    // =========================================================\\r?\\n    // CREATE FULL SYLLABUS";
        String p3 = "(?s)(    // =========================================================\\r?\\n    // HELPERS\\r?\\n    // =========================================================\\r?\\n    private List<String> parseLearningOutcomes.*?)\\r?\\n}$";

        StringBuilder extracted = new StringBuilder();

        Matcher m1 = Pattern.compile(p1).matcher(tmContent);
        if (m1.find()) extracted.append(m1.group(1)).append("\n");

        Matcher m2 = Pattern.compile(p2).matcher(tmContent);
        if (m2.find()) extracted.append(m2.group(1)).append("\n");

        Matcher m3 = Pattern.compile(p3).matcher(tmContent);
        if (m3.find()) extracted.append(m3.group(1)).append("\n");

        String extStr = extracted.toString().replace("public SyllabusDTO getSyllabusById", "public SyllabusDTO getSyllabusDtoById");

        myContent = myContent.replace("import model.*;", "import model.*;\nimport dto.SyllabusDTO;");

        int lastBrace = myContent.lastIndexOf("}");
        String newContent = myContent.substring(0, lastBrace) + "\n" + extStr + "\n}\n";

        Files.writeString(Paths.get("SWP391/src/main/java/dao/SyllabusDAO.java"), newContent, StandardCharsets.UTF_8);
        System.out.println("Merged successfully via Java!");
    }
}
