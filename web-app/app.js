// ============================================
// 开悟个体增智智能办公套件 V1.4.1 - 交互逻辑
// ============================================

// Particle System
class ParticleSystem {
    constructor(canvas) {
        this.canvas = canvas;
        this.ctx = canvas.getContext('2d');
        this.particles = [];
        this.mouse = { x: null, y: null };
        this.colors = this.getThemeColors();
        this.resize();
        this.init();
        this.animate();
        window.addEventListener('resize', () => this.resize());
        window.addEventListener('mousemove', (e) => {
            this.mouse.x = e.clientX;
            this.mouse.y = e.clientY;
        });
    }
    getThemeColors() {
        var isTechBlue = document.documentElement.classList.contains('theme-techblue');
        if (isTechBlue) return { primary: '99, 102, 241', secondary: '14, 165, 233' };
        return { primary: '196, 18, 48', secondary: '0, 102, 204' };
    }
    updateColors() {
        this.colors = this.getThemeColors();
        this.particles.forEach(function(p) {
            p.color = Math.random() > 0.5 ? p.primaryColor : p.secondaryColor;
        });
    }
    resize() {
        this.canvas.width = window.innerWidth;
        this.canvas.height = window.innerHeight;
    }
    init() {
        var count = Math.min(100, Math.floor(window.innerWidth / 15));
        for (var i = 0; i < count; i++) {
            this.particles.push({
                x: Math.random() * this.canvas.width,
                y: Math.random() * this.canvas.height,
                size: Math.random() * 2.5 + 0.5,
                speedX: (Math.random() - 0.5) * 0.6,
                speedY: (Math.random() - 0.5) * 0.6,
                opacity: Math.random() * 0.6 + 0.2,
                color: Math.random() > 0.5 ? this.colors.primary : this.colors.secondary,
                primaryColor: this.colors.primary,
                secondaryColor: this.colors.secondary
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
                var dx = p.x - this.mouse.x;
                var dy = p.y - this.mouse.y;
                var dist = Math.sqrt(dx * dx + dy * dy);
                if (dist < 150) { p.x += dx * 0.01; p.y += dy * 0.01; }
            }
            this.ctx.beginPath();
            this.ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2);
            this.ctx.fillStyle = 'rgba(' + p.color + ',' + p.opacity + ')';
            this.ctx.fill();
            for (var j = i + 1; j < this.particles.length; j++) {
                var p2 = this.particles[j];
                var dx2 = p.x - p2.x;
                var dy2 = p.y - p2.y;
                var dist2 = Math.sqrt(dx2 * dx2 + dy2 * dy2);
                if (dist2 < 120) {
                    this.ctx.beginPath();
                    this.ctx.moveTo(p.x, p.y);
                    this.ctx.lineTo(p2.x, p2.y);
                    this.ctx.strokeStyle = 'rgba(' + this.colors.primary + ',' + (0.15 * (1 - dist2 / 120)) + ')';
                    this.ctx.stroke();
                }
            }
        });
        requestAnimationFrame(() => this.animate());
    }
}

// Typewriter Effect
class Typewriter {
    constructor(element, texts, speed) {
        this.element = element;
        this.texts = texts;
        this.speed = speed || 100;
        this.textIndex = 0;
        this.charIndex = 0;
        this.isDeleting = false;
        this.type();
    }
    type() {
        var current = this.texts[this.textIndex];
        if (this.isDeleting) {
            this.element.textContent = current.substring(0, this.charIndex - 1);
            this.charIndex--;
        } else {
            this.element.textContent = current.substring(0, this.charIndex + 1);
            this.charIndex++;
        }
        var delay = this.isDeleting ? 50 : this.speed;
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
                var rect = card.getBoundingClientRect();
                var x = e.clientX - rect.left;
                var y = e.clientY - rect.top;
                var centerX = rect.width / 2;
                var centerY = rect.height / 2;
                var rotateX = (y - centerY) / 10;
                var rotateY = (centerX - x) / 10;
                card.style.transform = 'perspective(1000px) rotateX(' + rotateX + 'deg) rotateY(' + rotateY + 'deg) translateY(-8px)';
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
        var stats = document.querySelector('.hero-stats');
        if (stats) this.observer.observe(stats);
    }
    animate() {
        document.querySelectorAll('.stat-number').forEach(el => {
            var target = parseInt(el.getAttribute('data-target'));
            if (!target) return;
            var current = 0;
            var step = Math.ceil(target / 50);
            var timer = setInterval(() => {
                current += step;
                if (current >= target) { current = target; clearInterval(timer); }
                el.textContent = current;
            }, 20);
        });
    }
}

// Helper: build list items HTML
function buildListItems(items, iconSvg) {
    var html = '';
    for (var i = 0; i < items.length; i++) {
        html += '<li>' + iconSvg + items[i] + '</li>';
    }
    return html;
}

var CHECK_SVG = '<svg viewBox="0 0 16 16" fill="currentColor" width="16" height="16"><path d="M13.78 4.22a.75.75 0 010 1.06l-7.25 7.25a.75.75 0 01-1.06 0L2.22 9.28a.75.75 0 011.06-1.06L6 10.94l6.72-6.72a.75.75 0 011.06 0z"/></svg>';
var STAR_SVG = '<svg viewBox="0 0 14 14" fill="currentColor" width="14" height="14"><path d="M7 0l2.15 4.35L14 5.25l-3.5 3.4.83 4.82L7 11.17l-4.33 2.3.83-4.82L0 5.25l4.85-.9z"/></svg>';
var PLUS_SVG = '<svg viewBox="0 0 18 18" fill="none" stroke="currentColor" stroke-width="1.5" width="18" height="18"><path d="M9 1v16M1 9h16"/></svg>';

// Render Functions
function renderFeatures() {
    var grid = document.getElementById('featuresGrid');
    if (!grid || typeof FEATURES_DATA === 'undefined') return;
    var html = '';
    for (var i = 0; i < FEATURES_DATA.length; i++) {
        var f = FEATURES_DATA[i];
        html += '<div class="feature-card">';
        html += '<div class="feature-icon ' + f.color + '">' + getIcon(f.icon) + '</div>';
        html += '<h3>' + f.title + '</h3>';
        html += '<p>' + f.desc + '</p>';
        html += '<ul class="feature-list">';
        html += buildListItems(f.list, CHECK_SVG);
        html += '</ul></div>';
    }
    grid.innerHTML = html;
    new CardTilt(grid.querySelectorAll('.feature-card'));
}

function renderCases() {
    var tabs = document.getElementById('casesTabs');
    var content = document.getElementById('casesContent');
    if (!tabs || !content || typeof CASES_DATA === 'undefined') return;

    var tabsHtml = '';
    var panelsHtml = '';
    for (var i = 0; i < CASES_DATA.length; i++) {
        var c = CASES_DATA[i];
        var active = i === 0 ? ' active' : '';
        tabsHtml += '<button class="case-tab' + active + '" data-case="' + c.id + '">';
        tabsHtml += getIcon(c.icon) + ' ' + c.title + '</button>';

        panelsHtml += '<div class="case-panel' + active + '" id="' + c.id + '">';
        panelsHtml += '<div class="case-header"><div class="case-icon">' + getIcon(c.icon) + '</div>';
        panelsHtml += '<h3>' + c.title + '</h3></div>';
        panelsHtml += '<div class="case-body">';
        panelsHtml += '<div class="case-desc">' + c.desc + '</div>';
        panelsHtml += '<div class="case-steps"><h4>' + PLUS_SVG + '操作流程</h4><ol>';
        for (var s = 0; s < c.steps.length; s++) {
            panelsHtml += '<li>' + c.steps[s] + '</li>';
        }
        panelsHtml += '</ol></div>';
        panelsHtml += '<div class="case-tags">';
        for (var t = 0; t < c.tags.length; t++) {
            panelsHtml += '<span class="case-tag">' + STAR_SVG + c.tags[t] + '</span>';
        }
        panelsHtml += '</div></div></div>';
    }
    tabs.innerHTML = tabsHtml;
    content.innerHTML = panelsHtml;

    var tabBtns = tabs.querySelectorAll('.case-tab');
    tabBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            tabBtns.forEach(function(b) { b.classList.remove('active'); });
            content.querySelectorAll('.case-panel').forEach(function(p) { p.classList.remove('active'); });
            btn.classList.add('active');
            var panel = document.getElementById(btn.getAttribute('data-case'));
            if (panel) panel.classList.add('active');
        });
    });
}

function renderGuide() {
    var grid = document.getElementById('guideGrid');
    if (!grid || typeof GUIDE_DATA === 'undefined') return;
    var html = '';
    for (var i = 0; i < GUIDE_DATA.length; i++) {
        var g = GUIDE_DATA[i];
        html += '<div class="guide-card">';
        html += '<div class="guide-number">' + g.num + '</div>';
        html += '<h3>' + g.title + '</h3>';
        html += '<ul class="guide-list">';
        html += buildListItems(g.items, CHECK_SVG);
        html += '</ul></div>';
    }
    grid.innerHTML = html;
}

function renderEntry() {
    var grid = document.getElementById('entryGrid');
    if (!grid || typeof ENTRY_DATA === 'undefined') return;
    var html = '';
    for (var i = 0; i < ENTRY_DATA.length; i++) {
        var e = ENTRY_DATA[i];
        html += '<div class="entry-card" onclick="openApp(\'' + e.id + '\')">';
        html += '<div class="entry-icon ' + e.color + '">' + getIcon(e.icon) + '</div>';
        html += '<h3>' + e.title + '</h3>';
        html += '<p>' + e.desc + '</p>';
        html += '<button class="entry-btn"><svg viewBox="0 0 14 14" fill="currentColor" width="14" height="14"><path d="M1 1h5v1H2v10h10V8h1v5H1V1zm6 0h6v6h-1V3.41L4.71 8.7 4 8l4.3-4.3H7V1z"/></svg>查看路径</button>';
        html += '</div>';
    }
    grid.innerHTML = html;
}

function renderFaq() {
    var list = document.getElementById('faqList');
    if (!list || typeof FAQ_DATA === 'undefined') return;
    var html = '';
    for (var i = 0; i < FAQ_DATA.length; i++) {
        var f = FAQ_DATA[i];
        html += '<div class="faq-item">';
        html += '<button class="faq-question">' + f.q;
        html += '<svg viewBox="0 0 20 20" fill="currentColor" width="20" height="20"><path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd"/></svg>';
        html += '</button>';
        html += '<div class="faq-answer"><ul>';
        html += buildListItems(f.a, CHECK_SVG);
        html += '</ul></div></div>';
    }
    list.innerHTML = html;

    list.querySelectorAll('.faq-question').forEach(function(q) {
        q.addEventListener('click', function() {
            var item = this.parentElement;
            var isOpen = item.classList.contains('open');
            list.querySelectorAll('.faq-item').forEach(function(i) { i.classList.remove('open'); });
            if (!isOpen) item.classList.add('open');
        });
    });
}

function renderDocs() {
    var grid = document.getElementById('docsGrid');
    if (!grid || typeof DOCS_DATA === 'undefined') return;
    var html = '';
    for (var i = 0; i < DOCS_DATA.length; i++) {
        var d = DOCS_DATA[i];
        html += '<a href="../docs/' + encodeURIComponent(d.file) + '" class="doc-card" target="_blank">';
        html += '<div class="doc-icon">' + getIcon(d.icon) + '</div>';
        html += '<h3>' + d.title + '</h3>';
        html += '<p>' + d.desc + '</p>';
        html += '</a>';
    }
    grid.innerHTML = html;
}

// Open App
function openApp(app) {
    var paths = {
        'wps': '../packages/raw/WPS_Setup_26895.exe',
        'everything': '../packages/raw/Everything-1.4.1.1024.x64-Setup.exe',
        'ocr': '../packages/raw/tesseract-ocr-w64-setup-5.3.1.20230401.exe',
        'obsidian': '../packages/raw/Obsidian.1.4.16.exe',
        'xmind': null,
        'aionui': '../packages/raw/AionUI-setup.exe',
        'check': '../check.bat',
        'repair': '../repair.bat'
    };
    var names = {
        'wps': 'WPS Office', 'everything': 'Everything', 'ocr': 'OCR 识别工具',
        'obsidian': 'Obsidian', 'xmind': 'XMind', 'aionui': 'AionUI Agent',
        'check': '系统检测', 'repair': '系统修复'
    };
    var path = paths[app], name = names[app] || app;
    if (!path) { alert('该组件未随当前候选版交付。'); return; }
    alert('组件：' + name + '\n\n路径：' + path + '\n\n浏览器不会直接执行本地程序，请从资源管理器或开始菜单启动。');
}

// Data Stream Effect
(function initDataStream() {
    var container = document.getElementById('dataStream');
    if (!container) return;
    var chars = '01电科信安控测通导算网智芯雷卫量子密码二进制十六进制ABCDEF';
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
var particleSystem = null;
document.addEventListener('DOMContentLoaded', function() {
    var canvas = document.getElementById('particles');
    if (canvas) particleSystem = new ParticleSystem(canvas);

    var twEl = document.getElementById('typewriter');
    var defaultTexts = ['公文写作 / 会议纪要 / 数据分析 / 知识管理 一体化', 'AI Agent + MCP + A2A 智能组件协议体系', '支持离线部署与国产化平台适配', '30+ 智能组件，开箱即用'];
    var techblueTexts = ['AI 驱动的智能办公解决方案', '让每个办公场景都有 AI 助手', '离线可用的完整办公套件', '一键安装即刻体验'];
    var tw = null;
    if (twEl) {
        tw = new Typewriter(twEl, defaultTexts);
    }

    renderFeatures();
    renderCases();
    renderGuide();
    renderEntry();
    renderFaq();
    renderDocs();

    new ScrollReveal();
    new CounterAnimation();

    var navToggle = document.getElementById('navToggle');
    var navLinks = document.querySelector('.nav-links');
    if (navToggle && navLinks) {
        navToggle.addEventListener('click', function() { navLinks.classList.toggle('open'); });
        document.querySelectorAll('.nav-links a').forEach(function(l) {
            l.addEventListener('click', function() { navLinks.classList.remove('open'); });
        });
    }

    window.addEventListener('scroll', function() {
        document.querySelector('.navbar').classList.toggle('scrolled', window.scrollY > 50);
    });

    document.querySelectorAll('a[href^="#"]').forEach(function(a) {
        a.addEventListener('click', function(e) {
            e.preventDefault();
            var t = document.querySelector(this.getAttribute('href'));
            if (t) window.scrollTo({ top: t.getBoundingClientRect().top + window.pageYOffset - 72, behavior: 'smooth' });
        });
    });

    // Theme Switcher
    var themes = ['default', 'techblue'];
    var themeColors = {
        default: { main: '#C41230', light: '#E8354A', mid: '#0066CC', dark: '#8B0D22', deep: '#004499', rgb: '196, 18, 48' },
        techblue: { main: '#6366f1', light: '#818cf8', mid: '#0ea5e9', dark: '#4f46e5', deep: '#6366f1', rgb: '99, 102, 241' }
    };
    var themeToggle = document.getElementById('themeToggle');
    var themeLabel = document.getElementById('themeLabel');
    var savedTheme = localStorage.getItem('kw-theme');
    if (themes.indexOf(savedTheme) === -1) savedTheme = 'default';
    applyTheme(savedTheme);

    if (themeToggle) {
        themeToggle.addEventListener('click', function() {
            var current = document.body.getAttribute('data-theme') || 'default';
            var idx = themes.indexOf(current);
            var next = themes[(idx + 1) % themes.length];
            applyTheme(next);
            localStorage.setItem('kw-theme', next);
        });
    }

    // Scroll Spy - highlight active menu item based on scroll position
    function initScrollSpy() {
        var links = document.querySelectorAll('.nav-links a[href^="#"]');
        var sections = [];
        links.forEach(function(link) {
            var id = link.getAttribute('href').substring(1);
            var section = document.getElementById(id);
            if (section) sections.push({ id: id, el: section, link: link });
        });
        if (sections.length === 0) return;
        function setActive(id) {
            links.forEach(function(l) { l.classList.remove('active'); });
            var link = document.querySelector('.nav-links a[href="#' + id + '"]');
            if (link) link.classList.add('active');
        }
        var observer = new IntersectionObserver(function(entries) {
            entries.forEach(function(entry) {
                if (entry.isIntersecting) setActive(entry.target.id);
            });
        }, { rootMargin: '-30% 0px -55% 0px', threshold: 0 });
        sections.forEach(function(s) { observer.observe(s.el); });
    }
    initScrollSpy();

    function applyTheme(name) {
        document.body.setAttribute('data-theme', name);
        document.documentElement.className = name === 'default' ? '' : 'theme-' + name;
        var labels = { default: 'Default', techblue: 'TechBlue' };
        if (themeLabel) themeLabel.textContent = labels[name] || name;
        updateSvgColors(name);
        if (particleSystem) particleSystem.updateColors();
        if (tw) {
            tw.texts = name === 'techblue' ? techblueTexts : defaultTexts;
            tw.textIndex = 0;
            tw.charIndex = 0;
            tw.isDeleting = false;
            tw.element.textContent = '';
        }
        renderFeatures();
        renderCases();
        renderGuide();
        renderEntry();
        renderFaq();
        renderDocs();
    }

    function updateSvgColors(name) {
        var c = themeColors[name] || themeColors['default'];
        var rgb = c.rgb;
        var light = c.light;
        var mid = c.mid;
        var dark = c.dark;
        var deep = c.deep;

        document.querySelectorAll('.nav-brand svg, .footer-brand svg').forEach(function(svg) {
            var stops = svg.querySelectorAll('linearGradient stop');
            if (stops.length >= 2) {
                stops[0].setAttribute('stop-color', light);
                stops[1].setAttribute('stop-color', mid);
            }
            if (stops.length >= 4) {
                stops[2].setAttribute('stop-color', dark);
                stops[3].setAttribute('stop-color', deep);
            }
            svg.querySelectorAll('path[stroke="#818cf8"], ellipse[stroke="#818cf8"], circle[fill="#818cf8"], line[stroke="#818cf8"]').forEach(function(el) {
                if (el.tagName === 'circle' && el.getAttribute('fill')) el.setAttribute('fill', light);
                else el.setAttribute('stroke', light);
            });
            svg.querySelectorAll('path[stroke="#0ea5e9"], ellipse[stroke="#0ea5e9"], circle[fill="#0ea5e9"], line[stroke="#0ea5e9"]').forEach(function(el) {
                if (el.tagName === 'circle' && el.getAttribute('fill')) el.setAttribute('fill', mid);
                else el.setAttribute('stroke', mid);
            });
            svg.querySelectorAll('circle[stroke="#a78bfa"], line[stroke="#a78bfa"]').forEach(function(el) {
                if (el.tagName === 'circle' && el.getAttribute('fill')) el.setAttribute('fill', light);
                else el.setAttribute('stroke', light);
            });
            svg.querySelectorAll('circle[fill="#06b6d4"], line[stroke="#06b6d4"]').forEach(function(el) {
                if (el.tagName === 'circle' && el.getAttribute('fill')) el.setAttribute('fill', mid);
                else el.setAttribute('stroke', mid);
            });
            var glowFilter = svg.querySelector('feGaussianBlur');
            if (glowFilter) {
                var filterParent = glowFilter.closest('filter');
                if (filterParent) {
                    var merge = filterParent.querySelector('feMerge');
                    if (merge) {
                        var feMergeNode = merge.querySelector('feMergeNode');
                        if (feMergeNode) {
                            feMergeNode.setAttribute('in', 'SourceGraphic');
                        }
                    }
                }
            }
        });

        document.querySelectorAll('.corner-decor svg path').forEach(function(p, i) {
            var fills = [
                'rgba(' + rgb + ',0.3)',
                'rgba(' + rgb + ',0.3)',
                'rgba(' + rgb + ',0.3)',
                'rgba(' + rgb + ',0.3)'
            ];
            p.setAttribute('fill', fills[i % 4]);
        });
        document.querySelectorAll('.corner-decor svg circle').forEach(function(c) {
            c.setAttribute('fill', 'rgba(' + rgb + ',0.5)');
        });

        var heroGlow = document.querySelector('.hero-glow');
        if (heroGlow) heroGlow.style.background = 'radial-gradient(circle, rgba(' + rgb + ', 0.35) 0%, transparent 55%)';
        var heroGlow2 = document.querySelector('.hero-glow-2');
        if (heroGlow2) heroGlow2.style.background = 'radial-gradient(circle, rgba(' + rgb + ', 0.25) 0%, transparent 55%)';
        
        document.documentElement.style.setProperty('--cetc-glow', 'radial-gradient(circle, rgba(' + rgb + ', 0.35) 0%, transparent 55%)');
    }
});
