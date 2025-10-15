<!DOCTYPE html>
<html lang="en">
<head>
    <title>Create Event</title>
    <link rel="icon" type="image/x-icon" href="/imgs/logo.jpg">

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <script src="https://kit.fontawesome.com/6e1d51a9e9.js" crossorigin="anonymous"></script>

</head>
<body>
<div class="d-flex flex-column min-vh-100">
    <#include "nav.ftl">
    <link href="/css/style.css" rel="stylesheet" type="text/css"/>
    <style>
        /* Fix horizontal scrolling issue */
        html, body {
            overflow-x: hidden;
            width: 100%;
            position: relative;
        }
        
        /* Ensure all elements stay within container boundaries */
        .container {
            max-width: 100%;
            padding-left: 15px;
            padding-right: 15px;
            overflow-x: hidden;
        }
        
        /* Ensure all rows don't cause overflow */
        .row {
            margin-left: 0;
            margin-right: 0;
            width: 100%;
        }
        
        /* Ensure all inputs don't overflow */
        input, textarea, select {
            max-width: 100%;
            box-sizing: border-box;
        }
        
        /* Fix for any potential table overflow */
        .table-responsive {
            overflow-x: auto;
        }
        
        /* Add proper box-sizing to all elements */
        * {
            box-sizing: border-box;
        }
        
        /* Fix for date inputs */
        input[type="datetime-local"] {
            width: 100%;
        }

        /* Mobile button layout - 2 buttons per row */
        @media (max-width: 767px) {
            .button-container {
                display: grid !important;
                grid-template-columns: 1fr 1fr;
                gap: 10px;
                width: 100%;
            }

            .button-container .btn {
                width: 100%;
                font-size: 0.85rem;
                padding: 8px 10px;
            }

            .button-container .btn i {
                display: block;
                margin-bottom: 4px;
            }
        }
    </style>
    <main class="container mt-3 flex-grow-1">
        <form action="/events" method="post">
            <div class="container mt-3">
                <div class="row mt-4">
                    <div class="col-md-6 justify-content-start">
                        <h2>${event.eventId?has_content?then('Edit Event', 'Create New Event')}</h2>
                    </div>
                    <div class="col-md-6">
                        <div class="d-flex justify-content-end gap-2 button-container">
                            <#if event.eventId?? && event.published == 1 && (event.status == "active" || event.status == "Active")>
                                <a href="/events/send-qr-emails/${event.eventId}" type="button" class="btn btn-primary" 
                                   title="Send QR Code Emails" onclick="return confirm('Are you sure you want to send ticket emails with QR codes to all ticket holders for ${event.eventName}?')">
                                    <i class="fa-solid fa-qrcode"></i> Send QR Emails
                                </a>
                                <a href="/events/publish/${event.eventId}" type="button" class="btn btn-warning" 
                                   title="Unpublish Event" onclick="return confirm('Are you sure you want to close ${event.eventName}?')">
                                    <i class="fa-solid fa-ban"></i> Unpublish
                                </a>
                                <a href="/payment/all/${event.eventId}" type="button" class="btn btn-info" 
                                   title="Send Payment Reminder" onclick="return confirm('Are you sure you want to send reminder for payment for ${event.eventName}?')">
                                    <i class="fa-solid fa-envelope"></i> Send Payment Reminder
                                </a>
                            </#if>
                            <button type="submit" class="btn btn-success">${event.eventId?has_content?then('Update', 'Save')}</button>
                        </div>
                    </div>
                </div>



                <#if event.eventId??>
                    <input type="hidden" name="eventId" value="${event.eventId}" />
                </#if>

                <div class="mb-3 mt-3">
                    <label for="name">Name:</label>
                    <input type="text" class="form-control" id="name" value="${event.eventName!}" placeholder="Enter name" name="eventName" required>
                </div>
                <div class="mb-3">
                    <label for="description">Description:</label>
                    <input type="text" class="form-control" id="description" value="${event.eventDescription!}" placeholder="Enter Description" name="eventDescription" required>
                </div>
                <div class="mb-3">
                    <label for="location">Location:</label>
                    <input type="text" class="form-control" id="location" value="${event.eventLocation!}" placeholder="Enter Location" name="eventLocation" required>
                </div>
                <div class="mb-3">
                    <label for="date">Date & Time:</label>
                    <input type="datetime-local" class="form-control" id="date" value="${event.eventDateTimeOrig!}" placeholder="Enter Date Time" name="eventDateTime" required>
                </div>
                <div class="mb-3">
                    <label for="date">Event Type</label>
                    <select class="form-select" aria-label="Default select example" name="eventType">
                        <#if event.eventId?? && event.eventType?? &&(event.eventType == "paid")>
                        <option selected value="paid">Paid</option>
                        <option value="unpaid">Free</option>
                        <#else>
                        <option value="paid">Paid</option>
                        <option value="unpaid"selected>Free</option>
                        </#if>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="notesOnTickets">Message to show on buying tickets:</label>
                    <textarea class="form-control" type="text" id="comment" name="notesOnTickets" placeholder="Enter Notes for buying tickets! Remember earlier notes will not show up here!">${event.notesOnTickets!}</textarea>
                </div>
                <div class="mb-3">
                    <label for="notesOnTickets">Image Url:</label>
                    <input class="form-control" type="text" id="image" name="imageUrl" value="${event.imageUrl!}"  placeholder="Enter Image Url Here!">
                </div>
                <#if event.eventId??>
                    <hr>
                    <h3>Participation</h3>
                    <div class="mb-3">
                        <label class="form-label">Participation Allowed?</label>
                        <#if event.status == "active" || event.status == "Active">
                            <#if event.participationAllowed == 1>
                                <input type="radio" class="btn-check form-control" name="partiCheck" autocomplete="off" onclick="showHide(2)" value="no" id="noParti">
                                <label class="btn" for="noParti">No</label>
                                <input type="radio" class="btn-check form-control" name="partiCheck" autocomplete="off" checked onclick="showHide(1)" value="yes" id="yesParti">
                                <label class="btn" for="yesParti">Yes</label>
                            <#else>
                                <input type="radio" class="btn-check form-control" name="partiCheck" autocomplete="off" checked onclick="showHide(2)" value="no" id="noParti">
                                <label class="btn" for="noParti">No</label>
                                <input type="radio" class="btn-check form-control" name="partiCheck" autocomplete="off" onclick="showHide(1)" value="yes" id="yesParti">
                                <label class="btn" for="yesParti">Yes</label>
                            </#if>

                            <div id="yesDiv" class="d-none">
                                <label for="partiStart" class="form-label">Start Date:</label>
                                <input id="partiStart" type="date" name="partiStart" value="${(event.participationStartDate)!}" class="form-control">
                                <label for="partiEnd" class="form-label">End Date:</label>
                                <input id="partiEnd" type="date" name="partiEnd" value="${(event.participationEndDate)!}" class="form-control">
                            </div>
                        <#else>
                            <p class="text-muted">
                                <#if event.participationAllowed == 1>
                                    <span class="badge bg-success">Yes</span>
                                    <#if event.participationStartDate?? && event.participationEndDate??>
                                        (From: ${event.participationStartDate} To: ${event.participationEndDate})
                                    </#if>
                                <#else>
                                    <span class="badge bg-secondary">No</span>
                                </#if>
                                <br>
                                <small class="text-muted mt-2 d-block">Participation settings can only be modified when the event is active.</small>
                            </p>
                            <input type="hidden" name="partiCheck" value="<#if event.participationAllowed?? && event.participationAllowed == 1>yes<#else>no</#if>">
                            <#if event.participationStartDate??>
                                <input type="hidden" name="partiStart" value="${event.participationStartDate}">
                            </#if>
                            <#if event.participationEndDate??>
                                <input type="hidden" name="partiEnd" value="${event.participationEndDate}">
                            </#if>
                        </#if>
                    </div>
                    <#if event.eventId?? && event.eventType?? && (event.eventType != "paid")>
                        <br>
                        <br>
                        <h3>RSVP</h3>
                        <div class="mb-3">
                            <label class="form-label">RSVP Allowed?</label>
                            <#if event.status == "active" || event.status == "Active">
                                <#if event.rsvpYes?? && event.rsvpYes == "yes">
                                    <input type="radio" class="btn-check form-control" name="rsvpCheck" autocomplete="off" value="no" id="noRsvp" onclick="toggleRsvpCount(false)">
                                    <label class="btn" for="noRsvp">No</label>
                                    <input type="radio" class="btn-check form-control" checked name="rsvpCheck" autocomplete="off" value="yes" id="yesRsvp" onclick="toggleRsvpCount(true)">
                                    <label class="btn" for="yesRsvp">Yes</label>
                                <#else>
                                    <input type="radio" class="btn-check form-control" checked name="rsvpCheck" autocomplete="off" value="no" id="noRsvp" onclick="toggleRsvpCount(false)">
                                    <label class="btn" for="noRsvp">No</label>
                                    <input type="radio" class="btn-check form-control" name="rsvpCheck" autocomplete="off" value="yes" id="yesRsvp" onclick="toggleRsvpCount(true)">
                                    <label class="btn" for="yesRsvp">Yes</label>
                                </#if>
                                <div id="rsvpCountDiv" class="mt-3 <#if event.rsvpYes?? && event.rsvpYes == 'yes'><#else>d-none</#if>">
                                    <label for="rsvpCount" class="form-label">Maximum RSVP Count:</label>
                                    <input type="number" class="form-control" id="rsvpCount" name="rsvpCount" value="${event.rsvpCount!0}" min="0">
                                    
                                    <div class="mt-3">
                                        <label for="rsvpStart" class="form-label">RSVP Start Date:</label>
                                        <input id="rsvpStart" type="date" name="rsvpStart" value="${(event.rsvpStartDate)!}" class="form-control">
                                        <label for="rsvpEnd" class="form-label">RSVP End Date:</label>
                                        <input id="rsvpEnd" type="date" name="rsvpEnd" value="${(event.rsvpEndDate)!}" class="form-control">
                                    </div>
                                </div>
                            <#else>
                                <p class="text-muted">
                                    <#if event.rsvpYes?? && event.rsvpYes == "yes">
                                        <span class="badge bg-success">Yes</span>
                                        <#if event.rsvpCount??>
                                            (Max: ${event.rsvpCount})
                                        </#if>
                                        <#if event.rsvpStartDate?? && event.rsvpEndDate??>
                                            <br>From: ${event.rsvpStartDate} To: ${event.rsvpEndDate}
                                        </#if>
                                    <#else>
                                        <span class="badge bg-secondary">No</span>
                                    </#if>
                                    <br>
                                    <small class="text-muted mt-2 d-block">RSVP settings can only be modified when the event is active.</small>
                                </p>
                                <input type="hidden" name="rsvpCheck" value="<#if event.rsvpYes?? && event.rsvpYes == 'yes'>yes<#else>no</#if>">
                                <#if event.rsvpCount??>
                                    <input type="hidden" name="rsvpCount" value="${event.rsvpCount}">
                                </#if>
                                <#if event.rsvpStartDate??>
                                    <input type="hidden" name="rsvpStart" value="${event.rsvpStartDate}">
                                </#if>
                                <#if event.rsvpEndDate??>
                                    <input type="hidden" name="rsvpEnd" value="${event.rsvpEndDate}">
                                </#if>
                            </#if>
                        </div>
                    </#if>
                </#if>

            </div>
        </form>

        <#if event.eventId?? && event.eventType?? &&(event.eventType == "paid")>
        <div class="container mt-3 mb-3">
            <#if event.eventId??>
                <hr>

                <div>
                    <div class="row border-bottom-0 mb-4">
                        <div class="col-sm-10">
                            <h3>Pricing Details</h3>
                            <#if event.status != "active" && event.status != "Active">
                                <p class="text-muted"><small>Pricing can only be modified when the event is active</small></p>
                            </#if>
                        </div>
                        <div class="col-sm-2 text-end">
                            <#if event.status == "active" || event.status == "Active">
                                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addPricing">+ Add Pricing</button>
                            </#if>
                        </div>
                    </div>
                    
                    <style>
                        .pricing-box {
                            border-radius: 8px;
                            padding: 25px;
                            margin-bottom: 20px;
                            height: 100%;
                            display: flex;
                            flex-direction: column;
                            background-color: #ffffff;
                            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
                            transition: all 0.2s ease;
                            position: relative;
                            overflow: hidden;
                        }
                        
                        .pricing-box:not(.expired):hover {
                            transform: translateY(-5px);
                            box-shadow: 0 8px 24px rgba(0,0,0,0.12);
                        }
                        
                        /* Styles for expired pricing */
                        .pricing-box.expired {
                            background-color: #ffeeee;
                            box-shadow: 0 2px 12px rgba(220,53,69,0.08);
                            opacity: 0.85;
                            pointer-events: none; /* Disable hover events on the box */
                        }
                        
                        .pricing-box.expired::before {
                            content: "EXPIRED";
                            position: absolute;
                            top: 10px;
                            right: 10px;
                            background-color: rgba(220,53,69,0.2);
                            color: #dc3545;
                            font-size: 0.7rem;
                            font-weight: bold;
                            padding: 4px 8px;
                            border-radius: 4px;
                            letter-spacing: 0.5px;
                        }
                        
                        /* Re-enable pointer events on the action buttons */
                        .pricing-box.expired .pricing-actions {
                            pointer-events: auto;
                        }
                        
                        .price {
                            font-size: 2.8rem;
                            font-weight: bold;
                            color: #198754;
                            text-align: center;
                            margin-top: 5px;
                            margin-bottom: 15px;
                            line-height: 1;
                        }
                        
                        .price::after {
                            content: '';
                            display: block;
                            width: 40px;
                            height: 3px;
                            background-color: #198754;
                            margin: 12px auto 10px;
                            border-radius: 2px;
                        }
                        
                        .expired .price {
                            color: #dc3545;
                            opacity: 0.7;
                        }
                        
                        .expired .price::after {
                            background-color: #dc3545;
                            opacity: 0.5;
                        }
                        
                        .expired .ticket-name,
                        .expired .ticket-desc,
                        .expired .date-badge {
                            opacity: 0.75;
                        }
                        
                        .expired .date-badge {
                            background-color: rgba(220,53,69,0.05);
                            border-color: rgba(220,53,69,0.2);
                        }
                        
                        .expired .date-badge i {
                            color: rgba(220,53,69,0.6);
                        }
                        
                        .ticket-name {
                            font-size: 1.5rem;
                            font-weight: 600;
                            color: #333;
                            text-align: center;
                            margin-bottom: 8px;
                        }
                        
                        .ticket-desc {
                            font-size: 1rem;
                            color: #666;
                            text-align: center;
                            margin-bottom: 20px;
                            flex-grow: 1;
                        }
                        
                        .ticket-dates {
                            font-size: 0.9rem;
                            color: #666;
                            text-align: center;
                            margin-bottom: 20px;
                            display: flex;
                            flex-direction: column;
                            gap: 8px;
                        }
                        
                        .date-badge {
                            background-color: #f8f9fa;
                            padding: 8px 12px;
                            border-radius: 6px;
                            display: block;
                            font-size: 0.9rem;
                            color: #555;
                            overflow: hidden;
                            text-overflow: ellipsis;
                            border: 1px solid #eaeaea;
                            box-sizing: border-box;
                        }
                        
                        .date-badge i {
                            margin-right: 8px;
                            color: #198754;
                        }
                        
                        .pricing-actions {
                            display: flex;
                            justify-content: center;
                            gap: 10px;
                            margin-top: auto;
                            padding-top: 15px;
                            border-top: 1px solid #eee;
                        }
                        
                        .pricing-actions .btn {
                            padding: 8px 16px;
                            font-weight: 500;
                            transition: all 0.2s;
                        }
                        
                        .pricing-actions .btn:hover {
                            transform: translateY(-2px);
                        }
                        
                        /* Responsive adjustments */
                        @media (max-width: 767px) {
                            .row-cols-md-2 {
                                row-gap: 20px;
                            }
                            
                            .pricing-box {
                                min-height: 320px;
                                padding: 20px 15px;
                            }
                            
                            .price {
                                font-size: 2.5rem;
                                margin-bottom: 12px;
                            }
                            
                            .ticket-name {
                                font-size: 1.3rem;
                            }
                            
                            .ticket-desc {
                                font-size: 0.95rem;
                            }
                        }
                        
                        @media (max-width: 576px) {
                            .row-cols-1 {
                                row-gap: 20px;
                            }
                            
                            .pricing-box {
                                padding: 20px 15px;
                                min-height: 280px;
                            }
                            
                            .price {
                                font-size: 2.4rem;
                                margin-bottom: 10px;
                            }
                            
                            .pricing-actions {
                                flex-direction: row;
                                gap: 10px;
                            }
                            
                            .pricing-actions .btn {
                                flex: 1;
                                justify-content: center;
                            }
                        }
                    </style>
                    
                    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4 mx-0 w-100">
                        <#if eventPricings?size == 0 && (event.status == "active" || event.status == "Active")>
                            <div class="col">
                                <div class="pricing-box d-flex align-items-center justify-content-center">
                                    <div class="text-center">
                                        <div class="mb-3 text-muted">
                                            <i class="fa-solid fa-ticket fa-3x"></i>
                                        </div>
                                        <h4>No Pricing Options</h4>
                                        <p>Click the "Add Pricing" button to create your first pricing option.</p>
                                        <button type="button" class="btn btn-primary mt-3" data-bs-toggle="modal" data-bs-target="#addPricing">
                                            <i class="fa-solid fa-plus"></i> Add Pricing
                                        </button>
                                    </div>
                                </div>
                            </div>
                        <#elseif eventPricings?size == 0>
                            <div class="col">
                                <div class="pricing-box d-flex align-items-center justify-content-center">
                                    <div class="text-center">
                                        <div class="mb-3 text-muted">
                                            <i class="fa-solid fa-ticket fa-3x"></i>
                                        </div>
                                        <h4>No Pricing Options</h4>
                                        <p>No pricing options have been added to this event yet.</p>
                                    </div>
                                </div>
                            </div>
                        <#else>
                            <#list eventPricings as pricing>
                                <div class="col">
                                    <div class="pricing-box">
                                        <div class="price">$${pricing.pricingRate}</div>
                                        <div class="ticket-name">${pricing.pricingName}</div>
                                        <div class="ticket-desc">${pricing.pricingDesc!''}</div>
                                        <div class="ticket-dates">
                                            <span class="date-badge" title="${pricing.startDate}">
                                                <i class="fa-regular fa-calendar"></i> From: ${pricing.startDate?substring(0,10)}
                                            </span>
                                            <span class="date-badge" title="${pricing.endDate}">
                                                <i class="fa-regular fa-calendar-check"></i> To: ${pricing.endDate?substring(0,10)}
                                            </span>
                                        </div>
                                        <#if event.status == "active" || event.status == "Active">
                                            <div class="pricing-actions">
                                                <a href="#" class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#addPricing"
                                                   data-id="${pricing.id}"
                                                   data-tickettype="${pricing.pricingName}"
                                                   data-description="${pricing.pricingDesc}"
                                                   data-rate="${pricing.pricingRate}"
                                                   data-startdate="${pricing.startDate}"
                                                   data-enddate="${pricing.endDate}" title="Edit Pricing">
                                                    <i class="fa-solid fa-pen"></i> Edit
                                                </a>
                                                <a href="/event_pricing/delete/${pricing.id}" class="btn btn-danger" 
                                                   onclick="return confirm('Are you sure you want to delete this pricing?')" title="Delete Pricing">
                                                    <i class="fa-solid fa-trash"></i> Delete
                                                </a>
                                            </div>
                                        </#if>
                                    </div>
                                </div>
                            </#list>
                        </#if>
                    </div>
                    <div class="modal fade" id="addPricing">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h3 class="modal-title">Add Pricing</h3>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <form action="/event_pricing" method="post" id="pricingForm">
                                        <input type="hidden" name="eventId" value="${event.eventId}" />
                                        
                                        <input type="hidden" name="eventPricingId" />
                                    
                                        <div class="mb-3">
                                            <label for="ticketType">Ticket Type:</label>
                                            <input type="text" class="form-control" id="ticketType" name="ticketType" value="${(pricing.pricingName)!}" required>
                                        </div>
                                        <div class="mb-3">
                                            <label for="description">Description:</label>
                                            <input type="text" class="form-control" id="description" name="description" value="${(pricing.pricingDesc)!}">
                                        </div>
                                        <div class="mb-3">
                                            <label for="startDate">Start Date:</label>
                                            <input id="startDate" type="datetime-local" class="form-control" name="startDate" value="${(pricing.startDate)!}" required>
                                        </div>
                                        <div class="mb-3">
                                            <label for="endDate">End Date:</label>
                                            <input id="endDate" type="datetime-local" class="form-control" name="endDate" value="${(pricing.endDate)!}" required>
                                        </div>
                                        <div class="mb-3">
                                            <label for="ratePerTicket">Rate Per Ticket:</label>
                                            <input type="number" step="0.5" class="form-control" id="ratePerTicket" name="ratePerTicket" value="${(pricing.pricingRate)!}" required>
                                        </div>

                                        <span id="warningText" class="warning-text text-danger"></span><br>

                                        <button type="submit" class="btn btn-success" id="addButton">Save</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    
                    

                </div>
            </#if>
        </div>
        </#if>

    </main>
    
    <!-- Message Modal -->
    <script>
        // Check for message cookie and display modal
        function getCookie(name) {
            const value = `; $${'{'}document.cookie${'}'}`;
            const parts = value.split(`; $${'{'}name${'}'}=`);
            if (parts.length === 2) return parts.pop().split(';').shift();
        }
        
        function deleteCookie(name) {
            document.cookie = name + '=; Path=/; Expires=Thu, 01 Jan 1970 00:00:01 GMT;';
        }
        
        // Check if there's a message cookie
        const messageCookie = getCookie('message');
        if (messageCookie) {
            const message = decodeURIComponent(messageCookie);
            
            // Create and show modal
            const modalHtml = `
                <div class="modal fade" id="messageModal" tabindex="-1" aria-labelledby="messageModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header bg-primary text-white">
                                <h5 class="modal-title" id="messageModalLabel">
                                    <i class="fa-solid fa-envelope-circle-check"></i> Email Status
                                </h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <pre style="white-space: pre-wrap; font-family: inherit; font-size: 1rem;">$${'{'}message${'}'}</pre>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            </div>
                        </div>
                    </div>
                </div>
            `;
            
            // Add modal to body
            document.body.insertAdjacentHTML('beforeend', modalHtml);
            
            // Show modal
            const myModal = new bootstrap.Modal(document.getElementById('messageModal'));
            myModal.show();
            
            // Delete the cookie after showing
            deleteCookie('message');
        }
    </script>
    
    <footer class="bg-dark text-white text-center py-3 mt-auto">
            <p>2025 Sangam &copy;. All Rights reserved.</p>
        </footer>
</div>
    <script>
    let addPricingModal = document.getElementById('addPricing');
    addPricingModal.addEventListener('show.bs.modal', function (event) {
        // Button that triggered the modal
        let button = event.relatedTarget;

        // Extract data-* attributes from the button
        let id = button.getAttribute('data-id');
        let ticketType = button.getAttribute('data-tickettype');
        let description = button.getAttribute('data-description');
        let rate = button.getAttribute('data-rate');
        let startDate = button.getAttribute('data-startdate');
        let endDate = button.getAttribute('data-enddate');

        // Use the above data to populate the form fields in the modal
        let modalTitle = addPricingModal.querySelector('.modal-title');
        let ticketTypeInput = addPricingModal.querySelector('#ticketType');
        let descriptionInput = addPricingModal.querySelector('#description');
        let rateInput = addPricingModal.querySelector('#ratePerTicket');
        let submitButton = addPricingModal.querySelector('#addButton');
        let hiddenIdInput = addPricingModal.querySelector('input[name="eventPricingId"]');
        let startDateInput = addPricingModal.querySelector('#startDate');
        let endDateInput = addPricingModal.querySelector('#endDate');


        modalTitle.textContent = id ? 'Update Pricing' : 'Add Pricing';
        submitButton.textContent = id ? 'Update' : 'Save';
        ticketTypeInput.value = ticketType;
        descriptionInput.value = description;
        rateInput.value = rate;
        startDateInput.value = startDate;
        endDateInput.value = endDate;
        hiddenIdInput.value = id;
    });
    document.addEventListener('DOMContentLoaded', function () {
        // Check for expired pricing options
        checkExpiredPricingOptions();
        
        // Initialize RSVP controls if they exist
        const yesRsvp = document.getElementById('yesRsvp');
        if (yesRsvp && yesRsvp.checked) {
            toggleRsvpCount(true);
        }
        
        // Only initialize pricing form validation if the form exists
        const form = document.getElementById('pricingForm');
        if (form) {
            const warningText = document.getElementById('warningText');
            const submitButton = form.querySelector('button[type="submit"]');

            form.addEventListener('submit', function (event) {
                const startDateInput = form.querySelector('input[name="startDate"]');
                const endDateInput = form.querySelector('input[name="endDate"]');

                if (startDateInput && endDateInput) {
                    const startDate = new Date(startDateInput.value);
                    const endDate = new Date(endDateInput.value);

                    if (endDate < startDate) {
                        event.preventDefault(); // Prevent form submission
                        warningText.textContent = 'End date must be greater than or equal to the start date.';
                        submitButton.disabled = true; // Disable submit button
                    } else {
                        warningText.textContent = ''; // Clear warning text
                        submitButton.disabled = false; // Enable submit button
                    }
                }
            });

            // Optional: Enable submit button when fields change
            form.querySelectorAll('input[name="startDate"], input[name="endDate"]').forEach(input => {
                input.addEventListener('change', function () {
                    const startDateInput = form.querySelector('input[name="startDate"]');
                    const endDateInput = form.querySelector('input[name="endDate"]');

                    if (startDateInput && endDateInput) {
                        const startDate = new Date(startDateInput.value);
                        const endDate = new Date(endDateInput.value);

                        if (endDate < startDate) {
                            warningText.textContent = 'End date must be greater than or equal to the start date.';
                            submitButton.disabled = true;
                        } else {
                            warningText.textContent = '';
                            submitButton.disabled = false;
                        }
                    }
                });
            });
        }
    });
    
    // Function to check if pricing options are expired and mark them accordingly
    function checkExpiredPricingOptions() {
        const today = new Date();
        const pricingBoxes = document.querySelectorAll('.pricing-box');
        
        pricingBoxes.forEach(box => {
            // Find the end date badge inside this pricing box
            const endDateElement = box.querySelector('.date-badge:last-child');
            if (endDateElement) {
                // Extract the date string - format is "From: YYYY-MM-DD" or "To: YYYY-MM-DD"
                const dateText = endDateElement.textContent.trim();
                const dateMatch = dateText.match(/To: (\d{4}-\d{2}-\d{2})/);
                
                if (dateMatch && dateMatch[1]) {
                    const endDate = new Date(dateMatch[1]);
                    endDate.setHours(23, 59, 59); // Set to end of day
                    
                    // Check if end date has passed
                    if (endDate < today) {
                        box.classList.add('expired');
                    }
                }
            }
        });
    }    function showHide(val) {
        const yesDiv = document.getElementById('yesDiv');
        if(val==1) {
            yesDiv.classList.remove('d-none');
            partiStart.required = true;
            partiEnd.required = true;
        }
        if(val==2) {
            yesDiv.classList.add('d-none');
            partiStart.required = false;
            partiEnd.required = false;
        }
    }
    
    function toggleRsvpCount(show) {
        const rsvpCountDiv = document.getElementById('rsvpCountDiv');
        const rsvpCount = document.getElementById('rsvpCount');
        const rsvpStart = document.getElementById('rsvpStart');
        const rsvpEnd = document.getElementById('rsvpEnd');
        
        if (show) {
            rsvpCountDiv.classList.remove('d-none');
            if (rsvpCount) rsvpCount.required = true;
            if (rsvpStart) rsvpStart.required = true;
            if (rsvpEnd) rsvpEnd.required = true;
        } else {
            rsvpCountDiv.classList.add('d-none');
            if (rsvpCount) rsvpCount.required = false;
            if (rsvpStart) rsvpStart.required = false;
            if (rsvpEnd) rsvpEnd.required = false;
        }
    }
</script>
</body>
</html>

