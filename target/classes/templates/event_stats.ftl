<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Event Stats - Sangam</title>
    <link rel="icon" type="image/x-icon" href="/imgs/logo.jpg">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</head>
<body>
<#include "nav.ftl">
<link rel="stylesheet" href="/css/style.css">

<div class="container">
    <div class="header stats-header bordered-2 mb-3">
        Event: ${event.eventName}
    </div>
    <div class="dashboard">
        <#if isRsvpEvent>
            <div class="widget">
                <h2>Total RSVP</h2>
                <p>${totalRsvp}</p>
            </div>
            <div class="widget">
                <h2>RSVP List</h2>
                <ul>
                    <#list rsvpMap?keys as rsvpKey>
                        <li>${rsvpKey} - ${rsvpMap[rsvpKey]} people</li>
                    </#list>
                </ul>
            </div>
        <#else>
            <div class="widget" onclick="toggleTicketsDropdown()">
                <h2>Total Tickets</h2>
                <p>${totalTickets}</p>
                <div id="pricing-dropdown" class="pricing-dropdown">
                    <#list pricingCounts?keys as pricingOption>
                        <p style="color: white;">${pricingOption}: #${pricingCounts[pricingOption]}</p>
                    </#list>
                </div>
            </div>
            <div class="widget" onclick="toggleTotalPaymentDropdown()">
                <h2>Total Sale</h2>
                <p>$${totalAmount}</p>
                <div id="totalAmountType" class="pricing-dropdown">
                    <#if totalAmountTypes??>
                        <#list totalAmountTypes?keys as totalAmountType>
                            <p style="color: white;">${totalAmountType}: $${totalAmountTypes[totalAmountType]}</p>
                        </#list>
                    <#else>
                        <p style="color: white;">No Payment Received Yet!</p>
                    </#if>
                </div>
            </div>
            <div class="widget" onclick="togglePaymentsDropdown()">
                <h2>Payment Received</h2>
                <p>$${totalPaid}</p>
                <div id="payments-dropdown" class="pricing-dropdown">
                    <#if receiveTotal??>
                        <#list receiveTotal?keys as receiverName>
                            <p style="color: white;">${receiverName}: $${receiveTotal[receiverName]}</p>
                        </#list>
                    <#else>
                        <p style="color: white;">No Payment Received Yet!</p>
                    </#if>
                </div>
            </div>
            <div class="widget">
                <h2>Total Sale vs Payment Received</h2>
                <canvas id="saleVsPaymentChart"></canvas>
            </div>
            <div class="widget" onclick="toggleCheckInDropdown()">
                <h2>Total Check-Ins</h2>
                <p>${totalCheckedIn}</p>
                <div id="checkin-dropdown" class="pricing-dropdown">
                    <#if checkInTypes??>
                        <#list checkInTypes?keys as checkInType>
                            <p style="color: white;">${checkInType}: ${checkInTypes[checkInType]}</p>
                        </#list>
                    <#else>
                        <p style="color: white;">No CheckIns Yet!</p>
                    </#if>
                </div>
            </div>
            <div class="widget">
                <h2>Tickets vs Check-Ins</h2>
                <canvas id="ticketsVsCheckInsChart"></canvas>
            </div>
        </#if>
    </div>
</div>

<footer class="bg-dark text-white text-center py-3">
    <p>2025 Sangam &copy;. All Rights reserved.</p>
</footer>

<!-- Chart.js Library -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    <#if isRsvpEvent>
        // Data for RSVP comparison chart
        const rsvpVsCheckInsData = [${totalRsvp}, ${totalCheckedIn}];
        const rsvpVsCheckInsCtx = document.getElementById('rsvpVsCheckInsChart').getContext('2d');

        // Chart configuration for donut chart
    <#else>
        // Data for the comparison charts
        const ticketsVsCheckInsData = [${totalTickets}, ${totalCheckedIn}];
        const saleVsPaymentData = [${totalAmount?string("0")}, ${totalPaid?string("0")}];

        const ticketsVsCheckInsCtx = document.getElementById('ticketsVsCheckInsChart').getContext('2d');
        const saleVsPaymentCtx = document.getElementById('saleVsPaymentChart').getContext('2d');

        // Chart configuration for donut charts
    </#if>
    const createDonutChart = (ctx, data, label, segmentOne, segmentTwo) => {
        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: [segmentOne, segmentTwo],
                datasets: [{
                    label: label,
                    data: data,
                    backgroundColor: [
                        'rgba(34, 193, 195, 0.7)',   // Green
                        'rgba(253, 187, 45, 0.7)'    // Red
                    ],
                    borderColor: [
                        'rgba(34, 193, 195, 1)',     // Green
                        'rgba(253, 187, 45, 1)'      // Red
                    ],
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'top',
                    },
                    tooltip: {
                        callbacks: {
                            label: function(tooltipItem) {
                                return tooltipItem.label;
                            }
                        }
                    }
                }
            }
        });
    };

    function toggleTicketsDropdown() {
        var dropdown = document.getElementById('pricing-dropdown');
        dropdown.style.display = (dropdown.style.display == 'block') ? 'none' : 'block';
    }

    function togglePaymentsDropdown() {
        var dropdown = document.getElementById('payments-dropdown');
        dropdown.style.display = (dropdown.style.display == 'block') ? 'none' : 'block';
    }

    function toggleTotalPaymentDropdown() {
        var dropdown = document.getElementById('totalAmountType');
        dropdown.style.display = (dropdown.style.display == 'block') ? 'none' : 'block';
    }

    function toggleCheckInDropdown() {
        var dropdown = document.getElementById('checkin-dropdown');
        dropdown.style.display = (dropdown.style.display == 'block') ? 'none' : 'block';
    }

    <#if isRsvpEvent>
        // Create donut chart for RSVP comparison
        createDonutChart(rsvpVsCheckInsCtx, rsvpVsCheckInsData, 'RSVP vs Check-Ins', 'RSVP: ${totalRsvp}', 'Checked In: ${totalCheckedIn}');
    <#else>
        // Create donut charts for comparisons
        createDonutChart(ticketsVsCheckInsCtx, ticketsVsCheckInsData, 'Booked vs Check-Ins', ' Booked: ${totalTickets}', 'Checked In: ${totalCheckedIn}');
        createDonutChart(saleVsPaymentCtx, saleVsPaymentData, 'Sale vs Payment Received',
        'Total Sale: ${totalAmount}', 'Total Paid: ${totalPaid}');
    </#if>
</script>
</body>
</html>
