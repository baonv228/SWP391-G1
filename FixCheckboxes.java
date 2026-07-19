import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class FixCheckboxes {
    public static void main(String[] args) throws IOException {
        String newFunction = 
            "    function buildCLOCheckboxes(prefix, rowIdx, checkedIds = []) {\n" +
            "        let html = '<div style=\"display:flex;gap:4px;flex-wrap:wrap;\">';\n" +
            "        let found = false;\n" +
            "        document.querySelectorAll('#cloBody tr').forEach((tr) => {\n" +
            "            let cloNameStr = tr.querySelector('input[name=\"clo_name\"]').value.trim();\n" +
            "            const match = cloNameStr.match(/CLO(\\d+)/i);\n" +
            "            const num = match ? parseInt(match[1]) : 0;\n" +
            "            const isChecked = checkedIds.includes(num) ? 'checked' : '';\n" +
            "            html += '<label style=\"font-size:12px;white-space:nowrap;\">' +\n" +
            "                '<input type=\"checkbox\" onchange=\"checkValidationStatus()\" class=\"' + prefix + '-clo-cb\" name=\"' + prefix + '_clo_' + rowIdx + '_' + num + '\" value=\"' + num + '\" ' + isChecked + '/> CLO' + num +\n" +
            "                '</label>';\n" +
            "            found = true;\n" +
            "        });\n" +
            "        if (!found) html += '<span style=\"color:var(--muted);font-size:12px;\">Thêm CLO trước</span>';\n" +
            "        html += '</div>';\n" +
            "        return html;\n" +
            "    }";

        String[] files = {
            "SWP391/src/main/webapp/syllabus/create.jsp",
            "SWP391/src/main/webapp/syllabus/edit.jsp"
        };

        for (String file : files) {
            String content = Files.readString(Paths.get(file), StandardCharsets.UTF_8);
            
            // Regex to find and replace the old buildCLOCheckboxes
            Pattern pattern = Pattern.compile("(?s)function buildCLOCheckboxes\\(prefix,\\s*rowIdx\\).*?return html;\\s*\\}");
            Matcher matcher = pattern.matcher(content);
            if (matcher.find()) {
                content = matcher.replaceFirst(Matcher.quoteReplacement(newFunction));
                Files.writeString(Paths.get(file), content, StandardCharsets.UTF_8);
                System.out.println("Fixed buildCLOCheckboxes in " + file);
            } else {
                System.out.println("Could not find buildCLOCheckboxes in " + file);
            }
        }
    }
}
