<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Buy Tickets - Sangam</title>
    <link rel="icon" type="image/x-icon" href="/imgs/logo.jpg">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="https://kit.fontawesome.com/6e1d51a9e9.js" crossorigin="anonymous"></script>
    
</head>
<body>
<#include "nav.ftl">
<link href="/css/style.css" rel="stylesheet">
<div class="container buy-ticket">
    <div class="row justify-content-center">
        <div class="col-md-10 col-lg-8">
            <form class="row mt-5 buy-ticket" action="/competition/new" method="post" autocomplete="off" id="registration_form">
                <h6 class="text-center">${event.eventName}</h6>
                <h4 class="text-center">Best Traditional Dress Competition</h4><br><br>
                <h4 class="text-center">Oct 26th, 2024 <strong>Time: 3:30-4:15 PM</strong></h4>

                <#if (error)??>
                    <div id="error-message" class="alert alert-danger text-center" role="alert">
                        ${error}
                    </div>
                </#if>

                <input type="hidden" name="eventInput" value="${event.eventId}">

                <div class="mt-5">
                    <input type="text" class="form-control" id="checkHidden" placeholder="John Smith" name="checkHidden" hidden>
                    <div class="mb-3">
                        <label for="categoryType" class="form-label">Category:</label>
                        <select class="form-control" id="categoryType" name="categoryType">
                            <option selected>Select Category Type</option>
                            <option value="Adult - Male">Adult Male</option>
                            <option value="Adult - Female">Adult Female</option>
                            <option value="Teen - Boys">Teen Boys (13-19 Yrs)</option>
                            <option value="Teen - Girls">Teen Girls (13-19 Yrs)</option>
                            <option value="Kids - Boys">Kids Boys (5-12 Yrs)</option>
                            <option value="Kids - Girls">Kids Girls (5-12 Yrs)</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="ticketCode" class="form-label">Ticket Code:</label>
                        <input type="text" class="form-control" id="ticketCode" placeholder="123456" name="ticketCode" required>
                    </div>
                    <div class="mb-3">
                        <label for="fullName" class="form-label">Full Name:</label>
                        <input type="text" class="form-control" id="fullName" placeholder="John Smith" name="fullName" required>
                    </div>
                    <div class="mb-3" style="display: none;" id="parentNameContainer">
                        <label for="parentName" class="form-label">Parent Name:</label>
                        <input type="text" class="form-control" id="parentName" placeholder="John Smith" name="parentName">
                    </div>
                    <div class="mb-3">
                        <label for="phone" class="form-label">Phone Number:</label>
                        <input type="number" class="form-control" id="phone" placeholder="1234567890" name="phone" required minlength="10" maxlength="10">
                    </div>
                    

                    <div class="text-end mt-4">
                        <span id="warningText" class="text-danger"></span>
                        <button type="submit" class="btn btn-primary btn-submit mt-3 text-end">Register</button>
                        <div id="spinner" class="spinner-border text-primary" role="status" style="display: none;">
                            <span class="sr-only"></span>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <div class="text-center mt-5 text-secondary h5">
    <p>Evaluation based on Traditional Attire and Accessories.<br>
    Please checkin to the event by 3:30 PM in order to be eligible for the competition.<br>
    Because of time constraint, we will not be able to do evaluation after above time.</p>
    </div>
</div>

<footer class="bg-dark text-white text-center py-3">
    <p>${.now?string('yyyy')} Sangam &copy;. All Rights reserved.</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {

        const categoryDropdown = document.getElementById('categoryType');
        const parentNameContainer = document.getElementById('parentNameContainer');
        const form = document.getElementById('registration_form');
        const warningText = document.getElementById('warningText');
        const submitButton = document.querySelector('.btn-submit');
        const spinner = document.getElementById("spinner");

        categoryDropdown.addEventListener('change', function() {
            const selectedValue = categoryDropdown.value;
            if (selectedValue.startsWith('Teen') || selectedValue.startsWith('Kids')) {
                parentNameContainer.style.display = 'block';
            } else {
                parentNameContainer.style.display = 'none';
            }
        });

        const ticketCodes = [<#list ticketDetails as ticketDetail>"${ticketDetail}"<#if ticketDetail_has_next>,</#if></#list>];
        const already = [<#list already as al>"${al}"<#if al_has_next>,</#if></#list>];

        form.addEventListener('submit', function(event) {
            event.preventDefault(); // Prevent form submission to allow validation

            if(categoryDropdown.value == "Select Category Type") {
                warningText.textContent = 'Please select a valid category type!';
                return false;
            }

            const hiddenCheck = document.getElementById('checkHidden');
            if (hiddenCheck.value.length > 0) {
                return false;
            }

            const ticketCode = document.getElementById('ticketCode');

             if (!ticketCodes.includes(ticketCode.value)) {
                warningText.textContent = 'Ticket code does not exist! Check your email!';
                return false;
            }

            if (already.includes(ticketCode.value)) {
                warningText.textContent = 'Ticket code already used!';
                return false;
            }

            const nameField = document.getElementById('fullName');
            if (nameField.value.length === 0 || nameField.value.length > 25) {
                warningText.textContent = 'Invalid name!';
                return false;
            }

            const parentNameField = document.getElementById('parentName');
            if (parentNameContainer.style.display == 'block' && parentNameField.value.length < 1) {
                warningText.textContent = 'Parent name cannot be empty!';
                return false;
            }

            const phoneField = document.getElementById('phone');
            const isValid = phoneField.value.length === 10;
            if (!isValid) {
                warningText.textContent = 'Invalid phone number! Must be 10 digits long';
                return false;
            }

            submitButton.classList.add('d-none');
            spinner.style.display = "inline-block";

            form.submit(); // Now submit the form
        });

    });
</script>
</body>
</html>
