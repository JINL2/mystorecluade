/**
 * Dashboard Cards Widget
 * Page-specific component for dashboard financial overview cards
 */

class DashboardCards {
    constructor(containerId) {
        this.containerId = containerId;
        this.cards = [
            {
                id: 'netWorth',
                title: 'Net Worth',
                icon: 'checkCircle',
                value: '$45,230.50',
                change: '+12.5%',
                changeLabel: 'this month',
                changeType: 'positive'
            },
            {
                id: 'monthlyIncome',
                title: 'Monthly Income',
                icon: 'dollarSign',
                value: '$8,500.00',
                change: '+5.2%',
                changeLabel: 'vs last month',
                changeType: 'positive'
            },
            {
                id: 'monthlyExpenses',
                title: 'Monthly Expenses',
                icon: 'receipt',
                value: '$6,230.75',
                change: '+8.3%',
                changeLabel: 'vs budget',
                changeType: 'negative'
            },
            {
                id: 'savingsGoal',
                title: 'Savings Goal',
                icon: 'star',
                value: '$15,500',
                change: '72%',
                changeLabel: 'complete',
                changeType: 'positive'
            }
        ];
    }
    
    init() {
        this.render();
        this.startDataRefresh();
    }
    
    render() {
        const container = document.getElementById(this.containerId);
        if (!container) {
            console.error(`Container ${this.containerId} not found`);
            return;
        }
        
        const cardsHTML = `
            <section class="overview-grid">
                ${this.cards.map(card => this.renderCard(card)).join('')}
            </section>
        `;
        
        container.innerHTML = cardsHTML;
    }
    
    renderCard(card) {
        const changeClass = card.changeType === 'positive' ? 'change-positive' : 'change-negative';
        const changeIcon = card.changeType === 'positive' ? 
            '<path d="M7 14l5-5 5 5z"/>' : 
            '<path d="M7 10l5 5 5-5z"/>';
        
        return `
            <div class="overview-card">
                <div class="card-header">
                    <div class="card-title">
                        ${this.getIconSVG(card.icon)}
                        ${card.title}
                    </div>
                </div>
                <div class="card-value" id="${card.id}Value">${card.value}</div>
                <div class="card-change ${changeClass}">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                        ${changeIcon}
                    </svg>
                    ${card.change} ${card.changeLabel}
                </div>
            </div>
        `;
    }
    
    getIconSVG(iconType) {
        const icons = {
            checkCircle: '<svg class="card-icon" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/></svg>',
            dollarSign: '<svg class="card-icon" viewBox="0 0 24 24" fill="currentColor"><path d="M7 15h2c0 1.08.81 2 2 2h2c1.19 0 2-.81 2-2s-.81-2-2-2h-2c-1.19 0-2-.81-2-2s.81-2 2-2h2c1.19 0 2 .92 2 2h2c0-1.08-.81-2-2-2V9h-2v2h-2c-1.19 0-2 .81-2 2s.81 2 2 2h2c1.19 0 2 .81 2 2s-.81 2-2 2h-2c-1.19 0-2-.92-2-2H7v2z"/></svg>',
            receipt: '<svg class="card-icon" viewBox="0 0 24 24" fill="currentColor"><path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 14H7v-2h5v2zm5-4H7v-2h10v2zm0-4H7V7h10v2z"/></svg>',
            star: '<svg class="card-icon" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>'
        };
        
        return icons[iconType] || icons.checkCircle;
    }
    
    updateCard(cardId, newValue) {
        const element = document.getElementById(`${cardId}Value`);
        if (element) {
            this.animateValue(element, newValue);
        }
    }
    
    animateValue(element, targetValue) {
        const currentText = element.textContent.replace(/[^0-9.]/g, '');
        const currentValue = parseFloat(currentText) || 0;
        const prefix = element.textContent.includes('$') ? '$' : '';
        
        // Parse target value
        const targetNumeric = typeof targetValue === 'string' ? 
            parseFloat(targetValue.replace(/[^0-9.]/g, '')) : targetValue;
        
        const difference = targetNumeric - currentValue;
        const steps = 20;
        const stepValue = difference / steps;
        let currentStep = 0;
        
        const timer = setInterval(() => {
            currentStep++;
            const newValue = currentValue + (stepValue * currentStep);
            
            element.textContent = `${prefix}${newValue.toLocaleString('en-US', {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
            })}`;
            
            if (currentStep >= steps) {
                clearInterval(timer);
                element.textContent = typeof targetValue === 'string' ? 
                    targetValue : `${prefix}${targetNumeric.toLocaleString('en-US', {
                        minimumFractionDigits: 2,
                        maximumFractionDigits: 2
                    })}`;
            }
        }, 50);
    }
    
    startDataRefresh() {
        // Simulate real-time data updates every 30 seconds
        setInterval(() => {
            this.updateMetrics();
        }, 30000);
    }
    
    updateMetrics() {
        // In a real application, this would fetch from API
        const updates = {
            netWorth: this.generateRandomValue(45000, 50000),
            monthlyIncome: this.generateRandomValue(8000, 9000),
            monthlyExpenses: this.generateRandomValue(6000, 7000)
        };
        
        Object.keys(updates).forEach(key => {
            this.updateCard(key, `$${updates[key].toFixed(2)}`);
        });
    }
    
    generateRandomValue(min, max) {
        return Math.random() * (max - min) + min;
    }
}