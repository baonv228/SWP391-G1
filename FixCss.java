import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;

public class FixCss {
    public static void main(String[] args) throws IOException {
        String cssFile = "SWP391/src/main/webapp/css/syllabus.css";
        String content = Files.readString(Paths.get(cssFile), StandardCharsets.UTF_8);

        // Replace declarations
        content = content.replace("--leaf: #2f7d32;", "--primary: #f26d21;");
        content = content.replace("--leaf-dark: #1f5d25;", "--primary-dark: #c55416;");
        content = content.replace("--leaf-light: #4caf50;", "--primary-light: #f89b65;");
        content = content.replace("--mint: #dff0df;", "--primary-bg: #fff0e6;");
        
        // Replace RGBA hardcoded shadows
        content = content.replace("rgba(47,125,50,", "rgba(242,109,33,");

        // Replace usage
        content = content.replace("var(--leaf-dark)", "var(--primary-dark)");
        content = content.replace("var(--leaf-light)", "var(--primary-light)");
        content = content.replace("var(--leaf)", "var(--primary)");
        content = content.replace("var(--mint)", "var(--primary-bg)");

        Files.writeString(Paths.get(cssFile), content, StandardCharsets.UTF_8);
        System.out.println("CSS updated to Orange!");
    }
}
