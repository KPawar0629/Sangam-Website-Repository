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

        .food-info {
            margin-bottom: 20px;
        }

        .food-info ul {
            list-style-type: none;
            padding: 0;
        }

        .food-info li {
            padding: 5px 0;
        }

        .payment-options {
            padding: 10px;
            margin-top: 10px;
        }

        .onsite-prices {
            margin-top: 20px;
            padding: 10px;
        }

        .free-items {
            font-weight: bold;
        }

        .cta {
            text-align: center;
            margin-top: 30px;
        }

        .cta button {
            background-color: #ff6347;
            color: white;
            padding: 10px 20px;
            border: none;
            font-size: 16px;
            cursor: pointer;
        }

        .cta button:hover {
            background-color: #e55342;
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
        <div class="container">

    <header>
        <h2>Limited Spots - RSVP Now & Pre-Order Your Food</h2>
    </header>

    <div class="content">
        <h2>Food Options (Pre-Order by March 8th, 2025)</h2>

        <div class="food-info">
            <h3>Veggie Combo (Prepaid)</h3>
            <ul>
                <li>Price: $12.00</li>
                <li>Includes: Vegetable Biryani, Raita, Samosas, Jalebi</li>
            </ul>
        </div>

        <div class="food-info">
            <h3>Non-Veg Combo (Prepaid)</h3>
            <ul>
                <li>Price: $14.00</li>
                <li>Includes: Chicken Biryani, Raita, Samosas, Jalebi</li>
            </ul>
        </div>

        <h3>Payment Options</h3>
        <div class="payment-options">
            <ul>
                <li>Venmo/Zelle to <strong>408-373-7372</strong> (Add Description: <em>Holi2025</em> - <em>RSVP NAME</em>)</li>
                <li>Cash at Masala Spice Restaurant</li>
                <li>Credit Card at Masala Spice Restaurant (Note: $3 surcharge per transaction)</li>
            </ul>
        </div>

        <div class="onsite-prices mb-4">
            <h2>Onsite Prices</h2>
            <ul>
                <li>Veggie Combo: $14.00</li>
                <li>Non-Veg Combo: $16.00</li>
                <li>Lassi: $4.00 (Available Flavors: Mango, Sweet, Salted, Rose Milk, Thandai)</li>
            </ul>
        </div>

        <div class="free-items">
            <h3>FREE Offerings: <h6>***FIRST COME, FIRST SERVE***</h6></h3>
            <ul>
                <li>Colors (1 per adult - Additional colors can be brought or purchased)</li>
                <li>Tea</li>
                <li>Water</li>
                <li>Bollywood Music</li>
            </ul>
        </div>

        <div class="cta">
           <#if event.rsvpYes?? && event.rsvpYes == "yes">
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
</div>
</div>

<footer class="bg-dark text-white text-center py-3">
    <p>2025 Sangam &copy;. All Rights reserved.</p>
</footer>
</body>
</html>
