<!DOCTYPE html>
<html lang="en">
<head>
    <title>QR Scanner - Sangam</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" type="image/x-icon" href="/imgs/logo.jpg">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/html5-qrcode@2.3.8/html5-qrcode.min.js"></script>
    <script src="https://kit.fontawesome.com/6e1d51a9e9.js" crossorigin="anonymous"></script>
    
    <style>
        #qr-reader {
            width: 100%;
            max-width: 600px;
            margin: 0 auto;
        }
        
        #qr-reader__dashboard_section_swaplink {
            display: none !important;
        }
        
        .scanner-container {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        
        /* Toast notification styles */
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
        }
        
        .custom-toast {
            min-width: 300px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            border-left: 5px solid #28a745;
            animation: slideInRight 0.3s ease-out;
        }
        
        .custom-toast .toast-header {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            font-weight: 600;
        }
        
        .custom-toast .toast-body {
            font-size: 1rem;
            padding: 1rem;
        }
        
        .custom-toast .btn-close {
            filter: brightness(0) invert(1);
        }
        
        .checkin-count {
            font-size: 2.5rem;
            font-weight: bold;
            color: #28a745;
            animation: bounceIn 0.5s ease-out;
        }
        
        @keyframes slideInRight {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
        
        @keyframes bounceIn {
            0% {
                transform: scale(0);
                opacity: 0;
            }
            50% {
                transform: scale(1.1);
            }
            100% {
                transform: scale(1);
                opacity: 1;
            }
        }
        
        /* Mobile responsive toast */
        @media (max-width: 576px) {
            .toast-container {
                top: 10px;
                right: 10px;
                left: 10px;
            }
            
            .custom-toast {
                min-width: auto;
                width: 100%;
            }
            
            /* Mobile back button styling */
            .d-flex.justify-content-between {
                flex-direction: column;
                align-items: flex-start !important;
            }
            
            .d-flex.justify-content-between h3 {
                margin-bottom: 0.75rem;
            }
            
            .d-flex.justify-content-between .btn {
                width: 100%;
                margin-top: 0.5rem;
            }
        }
        
        .ticket-card {
            transition: all 0.3s ease;
        }
        
        .ticket-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        
        /* Gray out already checked-in tickets */
        .ticket-card.border-success {
            opacity: 0.6;
            background-color: #f8f9fa;
            /* Don't disable the entire card - be more targeted */
        }
        
        .ticket-card.border-success .form-check-label {
            color: #6c757d;
            text-decoration: line-through;
        }
        
        .ticket-card.border-success:hover {
            transform: none;
            box-shadow: none;
            cursor: not-allowed;
        }
        
        /* Disable checkbox for checked-in tickets */
        .form-check-input:disabled {
            cursor: not-allowed;
            opacity: 0.5;
            pointer-events: none; /* Prevent any clicks on disabled checkboxes */
        }
        
        .form-check-input:disabled ~ .form-check-label {
            cursor: not-allowed;
            pointer-events: none; /* Prevent clicks on label too */
        }
        
        /* Extra safety: disable the entire form-check div for checked-in tickets */
        .ticket-card.border-success .form-check {
            pointer-events: none; /* This blocks manual clicks but allows programmatic access */
        }
        
        .ticket-card.border-success .form-check * {
            cursor: not-allowed !important;
        }
        
        .status-badge {
            font-size: 0.9rem;
            padding: 0.4rem 0.8rem;
        }
        
        .scan-status {
            font-size: 1.2rem;
            font-weight: 500;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 15px;
        }
        
        .scan-status.ready {
            background: #d1ecf1;
            color: #0c5460;
        }
        
        .scan-status.scanning {
            background: #fff3cd;
            color: #856404;
        }
        
        .scan-status.success {
            background: #d4edda;
            color: #155724;
        }
        
        .scan-status.error {
            background: #f8d7da;
            color: #721c24;
        }
    </style>
</head>
<body>
<div class="d-flex flex-column min-vh-100">
    <#include "nav.ftl">
    <link href="/css/style.css" rel="stylesheet" type="text/css"/>
    
    <!-- Toast Notification Container -->
    <div class="toast-container">
        <div id="checkin-toast" class="toast custom-toast" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="toast-header">
                <i class="fa-solid fa-check-circle me-2"></i>
                <strong class="me-auto">Check-In Success!</strong>
                <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
            <div class="toast-body" id="toast-message">
                <!-- Message will be populated dynamically -->
            </div>
        </div>
    </div>
    
    <!-- Check-In Success Modal -->
    <div class="modal fade" id="checkinModal" tabindex="-1" aria-labelledby="checkinModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title" id="checkinModalLabel">
                        <i class="fa-solid fa-check-circle me-2"></i>Check-In Successful!
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center" id="modal-body-content">
                    <!-- Content will be populated by JavaScript -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success" data-bs-dismiss="modal">
                        <i class="fa-solid fa-check"></i> OK
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <main class="flex-grow-1">
        <div class="container mt-4 mb-5 pb-4">
            <!-- Success Message Alert -->
            <div id="success-alert" class="alert alert-success alert-dismissible fade show d-none" role="alert">
                <i class="fa-solid fa-check-circle"></i> <span id="success-message"></span>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            
            <div class="row mb-3">
                <div class="col-12">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <h3 class="mb-0">
                            <i class="fa-solid fa-qrcode"></i> QR Check-In
                            <#if eventName??>
                                <span class="fs-5 text-muted">- ${eventName}</span>
                            </#if>
                        </h3>
                        <#if eventId??>
                            <a href="/checkin?selectedEventId=${eventId}" class="btn btn-outline-secondary">
                                <i class="fa-solid fa-arrow-left"></i> Manual Check-In
                            </a>
                        </#if>
                    </div>
                    <p class="text-muted mb-0">Scan ticket QR codes to check in attendees</p>
                </div>
            </div>
            
            <!-- Scanner Section -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="scanner-container">
                        <div id="scan-status" class="scan-status ready text-center">
                            <i class="fa-solid fa-camera"></i> Ready to scan
                        </div>
                        
                        <div id="qr-reader"></div>
                        
                        <div class="text-center mt-3">
                            <button id="start-button" class="btn btn-success btn-lg" onclick="startScanner()">
                                <i class="fa-solid fa-play"></i> Start Scanner
                            </button>
                            <button id="stop-button" class="btn btn-danger btn-lg d-none" onclick="stopScanner()">
                                <i class="fa-solid fa-stop"></i> Stop Scanner
                            </button>
                        </div>
                        
                        <div class="mt-3">
                            <p class="text-center text-muted mb-0">
                                <small><i class="fa-solid fa-lightbulb"></i> Position the QR code within the frame</small>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Ticket Details Section -->
            <div id="ticket-section" class="row d-none">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0">
                                <i class="fa-solid fa-ticket"></i> Ticket Details
                            </h5>
                        </div>
                        <div class="card-body">
                            <div id="ticket-info" class="mb-3">
                                <!-- Ticket holder info will be populated here -->
                            </div>
                            
                            <form id="checkin-form" action="/qr-checkin" method="post">
                                <input type="hidden" id="ticket-master-id" name="ticketMasterId" value="">
                                <#if eventId??>
                                    <input type="hidden" name="eventId" value="${eventId}">
                                </#if>
                                
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <div>
                                        <button type="button" class="btn btn-sm btn-outline-primary" onclick="selectAll()">
                                            Select All
                                        </button>
                                        <button type="button" class="btn btn-sm btn-outline-secondary" onclick="deselectAll()">
                                            Deselect All
                                        </button>
                                    </div>
                                </div>
                                
                                <div id="ticket-list" class="row g-3">
                                    <!-- Ticket cards will be populated here -->
                                </div>
                                
                                <div class="mt-4 d-flex gap-2">
                                    <button type="submit" class="btn btn-primary btn-lg flex-grow-1" id="checkin-button">
                                        <i class="fa-solid fa-check-circle"></i> Check In Selected
                                    </button>
                                    <button type="button" class="btn btn-secondary btn-lg" onclick="resetScanner()">
                                        <i class="fa-solid fa-arrow-left"></i> Scan Another
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <footer class="bg-dark text-white text-center py-3 mt-auto">
        <p>2025 Sangam &copy;. All Rights reserved.</p>
    </footer>
</div>

<script>
    let html5QrcodeScanner = null;
    let isScanning = false;
    
    // Check for success message cookie on page load
    window.addEventListener('DOMContentLoaded', () => {
        const messageCookie = getCookie('qr-message');
        if (messageCookie) {
            const message = decodeURIComponent(messageCookie);
            showCheckinToast(message);
            deleteCookie('qr-message');
        }
    });
    
    function showCheckinToast(message) {
        console.log('Showing check-in notification with message:', message);
        
        // Parse the message to extract counts
        const lines = message.split(/\\n|%0A/);
        let checkedInCount = 0;
        let alreadyCheckedInCount = 0;
        
        // Extract checked-in count
        const checkedInMatch = message.match(/Checked in: (\\d+)/);
        if (checkedInMatch) {
            checkedInCount = parseInt(checkedInMatch[1]);
        }
        
        // Extract already checked-in count
        const alreadyMatch = message.match(/Already checked in: (\\d+)/);
        if (alreadyMatch) {
            alreadyCheckedInCount = parseInt(alreadyMatch[1]);
        }
        
        console.log('Checked in:', checkedInCount, 'Already checked in:', alreadyCheckedInCount);
        
        // Play success sound if any tickets were checked in
        if (checkedInCount > 0) {
            playSuccessSound();
        }
        
        // Build modal content HTML
        let modalHTML = `
            <div class="mb-3">
                <div class="checkin-count" style="font-size: 4rem; font-weight: bold; color: #28a745; animation: bounceIn 0.5s ease-out;">
                    <i class="fa-solid fa-circle-check"></i> $${'{'}checkedInCount${'}'}
                </div>
                <h5 class="mt-3">Ticket$${'{'}checkedInCount !== 1 ? 's' : ''${'}'} Checked In Successfully!</h5>
            </div>
        `;
        
        if (alreadyCheckedInCount > 0) {
            modalHTML += `
                <div class="alert alert-warning" role="alert">
                    <i class="fa-solid fa-exclamation-triangle"></i>
                    <strong>${'{'}alreadyCheckedInCount${'}'}</strong> ticket$${'{'}alreadyCheckedInCount !== 1 ? 's were' : ' was'${'}'} already checked in
                </div>
            `;
        }
        
        // Update modal content
        document.getElementById('modal-body-content').innerHTML = modalHTML;
        
        // Show the modal
        const modalElement = document.getElementById('checkinModal');
        const modal = new bootstrap.Modal(modalElement);
        modal.show();
        
        // Also show the toast for extra feedback
        document.getElementById('toast-message').innerHTML = `
            <div class="text-center">
                <strong>${'{'}checkedInCount${'}'}</strong> ticket$${'{'}checkedInCount !== 1 ? 's' : ''${'}'} checked in!
            </div>
        `;
        
        const toastElement = document.getElementById('checkin-toast');
        const toast = new bootstrap.Toast(toastElement, {
            autohide: true,
            delay: 4000
        });
        toast.show();
    }
    
    function playSuccessSound() {
        // Create a simple success sound using Web Audio API
        try {
            const audioContext = new (window.AudioContext || window.webkitAudioContext)();
            const oscillator = audioContext.createOscillator();
            const gainNode = audioContext.createGain();
            
            oscillator.connect(gainNode);
            gainNode.connect(audioContext.destination);
            
            oscillator.frequency.value = 800;
            oscillator.type = 'sine';
            
            gainNode.gain.setValueAtTime(0.3, audioContext.currentTime);
            gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + 0.3);
            
            oscillator.start(audioContext.currentTime);
            oscillator.stop(audioContext.currentTime + 0.3);
        } catch (e) {
            console.log('Could not play sound:', e);
        }
    }
    
    function getCookie(name) {
        const value = `; $${'{'}document.cookie${'}'}`;
        const parts = value.split(`; $${'{'}name${'}'}=`);
        if (parts.length === 2) return parts.pop().split(';').shift();
    }
    
    function deleteCookie(name) {
        document.cookie = name + '=; Path=/; Expires=Thu, 01 Jan 1970 00:00:01 GMT;';
    }
    
    function updateStatus(message, type) {
        const statusDiv = document.getElementById('scan-status');
        statusDiv.className = `scan-status $${'{'}type${'}'} text-center`;
        statusDiv.innerHTML = message;
    }
    
    function startScanner() {
        if (isScanning) return;
        
        const config = {
            fps: 10,
            qrbox: { width: 250, height: 250 },
            aspectRatio: 1.0,
            formatsToSupport: [Html5QrcodeSupportedFormats.QR_CODE]
        };
        
        html5QrcodeScanner = new Html5Qrcode("qr-reader");
        
        updateStatus('<i class="fa-solid fa-spinner fa-spin"></i> Starting camera...', 'scanning');
        
        html5QrcodeScanner.start(
            { facingMode: "environment" },
            config,
            onScanSuccess,
            onScanFailure
        ).then(() => {
            isScanning = true;
            document.getElementById('start-button').classList.add('d-none');
            document.getElementById('stop-button').classList.remove('d-none');
            updateStatus('<i class="fa-solid fa-camera"></i> Scanning... Point camera at QR code', 'scanning');
        }).catch(err => {
            console.error('Error starting scanner:', err);
            updateStatus('<i class="fa-solid fa-exclamation-triangle"></i> Failed to start camera: ' + err, 'error');
        });
    }
    
    function stopScanner() {
        if (!isScanning) return;
        
        html5QrcodeScanner.stop().then(() => {
            isScanning = false;
            document.getElementById('start-button').classList.remove('d-none');
            document.getElementById('stop-button').classList.add('d-none');
            updateStatus('<i class="fa-solid fa-camera"></i> Scanner stopped', 'ready');
        }).catch(err => {
            console.error('Error stopping scanner:', err);
        });
    }
    
    function onScanSuccess(decodedText, decodedResult) {
        console.log('QR Code detected:', decodedText);
        
        // Stop scanner
        stopScanner();
        
        updateStatus('<i class="fa-solid fa-check-circle"></i> QR Code detected! Loading ticket details...', 'success');
        
        // Fetch ticket details
        fetchTicketDetails(decodedText);
    }
    
    function onScanFailure(error) {
        // This is called constantly while scanning, so we don't log it
    }
    
    function fetchTicketDetails(ticketMasterId) {
        fetch(`/api/qr-scan/$${'{'}ticketMasterId${'}'}`)
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    displayTicketDetails(data);
                } else {
                    updateStatus('<i class="fa-solid fa-exclamation-circle"></i> ' + data.message, 'error');
                    setTimeout(() => {
                        updateStatus('<i class="fa-solid fa-camera"></i> Ready to scan another code', 'ready');
                    }, 3000);
                }
            })
            .catch(error => {
                console.error('Error fetching ticket details:', error);
                updateStatus('<i class="fa-solid fa-exclamation-triangle"></i> Error loading ticket details', 'error');
                setTimeout(() => {
                    updateStatus('<i class="fa-solid fa-camera"></i> Ready to scan another code', 'ready');
                }, 3000);
            });
    }
    
    function displayTicketDetails(data) {
        // Set ticket master ID
        document.getElementById('ticket-master-id').value = data.ticketMaster.ticketMasterId;
        
        // Populate ticket holder info
        const ticketInfo = document.getElementById('ticket-info');
        ticketInfo.innerHTML = `
            <div class="row">
                <div class="col-md-6">
                    <p><strong><i class="fa-solid fa-user"></i> Name:</strong> $${'{'}data.ticketMaster.fullName${'}'}</p>
                </div>
                <div class="col-md-6">
                    <p><strong><i class="fa-solid fa-ticket"></i> Total Tickets:</strong> $${'{'}data.ticketDetails.length${'}'}</p>
                </div>
            </div>
        `;
        
        // Populate ticket list
        const ticketList = document.getElementById('ticket-list');
        ticketList.innerHTML = '';
        
        data.ticketDetails.forEach((ticket, index) => {
            const isCheckedIn = ticket.checkedIn === 1;
            const pricingName = data.pricingMap[ticket.pricingOptionId] || 'Unknown';
            
            const ticketCard = `
                <div class="col-md-6">
                    <div class="card ticket-card $${'{'}isCheckedIn ? 'border-success' : ''${'}'}">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-start">
                                <div class="form-check">
                                    <input class="form-check-input ticket-checkbox" 
                                           type="checkbox" 
                                           name="ticketIds" 
                                           value="$${'{'}ticket.detailId${'}'}" 
                                           id="ticket-$${'{'}index${'}'}"
                                           $${'{'}isCheckedIn ? 'disabled' : ''${'}'}">
                                    <label class="form-check-label" for="ticket-$${'{'}index${'}'}">
                                        <strong>$${'{'}pricingName${'}'}</strong><br>
                                        <small class="text-muted">Code: $${'{'}ticket.uniqueCode${'}'}</small>
                                    </label>
                                </div>
                                <span class="badge $${'{'}isCheckedIn ? 'bg-success' : 'bg-warning text-dark'${'}'} status-badge">
                                    $${'{'}isCheckedIn ? '<i class="fa-solid fa-check"></i> Checked In' : '<i class="fa-solid fa-clock"></i> Pending'${'}'}
                                </span>
                            </div>
                            $${'{'}isCheckedIn ? `
                                <div class="mt-2">
                                    <small class="text-muted">
                                        <i class="fa-solid fa-calendar-check"></i> Checked in at: $${'{'}ticket.checkedInAt || 'N/A'${'}'}
                                    </small>
                                </div>
                            ` : ''${'}'}
                        </div>
                    </div>
                </div>
            `;
            
            ticketList.innerHTML += ticketCard;
        });
        
        // Show ticket section
        document.getElementById('ticket-section').classList.remove('d-none');
        
        // Scroll to ticket section
        document.getElementById('ticket-section').scrollIntoView({ behavior: 'smooth', block: 'start' });
        
        // Enable/disable check-in button based on selections
        updateCheckinButton();
        
        // Add event listeners to checkboxes
        document.querySelectorAll('.ticket-checkbox').forEach(checkbox => {
            checkbox.addEventListener('change', updateCheckinButton);
        });
    }
    
    function selectAll() {
        document.querySelectorAll('.ticket-checkbox:not(:disabled)').forEach(checkbox => {
            checkbox.checked = true;
        });
        updateCheckinButton();
    }
    
    function deselectAll() {
        document.querySelectorAll('.ticket-checkbox:not(:disabled)').forEach(checkbox => {
            checkbox.checked = false;
        });
        updateCheckinButton();
    }
    
    function updateCheckinButton() {
        const checkedBoxes = document.querySelectorAll('.ticket-checkbox:checked').length;
        const button = document.getElementById('checkin-button');
        button.disabled = checkedBoxes === 0;
        button.innerHTML = `<i class="fa-solid fa-check-circle"></i> Check In Selected ($${'{'}checkedBoxes${'}'})`;
    }
    
    function resetScanner() {
        // Hide ticket section
        document.getElementById('ticket-section').classList.add('d-none');
        
        // Clear form
        document.getElementById('checkin-form').reset();
        
        // Reset status and restart scanner
        updateStatus('<i class="fa-solid fa-camera"></i> Ready to scan', 'ready');
        
        // Scroll back to top
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }
</script>

</body>
</html>
