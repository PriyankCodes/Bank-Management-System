<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/admin/components/header.jsp">
    <jsp:param name="pageTitle" value="Admin Dashboard"/>
</jsp:include>
<jsp:include page="/admin/components/navbar.jsp"/>

<div class="container my-5">

    <h2 class="text-gradient mb-4"><i class="bi bi-speedometer2 me-2"></i> System Overview</h2>
    
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show">
            ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="row text-center g-3 mb-5">
        <div class="col-md">
            <div class="card shadow-sm rounded-4 p-4 hover-card">
                <h5 class="fw-semibold">Active Customers</h5>
                <h3 class="text-primary">${metrics.activeCustomers}</h3>
            </div>
        </div>
        <div class="col-md">
            <div class="card shadow-sm rounded-4 p-4 hover-card">
                <h5 class="fw-semibold">Open Support Tickets</h5>
                <h3 class="text-warning">${metrics.openSupportTickets}</h3>
            </div>
        </div>
        <div class="col-md">
            <div class="card shadow-sm rounded-4 p-4 hover-card">
                <h5 class="fw-semibold">Active Fixed Deposits</h5>
                <h3 class="text-success">${metrics.activeFixedDeposits}</h3>
            </div>
        </div>
        <div class="col-md">
            <div class="card shadow-sm rounded-4 p-4 hover-card">
                <h5 class="fw-semibold">Savings Accounts</h5>
                <h3 class="text-info">${metrics.savingsAccounts}</h3>
            </div>
        </div>
        <div class="col-md">
            <div class="card shadow-sm rounded-4 p-4 hover-card">
                <h5 class="fw-semibold">Current Accounts</h5>
                <h3 class="text-secondary">${metrics.currentAccounts}</h3>
            </div>
        </div>
    </div>

    <h3 class="text-gradient mb-3"><i class="bi bi-bar-chart-line me-2"></i> Overview Chart</h3>
    <div class="card shadow-sm rounded-4 p-3">
        <canvas id="overviewChart" width="600" height="300"></canvas>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    const ctx = document.getElementById('overviewChart').getContext('2d');
    const overviewChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Active Customers', 'Open Support Tickets', 'Active FDs', 'Savings Accounts', 'Current Accounts'],
            datasets: [{
                label: 'Counts',
                data: [
                    ${metrics.activeCustomers}, 
                    ${metrics.openSupportTickets}, 
                    ${metrics.activeFixedDeposits}, 
                    ${metrics.savingsAccounts},
                    ${metrics.currentAccounts}
                ],
                backgroundColor: [
                    'rgba(54, 162, 235, 0.7)',
                    'rgba(255, 206, 86, 0.7)',
                    'rgba(75, 192, 192, 0.7)',
                    'rgba(255, 99, 132, 0.7)',
                    'rgba(153, 102, 255, 0.7)'
                ],
                borderColor: [
                    'rgba(54, 162, 235, 1)',
                    'rgba(255, 206, 86, 1)',
                    'rgba(75, 192, 192, 1)',
                    'rgba(255, 99, 132, 1)',
                    'rgba(153, 102, 255, 1)'
                ],
                borderWidth: 1,
                borderRadius: 6
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: { display: false },
                tooltip: { mode: 'index', intersect: false }
            },
            scales: {
                y: { beginAtZero: true, grid: { drawBorder: false } },
                x: { grid: { drawBorder: false } }
            }
        }
    });
</script>

<style>
    /* Gradient headings */
    .text-gradient {
        background: linear-gradient(90deg, #ff416c, #ff4b2b);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
    }

    /* Card hover effect */
    .hover-card {
        transition: transform 0.3s, box-shadow 0.3s;
    }
    .hover-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 25px rgba(0,0,0,0.15);
    }
</style>

<jsp:include page="/admin/components/footer.jsp"/>
