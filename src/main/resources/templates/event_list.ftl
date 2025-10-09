<!DOCTYPE html>
<html lang="en">
<head>
    <title>Events - Sangam</title>
    <link rel="icon" type="image/x-icon" href="/imgs/logo.jpg">

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <script src="https://kit.fontawesome.com/6e1d51a9e9.js" crossorigin="anonymous"></script>
    
    <style>
        .event-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border-radius: 10px;
            overflow: hidden;
        }
        
        .event-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        
        .card-title {
            font-weight: 600;
            color: #333;
        }
        
        .object-fit-cover {
            object-fit: cover;
        }
        
        /* Action buttons grid layout */
        .action-buttons {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 8px;
            width: 100%;
        }
        
        .action-btn {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 10px 5px;
            height: auto;
            min-height: 90px;
            text-align: center;
            border-radius: 8px;
            transition: all 0.2s ease-in-out;
            border: none;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        
        .action-btn i {
            font-size: 2rem;
            margin-bottom: 10px;
            display: block;
            text-align: center;
            width: 100%;
        }
        
        .btn-text {
            font-size: 0.75rem;
            display: block;
            line-height: 1.2;
            text-align: center;
            font-weight: 500;
            width: 100%;
        }
        
        @media (max-width: 1199px) {
            .action-buttons {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        
        @media (max-width: 991px) {
            .action-buttons {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        
        /* Button specific styling */
        .btn-success.action-btn {
            background-color: #198754;
            border-color: #198754;
            color: white;
            box-shadow: 0 3px 5px rgba(0,0,0,0.1);
        }
        
        .btn-warning.action-btn {
            background-color: #ffc107;
            border-color: #ffc107;
            color: #000;
            box-shadow: 0 3px 5px rgba(0,0,0,0.1);
        }
        
        .btn-info.action-btn {
            background-color: #0dcaf0;
            border-color: #0dcaf0;
            color: #000;
            box-shadow: 0 3px 5px rgba(0,0,0,0.1);
        }
        
        .btn-secondary.action-btn {
            background-color: #6c757d;
            border-color: #6c757d;
            color: white;
            box-shadow: 0 3px 5px rgba(0,0,0,0.1);
        }
        
        .btn-outline-secondary.action-btn, 
        .btn-outline-danger.action-btn {
            box-shadow: 0 3px 5px rgba(0,0,0,0.1);
        }
        
        /* Special button styling for the main action buttons */
        .action-btn:has(i.fa-hand) {
            background-color: #8a5da9;
            border-color: #8a5da9;
            color: white;
        }
        
        .action-btn:has(i.fa-dollar-sign) {
            background-color: #e74c3c;
            border-color: #e74c3c;
            color: white;
        }
        
        .action-btn:has(i.fa-check) {
            background-color: #f39c12;
            border-color: #f39c12;
            color: #000;
        }
        
        .action-btn:has(i.fa-chart-column) {
            background-color: #16a085;
            border-color: #16a085;
            color: white;
        }
        
        /* Specific icon styles to match screenshot */
        .action-btn:has(i.fa-hand) i {
            color: white;
        }
        
        .action-btn:has(i.fa-dollar-sign) i {
            color: white;
        }
        
        .action-btn:has(i.fa-chart-column) i {
            color: white;
        }
        
        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 7px rgba(0,0,0,0.15);
        }

        @media (max-width: 767px) {
            .event-card .row {
                flex-direction: column;
            }
            
            .event-card .col-md-3 img {
                height: 150px;
                width: 100%;
                object-fit: cover;
            }
            
            .event-card .col-md-3:last-child {
                border-top: 1px solid #eee;
                padding-top: 1rem;
            }
            
            .card-body {
                padding: 1rem;
            }
            
            .action-buttons {
                grid-template-columns: repeat(3, 1fr);
            }
            
            .action-btn {
                min-height: 70px;
                padding: 5px;
            }
            
            .action-btn i {
                margin-bottom: 4px;
            }
        }
        
        @media (max-width: 575px) {
            .action-buttons {
                grid-template-columns: repeat(2, 1fr);
            }
        }
    </style>
</head>
<body>
    <div class="d-flex flex-column min-vh-100">
        <#include "nav.ftl">
        <link href="/css/style.css" rel="stylesheet" type="text/css"/>

        <main class="content flex-grow-1">
            <div class="container mt-3">
    <div class="row mt-4 mb-4">
        <div class="col-sm-8">
            <h2>Events</h2>
        </div>
        <div class="col-sm-4 text-end">
            <#if loggedInUser?? && loggedInUser.role == "admin">
                <a type="button" class="btn btn-success" href="/events/new">+ Add Event</a>
            </#if>
        </div>
    </div>
    
    <!-- Event Cards -->
    <div class="row g-4">
        <#list events as event>
            <div class="col-12">
                <div class="card shadow-sm h-100 event-card">
                    <div class="row g-0 h-100">
                        <!-- Image Column -->
                        <div class="col-md-3 col-lg-2">
                            <#if event.imageUrl?? && event.imageUrl != "">
                                <img src="${event.imageUrl}" class="img-fluid rounded-start h-100 w-100 object-fit-cover" alt="${event.eventName}" style="max-height: 200px;">
                            <#else>
                                <img src="/imgs/logo.jpg" class="img-fluid rounded-start h-100 w-100 object-fit-cover" alt="Default event image" style="max-height: 200px;">
                            </#if>
                        </div>
                        
                        <!-- Content Column -->
                        <div class="col-md-6 col-lg-8">
                            <div class="card-body">
                                <h5 class="card-title mb-2">
                                    <#if loggedInUser?? && loggedInUser.role == "admin">
                                        <a href="/events/edit/${event.eventId}" class="text-decoration-none" title="Edit Event">${event.eventName}</a>
                                    <#else>
                                        ${event.eventName}
                                    </#if>
                                </h5>
                                
                                <div class="d-flex flex-wrap gap-2 mb-2">
                                    <#if event.status == "Active" || event.status == "active">
                                        <span class="badge bg-success">${event.status}</span>
                                    <#elseif event.status == "Draft">
                                        <span class="badge bg-warning">${event.status}</span>
                                    <#else>
                                        <span class="badge bg-secondary">${event.status}</span>
                                    </#if>
                                    <span class="badge bg-info text-dark">${event.eventDateTimeLanding}</span>
                                    <span class="badge bg-primary">${event.eventLocation}</span>
                                </div>
                                
                                <p class="card-text">
                                    <#if (event.eventDescription?length > 150)>
                                        ${event.eventDescription?substring(0, 150)}...
                                    <#else>
                                        ${event.eventDescription}
                                    </#if>
                                </p>
                                
                                <p class="card-text d-md-none">
                                    <small class="text-body-secondary">
                                        <i class="fas fa-calendar-alt me-1"></i> ${event.eventDateTimeLanding}
                                    </small>
                                </p>
                            </div>
                        </div>
                        
                        <!-- Actions Column -->
                        <div class="col-md-3 col-lg-2">
                            <div class="card-body d-flex flex-column justify-content-center h-100">
                                <#if event.published == 0>
                                    <#if loggedInUser?? && loggedInUser.role == "admin">
                                        <#if event.status == "Draft">
                                            <div class="action-buttons">
                                                <button class="btn btn-warning action-btn" onclick="confirmPublish('${event.eventId}', '${event.eventName}')">
                                                    <i class="fa-solid fa-paper-plane"></i>
                                                    <span class="btn-text">Publish</span>
                                                </button>
                                                <button class="btn btn-danger action-btn" onclick="confirmDelete('${event.eventId}')">
                                                    <i class="fa-solid fa-trash"></i>
                                                    <span class="btn-text">Delete</span>
                                                </button>
                                            </div>
                                        <#else>
                                            <div class="action-buttons">
                                                <button class="btn btn-danger action-btn" onclick="confirmDelete('${event.eventId}')">
                                                    <i class="fa-solid fa-trash"></i>
                                                    <span class="btn-text">Delete</span>
                                                </button>
                                            </div>
                                        </#if>
                                    </#if>
                                <#else>
                                    <#if loggedInUser?? && loggedInUser.role == "admin">
                                        <#if event.status == "active" || event.status == "Active">
                                            <div class="action-buttons">
                                                <a href="/participant_list?eventId=${event.eventId}" class="btn btn-outline-secondary action-btn">
                                                    <i class="fa-solid fa-hand"></i>
                                                    <span class="btn-text">Participants</span>
                                                </a>
                                                <a href="/payment_list/${event.eventId}" class="btn btn-outline-danger action-btn">
                                                    <i class="fa-solid fa-dollar-sign"></i>
                                                    <span class="btn-text">Payments</span>
                                                </a>
                                                <a href="/checkin?eventId=${event.eventId}" class="btn btn-warning action-btn">
                                                    <i class="fa-solid fa-check"></i>
                                                    <span class="btn-text">Check-in</span>
                                                </a>
                                                <a href="/event/stats/${event.eventId}" class="btn btn-success action-btn">
                                                    <i class="fa-solid fa-chart-column"></i>
                                                    <span class="btn-text">Stats</span>
                                                </a>
                                            </div>
                                        <#else>
                                            <div class="action-buttons">
                                                <a href="/event/stats/${event.eventId}" class="btn btn-success action-btn">
                                                    <i class="fa-solid fa-chart-column"></i>
                                                    <span class="btn-text">Stats</span>
                                                </a>
                                            </div>
                                        </#if>
                                    <#else>
                                        <#if event.status == "active" || event.status == "Active">
                                            <div class="action-buttons">
                                                <a href="/checkin?eventId=${event.eventId}" class="btn btn-warning action-btn">
                                                    <i class="fa-solid fa-check"></i>
                                                    <span class="btn-text">Check-in</span>
                                                </a>
                                                <a href="/participant_list?eventId=${event.eventId}" class="btn action-btn" style="background-color: #8a5da9; border-color: #8a5da9; color: white;">
                                                    <i class="fa-solid fa-hand"></i>
                                                    <span class="btn-text">Participants</span>
                                                </a>
                                            </div>
                                        </#if>
                                    </#if>
                                </#if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </#list>
    </div>
    </div>
</main>

        <#if message??>
        </#if>

        <footer class="bg-dark text-white text-center py-3 mt-auto">
            <p>2025 Sangam &copy;. All Rights reserved.</p>
        </footer>
    </div>

<script>
    const myModal = new bootstrap.Modal('#messageModal');

    document.addEventListener('DOMContentLoaded', () => {
        if(myModal) {
            myModal.show();
        }
    });
    
    function confirmPublish(eventId, eventName) {
        if (confirm('Are you ready to make ' + eventName + ' open for tickets?')) {
            window.location.href = '/events/publish/' + eventId;
        }
    }
    
    function confirmDelete(eventId) {
        if (confirm('Do you really want to delete this event?')) {
            window.location.href = '/events/delete/' + eventId;
        }
    }
</script>
</body>
</html>
