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
        const count = Math.min(80, Math.floor(window.innerWidth / 20));
        for (let i = 0; i < count; i++) {
            this.particles.push({
                x: Math.random() * this.canvas.width,
                y: Math.random() * this.canvas.height,
                size: Math.random() * 2 + 0.5,
                speedX: (Math.random() - 0.5) * 0.5,
                speedY: (Math.random() - 0.5) * 0.5,
                opacity: Math.random() * 0.5 + 0.2
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
            
            // Mouse interaction
            if (this.mouse.x && this.mouse.y) {
                const dx = p.x - this.mouse.x;
                const dy = p.y - this.mouse.y;
                const dist = Math.sqrt(dx * dx + dy * dy);
                if (dist < 150) {
                    p.x += dx * 0.01;
                    p.y += dy * 0.01;
                }
            }
            
            // Draw particle
            this.ctx.beginPath();
            this.ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2);
            this.ctx.fillStyle = `rgba(99, 102, 241, ${p.opacity})`;
            this.ctx.fill();
            
            // Draw connections
            for (let j = i + 1; j < this.particles.length; j++) {
                const p2 = this.particles[j];
                const dx = p.x - p2.x;
                const dy = p.y - p2.y;
                const dist = Math.sqrt(dx * dx + dy * dy);
                if (dist < 120) {
                    this.ctx.beginPath();
                    this.ctx.moveTo(p.x, p.y);
                    this.ctx.lineTo(p2.x, p2.y);
                    this.ctx.strokeStyle = `rgba(99, 102, 241, ${0.1 * (1 - dist / 120)})`;
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
            delay = 2000;
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

// Navigation
document.addEventListener('DOMContentLoaded', function() {
    // Particle System
    const canvas = document.getElementById('particles');
    if (canvas) new ParticleSystem(canvas);
    
    // Typewriter
    const tw = document.getElementById('typewriter');
    if (tw) new Typewriter(tw, ['智能办公解决方案', 'AI 驱动的生产力', '离线可用的套件', '一键安装体验']);
    
    // 3D Card Tilt
    new CardTilt(document.querySelectorAll('.feature-card'));
    
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
    
    // Case tabs
    document.querySelectorAll('.case-tab').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.case-tab').forEach(b => b.classList.remove('active'));
            document.querySelectorAll('.case-panel').forEach(p => p.classList.remove('active'));
            btn.classList.add('active');
            const panel = document.getElementById(btn.getAttribute('data-case'));
            if (panel) panel.classList.add('active');
        });
    });
    
    // FAQ accordion
    document.querySelectorAll('.faq-question').forEach(q => {
        q.addEventListener('click', function() {
            const item = this.parentElement;
            const isOpen = item.classList.contains('open');
            document.querySelectorAll('.faq-item').forEach(i => i.classList.remove('open'));
            if (!isOpen) item.classList.add('open');
        });
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
    var path = paths[app], name = names[app] || app;
    if (!path) { alert('组件路径未配置'); return; }
    alert('即将打开：' + name + '\n\n路径：' + path + '\n\n说明：需要在已安装套件的 Windows 7 环境下使用。');
}

// Data Stream Effect
(function initDataStream() {
    var container = document.getElementById('dataStream');
    if (!container) return;
    var chars = '01アイウエオカキクケコ<>/{}[]';
    for (var i = 0; i < 20; i++) {
        var span = document.createElement('span');
        span.textContent = chars[Math.floor(Math.random() * chars.length)];
        span.style.left = Math.random() * 100 + '%';
        span.style.animationDuration = (5 + Math.random() * 8) + 's';
        span.style.animationDelay = (-Math.random() * 10) + 's';
        span.style.fontSize = (10 + Math.random() * 6) + 'px';
        container.appendChild(span);
    }
    setInterval(function() {
        var spans = container.querySelectorAll('span');
        if (spans.length > 0) {
            var idx = Math.floor(Math.random() * spans.length);
            spans[idx].textContent = chars[Math.floor(Math.random() * chars.length)];
        }
    }, 2000);
})();
