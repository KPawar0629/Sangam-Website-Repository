<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - Sangam</title>
    <link rel="icon" type="image/x-icon" href="/imgs/logo.jpg">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <script src="https://kit.fontawesome.com/6e1d51a9e9.js" crossorigin="anonymous"></script>

</head>

<body>
<div class="d-flex flex-column min-vh-100">
    <#include "nav.ftl">
    <link href="/css/style.css" rel="stylesheet" type="text/css"/>
    <main class="flex-grow-1">
        <div class="cont">
            <div class="item left">
                <img src="/imgs/logo1.png" class="rounded-2 main-logo">
            </div>
            <#--  <div class="item left2">
                <h5 class="h3">Community Helpful Links</h5>
                <p style="line-height: 2.5;" class="mt-5">
                    <a href="https://www.google.com" target="_blank" class="h6" style="text-decoration: none;">Travel Insurance</a><br>
                    <a href="https://www.google.com" target="_blank" class="h6" style="text-decoration: none;">Restaurants</a><br>
                    <a href="https://www.google.com" target="_blank" class="h6" style="text-decoration: none;">LAX Airbus Schedule</a><br>
                </p>
            </div>  -->
            <div class="item main">
                <h1 class="text-center main-text">Welcome to Sangam Santa Barbara</h1>
                <div id="photoCarousel" class="carousel slide carousel-fade main-carousel mt-4" data-bs-ride="carousel">
                    <div class="carousel-inner">
                        <#--  <div class="carousel-item active" data-bs-interval="3000">
                            <img src="/imgs/gallery/diwali.JPG" alt="Photo 1" class="rounded-2">
                            </div>
                        <div class="carousel-item" data-bs-interval="3000">
                            <img src="/imgs/gallery/diwali5.JPG" alt="Photo 2" class="rounded-2">
                        </div>
                        <div class="carousel-item" data-bs-interval="3000">
                            <img src="/imgs/gallery/diwali6.JPG" alt="Photo 3" class="rounded-2">
                        </div>  -->
                        <div class="carousel-item active" data-bs-interval="3000">
                            <img src="/imgs/gallery/gallery1.JPG" class="rounded-2">
                        </div>
                    </div>
                </div>
            </div>
            <div class="item right">
                <h5 class="h3 main-text" style="font-size: 28px; margin: 5% 0 0 0; color: #000;">Our Events</h5>
                <#if events?size == 0>
                    <div class="d-flex justify-content-center">
                        <div class="card border-secondary" style="width: 18rem;">
                            <img src="/imgs/events/noevent.jpg" class="card-img-top" alt="...">
                            <div class="card-body text-center">
                                <p class="card-text"><small class="text-body-secondary">
                                    <b>No Upcoming Events to Show!</b>
                            </small></p>
                            </div>
                        </div>
                    </div>
                <#else>
                    <#assign numEvents = 0>
                    <#list events as event>
                        <#if event.status != "Completed!" && event.imageUrl??>
                            <div class="d-flex justify-content-center">
                                    <div class="card border-secondary mt-4" style="width: 18rem; margin:40px;">
                                        <img src="${event.imageUrl}" class="card-img-top" alt="...">
                                        <div class="card-body text-center">
                                            <a href="/event_details?eventId=${event.eventId}" style="text-decoration: none; color: #000;">
                                            <h5 class="card-title fw-bold">${event.eventName}</h5></a>
                                            <h6 class="card-subtitle">
                                                <#if (event.eventDescription?length > 40)>
                                                    ${event.eventDescription?substring(0, 40)}...
                                                <#else>
                                                    ${event.eventDescription}
                                                </#if>
                                            </h6>
                                            <p class="card-text"><small class="text-body-secondary">
                                                    <i class="fa-solid fa-location-dot"></i> ${event.eventLocation}<br>
                                                    <i class="fa-solid fa-calendar"></i> <span class="formatted-date">${event.eventDateTimeLanding}</span>
                                                </small></p>
                                                <#assign buyButtonDisplayed = false>
                                                <#if event.eventId?? && event.eventType?? && event.eventType == "paid">
                                                    <#list pricings as pricing>
                                                        <#if pricing.eventId?? && !buyButtonDisplayed && pricing.eventId == event.eventId && pricing.status == "Active">
                                                            <a href="/tickets/new/${event.eventId}" class="btn btn-lg mb-3 btn-success" style="text-decoration: none; color: white;">
                                                                <i class="fa-solid fa-ticket"></i> Buy Tickets
                                                            </a>
                                                            <#assign buyButtonDisplayed = true>
                                                            <#break>
                                                        <#else>
                                                        
                                                        </#if>
                                                    </#list>
                                                <#else>
                                                    <a href="/event_details?eventId=${event.eventId}" class="btn btn-lg mb-3 btn-primary" style="text-decoration: none; color: white;">RSVP Here</a>
                                                </#if>
                                                <div class="row card-row">
                                                <#--<#assign buyButtonDisplayed = false>
                                                <#if event.eventId?? && event.eventType?? && event.eventType == "paid">
                                                    <#list pricings as pricing>
                                                    <#if pricing.eventId?? && !buyButtonDisplayed && pricing.eventId == event.eventId && pricing.status == "Active">
                                                        <a type="button" class="btn btn-lg btn-outline-success" href="/tickets/new/${event.eventId}">
                                                            <i class="fa-solid fa-ticket"></i> Buy
                                                        </a>
                                                        <#assign buyButtonDisplayed = true>
                                                        <#break>
                                                    </#if>
                                                    </#list>
                                                <#else>
                                                    <#if event.rsvpYes?? && event.rsvpYes == "yes" && event.rsvpStartDate?? && event.rsvpEndDate??>
                                                        <#assign today = .now?date>
                                                        <#assign startDate = event.rsvpStartDate?date("yyyy-MM-dd")>
                                                        <#assign endDate = event.rsvpEndDate?date("yyyy-MM-dd")>
                                                        <#if (today >= startDate) && (today <= endDate)>
                                                            <a type="button" class="btn btn-lg btn-outline-success" href="/tickets/new/${event.eventId}">
                                                                <i class="fa-solid fa-stamp"></i> RSVP
                                                            </a>
                                                        </#if>
                                                    </#if>
                                                </#if>  -->

                                                <#if event.participationAllowed == 1 && event.partiStatus == "Active">
                                                    <a type="button" class="btn btn-lg btn-outline-primary mt-2 card-btn" href="/performance/${event.eventId}">
                                                        <i class="fa-regular fa-hand"></i> Participate
                                                    </a>
                                                </#if>
                                                <button type="button" class="btn btn-lg btn-outline-danger mt-2" hidden>
                                                    <i class="fa-solid fa-indian-rupee-sign"></i> Bid
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                            </div>
                            <#assign numEvents = numEvents + 1>
                        </#if>
                    </#list>
                    <#if numEvents == 0>
                        <div class="d-flex justify-content-center">
                                <div class="card border-secondary" style="width: 18rem;">
                                    <img src="/imgs/events/noevent.jpg" class="card-img-top" alt="...">
                                    <div class="card-body text-center">
                                        <p class="card-text"><small class="text-body-secondary">
                                            <b>No Upcoming Events to Show!</b>
                                        </small></p>
                                    </div>
                                </div>
                            </div>
                    </#if>
                </#if>
            </div>
        </div>
    </main>

    <#if message??>
        <div class="modal fade" id="messageModal" tabindex="-1" aria-labelledby="messageModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="messageModalLabel">Notification</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>${message}</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
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
</script>
</body>
</html>
