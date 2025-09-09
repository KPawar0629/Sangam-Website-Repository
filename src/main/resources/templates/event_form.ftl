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
    <main class="container mt-3 flex-grow-1">
        <form action="/events" method="post">
            <div class="container mt-3">
                <div class="row mt-4">
                    <div class="col-sm-10 justify-content-start">
                        <h2>${event.eventId?has_content?then('Edit Event', 'Create New Event')}</h2>
                    </div>
                    <div class="col-sm-2 text-end">
                        <button type="submit" class="btn btn-success">${event.eventId?has_content?then('Update', 'Save')}</button>
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
                    </div>
                    <#if event.eventId?? && event.eventType?? && (event.eventType != "paid")>
                        <br>
                        <br>
                        <h3>RSVP</h3>
                        <div class="mb-3">
                            <label class="form-label">RSVP Allowed?</label>
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
                            <div id="rsvpCountDiv" class="mt-3 ${(event.rsvpYes?? && event.rsvpYes == 'yes')?then('', 'd-none')}">
                                <label for="rsvpCount" class="form-label">Maximum RSVP Count:</label>
                                <input type="number" class="form-control" id="rsvpCount" name="rsvpCount" value="${event.rsvpCount!0}" min="0">
                                
                                <div class="mt-3">
                                    <label for="rsvpStart" class="form-label">RSVP Start Date:</label>
                                    <input id="rsvpStart" type="date" name="rsvpStart" value="${(event.rsvpStartDate)!}" class="form-control">
                                    <label for="rsvpEnd" class="form-label">RSVP End Date:</label>
                                    <input id="rsvpEnd" type="date" name="rsvpEnd" value="${(event.rsvpEndDate)!}" class="form-control">
                                </div>
                            </div>
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
                    <div class="row border-bottom-0">
                        <div class="col-sm-10"><h3>Pricing Details</h3></div>
                        <div class="col-sm-2 text-end">
                            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addPricing">+ Add Pricing</button>
                        </div>
                    </div>
                    <table class="table mt-4 table-striped">
                        <thead>
                        <tr>
                            <th>Ticket Type</th>
                            <th>Description</th>
                            <th>Start Date</th>
                            <th>End Date</th>
                            <th>Rate Per Ticket</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <#list eventPricings as pricing>
                            <tr>
                                <td>${pricing.pricingName}</td>
                                <td>${pricing.pricingDesc}</td>
                                <td>${pricing.startDate}</td>
                                <td>${pricing.endDate}</td>
                                <td>$${pricing.pricingRate}</td>
                                <td>
                                    <a href="#" class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#addPricing"
                                    data-id="${pricing.id}"
                                    data-tickettype = "${pricing.pricingName}"
                                    data-description = "${pricing.pricingDesc}"
                                    data-rate="${pricing.pricingRate}"
                                    data-startdate="${pricing.startDate}"
                                    data-enddate="${pricing.endDate}" title="Edit Pricing"><i class="fa-solid fa-pen"></i></a>
                                    <a href="/event_pricing/delete/${pricing.id}" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this pricing?')" title="Delete Pricing"><i class="fa-solid fa-trash"></i></a>
                                </td>
                            </tr>
                        </#list>
                        </tbody>
                    </table>
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
                                            <input id="startDate" type="datetime-local" name="startDate" value="${(pricing.startDate)!}" required>
                                        </div>
                                        <div class="mb-3">
                                            <label for="endDate">End Date:</label>
                                            <input id="endDate" type="datetime-local" name="endDate" value="${(pricing.endDate)!}" required>
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
        const form = document.getElementById('pricingForm');
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
    });

    function showHide(val) {
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
</script>
</body>
</html>

