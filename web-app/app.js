document.addEventListener('DOMContentLoaded', function() {

    // Mobile navigation toggle
    const navToggle = document.getElementById('navToggle');
    const navLinks = document.querySelector('.nav-links');
    if (navToggle && navLinks) {
        navToggle.addEventListener('click', function() {
            navLinks.classList.toggle('open');
        });
        document.querySelectorAll('.nav-links a').forEach(function(link) {
            link.addEventListener('click', function() {
                navLinks.classList.remove('open');
            });
        });
    }

    // Case tab switching
    const tabBtns = document.querySelectorAll('.tab-btn');
    const casePanels = document.querySelectorAll('.case-panel');
    tabBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            var target = this.getAttribute('data-case');
            tabBtns.forEach(function(b) { b.classList.remove('active'); });
            casePanels.forEach(function(p) { p.classList.remove('active'); });
            btn.classList.add('active');
            var panel = document.getElementById(target);
            if (panel) { panel.classList.add('active'); }
        });
    });

    // FAQ accordion
    var faqQuestions = document.querySelectorAll('.faq-question');
    faqQuestions.forEach(function(q) {
        q.addEventListener('click', function() {
            var item = this.parentElement;
            var isOpen = item.classList.contains('open');
            document.querySelectorAll('.faq-item').forEach(function(i) {
                i.classList.remove('open');
            });
            if (!isOpen) { item.classList.add('open'); }
        });
    });

    // Smooth scroll for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(function(anchor) {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            var target = document.querySelector(this.getAttribute('href'));
            if (target) {
                var offset = 70;
                var top = target.getBoundingClientRect().top + window.pageYOffset - offset;
                window.scrollTo({ top: top, behavior: 'smooth' });
            }
        });
    });

    // Navbar background on scroll
    window.addEventListener('scroll', function() {
        var navbar = document.querySelector('.navbar');
        if (navbar) {
            if (window.scrollY > 50) {
                navbar.style.boxShadow = '0 2px 10px rgba(0,0,0,0.1)';
            } else {
                navbar.style.boxShadow = 'none';
            }
        }
    });

    // Stats counter animation
    var statNumbers = document.querySelectorAll('.stat-number');
    var animated = false;
    function animateStats() {
        if (animated) return;
        var statsSection = document.querySelector('.hero-stats');
        if (!statsSection) return;
        var rect = statsSection.getBoundingClientRect();
        if (rect.top < window.innerHeight && rect.bottom > 0) {
            animated = true;
            statNumbers.forEach(function(el) {
                var text = el.textContent;
                var match = text.match(/(\d+)/);
                if (match) {
                    var target = parseInt(match[0]);
                    var suffix = text.replace(match[0], '');
                    var current = 0;
                    var step = Math.ceil(target / 30);
                    var timer = setInterval(function() {
                        current += step;
                        if (current >= target) {
                            current = target;
                            clearInterval(timer);
                        }
                        el.textContent = current + suffix;
                    }, 30);
                }
            });
        }
    }
    window.addEventListener('scroll', animateStats);
    animateStats();
});

function openApp(app) {
    var appPaths = {
        'wps': '../installers/02_office/wps/',
        'everything': '../installers/03_tools/everything/',
        'ocr': '../installers/03_tools/tesseract/',
        'obsidian': '../installers/04_knowledge/obsidian/',
        'xmind': '../installers/04_knowledge/xmind/',
        'aionui': '../installers/01_agent/aionui/',
        'check': '../check.bat',
        'repair': '../repair.bat'
    };

    var path = appPaths[app];
    if (!path) {
        alert('组件路径未配置，请手动启动对应程序。');
        return;
    }

    var appNames = {
        'wps': 'WPS Office',
        'everything': 'Everything',
        'ocr': 'OCR 识别工具',
        'obsidian': 'Obsidian',
        'xmind': 'XMind',
        'aionui': 'AionUI Agent',
        'check': '系统检测',
        'repair': '系统修复'
    };

    var name = appNames[app] || app;
    var msg = '即将打开：' + name + '\n\n';
    msg += '路径：' + path + '\n\n';
    msg += '说明：此入口需要在已安装套件的 Windows 7 环境下使用。';
    msg += '\n在当前浏览器环境中，请手动导航到上述路径运行对应程序。';
    alert(msg);
}
