import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;

public class FixJs {
    public static void main(String[] args) throws IOException {
        String[] files = {
            "SWP391/src/main/webapp/syllabus/create.jsp",
            "SWP391/src/main/webapp/syllabus/edit.jsp"
        };
        
        for (String file : files) {
            String content = Files.readString(Paths.get(file), StandardCharsets.UTF_8);
            
            content = content.replace("removeRow(\\'matRow_' + i + '\\')", "removeRow(this, \\'mat\\')");
            content = content.replace("removeRow(\\'sesRow_' + i + '\\')", "removeRow(this, \\'ses\\')");
            content = content.replace("removeRow(\\'asmRow_' + i + '\\')", "removeRow(this, \\'asm\\')");
            content = content.replace("removeCLORow(\\'cloRow_' + i + '\\', ' + num + ')", "removeCLORow(this, ' + num + ')");
            
            content = content.replaceAll("removeRow\\('matRow_\\d+'\\)", "removeRow(this, 'mat')");
            content = content.replaceAll("removeRow\\('sesRow_\\d+'\\)", "removeRow(this, 'ses')");
            content = content.replaceAll("removeRow\\('asmRow_\\d+'\\)", "removeRow(this, 'asm')");
            content = content.replaceAll("removeCLORow\\('cloRow_\\d+',\\s*(\\d+)\\)", "removeCLORow(this, $1)");

            int removeRowStart = content.indexOf("function removeRow(rowId)");
            if (removeRowStart > -1) {
                int removeRowEnd = content.indexOf("function buildCLOCheckboxes", removeRowStart);
                if (removeRowEnd == -1) removeRowEnd = content.indexOf("function checkValidationStatus", removeRowStart);
                
                String newRemoveRow = "function removeRow(btn, type) {\n" +
                    "        if(typeof btn === 'string') {\n" +
                    "            const el = document.getElementById(btn);\n" +
                    "            if(el) el.remove();\n" +
                    "        } else {\n" +
                    "            btn.closest('tr').remove();\n" +
                    "        }\n" +
                    "        if (type === 'mat') {\n" +
                    "            const rows = document.querySelectorAll('#matBody tr');\n" +
                    "            rows.forEach((tr, index) => {\n" +
                    "                tr.cells[0].textContent = index + 1;\n" +
                    "                const mainCb = tr.querySelector('input[name^=\"mat_isMain_\"]'); if (mainCb) mainCb.name = 'mat_isMain_' + index;\n" +
                    "                const hardCb = tr.querySelector('input[name^=\"mat_isHard_\"]'); if (hardCb) hardCb.name = 'mat_isHard_' + index;\n" +
                    "                const onlineCb = tr.querySelector('input[name^=\"mat_isOnline_\"]'); if (onlineCb) onlineCb.name = 'mat_isOnline_' + index;\n" +
                    "                const actionBtn = tr.querySelector('.btn-danger-syl');\n" +
                    "                if(actionBtn) actionBtn.setAttribute('onclick', 'removeRow(this, \\'mat\\')');\n" +
                    "            });\n" +
                    "            matCount = rows.length;\n" +
                    "        } else if (type === 'ses') {\n" +
                    "            const rows = document.querySelectorAll('#sesBody tr');\n" +
                    "            rows.forEach((tr, index) => {\n" +
                    "                tr.cells[0].textContent = index + 1;\n" +
                    "                const tdClo = tr.querySelector('td[id^=\"sesClo_\"]');\n" +
                    "                if(tdClo) {\n" +
                    "                    tdClo.id = 'sesClo_' + index;\n" +
                    "                    tdClo.querySelectorAll('input[type=\"checkbox\"]').forEach(cb => {\n" +
                    "                        const parts = cb.name.split('_');\n" +
                    "                        if(parts.length >= 4) { parts[2] = index; cb.name = parts.join('_'); }\n" +
                    "                    });\n" +
                    "                }\n" +
                    "                const actionBtn = tr.querySelector('.btn-danger-syl');\n" +
                    "                if(actionBtn) actionBtn.setAttribute('onclick', 'removeRow(this, \\'ses\\')');\n" +
                    "            });\n" +
                    "            sesCount = rows.length;\n" +
                    "        } else if (type === 'asm') {\n" +
                    "            const rows = document.querySelectorAll('#asmBody tr');\n" +
                    "            rows.forEach((tr, index) => {\n" +
                    "                tr.cells[0].textContent = index + 1;\n" +
                    "                const tdClo = tr.querySelector('td[id^=\"asmClo_\"]');\n" +
                    "                if(tdClo) {\n" +
                    "                    tdClo.id = 'asmClo_' + index;\n" +
                    "                    tdClo.querySelectorAll('input[type=\"checkbox\"]').forEach(cb => {\n" +
                    "                        const parts = cb.name.split('_');\n" +
                    "                        if(parts.length >= 4) { parts[2] = index; cb.name = parts.join('_'); }\n" +
                    "                    });\n" +
                    "                }\n" +
                    "                const actionBtn = tr.querySelector('.btn-danger-syl');\n" +
                    "                if(actionBtn) actionBtn.setAttribute('onclick', 'removeRow(this, \\'asm\\')');\n" +
                    "            });\n" +
                    "            asmCount = rows.length;\n" +
                    "        }\n" +
                    "        updateWeightTotal();\n" +
                    "        checkValidationStatus();\n" +
                    "    }\n\n    ";
                content = content.substring(0, removeRowStart) + newRemoveRow + content.substring(removeRowEnd);
            }

            int cloStart = content.indexOf("function removeCLORow");
            if (cloStart > -1) {
                int cloEnd = content.indexOf("function checkValidationStatus", cloStart);
                if (cloEnd == -1) cloEnd = content.indexOf("function updateWeightTotal", cloStart);
                if (content.indexOf("function removeRow", cloStart) < cloEnd && content.indexOf("function removeRow", cloStart) != -1) {
                    cloEnd = content.indexOf("function removeRow", cloStart);
                }
                
                String newRemoveCLORow = "function removeCLORow(btn, cloNum) {\n" +
                    "        const isUsed = document.querySelector('input[name^=\"ses_clo_\"][name$=\"_' + cloNum + '\"]:checked') ||\n" +
                    "                       document.querySelector('input[name^=\"asm_clo_\"][name$=\"_' + cloNum + '\"]:checked');\n" +
                    "        if(isUsed) {\n" +
                    "            alert('Không thể xóa CLO này vì nó đang được map trong Session hoặc Assessment!');\n" +
                    "            return;\n" +
                    "        }\n" +
                    "        const checkedMap = {};\n" +
                    "        document.querySelectorAll('input[type=\"checkbox\"]:checked').forEach(cb => { checkedMap[cb.name] = true; });\n" +
                    "        if(typeof btn === 'string') { const el = document.getElementById(btn); if(el) el.remove(); }\n" +
                    "        else { btn.closest('tr').remove(); }\n" +
                    "        const cloRows = document.querySelectorAll('#cloBody tr');\n" +
                    "        const oldToNew = {};\n" +
                    "        cloRows.forEach((tr, index) => {\n" +
                    "            const num = index + 1;\n" +
                    "            const nameInput = tr.querySelector('input[name=\"clo_name\"]');\n" +
                    "            const detailsInput = tr.querySelector('input[name=\"clo_details\"]');\n" +
                    "            const oldNum = parseInt(nameInput.value.replace('CLO', ''));\n" +
                    "            oldToNew[oldNum] = num;\n" +
                    "            nameInput.value = 'CLO' + num;\n" +
                    "            if(detailsInput.value === 'CLO' + oldNum) detailsInput.value = 'CLO' + num;\n" +
                    "            const actionBtn = tr.querySelector('.btn-danger-syl');\n" +
                    "            if(actionBtn) actionBtn.setAttribute('onclick', 'removeCLORow(this, ' + num + ')');\n" +
                    "        });\n" +
                    "        cloCount = cloRows.length;\n" +
                    "        const newCheckedMap = {};\n" +
                    "        for(let key in checkedMap) {\n" +
                    "            const parts = key.split('_');\n" +
                    "            if(parts.length >= 4 && (parts[0] === 'ses' || parts[0] === 'asm') && parts[1] === 'clo') {\n" +
                    "                const oldNum = parseInt(parts[3]);\n" +
                    "                if(oldToNew[oldNum]) { parts[3] = oldToNew[oldNum]; newCheckedMap[parts.join('_')] = true; }\n" +
                    "            } else { newCheckedMap[key] = true; }\n" +
                    "        }\n" +
                    "        document.querySelectorAll('[id^=\"sesClo_\"]').forEach(function (td) {\n" +
                    "            const idx = td.id.split('_')[1]; td.innerHTML = buildCLOCheckboxes('ses', idx);\n" +
                    "        });\n" +
                    "        document.querySelectorAll('[id^=\"asmClo_\"]').forEach(function (td) {\n" +
                    "            const idx = td.id.split('_')[1]; td.innerHTML = buildCLOCheckboxes('asm', idx);\n" +
                    "        });\n" +
                    "        document.querySelectorAll('input[type=\"checkbox\"]').forEach(cb => {\n" +
                    "            if(newCheckedMap[cb.name]) cb.checked = true;\n" +
                    "        });\n" +
                    "        checkValidationStatus();\n" +
                    "    }\n\n    ";
                
                content = content.substring(0, cloStart) + newRemoveCLORow + content.substring(cloEnd);
            }
            
            Files.writeString(Paths.get(file), content, StandardCharsets.UTF_8);
        }
        System.out.println("Done fixing JS");
    }
}
