// ============================================
// 开悟个体增智智能办公套件 V1.0 - 交互逻辑
// ============================================

// Particle System
class ParticleSystem {
    constructor(canvas) {
        this.canvas = canvas;
        this.ctx = canvas.getContext('2d');
        this.particles = [];
        this.mouse = { x: null, y: null };
        this.resize();
        this.init();
        this.animate();
        window.addEventListener('resize', () => this.resize());
        window.addEventListener('mousemove', (e) => {
            this.mouse.x = e.clientX;
            this.mouse.y = e.clientY;
        });
    }
    resize() {
        this.canvas.width = window.innerWidth;
        this.canvas.height = window.innerHeight;
    }
    init() {
        const count = Math.min(100, Math.floor(window.innerWidth / 15));
        for (let i = 0; i < count; i++) {
            this.particles.push({
                x: Math.random() * this.canvas.width,
                y: Math.random() * this.canvas.height,
                size: Math.random() * 2.5 + 0.5,
                speedX: (Math.random() - 0.5) * 0.6,
                speedY: (Math.random() - 0.5) * 0.6,
                opacity: Math.random() * 0.6 + 0.2,
                color: Math.random() > 0.5 ? '99, 102, 241' : '14, 165, 233'
            });
        }
    }
    animate() {
        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
        this.particles.forEach((p, i) => {
            p.x += p.speedX;
            p.y += p.speedY;
            if (p.x < 0 || p.x > this.canvas.width) p.speedX *= -1;
            if (p.y < 0 || p.y > this.canvas.height) p.speedY *= -1;
            
            if (this.mouse.x && this.mouse.y) {
                const dx = p.x - this.mouse.x;
                const dy = p.y - this.mouse.y;
                const dist = Math.sqrt(dx * dx + dy * dy);
                if (dist < 150) {
                    p.x += dx * 0.01;
                    p.y += dy * 0.01;
                }
            }
            
            this.ctx.beginPath();
            this.ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2);
            this.ctx.fillStyle = `rgba(${p.color}, ${p.opacity})`;
            this.ctx.fill();
            
            for (let j = i + 1; j < this.particles.length; j++) {
                const p2 = this.particles[j];
                const dx = p.x - p2.x;
                const dy = p.y - p2.y;
                const dist = Math.sqrt(dx * dx + dy * dy);
                if (dist < 120) {
                    this.ctx.beginPath();
                    this.ctx.moveTo(p.x, p.y);
                    this.ctx.lineTo(p2.x, p2.y);
                    this.ctx.strokeStyle = `rgba(99, 102, 241, ${0.15 * (1 - dist / 120)})`;
                    this.ctx.stroke();
                }
            }
        });
        requestAnimationFrame(() => this.animate());
    }
}

// Typewriter Effect
class Typewriter {
    constructor(element, texts, speed = 100) {
        this.element = element;
        this.texts = texts;
        this.speed = speed;
        this.textIndex = 0;
        this.charIndex = 0;
        this.isDeleting = false;
        this.type();
    }
    type() {
        const current = this.texts[this.textIndex];
        if (this.isDeleting) {
            this.element.textContent = current.substring(0, this.charIndex - 1);
            this.charIndex--;
        } else {
            this.element.textContent = current.substring(0, this.charIndex + 1);
            this.charIndex++;
        }
        let delay = this.isDeleting ? 50 : this.speed;
        if (!this.isDeleting && this.charIndex === current.length) {
            delay = 2500;
            this.isDeleting = true;
        } else if (this.isDeleting && this.charIndex === 0) {
            this.isDeleting = false;
            this.textIndex = (this.textIndex + 1) % this.texts.length;
            delay = 500;
        }
        setTimeout(() => this.type(), delay);
    }
}

// 3D Card Tilt
class CardTilt {
    constructor(cards) {
        cards.forEach(card => {
            card.addEventListener('mousemove', (e) => {
                const rect = card.getBoundingClientRect();
                const x = e.clientX - rect.left;
                const y = e.clientY - rect.top;
                const centerX = rect.width / 2;
                const centerY = rect.height / 2;
                const rotateX = (y - centerY) / 10;
                const rotateY = (centerX - x) / 10;
                card.style.transform = `perspective(1000px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) translateY(-8px)`;
            });
            card.addEventListener('mouseleave', () => {
                card.style.transform = 'perspective(1000px) rotateX(0) rotateY(0) translateY(0)';
            });
        });
    }
}

// Scroll Reveal
class ScrollReveal {
    constructor() {
        this.observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('revealed');
                }
            });
        }, { threshold: 0.1 });
        document.querySelectorAll('.scroll-reveal').forEach(el => this.observer.observe(el));
    }
}

// Counter Animation
class CounterAnimation {
    constructor() {
        this.animated = false;
        this.observer = new IntersectionObserver((entries) => {
            if (entries[0].isIntersecting && !this.animated) {
                this.animated = true;
                this.animate();
            }
        }, { threshold: 0.5 });
        const stats = document.querySelector('.hero-stats');
        if (stats) this.observer.observe(stats);
    }
    animate() {
        document.querySelectorAll('.stat-number').forEach(el => {
            const target = parseInt(el.getAttribute('data-target'));
            if (!target) return;
            const suffix = el.textContent.replace('0', '');
            let current = 0;
            const step = Math.ceil(target / 50);
            const timer = setInterval(() => {
                current += step;
                if (current >= target) { current = target; clearInterval(timer); }
                el.textContent = current + (suffix || '');
            }, 20);
        });
    }
}

// Render Functions
function renderFeatures() {
    const grid = document.getElementById('featuresGrid');
    if (!grid || !FEATURES_DATA) return;
    grid.innerHTML = FEATURES_DATA.map(f => `
        <div class="feature-card">
            <div class="feature-icon ${f.color}">${getIcon(f.icon)}</div>
            <h3>${f.title}</h3>
            <p>${f.desc}</p>
            <ul class="feature-list">
                ${f.list.map(item => `<li><svg viewBox="0 0 16 16" fill="currentColor"><path d="M13.78 4.22a.75.75 0 010 1.06l-7.25 7.25a.75.75 0 01-1.06 0L2.22 9.28a.75.75 0 011.06-1.06L6 10.94l6.72-6.72a.75.75 0 011.06 0z"/></svg>${item}</li>
            </ul>
        </div>
    `).join('');
    new CardTilt(grid.querySelectorAll('.feature-card'));
}

function renderCases() {
    const tabs = document.getElementById('casesTabs');
    const content = document.getElementById('casesContent');
    if (!tabs || !content || !CASES_DATA) return;
    
    tabs.innerHTML = CASES_DATA.map((c, i) => `
        <button class="case-tab ${i === 0 ? 'active' : ''}" data-case="${c.id}">
            ${getIcon(c.icon)} ${c.title}
        </button>
    `).join('');
    
    content.innerHTML = CASES_DATA.map((c, i) => `
        <div class="case-panel ${i === 0 ? 'active' : ''}" id="${c.id}">
            <div class="case-header">
                <div class="case-icon">${getIcon(c.icon)}</div>
                <h3>${c.title}</h3>
            </div>
            <div class="case-body">
                <div class="case-desc">${c.desc}</div>
                <div class="case-steps">
                    <h4><svg viewBox="0 0 18 18" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M9 1v16M1 9h16"/></svg>操作流程</h4>
                    <ol>${c.steps.map(s => `<li>${s}</li>`).join('')}</ol>
                </div>
                <div class="case-tags">
                    ${c.tags.map(t => `<span class="case-tag"><svg viewBox="0 0 14 14" fill="currentColor"><path d="M7 0l2.15 4.35L14 5.25l-3.5 3.4.83 4.82L7 11.17l-4.33 2.3.83-4.82L0 5.25l4.85-.9z"/></svg>${t}</span>`).join('')}
                </div>
            </div>
        </div>
    `).join('');
    
    tabs.querySelectorAll('.case-tab').forEach(btn => {
        btn.addEventListener('click', function() {
            tabs.querySelectorAll('.case-tab').forEach(b => b.classList.remove('active'));
            content.querySelectorAll('.case-panel').forEach(p => p.classList.remove('active'));
            btn.classList.add('active');
            const panel = document.getElementById(btn.getAttribute('data-case'));
            if (panel) panel.classList.add('active');
        });
    });
}

function renderGuide() {
    const grid = document.getElementById('guideGrid');
    if (!grid || !GUIDE_DATA) return;
    grid.innerHTML = GUIDE_DATA.map(g => `
        <div class="guide-card">
            <div class="guide-number">${g.num}</div>
            <h3>${g.title}</h3>
            <ul class="guide-list">
                ${g.items.map(item => `<li><svg viewBox="0 0 16 16" fill="currentColor"><path d="M8 0a8 8 0 110 16A8 8 0 018 0zm3.78 5.22a.75.75 0 00-1.06 0L7 8.94 5.28 7.22a.75.75 0 00-1.06 1.06l2.25 2.25a.75.75 0 001.06 0l4.25-4.25a.75.75 0 000-1.06z"/></svg>${item}</li>
            </ul>
        </div>
    `).join('');
}

function renderEntry() {
    const grid = document.getElementById('entryGrid');
    if (!grid || !ENTRY_DATA) return;
    grid.innerHTML = ENTRY_DATA.map(e => `
        <div class="entry-card" onclick="openApp('${e.id}')">
            <div class="entry-icon ${e.color}">${getIcon(e.icon)}</div>
            <h3>${e.title}</h3>
            <p>${e.desc}</p>
            <button class="entry-btn">
                <svg viewBox="0 0 14 14" fill="currentColor"><path d="M1 1h5v1H2v10h10V8h1v5H1V1zm6 0h6v6h-1V3.41L4.71 8.7 4 8l4.3-4.3H7V1z"/></svg>
                启动
            </button>
        </div>
    `).join('');
}

function renderFaq() {
    const list = document.getElementById('faqList');
    if (!list || !FAQ_DATA) return;
    list.innerHTML = FAQ_DATA.map(f => `
        <div class="faq-item">
            <button class="faq-question">
                ${f.q}
                <svg viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd"/></svg>
            </button>
            <div class="faq-answer">
                <ul>${f.a.map(item => `<li><svg viewBox="0 0 16 16" fill="currentColor"><path d="M8 0a8 8 0 110 16A8 8 0 018 0zm3.78 5.22a.75.75 0 00-1.06 0L7 8.94 5.28 7.22a.75.75 0 00-1.06 1.06l2.25 2.25a.75.75 0 001.06 0l4.25-4.25a.75.75 0 000-1.06z"/></svg>${item}</li>`).join('')}</ul>
            </div>
        </div>
    `).join('');
    
    list.querySelectorAll('.faq-question').forEach(q => {
        q.addEventListener('click', function() {
            const item = this.parentElement;
            const isOpen = item.classList.contains('open');
            list.querySelectorAll('.faq-item').forEach(i => i.classList.remove('open'));
            if (!isOpen) item.classList.add('open');
        });
    });
}

function renderDocs() {
    const grid = document.getElementById('docsGrid');
    if (!grid || !DOCS_DATA) return;
    grid.innerHTML = DOCS_DATA.map(d => `
        <a href="../docs/0${DOCS_DATA.indexOf(d)+1}_${d.id}.md" class="doc-card" target="_blank">
            <div class="doc-icon">${getIcon(d.icon)}</div>
            <h3>${d.title}</h3>
            <p>${d.desc}</p>
        </a>
    `).join('');
}

// Open App
function openApp(app) {
    var paths = {
        'wps': '../installers/02_office/wps/',
        'everything': '../installers/03_tools/everything/',
        'ocr': '../installers/03_tools/tesseract/',
        'obsidian': '../installers/04_knowledge/obsidian/',
        'xmind': '../installers/04_knowledge/xmind/',
        'aionui': '../installers/01_agent/aionui/',
        'check': '../check.bat',
        'repair': '../repair.bat'
    };
    var names = {
        'wps': 'WPS Office', 'everything': 'Everything', 'ocr': 'OCR 识别工具',
        'obsidian': 'Obsidian', 'xmind': 'XMind', 'aionui': 'AionUI Agent',
        'check': '系统检测', 'repair': '系统修复'
    };
    var path = paths[app], name = names[app] || app;
    if (!path) { alert('组件路径未配置'); return; }
    alert('即将打开：' + name + '\n\n路径：' + path + '\n\n说明：需要在已安装套件的 Windows 7 环境下使用。');
}

// Data Stream Effect
(function initDataStream() {
    var container = document.getElementById('dataStream');
    if (!container) return;
    var chars = '01アイウエオカキクケコ<>/{}[]ABCDEF';
    for (var i = 0; i < 25; i++) {
        var span = document.createElement('span');
        span.textContent = chars[Math.floor(Math.random() * chars.length)];
        span.style.left = Math.random() * 100 + '%';
        span.style.animationDuration = (4 + Math.random() * 6) + 's';
        span.style.animationDelay = (-Math.random() * 8) + 's';
        span.style.fontSize = (10 + Math.random() * 8) + 'px';
        container.appendChild(span);
    }
    setInterval(function() {
        var spans = container.querySelectorAll('span');
        if (spans.length > 0) {
            var idx = Math.floor(Math.random() * spans.length);
            spans[idx].textContent = chars[Math.floor(Math.random() * chars.length)];
        }
    }, 1500);
})();

// Initialize
document.addEventListener('DOMContentLoaded', function() {
    // Particle System
    const canvas = document.getElementById('particles');
    if (canvas) new ParticleSystem(canvas);
    
    // Typewriter
    const tw = document.getElementById('typewriter');
    if (tw) new Typewriter(tw, ['AI 驱动的智能办公解决方案', '让每个办公场景都有 AI 助手', '离线可用的完整办公套件', '一键安装即刻体验']);
    
    // Render content
    renderFeatures();
    renderCases();
    renderGuide();
    renderEntry();
    renderFaq();
    renderDocs();
    
    // Scroll Reveal
    new ScrollReveal();
    
    // Counter Animation
    new CounterAnimation();
    
    // Mobile nav
    const navToggle = document.getElementById('navToggle');
    const navLinks = document.querySelector('.nav-links');
    if (navToggle && navLinks) {
        navToggle.addEventListener('click', () => navLinks.classList.toggle('open'));
        document.querySelectorAll('.nav-links a').forEach(l => {
            l.addEventListener('click', () => navLinks.classList.remove('open'));
        });
    }
    
    // Navbar scroll
    window.addEventListener('scroll', () => {
        document.querySelector('.navbar').classList.toggle('scrolled', window.scrollY > 50);
    });
    
    // Smooth scroll
    document.querySelectorAll('a[href^="#"]').forEach(a => {
        a.addEventListener('click', function(e) {
            e.preventDefault();
            const t = document.querySelector(this.getAttribute('href'));
            if (t) window.scrollTo({ top: t.getBoundingClientRect().top + window.pageYOffset - 72, behavior: 'smooth' });
        });
    });
});
