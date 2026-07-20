<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="pageTitle" value="AI Academic Assistant" scope="request"/>
<jsp:include page="/views/layout/header.jsp"/>

<!-- Marked Markdown Parser -->
<script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>

<style>
    :root {
        --chat-bg: #f8f9fa;
        --sidebar-bg: #ffffff;
        --user-bubble: #e0f2fe;
        --bot-bubble: #ffffff;
        --chat-border: #e5e7eb;
    }

    .chat-container {
        display: flex;
        height: 75vh;
        border-radius: 12px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        overflow: hidden;
        background-color: var(--chat-bg);
        border: 1px solid var(--chat-border);
        margin-bottom: 2rem;
    }

    /* History Sidebar */
    .chat-sidebar {
        width: 280px;
        background-color: var(--sidebar-bg);
        border-right: 1px solid var(--chat-border);
        display: flex;
        flex-direction: column;
        transition: all 0.3s ease;
    }

    .sidebar-header {
        padding: 1.2rem;
        font-weight: 700;
        border-bottom: 1px solid var(--chat-border);
        color: #333;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .history-list {
        flex: 1;
        overflow-y: auto;
        padding: 0.8rem;
    }

    .history-item {
        padding: 0.8rem;
        border-radius: 8px;
        margin-bottom: 0.5rem;
        cursor: pointer;
        transition: background-color 0.2s;
        border: 1px solid transparent;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        font-size: 0.9rem;
        color: #555;
    }

    .history-item:hover {
        background-color: #f1f5f9;
        color: var(--fpt-orange);
    }

    .history-item.active {
        background-color: #ffeae0;
        border-color: #ffd0b5;
        color: var(--fpt-orange);
        font-weight: 600;
    }

    /* Chat Area */
    .chat-main {
        flex: 1;
        display: flex;
        flex-direction: column;
        background-color: var(--chat-bg);
    }

    .chat-header {
        padding: 1rem 1.5rem;
        background-color: #fff;
        border-bottom: 1px solid var(--chat-border);
        display: flex;
        align-items: center;
        justify-content: space-between;
    }

    .chat-header-title {
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }

    .chat-header-title h4 {
        margin: 0;
        font-weight: 700;
        font-size: 1.1rem;
        color: #333;
    }

    .chat-header-title span {
        font-size: 0.8rem;
        color: #10b981;
        display: flex;
        align-items: center;
        gap: 0.25rem;
    }

    .chat-messages {
        flex: 1;
        overflow-y: auto;
        padding: 1.5rem;
        display: flex;
        flex-direction: column;
        gap: 1rem;
    }

    /* Chat Bubbles */
    .message-row {
        display: flex;
        width: 100%;
        margin-bottom: 0.5rem;
    }

    .message-row.user {
        justify-content: flex-end;
    }

    .message-row.bot {
        justify-content: flex-start;
    }

    .message-bubble {
        max-width: 75%;
        padding: 1rem 1.2rem;
        border-radius: 12px;
        font-size: 0.95rem;
        line-height: 1.5;
        position: relative;
        box-shadow: 0 2px 5px rgba(0,0,0,0.03);
    }

    .message-row.user .message-bubble {
        background-color: var(--fpt-orange);
        color: #ffffff;
        border-bottom-right-radius: 2px;
        border: none;
    }

    .message-row.bot .message-bubble {
        background-color: #f1f5f9;
        color: #1e293b;
        border-bottom-left-radius: 2px;
        border: 1px solid #e2e8f0;
    }

    /* Markdown output styling inside bubbles */
    .message-bubble h1, .message-bubble h2, .message-bubble h3 {
        font-size: 1.05rem;
        margin-top: 0.8rem;
        margin-bottom: 0.4rem;
        color: #0f172a;
        font-weight: 700;
    }
    .message-bubble p {
        margin-bottom: 0.5rem;
    }
    .message-bubble ul, .message-bubble ol {
        margin-bottom: 0.5rem;
        padding-left: 1.2rem;
    }
    .message-bubble table {
        width: 100%;
        margin: 0.8rem 0;
        border-collapse: collapse;
        font-size: 0.85rem;
    }
    .message-bubble th, .message-bubble td {
        border: 1px solid #e2e8f0;
        padding: 0.4rem 0.6rem;
        text-align: left;
    }
    .message-bubble th {
        background-color: #f8fafc;
    }
    .message-bubble a {
        color: var(--fpt-orange);
        text-decoration: underline;
        font-weight: 600;
    }

    /* Suggestion Chips */
    .suggestion-container {
        padding: 0.8rem 1.5rem;
        background-color: #fff;
        border-top: 1px solid var(--chat-border);
        display: flex;
        gap: 0.6rem;
        overflow-x: auto;
        white-space: nowrap;
    }

    .suggestion-chip {
        padding: 0.5rem 1rem;
        background-color: #f1f5f9;
        border: 1px solid #e2e8f0;
        border-radius: 20px;
        font-size: 0.85rem;
        cursor: pointer;
        transition: all 0.2s;
        color: #475569;
        font-weight: 500;
    }

    .suggestion-chip:hover {
        background-color: #ffeae0;
        color: var(--fpt-orange);
        border-color: #ffd0b5;
    }

    /* Chat Input Area */
    .chat-input-area {
        padding: 1.2rem 1.5rem;
        background-color: #fff;
        border-top: 1px solid var(--chat-border);
    }

    .chat-form {
        display: flex;
        gap: 0.8rem;
    }

    .chat-input {
        flex: 1;
        border-radius: 8px;
        border: 1px solid #cbd5e1;
        padding: 0.8rem 1rem;
        font-size: 0.95rem;
        resize: none;
        height: 46px;
        line-height: 1.4;
        transition: border-color 0.2s;
    }

    .chat-input:focus {
        outline: none;
        border-color: var(--fpt-orange);
        box-shadow: 0 0 0 3px rgba(243, 114, 44, 0.15);
    }

    .chat-send-btn {
        background-color: var(--fpt-orange);
        color: #fff;
        border: none;
        border-radius: 8px;
        width: 50px;
        height: 46px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.2rem;
        cursor: pointer;
        transition: background-color 0.2s;
    }

    .chat-send-btn:hover {
        background-color: #e05e1a;
    }

    .typing-indicator {
        display: flex;
        align-items: center;
        gap: 0.25rem;
        padding: 0.3rem 0;
    }

    .typing-dot {
        width: 6px;
        height: 6px;
        background-color: #94a3b8;
        border-radius: 50%;
        animation: typing 1.4s infinite ease-in-out both;
    }

    .typing-dot:nth-child(2) { animation-delay: 0.2s; }
    .typing-dot:nth-child(3) { animation-delay: 0.4s; }

    @keyframes typing {
        0%, 80%, 100% { transform: scale(0); }
        40% { transform: scale(1); }
    }
</style>

<main class="container-fluid py-4">
    <div class="row">
        <div class="col-12">
            <div class="chat-container">
                
                <!-- Sidebar (Logs/History) -->
                <div class="chat-sidebar" id="sidebar-panel">
                    <div class="sidebar-header">
                        <i class="bi bi-clock-history"></i> Lịch sử hội thoại
                    </div>
                    <div class="history-list" id="history-container">
                        <c:choose>
                            <c:when test="${empty chatLogs}">
                                <div class="text-center py-4 text-muted" style="font-size: 0.85rem;" id="no-history-msg">
                                    Không có hội thoại cũ.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="log" items="${chatLogs}">
                                    <div class="history-item" onclick="loadHistoryToChat('${fn:escapeXml(log.question)}', '${fn:escapeXml(log.answer)}')" title="${fn:escapeXml(log.question)}">
                                        <i class="bi bi-chat-left-dots-fill me-2"></i> ${fn:escapeXml(log.question)}
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Main Chat Screen -->
                <div class="chat-main">
                    <div class="chat-header">
                        <div class="chat-header-title">
                            <i class="bi bi-robot text-primary fs-3"></i>
                            <div>
                                <h4>AI Academic Assistant</h4>
                                <span><i class="bi bi-circle-fill" style="font-size: 8px;"></i> Online - DeepSeek API</span>
                            </div>
                        </div>
                    </div>

                    <!-- Message Feed -->
                    <div class="chat-messages" id="chat-feed">
                        
                        <!-- Welcome message -->
                        <div class="message-row bot">
                            <div class="message-bubble" id="welcome-bubble">
                                <p><strong>Xin chào!</strong> Tôi là <strong>Trợ lý Học tập AI</strong> dành riêng cho Hệ thống học liệu FPT (FLM).</p>
                                <p>Tôi có thể giúp bạn tra cứu:</p>
                                <ul>
                                    <li>Chương trình đào tạo (Curriculum) & tiến độ học kỳ.</li>
                                    <li>Thông tin môn học chi tiết (Syllabus, CLOs, Assessments).</li>
                                    <li>Lộ trình học tập (Learning Path) các tuần.</li>
                                    <li>Liên kết tải tài liệu học tập trực tiếp (Learning Materials).</li>
                                </ul>
                                <p>Hãy chọn các gợi ý bên dưới hoặc nhập câu hỏi của bạn để bắt đầu!</p>
                            </div>
                        </div>

                    </div>

                    <!-- Chips container -->
                    <div class="suggestion-container" id="chips-container">
                        <div class="suggestion-chip" onclick="submitChip('Chương trình đào tạo ngành Software Engineering gồm những môn nào và học kỳ mấy?')">
                            <i class="bi bi-mortarboard-fill me-1"></i> Software Engineering Curriculum
                        </div>
                        <div class="suggestion-chip" onclick="submitChip('Học kỳ 3 của ngành Kỹ thuật phần mềm gồm các môn học nào?')">
                            <i class="bi bi-calendar-event me-1"></i> Học kỳ 3 học gì?
                        </div>
                        <div class="suggestion-chip" onclick="submitChip('Mục tiêu môn học, CLO và điều kiện tiên quyết của môn PRJ301 là gì?')">
                            <i class="bi bi-info-circle-fill me-1"></i> Thông tin môn PRJ301
                        </div>
                        <div class="suggestion-chip" onclick="submitChip('Tài liệu học môn PRJ301 xem và tải ở đâu?')">
                            <i class="bi bi-journal-text me-1"></i> Syllabus PRJ301
                        </div>
                        <div class="suggestion-chip" onclick="submitChip('Lộ trình học môn SWP391 theo tuần như thế nào? Cần làm gì để chuẩn bị?')">
                            <i class="bi bi-compass-fill me-1"></i> Lộ trình học SWP391
                        </div>
                        <div class="suggestion-chip" onclick="submitChip('Tôi muốn xem chi tiết syllabus và tài liệu môn SWP391.')">
                            <i class="bi bi-journal-text me-1"></i> Syllabus SWP391
                        </div>
                    </div>

                    <!-- Input Box -->
                    <div class="chat-input-area">
                        <form class="chat-form" id="chat-submit-form" onsubmit="event.preventDefault(); submitQuestion();">
                            <input type="text" class="chat-input" id="user-input-box" placeholder="Hỏi tôi về chương trình, môn học, tài liệu..." autocomplete="off" />
                            <button type="submit" class="chat-send-btn" id="send-btn">
                                <i class="bi bi-send-fill"></i>
                            </button>
                        </form>
                    </div>

                </div>

            </div>
        </div>
    </div>
</main>

<script>
    const chatFeed = document.getElementById('chat-feed');
    const userInputBox = document.getElementById('user-input-box');
    const historyContainer = document.getElementById('history-container');
    const noHistoryMsg = document.getElementById('no-history-msg');

    function fixMaterialLinks(html) {
        const contextPath = '${pageContext.request.contextPath}';
        const wrapper = document.createElement('div');
        wrapper.innerHTML = html;
        wrapper.querySelectorAll('a[href]').forEach(function(a) {
            const href = a.getAttribute('href');
            if (!href) return;
            if (href.startsWith('/syllabus/detail') || href.startsWith('/download-material') || href.startsWith('/materials/')) {
                a.setAttribute('href', contextPath + href);
            } else if (href.includes('/syllabus/detail?') && !href.startsWith(contextPath)) {
                const idx = href.indexOf('/syllabus/detail?');
                a.setAttribute('href', contextPath + href.substring(idx));
            } else if (href.includes('/download-material?') && !href.startsWith(contextPath)) {
                const idx = href.indexOf('/download-material?');
                a.setAttribute('href', contextPath + href.substring(idx));
            } else if (href.includes('/materials/') && !href.startsWith(contextPath)) {
                const idx = href.indexOf('/materials/');
                a.setAttribute('href', contextPath + href.substring(idx));
            }
        });
        return wrapper.innerHTML;
    }

    function appendMessage(sender, text) {
        const messageRow = document.createElement('div');
        messageRow.className = `message-row ${sender}`;

        const bubble = document.createElement('div');
        bubble.className = 'message-bubble';
        
        if (sender === 'bot') {
            bubble.innerHTML = fixMaterialLinks(marked.parse(text));
        } else {
            bubble.textContent = text;
        }

        messageRow.appendChild(bubble);
        chatFeed.appendChild(messageRow);
        chatFeed.scrollTop = chatFeed.scrollHeight;
    }

    function showTypingIndicator() {
        const messageRow = document.createElement('div');
        messageRow.className = 'message-row bot';
        messageRow.id = 'typing-indicator-row';

        const bubble = document.createElement('div');
        bubble.className = 'message-bubble';
        
        const typing = document.createElement('div');
        typing.className = 'typing-indicator';
        typing.innerHTML = '<div class="typing-dot"></div><div class="typing-dot"></div><div class="typing-dot"></div>';
        
        bubble.appendChild(typing);
        messageRow.appendChild(bubble);
        chatFeed.appendChild(messageRow);
        chatFeed.scrollTop = chatFeed.scrollHeight;
    }

    function removeTypingIndicator() {
        const indicator = document.getElementById('typing-indicator-row');
        if (indicator) {
            indicator.remove();
        }
    }

    function submitChip(questionText) {
        userInputBox.value = questionText;
        submitQuestion();
    }

    function loadHistoryToChat(question, answer) {
        const welcome = chatFeed.firstElementChild;
        chatFeed.innerHTML = '';
        chatFeed.appendChild(welcome);

        appendMessage('user', question);
        appendMessage('bot', answer);
    }

    function submitQuestion() {
        const questionText = userInputBox.value.trim();
        if (!questionText) return;

        userInputBox.value = '';
        appendMessage('user', questionText);
        showTypingIndicator();

        const params = new URLSearchParams();
        params.append('question', questionText);

        fetch('${pageContext.request.contextPath}/ai-assistant', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: params
        })
        .then(response => response.json())
        .then(data => {
            removeTypingIndicator();
            if (data.success) {
                appendMessage('bot', data.answer);
                
                if (noHistoryMsg) {
                    noHistoryMsg.remove();
                }
                const newHist = document.createElement('div');
                newHist.className = 'history-item';
                newHist.title = questionText;
                newHist.innerHTML = '<i class="bi bi-chat-left-dots-fill me-2"></i> ' + escapeHtml(questionText);
                newHist.onclick = function() { loadHistoryToChat(questionText, data.answer); };
                historyContainer.insertBefore(newHist, historyContainer.firstChild);
            } else {
                appendMessage('bot', '**Lỗi**: ' + (data.message || 'Không thể liên lạc với trợ lý AI.'));
            }
        })
        .catch(error => {
            removeTypingIndicator();
            console.error('Error fetching bot completion:', error);
            appendMessage('bot', '**Lỗi kết nối**: Vui lòng kiểm tra lại đường truyền mạng.');
        });
    }

    function escapeHtml(text) {
        return text
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#039;");
    }
</script>

<jsp:include page="/views/layout/footer.jsp"/>
