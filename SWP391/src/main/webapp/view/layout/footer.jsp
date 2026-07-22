<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/validation.js"></script>
    <script>
        function changeLanguage(lang) {
            // Language switching placeholder
            console.log('Language changed to: ' + lang);
        }
    </script>

<c:if test="${not empty sessionScope.user}">
    <!-- Marked Markdown Parser -->
    <script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>

    <!-- Floating Chat Widget Styles -->
    <style>
        .ai-widget-btn {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 60px;
            height: 60px;
            background-color: var(--fpt-orange, #f3722c);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            cursor: pointer;
            z-index: 2000;
            transition: all 0.3s ease;
            font-size: 1.8rem;
        }
        .ai-widget-btn:hover {
            transform: scale(1.1);
            background-color: #e05e1a;
        }
        .ai-widget-box {
            position: fixed;
            bottom: 100px;
            right: 30px;
            width: 380px;
            height: 520px;
            background-color: #f8f9fa;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.15);
            z-index: 2000;
            display: none;
            flex-direction: column;
            overflow: hidden;
            transition: all 0.3s ease;
            font-family: system-ui, -apple-system, sans-serif;
        }
        .ai-widget-header {
            background-color: var(--fpt-orange, #f3722c);
            color: #ffffff;
            padding: 1rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-weight: bold;
        }
        .ai-widget-header-title {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .ai-widget-close {
            background: none;
            border: none;
            color: #ffffff;
            font-size: 1.2rem;
            cursor: pointer;
        }
        .ai-widget-body {
            flex: 1;
            overflow-y: auto;
            padding: 1rem;
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
            background-color: #f8f9fa;
        }
        .ai-widget-msg {
            display: flex;
            width: 100%;
        }
        .ai-widget-msg.user {
            justify-content: flex-end;
        }
        .ai-widget-msg.bot {
            justify-content: flex-start;
        }
        .ai-widget-bubble {
            max-width: 80%;
            padding: 0.75rem 1rem;
            border-radius: 12px;
            font-size: 0.9rem;
            line-height: 1.4;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        .ai-widget-msg.user .ai-widget-bubble {
            background-color: var(--fpt-orange, #f3722c);
            color: #ffffff;
            border-bottom-right-radius: 2px;
        }
        .ai-widget-msg.bot .ai-widget-bubble {
            background-color: #ffffff;
            color: #1e293b;
            border-bottom-left-radius: 2px;
            border: 1px solid #e2e8f0;
        }
        /* Markdown override inside widget bubble */
        .ai-widget-bubble h1, .ai-widget-bubble h2, .ai-widget-bubble h3 {
            font-size: 0.95rem;
            margin-top: 0.5rem;
            margin-bottom: 0.25rem;
            font-weight: bold;
        }
        .ai-widget-bubble p {
            margin-bottom: 0.25rem;
        }
        .ai-widget-bubble ul {
            padding-left: 1rem;
            margin-bottom: 0.25rem;
        }
        .ai-widget-bubble a {
            color: var(--fpt-orange, #f3722c);
            text-decoration: underline;
        }
        .ai-widget-chips {
            padding: 0.5rem;
            background-color: #ffffff;
            border-top: 1px solid #e2e8f0;
            display: flex;
            gap: 0.4rem;
            overflow-x: auto;
            white-space: nowrap;
        }
        .ai-widget-chip {
            padding: 0.35rem 0.7rem;
            background-color: #f1f5f9;
            border: 1px solid #e2e8f0;
            border-radius: 15px;
            font-size: 0.75rem;
            cursor: pointer;
            color: #475569;
            transition: all 0.2s;
        }
        .ai-widget-chip:hover {
            background-color: #ffeae0;
            color: var(--fpt-orange, #f3722c);
            border-color: #ffd0b5;
        }
        .ai-widget-footer {
            padding: 0.75rem 1rem;
            background-color: #ffffff;
            border-top: 1px solid #e2e8f0;
        }
        .ai-widget-form {
            display: flex;
            gap: 0.5rem;
        }
        .ai-widget-input {
            flex: 1;
            border-radius: 6px;
            border: 1px solid #cbd5e1;
            padding: 0.5rem 0.75rem;
            font-size: 0.85rem;
        }
        .ai-widget-input:focus {
            outline: none;
            border-color: var(--fpt-orange, #f3722c);
        }
        .ai-widget-send {
            background-color: var(--fpt-orange, #f3722c);
            color: #ffffff;
            border: none;
            border-radius: 6px;
            width: 40px;
            height: 34px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
        }
        .ai-widget-typing {
            display: flex;
            align-items: center;
            gap: 3px;
            padding: 5px 0;
        }
        .ai-widget-dot {
            width: 5px;
            height: 5px;
            background-color: #94a3b8;
            border-radius: 50%;
            animation: widget-typing 1.4s infinite ease-in-out both;
        }
        .ai-widget-dot:nth-child(2) { animation-delay: 0.2s; }
        .ai-widget-dot:nth-child(3) { animation-delay: 0.4s; }
        @keyframes widget-typing {
            0%, 80%, 100% { transform: scale(0); }
            40% { transform: scale(1); }
        }
    </style>

    <!-- Floating Chat Button -->
    <div class="ai-widget-btn" id="ai-widget-toggle" onclick="toggleAIWidget()" title="Chat with AI Assistant">
        <i class="bi bi-robot" id="ai-widget-icon"></i>
    </div>

    <!-- Floating Chat Window -->
    <div class="ai-widget-box" id="ai-widget-container">
        <div class="ai-widget-header">
            <div class="ai-widget-header-title">
                <i class="bi bi-robot"></i> AI Academic Assistant
            </div>
            <button class="ai-widget-close" onclick="toggleAIWidget()"><i class="bi bi-x-lg"></i></button>
        </div>
        
        <div class="ai-widget-body" id="ai-widget-feed">
            <div class="ai-widget-msg bot">
                <div class="ai-widget-bubble">
                    <p><strong>Xin chào!</strong> Tôi là Trợ lý Học tập AI.</p>
                    <p>Hãy hỏi tôi bất kỳ điều gì về chương trình học hoặc tài liệu!</p>
                </div>
            </div>
        </div>

        <div class="ai-widget-chips">
            <div class="ai-widget-chip" onclick="submitWidgetChip('Học kỳ 3 ngành SE học những môn gì?')">Kỳ 3 học gì?</div>
            <div class="ai-widget-chip" onclick="submitWidgetChip('Thông tin môn học PRJ301?')">Môn PRJ301</div>
            <div class="ai-widget-chip" onclick="submitWidgetChip('Cho tôi xem chi tiết syllabus môn SWP391')">Syllabus SWP391</div>
        </div>

        <div class="ai-widget-footer">
            <form class="ai-widget-form" onsubmit="event.preventDefault(); submitWidgetMsg();">
                <input type="text" class="ai-widget-input" id="ai-widget-text-input" placeholder="Hỏi AI Assistant..." autocomplete="off" />
                <button type="submit" class="ai-widget-send">
                    <i class="bi bi-send-fill"></i>
                </button>
            </form>
        </div>
    </div>

    <!-- Floating Chat Widget Script -->
    <script>
        const widgetContainer = document.getElementById('ai-widget-container');
        const widgetFeed = document.getElementById('ai-widget-feed');
        const widgetInput = document.getElementById('ai-widget-text-input');
        const widgetToggleBtn = document.getElementById('ai-widget-toggle');
        const widgetIcon = document.getElementById('ai-widget-icon');
        let widgetOpen = false;

        function toggleAIWidget() {
            widgetOpen = !widgetOpen;
            if (widgetOpen) {
                widgetContainer.style.display = 'flex';
                widgetIcon.className = 'bi bi-x-lg';
                widgetToggleBtn.style.backgroundColor = '#64748b'; // slate grey when open
            } else {
                widgetContainer.style.display = 'none';
                widgetIcon.className = 'bi bi-robot';
                widgetToggleBtn.style.backgroundColor = ''; // back to default orange
            }
        }

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

        function appendWidgetMsg(sender, text) {
            const row = document.createElement('div');
            row.className = 'ai-widget-msg ' + sender;

            const bubble = document.createElement('div');
            bubble.className = 'ai-widget-bubble';

            if (sender === 'bot') {
                bubble.innerHTML = fixMaterialLinks(marked.parse(text));
            } else {
                bubble.textContent = text;
            }

            row.appendChild(bubble);
            widgetFeed.appendChild(row);
            widgetFeed.scrollTop = widgetFeed.scrollHeight;
        }

        function showWidgetTyping() {
            const row = document.createElement('div');
            row.className = 'ai-widget-msg bot';
            row.id = 'ai-widget-typing-row';

            const bubble = document.createElement('div');
            bubble.className = 'ai-widget-bubble';

            const typing = document.createElement('div');
            typing.className = 'ai-widget-typing';
            typing.innerHTML = '<div class="ai-widget-dot"></div><div class="ai-widget-dot"></div><div class="ai-widget-dot"></div>';

            bubble.appendChild(typing);
            row.appendChild(bubble);
            widgetFeed.appendChild(row);
            widgetFeed.scrollTop = widgetFeed.scrollHeight;
        }

        function removeWidgetTyping() {
            const indicator = document.getElementById('ai-widget-typing-row');
            if (indicator) indicator.remove();
        }

        function submitWidgetChip(text) {
            widgetInput.value = text;
            submitWidgetMsg();
        }

        function submitWidgetMsg() {
            const questionText = widgetInput.value.trim();
            if (!questionText) return;

            widgetInput.value = '';
            appendWidgetMsg('user', questionText);
            showWidgetTyping();

            const params = new URLSearchParams();
            params.append('question', questionText);

            fetch('${pageContext.request.contextPath}/ai-assistant', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params
            })
            .then(res => res.json())
            .then(data => {
                removeWidgetTyping();
                if (data.success) {
                    appendWidgetMsg('bot', data.answer);
                } else {
                    appendWidgetMsg('bot', '**Lỗi**: ' + (data.message || 'Không thể liên lạc với trợ lý AI.'));
                }
            })
            .catch(err => {
                removeWidgetTyping();
                console.error(err);
                appendWidgetMsg('bot', 'Lỗi kết nối mạng.');
            });
        }
    </script>
</c:if>
</body>
</html>
