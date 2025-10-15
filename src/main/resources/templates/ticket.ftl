<!doctype html>
<html lang="en">
<head>
    <style>
        .disclaimer-box {
      padding: 30px;
      border-radius: 10px;
      text-align: center;
      max-width: 600px;
      width: 100%;
    }

    .disclaimer-box h2,
    .disclaimer-box h3 {
      margin-top: 0;
      font-weight: bold;
      color: #333;
    }

    .disclaimer-box p {
      font-size: 16px;
      line-height: 1.6;
      margin-bottom: 15px;
      color: #444;
    }

    .disclaimer-box strong {
      color: #c0392b;
    }

    @media (max-width: 768px) {
      .disclaimer-box {
        padding: 20px;
      }

      .disclaimer-box p {
        font-size: 15px;
      }

      .disclaimer-box h2 {
        font-size: 20px;
      }

      .disclaimer-box h3 {
        font-size: 18px;
      }
    }

    @media (max-width: 480px) {
      .disclaimer-box {
        padding: 15px;
      }

      .disclaimer-box p {
        font-size: 14px;
      }

      .disclaimer-box h2,
      .disclaimer-box h3 {
        font-size: 17px;
      }
    }
    </style>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <#if event.eventType == "free">
        <title>Reserve Spot - Sangam</title>
    <#else>
        <title>Buy Tickets - Sangam</title>
    </#if>
    <link rel="icon" type="image/x-icon" href="/imgs/logo.jpg">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="https://kit.fontawesome.com/6e1d51a9e9.js" crossorigin="anonymous"></script>

</head>
<body>
<div class="d-flex flex-column min-vh-100">
    <#include "nav.ftl">
    <script src="https://www.google.com/recaptcha/api.js" async defer></script>
    <link href="/css/style.css" rel="stylesheet">
    <main class="container buy-ticket flex-grow-1">
        <div class="row justify-content-center">
            <div class="col-md-10 col-lg-8">
                <form class="row mt-5 buy-ticket" action="/add_ticket" method="post" autocomplete="off" id="registration_form">
                    <h4 class="text-center">
                        <#if event.eventType == "free" && event.rsvpYes == "yes">
                            Reserve a spot for ${event.eventName}
                        <#else>
                            Buy Tickets for ${event.eventName}
                        </#if>
                    </h4>
                    <h6 class="text-center mt-1"><i class="fa-solid fa-location-dot"></i> ${event.eventLocation}</h6>
                    <h6 class="text-center mt-1"><i class="fa-solid fa-calendar"></i> ${event.eventDateTimeLanding}</h6>

                    <#if (error)??>
                        <div id="error-message" class="alert alert-danger text-center" role="alert">
                            ${error}
                        </div>
                    </#if>

                    <input type="hidden" name="eventInput" value="${event.eventId}">

                    <div class="mt-5">
                        <input type="text" class="form-control" id="checkHidden" placeholder="John Smith" name="checkHidden" required hidden>
                        <div class="mb-3">
                            <label for="fullName" class="form-label">Full Name</label>
                            <input type="text" class="form-control" id="fullName" placeholder="John Smith" name="fullName" required>
                        </div>
                        <div class="mb-3">
                            <label for="email" class="form-label">Email Address</label>
                            <input type="email" class="form-control" id="email" placeholder="JohnSmith@gmail.com" name="email" required>
                        </div>
                        <div class="mb-3">
                            <label for="phone" class="form-label">Phone Number</label>
                            <input type="number" class="form-control" id="phone" placeholder="1234567890" name="phone" required minlength="10" maxlength="10">
                        </div>
                        <#if event.eventType == "free" && event.rsvpYes == "yes">
                            <div class="mb-3">
                                <label for="rsvpCount" class="form-label">Number of People</label>
                                <input type="number" class="form-control" id="rsvpCount" name="rsvpCount" min="1" max="6" required>
                                <small class="text-muted">Count of 12 years and old people</small>
                            </div>
                        <#else>
                            <div class="pricing-table mt-5">
                                <table class="table table-bordered bdr" id="pricingTable">
                                    <thead>
                                    <tr>
                                        <th>Pricing Option</th>
                                        <th>Price</th>
                                        <th>No. of Tickets</th>
                                        <th>Cost</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <#list eventPricings as pricing>
                                        <#if pricing.status == "Active">
                                            <tr>
                                                <td>${pricing.pricingName}<br>${pricing.pricingDesc}</td>
                                                <td>$${pricing.pricingRate}</td>
                                                <td><input type="number" step="1" name="pricing_${pricing.id}" class="pricing-input" min="0" max="6" required></td>
                                                <td>$0</td>
                                            </tr>
                                        </#if>
                                    </#list>
                                    </tbody>
                                </table>
                            </div>
                        </#if>

                        <#if event.eventType == "free" && event.rsvpYes == "yes">
                            <div class="text-end mt-4">
                                <span id="warningText" class="text-danger"></span>
                                <button type="submit" class="g-recaptcha btn btn-outline-success mt-3 text-end" data-sitekey="6LeRCEEqAAAAAEGAoUk5qDCUn-NL1tJ-nhN1xpWH" data-callback="onSubmit"><i class="fa-solid fa-stamp"></i> RSVP</button>
                                <div id="spinner" class="spinner-border text-primary" role="status" style="display: none;">
                                    <span class="sr-only"></span>
                                </div>
                            </div>
                        <#else>
                        <div class="text-end mt-4">
                        <span id="totalText" class="text-dark">Total: $0</span><br>
                        <span id="warningText" class="text-danger"></span>
                        <button type="submit" class="g-recaptcha btn btn-primary btn-submit mt-3 text-end" data-sitekey="6LeRCEEqAAAAAEGAoUk5qDCUn-NL1tJ-nhN1xpWH" data-callback="onSubmit">Book Tickets</button>
                        <div id="spinner" class="spinner-border text-primary" role="status" style="display: none;">
                            <span class="sr-only"></span>
                        </div>
                        </div>
                        </#if>
                </form>
            </div>
        </div>

        <!-- Nonprofit Information -->
        <div class="text-center mt-4 mb-4">
            <div class="alert alert-info d-inline-block" role="alert">
                <i class="fa-solid fa-heart text-primary"></i>
                <strong>SANGAM Santa Barbara Inc.</strong> is a <strong>501(c)(3) Non-Profit Organization.</strong><br>
                <small class="text-muted"> Your contributions support our community programs.</small>
            </div>
        </div>

        <#if !(event.eventType == "free" && event.rsvpYes == "yes")>
        <div class="disclaimer-box">
        <h2><strong>Disclaimer</strong></h2>
        <p>All Sales are FINAL.</p>
        <p>All tickets are NON-REFUNDABLE and NON-TRANSFERABLE.</p>
        <p>Early Bird Tickets payments must be completed before the offer ends.</p>

        <h3><strong>Liability Waiver</strong></h3>
        <p>
          By purchasing this ticket, you agree to attend the event at your own risk.
          The organizers, volunteers, and venue management shall not be held responsible for any injury, loss, theft,
          damage to personal property, or other incidents that may occur before, during, or after the event.
        </p>
        <p>
          Attendees are responsible for their own safety and belongings. Children must be supervised by a parent or guardian at all times.
        </p>
        <p><strong>By completing this purchase, you acknowledge and accept these terms.</strong></p>
      </div>
        </#if>
    </main>

    <footer class="bg-dark text-white text-center py-3 mt-auto">
        <p>2025 Sangam &copy;. All Rights reserved.</p>
    </footer>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('registration_form');
        const submitButton = form.querySelector('button[type="submit"]');
        const warningText = document.getElementById('warningText');

        function updateSubTotal() {
            const rsvpInput = document.getElementById('rsvpCount');

            // If this is an RSVP form
            if (rsvpInput) {
                const text = document.getElementById('totalText');
                text.textContent = 'Free Event - RSVP Only';
                return;
            }

            // If this is a paid ticket form
            const table = document.getElementById('pricingTable');
            const text = document.getElementById('totalText');
            let sumVal = 0;

            for (let i = 1; i < table.rows.length; i++) {
                const priceText = table.rows[i].cells[1].innerHTML;
                const price = parseFloat(priceText.replace(/[^0-9,-]+/g, ''));
                const numberTimesInput = table.rows[i].cells[2].querySelector('input');
                let numberTimes = parseInt(numberTimesInput.value, 10);

                if(isNaN(numberTimes) || numberTimes < 0) {
                    numberTimes = 0;
                }

                const rowTotal = price * numberTimes;

                table.rows[i].cells[3].innerHTML = "$" + rowTotal.toFixed(2);
                sumVal += rowTotal;
            }

            text.textContent = 'Total: $' + sumVal.toFixed(2);
        }

        function checkInputs() {
            const rsvpInput = document.getElementById('rsvpCount');
            const pricingInputs = document.querySelectorAll('#pricingTable .pricing-input');

            // If this is an RSVP form
            if (rsvpInput) {
                const rsvpCount = parseInt(rsvpInput.value, 10);
                if (isNaN(rsvpCount) || rsvpCount < 1) {
                    warningText.textContent = 'Please enter number of people for RSVP!';
                    return false;
                } else if (rsvpCount > 6) {
                    warningText.textContent = 'Maximum 6 people allowed per RSVP!';
                    return false;
                }
                warningText.textContent = '';
                return true;
            }

            // If this is a paid ticket form
            let hasValue = false;
            pricingInputs.forEach(input => {
                if (parseInt(input.value, 10) > 0) {
                    hasValue = true;
                }
            });

            if (hasValue) {
                warningText.textContent = '';
                return true;
            } else {
                warningText.textContent = 'Please choose at least one ticket to book!';
                return false;
            }
        }

        form.addEventListener('input', function() {
            updateSubTotal();
            checkInputs();
        });

        function validateEmail(email) {
            const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return emailPattern.test(email);
        }

        window.onSubmit = function() {
            if(!checkInputs()) {
                return false;
            }

            const hiddenCheck = document.getElementById('checkHidden');
            if(hiddenCheck.value.length > 0) {
                return false;
            }

            const nameField = document.getElementById('fullName');
            if(nameField.value.length == 0 || nameField.value.length > 25) {
                warningText.textContent = 'Invalid name!';
                return false;
            }

            const emailField = document.getElementById('email');
            if(!validateEmail(emailField.value)) {
                warningText.textContent = 'Invalid email address!';
                return false;
            }
            const phoneField = document.getElementById('phone');
            const isValid = phoneField.value.length == 10;
            if(!isValid) {
                warningText.textContent = 'Invalid phone number! Must be 10 digits long';
                return false;
            }

            submitButton.classList.add('d-none');
            document.getElementById("spinner").style.display = "inline-block";

            form.submit();
        }
        updateSubTotal();

    });

    document.getElementById('registration_form').addEventListener('submit', function(event) {

    });
</script>
</body>
</html>
