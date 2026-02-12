<!DOCTYPE html>
<html lang="en">
<head>
    <title>Participants List - Sangam</title>
    <link rel="icon" type="image/x-icon" href="/imgs/logo.jpg">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <script src="https://kit.fontawesome.com/6e1d51a9e9.js" crossorigin="anonymous"></script>


</head>
<body>
<#include "nav.ftl">
<link href="./css/style.css" rel="stylesheet" type="text/css"/>

<div class="container mt-3">
    <div class="row mt-2">
        <div class="col-sm-10 text-center">
            <h2>All Participants</h2>
        </div>
        <div class="col-sm-2">
            <a href="participation/details/send" type="button" class="btn btn-primary" onclick="return confirm('Are you sure you want to send participation details to everyone?')">Send Participation Details</a>
        </div>
    </div>
    <table class="table mt-3">
        <thead>
        <tr>
            <th>Participant Name/Order</th>
            <th>Type of Performance</th>
            <th>Category</th>
            <th class="hide-on-md">Group Name</th>
            <#if loggedInUser.role == "admin">
            <th class="hide-on-md">Age Group</th>
            </#if>
            <th class="hide-on-md">Contact Name</th>
            <th>Check In</th>
            <#if loggedInUser.role == "admin">
            <th class="hide-on-md">Contact Email</th>
            <th class="hide-on-md">Contact Phone</th>
            <th class="hide-on-md">Notes?</th>
            <th class="hide-on-md">Background></th>
            <th class="hide-on-md">No. Of Mics</th>
            <th class="hide-on-md">No. Of Chairs</th>
            <th>Actions</th>
            </#if>
        </tr>
        </thead>
        <tbody>
        <#list participants as participant>
            <tr>
                <td>${participant.participatorName}<br>${participant.orderNumber}</td>
                <td>${participant.typeOfPerformance}</td>
                <td>${participant.whoWillPerform}</td>
                <td class="hide-on-md">${participant.nameOfGroup}</td>
                <#if loggedInUser.role == "admin">
                <td class="hide-on-md">${participant.ageGroup}</td>
                </#if>
                <td class="hide-on-md">${participant.contactPerName}</td>
                <td>
                <#if participant.checkedIn == 0>
                    <a href="/participation/checkin/${participant.participationId}" class="btn btn-primary"><i class="fa-solid fa-list-check"></i></a>
                <#else>
                    <a href="/participation/checkin/${participant.participationId}" class="btn btn-success"><i class="fa-solid fa-check"></i></a>
                </#if>
                </td>
                <#if loggedInUser.role == "admin">
                    <td class="hide-on-md">${participant.contactEmail}</td>
                    <td class="hide-on-md">${participant.contactPhone}</td>
                    <td class="hide-on-md">${participant.notes}</td>
                    <#if participant.bgNeeded == 0>
                    <td class="hide-on-md">No</td>
                    <#else>
                    <td class="hide-on-md">Yes</td>
                    </#if>
                    <td class="hide-on-md">${participant.noOfMics}</td>
                    <td class="hide-on-md">${participant.noOfChairs}</td>
                    <td><a href="/participation/delete/${participant.participationId}" type="button" class="btn btn-danger" onclick="return confirm('Do you really want to delete this participation entry?')" title="Delete Entry"><i class="fa-solid fa-trash"></i></a>
                    <a href="#" class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#updateParti"
                            data-id="${participant.participationId}"
                            data-partiName="${participant.participatorName}"
                            data-contactName = "${participant.contactPerName}"
                            data-type= "${participant.typeOfPerformance}"
                            data-who= "${participant.whoWillPerform}"
                            data-groupName= "${participant.nameOfGroup}"
                            data-ageGroup= "${participant.ageGroup}"
                            data-contactEmail = "${participant.contactEmail}"
                            data-contactPhone="${participant.contactPhone}"
                            data-notes= "${participant.notes}"
                            data-chairs= "${participant.noOfChairs}"
                            data-mics= "${participant.noOfMics}"
                            data-order="${participant.orderNumber}"
                            title="Edit Participant"><i class="fa-solid fa-pen"></i></a>
                    </td>
                </#if>
            </tr>
        </#list>
        </tbody>
    </table>
    <div class="modal fade" id="updateParti">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title">Update Participation Details</h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="/participation/edit" method="post" id="userForm">
                        <input type="hidden" name="partiCode" />
                        <div class="mb-3">
                            <label for="partiName">Participator Name:</label>
                            <input type="text" class="form-control" id="partiName" name="partiName">
                        </div>
                        <div class="mb-3">
                            <label for="type">Type of Performance:</label>
                            <input type="text" class="form-control" id="type" name="type">
                        </div>
                        <div class="mb-3">
                            <label for="who" class="d-block">Who Will Perform:</label>
                            <input id="who" type="text" name="who" class="form-control">
                        </div>
                        <div class="mb-3">
                            <label for="group" class="d-block">Name of Group:</label>
                            <input id="group" type="text" name="group" class="form-control">
                        </div>
                        <div class="mb-3">
                            <label for="age" class="d-block">Age Group:</label>
                            <input id="age" type="text" name="age" class="form-control">
                        </div>
                        <div class="mb-3">
                            <label for="contactName" class="d-block">Contact Person Name:</label>
                            <input id="contactName" type="text" name="contactName" class="form-control">
                        </div>
                        <div class="mb-3">
                            <label for="contactEmail" class="d-block">Contact Email:</label>
                            <input id="contactEmail" type="text" name="contactEmail" class="form-control">
                        </div>
                        <div class="mb-3">
                            <label for="contactPhone" class="d-block">Contact Phone:</label>
                            <input id="contactPhone" type="tel" name="contactPhone" class="form-control">
                        </div>
                        <div class="mb-3">
                            <label for="notes" class="d-block">Notes:</label>
                            <input id="notes" type="text" name="notes" class="form-control">
                        </div>
                        <div class="mb-3">
                            <label for="mics" class="d-block">No. of Mics:</label>
                            <input id="mics" type="number" name="mics" class="form-control">
                        </div>
                        <div class="mb-3">
                            <label for="chairs" class="d-block">No. of Chairs:</label>
                            <input id="chairs" type="number" name="chairs" class="form-control">
                        </div>
                        <div class="mb-3">
                            <label for="order" class="d-block">Order:</label>
                            <input id="order" type="number" name="order" class="form-control">
                        </div>

                        <button type="submit" class="btn btn-success" id="addButton">Save</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<footer class="bg-dark text-white text-center py-3">
    <p>${.now?string('yyyy')} Sangam &copy;. All Rights reserved.</p>
</footer>

<script>
    let userUpdateModal = document.getElementById('updateParti');
    userUpdateModal.addEventListener('show.bs.modal', function (event) {
        // Button that triggered the modal
        let button = event.relatedTarget;

        // Extract data-* attributes from the button
        let id = button.getAttribute('data-id');
        let partiName = button.getAttribute('data-partiName');
        let contactName = button.getAttribute('data-contactName');
        let type = button.getAttribute('data-type');
        let who = button.getAttribute('data-who');
        let groupName = button.getAttribute('data-groupName');
        let ageGroup = button.getAttribute('data-ageGroup');
        let contactEmail = button.getAttribute('data-contactEmail');
        let contactPhone = button.getAttribute('data-contactPhone');
        let notes = button.getAttribute('data-notes');
        let chairs = button.getAttribute('data-chairs');
        let mics = button.getAttribute('data-mics');
        let order = button.getAttribute('data-order');

        // Use the above data to populate the form fields in the modal
        let partiNameInput = userUpdateModal.querySelector('#partiName');
        let contactNameInput = userUpdateModal.querySelector('#contactName');
        let typeInput = userUpdateModal.querySelector('#type');
        let whoInput = userUpdateModal.querySelector('#who');
        let groupNameInput = userUpdateModal.querySelector('#group');
        let ageGroupInput = userUpdateModal.querySelector('#age');
        let contactEmailInput = userUpdateModal.querySelector('#contactEmail');
        let contactPhoneInput = userUpdateModal.querySelector('#contactPhone');
        let notesInput = userUpdateModal.querySelector('#notes');
        let chairsInput = userUpdateModal.querySelector('#chairs');
        let micsInput = userUpdateModal.querySelector('#mics');
        let orderInput = userUpdateModal.querySelector('#order');
        let hiddenIdInput = userUpdateModal.querySelector('input[name="partiCode"]');

        partiNameInput.value = partiName;
        contactNameInput.value = contactName;
        typeInput.value = type;
        whoInput.value = who;
        groupNameInput.value = groupName;
        ageGroupInput.value = ageGroup;
        contactEmailInput.value = contactEmail;
        contactPhoneInput.value = contactPhone;
        notesInput.value = notes;
        chairsInput.value = chairs;
        micsInput.value = mics;
        orderInput.value = order;
        hiddenIdInput.value = id;
    });
</script>
</body>
</html>

