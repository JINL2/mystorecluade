/**
 * Dashboard Chart Widget
 * Page-specific component for spending overview chart
 */

class DashboardChart {
    constructor(options = {}) {
        this.containerId = options.containerId || 'chart-container';
        this.chartId = options.chartId || 'spendingChart';
        this.chart = null;
        this.chartData = options.data || this.getDefaultData();
    }
    
    getDefaultData() {
        return {
            labels: ['Housing', 'Food', 'Transportation', 'Entertainment', 'Utilities', 'Other'],
            datasets: [{
                data: [1800, 650, 400, 300, 200, 350],
                backgroundColor: [
                    '#0064FF', // Toss primary
                    '#00C896', // Toss success
                    '#FF9500', // Toss warning
                    '#FF5847', // Toss error
                    '#6C757D', // Gray 600
                    '#DEE2E6'  // Gray 300
                ],
                borderWidth: 0,
                hoverOffset: 4
            }]
        };
    }
    
    init() {
        this.render();
        this.initializeChart();
    }
    
    render() {
        const container = document.getElementById(this.containerId);
        if (!container) {
            console.error(`Container ${this.containerId} not found`);
            return;
        }
        
        const chartHTML = `
            <section class="content-section">
                <div class="section-header">
                    <h2 class="section-title">Spending Overview</h2>
                    <button class="toss-btn toss-btn-ghost toss-btn-sm" onclick="DashboardChart.viewDetails()">
                        View Details
                    </button>
                </div>
                <div class="section-content">
                    <div class="chart-container">
                        <canvas id="${this.chartId}"></canvas>
                    </div>
                </div>
            </section>
        `;
        
        container.innerHTML = chartHTML;
    }
    
    initializeChart() {
        const ctx = document.getElementById(this.chartId);
        if (!ctx) {
            console.error(`Chart canvas ${this.chartId} not found`);
            return;
        }
        
        // Check if Chart.js is loaded
        if (typeof Chart === 'undefined') {
            console.error('Chart.js is not loaded');
            return;
        }
        
        this.chart = new Chart(ctx, {
            type: 'doughnut',
            data: this.chartData,
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'right',
                        labels: {
                            usePointStyle: true,
                            font: {
                                family: 'Inter, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif',
                                size: 14
                            },
                            color: '#495057',
                            padding: 12
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                const label = context.label || '';
                                const value = '$' + context.parsed.toLocaleString();
                                const dataset = context.dataset;
                                const total = dataset.data.reduce((a, b) => a + b, 0);
                                const percentage = ((context.parsed / total) * 100).toFixed(1);
                                return `${label}: ${value} (${percentage}%)`;
                            }
                        }
                    }
                },
                cutout: '65%',
                animation: {
                    animateRotate: true,
                    duration: 1000
                }
            }
        });
    }
    
    updateData(newData) {
        if (!this.chart) {
            console.error('Chart not initialized');
            return;
        }
        
        this.chart.data = newData;
        this.chart.update();
    }
    
    addData(label, value, color) {
        if (!this.chart) {
            console.error('Chart not initialized');
            return;
        }
        
        this.chart.data.labels.push(label);
        this.chart.data.datasets[0].data.push(value);
        if (color) {
            this.chart.data.datasets[0].backgroundColor.push(color);
        }
        this.chart.update();
    }
    
    removeData(index) {
        if (!this.chart) {
            console.error('Chart not initialized');
            return;
        }
        
        this.chart.data.labels.splice(index, 1);
        this.chart.data.datasets[0].data.splice(index, 1);
        this.chart.data.datasets[0].backgroundColor.splice(index, 1);
        this.chart.update();
    }
    
    destroy() {
        if (this.chart) {
            this.chart.destroy();
            this.chart = null;
        }
    }
    
    static viewDetails() {
        if (typeof showComingSoon === 'function') {
            showComingSoon('Chart Details');
        }
    }
}