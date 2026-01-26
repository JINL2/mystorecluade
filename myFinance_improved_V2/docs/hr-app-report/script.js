// HR App Report Interactive Features

document.addEventListener('DOMContentLoaded', function() {
    // Smooth scroll for navigation
    initSmoothScroll();

    // Animate elements on scroll
    initScrollAnimations();

    // Interactive comparison table
    initComparisonTable();

    // App card interactions
    initAppCards();

    // Stats counter animation
    initStatsCounter();
});

// Smooth Scroll Navigation
function initSmoothScroll() {
    const navLinks = document.querySelectorAll('nav#toc a');

    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const targetId = this.getAttribute('href');
            const targetSection = document.querySelector(targetId);

            if (targetSection) {
                const headerOffset = 80;
                const elementPosition = targetSection.getBoundingClientRect().top;
                const offsetPosition = elementPosition + window.pageYOffset - headerOffset;

                window.scrollTo({
                    top: offsetPosition,
                    behavior: 'smooth'
                });

                // Update active state
                navLinks.forEach(l => l.classList.remove('active'));
                this.classList.add('active');
            }
        });
    });

    // Update active nav on scroll
    window.addEventListener('scroll', function() {
        const sections = document.querySelectorAll('.section');
        let current = '';

        sections.forEach(section => {
            const sectionTop = section.offsetTop;
            if (pageYOffset >= sectionTop - 100) {
                current = section.getAttribute('id');
            }
        });

        navLinks.forEach(link => {
            link.classList.remove('active');
            if (link.getAttribute('href') === '#' + current) {
                link.classList.add('active');
            }
        });
    });
}

// Scroll Animations
function initScrollAnimations() {
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);

    // Observe app cards
    document.querySelectorAll('.app-card').forEach(card => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(30px)';
        card.style.transition = 'all 0.6s ease-out';
        observer.observe(card);
    });

    // Observe stat cards
    document.querySelectorAll('.stat-card').forEach((card, index) => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(30px)';
        card.style.transition = `all 0.5s ease-out ${index * 0.1}s`;
        observer.observe(card);
    });

    // Observe pattern cards
    document.querySelectorAll('.pattern-card').forEach((card, index) => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        card.style.transition = `all 0.4s ease-out ${index * 0.1}s`;
        observer.observe(card);
    });

    // Observe recommendation cards
    document.querySelectorAll('.recommendation-card').forEach((card, index) => {
        card.style.opacity = '0';
        card.style.transform = 'translateX(-30px)';
        card.style.transition = `all 0.5s ease-out ${index * 0.15}s`;
        observer.observe(card);
    });
}

// Add animate-in class styles
const style = document.createElement('style');
style.textContent = `
    .animate-in {
        opacity: 1 !important;
        transform: translateY(0) translateX(0) !important;
    }

    nav#toc a.active {
        background: var(--primary);
        color: white;
    }

    .app-card.expanded .app-content {
        max-height: 2000px;
    }

    .comparison-table tr.highlight-active {
        background: #dbeafe !important;
        transform: scale(1.01);
    }

    .feature-tags .tag.active {
        background: var(--primary);
        color: white;
    }
`;
document.head.appendChild(style);

// Comparison Table Interactions
function initComparisonTable() {
    const tableRows = document.querySelectorAll('.comparison-table tbody tr');

    tableRows.forEach(row => {
        row.addEventListener('mouseenter', function() {
            this.classList.add('highlight-active');
        });

        row.addEventListener('mouseleave', function() {
            this.classList.remove('highlight-active');
        });

        row.addEventListener('click', function() {
            const appName = this.querySelector('td:first-child strong');
            if (appName) {
                const appId = appName.textContent.toLowerCase().replace(/\s+/g, '');
                const targetCard = document.getElementById(appId) ||
                                   document.querySelector(`[id*="${appId}"]`);

                if (targetCard) {
                    targetCard.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    targetCard.style.boxShadow = '0 0 0 3px var(--primary)';
                    setTimeout(() => {
                        targetCard.style.boxShadow = '';
                    }, 2000);
                }
            }
        });

        row.style.cursor = 'pointer';
    });
}

// App Card Interactions
function initAppCards() {
    const tags = document.querySelectorAll('.feature-tags .tag');

    tags.forEach(tag => {
        tag.addEventListener('click', function() {
            // Toggle active state
            this.classList.toggle('active');

            // Show tooltip or additional info
            const tagText = this.textContent;
            showTagTooltip(this, tagText);
        });
    });

    // USP list hover effects
    const uspItems = document.querySelectorAll('.usp-list li');
    uspItems.forEach(item => {
        item.addEventListener('mouseenter', function() {
            this.style.backgroundColor = '#f0f9ff';
            this.style.paddingLeft = '30px';
            this.style.transition = 'all 0.3s';
        });

        item.addEventListener('mouseleave', function() {
            this.style.backgroundColor = '';
            this.style.paddingLeft = '25px';
        });
    });
}

// Tag Tooltip
function showTagTooltip(element, text) {
    // Remove existing tooltips
    const existingTooltip = document.querySelector('.tag-tooltip');
    if (existingTooltip) {
        existingTooltip.remove();
    }

    // Feature descriptions
    const featureDescriptions = {
        'AI 스마트 스케줄링': '인공지능이 직원 가용성, 역할, 노동비용을 고려해 자동으로 최적 스케줄 생성',
        '타임클록': '모바일/웹에서 출퇴근 시간 기록 및 관리',
        '급여 관리': '근무 시간 기반 급여 자동 계산 및 처리',
        '팀 메시징': '팀원 간 실시간 커뮤니케이션',
        '채용/온보딩': '채용 공고 게시부터 신규 직원 교육까지',
        '팁 관리': '팁 분배 및 정산 자동화',
        'GPS/WiFi 출퇴근': '위치 기반 출퇴근 인증',
        '전자서명': '근로계약서 등 문서 전자 서명',
        '근로계약서': '법적 효력 있는 전자 근로계약서',
        'QR/GPS/WiFi/비콘': '다양한 출퇴근 인증 방식 지원'
    };

    const description = featureDescriptions[text];
    if (!description) return;

    const tooltip = document.createElement('div');
    tooltip.className = 'tag-tooltip';
    tooltip.textContent = description;
    tooltip.style.cssText = `
        position: absolute;
        background: var(--dark);
        color: white;
        padding: 10px 15px;
        border-radius: 8px;
        font-size: 0.85rem;
        max-width: 250px;
        z-index: 1000;
        box-shadow: 0 4px 6px rgba(0,0,0,0.2);
        animation: fadeIn 0.2s ease-out;
    `;

    document.body.appendChild(tooltip);

    const rect = element.getBoundingClientRect();
    tooltip.style.left = rect.left + 'px';
    tooltip.style.top = (rect.bottom + 10 + window.scrollY) + 'px';

    setTimeout(() => {
        tooltip.remove();
    }, 3000);
}

// Stats Counter Animation
function initStatsCounter() {
    const statNumbers = document.querySelectorAll('.stat-number');

    const observerOptions = {
        threshold: 0.5
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                animateValue(entry.target);
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);

    statNumbers.forEach(stat => {
        observer.observe(stat);
    });
}

function animateValue(element) {
    const text = element.textContent;
    const match = text.match(/(\d+)/);

    if (!match) return;

    const endValue = parseInt(match[1]);
    const duration = 1500;
    const startTime = performance.now();

    const prefix = text.substring(0, text.indexOf(match[1]));
    const suffix = text.substring(text.indexOf(match[1]) + match[1].length);

    function update(currentTime) {
        const elapsed = currentTime - startTime;
        const progress = Math.min(elapsed / duration, 1);

        // Easing function
        const easeOutQuart = 1 - Math.pow(1 - progress, 4);
        const currentValue = Math.floor(easeOutQuart * endValue);

        element.textContent = prefix + currentValue + suffix;

        if (progress < 1) {
            requestAnimationFrame(update);
        } else {
            element.textContent = text;
        }
    }

    requestAnimationFrame(update);
}

// Print Report
function printReport() {
    window.print();
}

// Export to PDF (basic implementation)
function exportToPDF() {
    alert('PDF 내보내기를 위해 브라우저의 인쇄 기능 (Ctrl/Cmd + P)을 사용하고 "PDF로 저장"을 선택하세요.');
    window.print();
}

// Search functionality
function initSearch() {
    const searchInput = document.createElement('input');
    searchInput.type = 'text';
    searchInput.placeholder = '앱 검색...';
    searchInput.className = 'search-input';
    searchInput.style.cssText = `
        padding: 10px 20px;
        border: 1px solid var(--border);
        border-radius: 25px;
        font-size: 0.9rem;
        width: 200px;
        margin-left: 20px;
    `;

    const nav = document.querySelector('nav#toc .container ul');
    if (nav) {
        const li = document.createElement('li');
        li.appendChild(searchInput);
        nav.appendChild(li);
    }

    searchInput.addEventListener('input', function() {
        const query = this.value.toLowerCase();
        const appCards = document.querySelectorAll('.app-card');

        appCards.forEach(card => {
            const text = card.textContent.toLowerCase();
            if (text.includes(query) || query === '') {
                card.style.display = '';
            } else {
                card.style.display = 'none';
            }
        });
    });
}

// Initialize search on load
document.addEventListener('DOMContentLoaded', initSearch);

// Console welcome message
console.log('%c HR App Market Report 2025 ', 'background: #2563eb; color: white; font-size: 14px; padding: 10px;');
console.log('StoreBase Team - Market Research Report');
