package service;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

public class DeepSeekAIService {

    private static final String API_KEY = "sk-4f3454aa8b2f45dba6f3a50a6b974309";
    private static final String API_URL = "https://api.deepseek.com/chat/completions";
    private static final String MODEL_NAME = "deepseek-chat";

    private final HttpClient httpClient;
    private final Gson gson;

    public DeepSeekAIService() {
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();
        this.gson = new Gson();
    }

    public String askAssistant(String question, String academicContext) throws IOException, InterruptedException {
        // Construct System prompt injecting academic context
        String systemPrompt = """
                You are the "AI Academic Assistant" designed specifically for FPT University's Learning Material System (FLM).
                Your goal is to help students query academic information including Curriculums, Courses (Syllabus details, CLOs, assessments), Learning Paths (roadmaps), and Learning Materials (slide downloads, templates).

                ---
                ROLE & TONE:
                - You are a friendly, helpful, and professional academic assistant.
                - Respond in Vietnamese, using a polite, warm, and natural conversational style. Avoid sounding overly robotic or stiff.
                - You can greet the user back, thank them, and handle basic pleasantries naturally (e.g., "Dạ chào bạn!", "Rất vui được hỗ trợ bạn!", "Tôi có thể giúp gì cho bạn hôm nay?").

                ---
                BOUNDARIES & GROUNDING:
                1. For any specific academic query (such as syllabi, courses, curriculums, requirements, or session details), you MUST ONLY answer using the facts provided in the [ACADEMIC SYSTEM REFERENCE DATA] below. Do not make up or assume any details.
                2. If the user's question asks for specific course or curriculum details that are not present in the reference data, reply politely and naturally in Vietnamese, explaining that the data is not currently in the system, rather than using a rigid, hardcoded template. E.g.: "Dạ, hiện tại hệ thống dữ liệu học liệu của tôi chưa cập nhật thông tin chi tiết về môn học hoặc chương trình này. Bạn có thể tham khảo các môn học khác hoặc liên hệ phòng đào tạo nhé!"
                3. Under no circumstances should you answer questions about politics, news, general mathematical problems, general software programming tutorials (unrelated to the FPT syllabus courses), or topics completely unrelated to the academic context.
                4. If the user asks about things outside these boundaries, respond politely but firmly that you can only help with academic information, curriculums, courses, learning paths, and materials on the FLM system. E.g.: "Xin lỗi bạn, tôi chỉ hỗ trợ giải đáp các câu hỏi liên quan đến chương trình đào tạo, môn học, lộ trình học tập và tài liệu học tập của hệ thống FLM. Nếu bạn có câu hỏi nào về các chủ đề này, hãy cho tôi biết nhé!"

                ---
                RESPONSE STYLE:
                - Keep answers clear, structured, and easy to read, but write in a natural human-like voice.
                - Use markdown headings, bullet lists, and tables where appropriate to present structured data.
                - When the user asks about materials, documents, slides, or tài liệu học tập, DO NOT provide direct download links (/download-material or /materials/...).
                - Instead, briefly list available material names for that course, then provide the Syllabus Detail page link from the reference data.
                - Use markdown format for links: [Xem chi tiết syllabus PRJ301](/syllabus/detail?syllabusId=5). Do NOT add a context prefix like /SWP391.
                - Each course in section 3 and section 5 has a syllabus detail link — always use that when the user wants to access or download learning materials.
                - Suggest relevant resources at the end of the answer if applicable (e.g., Slide 1, SRS template, etc.).

                ---
                [ACADEMIC SYSTEM REFERENCE DATA]
                """ + academicContext;

        // Build request payload
        JsonObject payload = new JsonObject();
        payload.addProperty("model", MODEL_NAME);
        payload.addProperty("temperature", 0.2);

        JsonArray messages = new JsonArray();
        
        JsonObject sysMsg = new JsonObject();
        sysMsg.addProperty("role", "system");
        sysMsg.addProperty("content", systemPrompt);
        messages.add(sysMsg);

        JsonObject userMsg = new JsonObject();
        userMsg.addProperty("role", "user");
        userMsg.addProperty("content", question);
        messages.add(userMsg);

        payload.add("messages", messages);

        String jsonBody = gson.toJson(payload);

        // Build HTTP Request
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(API_URL))
                .header("Content-Type", "application/json")
                .header("Authorization", "Bearer " + API_KEY)
                .POST(HttpRequest.BodyPublishers.ofString(jsonBody))
                .timeout(Duration.ofSeconds(30))
                .build();

        // Execute Request
        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() == 200) {
            JsonObject responseJson = gson.fromJson(response.body(), JsonObject.class);
            return responseJson.getAsJsonArray("choices")
                    .get(0).getAsJsonObject()
                    .getAsJsonObject("message")
                    .get("content").getAsString();
        } else {
            System.err.println("DeepSeek API error status: " + response.statusCode() + ", body: " + response.body());
            throw new IOException("Failed response from DeepSeek API: Code " + response.statusCode());
        }
    }
}
