<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${event.eventName} - Event Details</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="icon" type="image/x-icon" href="/imgs/logo.jpg">
    <script src="https://kit.fontawesome.com/6e1d51a9e9.js" crossorigin="anonymous"></script>
    <style>
        li {
            list-style-type: none;
        }
        .event-image {
            width: 30%;
            height: 30vh;
            object-fit: fill;
            display: block;
            margin: 0 auto;
            border-radius: 10px;
        }
        .event-details h1, .event-details div {
            text-align: center;
        }

        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            background-color: #f4f4f4;
            color: #333;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 80%;
            margin: auto;
            padding: 20px;
        }

        header {
            background-color: #ff6347;
            color: white;
            padding: 10px 0;
            text-align: center;
        }

        h1, h2 {
            margin: 0;
        }

        .content {
            background-color: white;
            padding: 20px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }


        @media (max-width: 767.98px) {
            .event-image {
                height: 10vh !important;
            }
        }

    </style>
</head>
<body>
<#include "nav.ftl">

<div class="container">
    <div class="event-details">
        <h1>${event.eventName}</h1>
        <img src="${event.imageUrl}" alt="${event.eventName}" class="event-image mb-5">
        <div>
        <h3><strong>Date and Time:</strong> ${event.eventDateTimeLanding}</h3>
        <p><strong>Location:</strong> ${event.eventLocation}</p>
        <#if event.rsvpYes?? && event.rsvpYes == "yes">
            <#if event.rsvpYes?? && event.rsvpYes == "yes" && event.rsvpStartDate?? && event.rsvpEndDate??>
                <#assign today = .now?date>
                <#assign startDate = event.rsvpStartDate?date("yyyy-MM-dd")>
                <#assign endDate = event.rsvpEndDate?date("yyyy-MM-dd")>
                <#if (today >= startDate) && (today <= endDate)>
                    <a type="button" class="btn btn-lg btn-outline-success " href="/tickets/new/${event.eventId}">
                        <i class="fa-solid fa-stamp"></i> RSVP
                    </a>
                </#if>
            </#if>
        <#else>
            <#assign buyButtonDisplayed = false>
            <#list pricings as pricing>
                <#if pricing.eventId?? && !buyButtonDisplayed && pricing.eventId == event.eventId && pricing.status == "Active">
                    <a type="button" class="btn btn-lg btn-outline-success" href="/tickets/new/${event.eventId}">
                    <i class="fa-solid fa-ticket"></i> Buy
                    </a>
                    <#assign buyButtonDisplayed = true>
                    <#break>
                </#if>
            </#list>
        </#if>
        </div>
    </div>
</div>

<footer class="bg-dark text-white text-center py-3">
    <p>${.now?string('yyyy')} Sangam &copy;. All Rights reserved.</p>
</footer>
</body>
</html>
