document.addEventListener('DOMContentLoaded', function() {
    // Mobile nav toggle
    var navToggle = document.getElementById('navToggle');
    var navLinks = document.querySelector('.nav-links');
    if (navToggle && navLinks) {
        navToggle.addEventListener('click', function() { navLinks.classList.toggle('open'); });
        document.querySelectorAll('.nav-links a').forEach(function(l) {
            l.addEventListener('click', function() { navLinks.classList.remove('open'); });
        });
    }

    // Navbar scroll effect
    window.addEventListener('scroll', function() {
        var navbar = document.querySelector('.navbar');
        navbar.classList.toggle('scrolled', window.scrollY > 50);
    });

    // Smooth scroll
    document.querySelectorAll('a[href^="#"]').forEach(function(a) {
        a.addEventListener('click', function(e) {
            e.preventDefault();
            var t = document.querySelector(this.getAttribute('href'));
            if (t) {
                var off = 72;
                window.scrollTo({ top: t.getBoundingClientRect().top + window.pageYOffset - off, behavior: 'smooth' });
            }
        });
    });

    // Case tabs
    document.querySelectorAll('.case-tab').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var target = this.getAttribute('data-case');
            document.querySelectorAll('.case-tab').forEach(function(b) { b.classList.remove('active'); });
            document.querySelectorAll('.case-panel').forEach(function(p) { p.classList.remove('active'); });
            btn.classList.add('active');
            var panel = document.getElementById(target);
            if (panel) panel.classList.add('active');
        });
    });

    // FAQ accordion
    document.querySelectorAll('.faq-question').forEach(function(q) {
        q.addEventListener('click', function() {
            var item = this.parentElement;
            var isOpen = item.classList.contains('open');
            document.querySelectorAll('.faq-item').forEach(function(i) { i.classList.remove('open'); });
            if (!isOpen) item.classList.add('open');
        });
    });

    // Counter animation
    var animated = false;
    function animateCounters() {
        if (animated) return;
        var stats = document.querySelector('.hero-stats');
        if (!stats) return;
        var rect = stats.getBoundingClientRect();
        if (rect.top < window.innerHeight && rect.bottom > 0) {
            animated = true;
            document.querySelectorAll('.stat-number').forEach(function(el) {
                var target = parseInt(el.getAttribute('data-target'));
                if (!target) return;
                var suffix = el.textContent.replace('0', '');
                var current = 0;
                var step = Math.ceil(target / 40);
                var timer = setInterval(function() {
                    current += step;
                    if (current >= target) { current = target; clearInterval(timer); }
                    el.textContent = current + (suffix || '');
                }, 25);
            });
        }
    }
    window.addEventListener('scroll', animateCounters);
    animateCounters();

    // Intersection observer for fade-in
    var observer = new IntersectionObserver(function(entries) {
        entries.forEach(function(entry) {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, { threshold: 0.1 });

    document.querySelectorAll('.feature-card, .guide-card, .entry-card, .doc-card').forEach(function(el) {
        el.style.opacity = '0';
        el.style.transform = 'translateY(20px)';
        el.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
        observer.observe(el);
    });
});

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
    var path = paths[app];
    var name = names[app] || app;
    if (!path) { alert('组件路径未配置'); return; }
    alert('即将打开：' + name + '\n\n路径：' + path + '\n\n说明：此入口需要在已安装套件的 Windows 7 环境下使用。');
}
