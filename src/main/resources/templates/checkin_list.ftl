<!DOCTYPE html>
<html lang="en">
<head>
    <title>Ticket Checkin - Sangam</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" type="image/x-icon" href="/imgs/logo.jpg">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <style>
        @media (max-width: 576px) {
            .table-responsive {
                overflow-x: auto;
            }
        }
    </style>
</head>
<body>
<div class="d-flex flex-column min-vh-100">
    <#include "nav.ftl">
    <link href="/css/style.css" rel="stylesheet" type="text/css"/>
    <main class="flex-grow-1">
        <div id="main-content">
            <div class="container mt-3">
                <div class="row mb-3">
                    <h3 class="col-12 col-lg-6">Check In Tickets</h3>
                    <div class="col-12 col-sm-6 col-lg-2">
                        <button id="toggleButton" class="btn btn-success">Show All</button>
                    </div>
                    <div class="col-12 col-sm-6 col-lg-2">
                        <select class="form-select" id="eventFilter" onchange="filterByEvent()">
                            <option value="">All Events</option>
                            <#list events as event>
                                <option value="${event.eventId}" <#if selectedEventId?? && selectedEventId == event.eventId>selected</#if>>
                                    ${event.eventName}
                                </option>
                            </#list>
                        </select>
                    </div>
                    <div class="col-12 col-lg-2">
                        <div class="input-group mb-3">
                            <span class="input-group-text" id="basic-addon1">&#128270</span>
                            <input class="form-control" type="text" id="searchInput" onkeyup="searchFunction()" placeholder="Search names...">
                        </div>
                    </div>
                </div>

                <form action="/confirmCheckIn" method="post" id="checkInForm">
                    <div>
                        <div class="row d-flex align-items-end">
                            <button type="submit" class="btn btn-primary mb-3">Check In Selected</button>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-striped table-bordered" id="myTable">
                                <thead>
                                <tr>
                                    <th>Check In</th>
                                    <th>Name</th>
                                    <th>Ticket Code</th>
                                    <th>Ticket Type</th>
                                    <th class="hide-on-md">Event</th>
                                    <th class="hide-on-md">CheckIn By</th>
                                </tr>
                                </thead>
                                <tbody>
                                <#list details as detail>
                                    <#if detail.paidStatus == 0>
                                        <tr class="toggle-row d-none">
                                            <td><button type="button" class="btn btn-danger" disabled>&dollar;</button></td>
                                            <td>${detail.fullName}</td>
                                            <td>${detail.getUniqueCode()}</td>
                                            <td>${detail.pricingOptionName}</td>
                                            <td class="hide-on-md">
                                                <#if detail.eventId?? && eventsMap[detail.eventId]??>
                                                    ${eventsMap[detail.eventId].eventName}
                                                <#else>
                                                    N/A
                                                </#if>
                                            </td>
                                            <td class="hide-on-md"></td>
                                        </tr>
                                    <#elseif detail.checkedIn == 1>
                                        <tr class="toggle-row d-none">
                                            <td><button type="button" class="btn btn-success" disabled>&check;</button></td>
                                            <td>${detail.fullName}</td>
                                            <td>${detail.getUniqueCode()}</td>
                                            <td>${detail.pricingOptionName}</td>
                                            <td class="hide-on-md">
                                                <#if detail.eventId?? && eventsMap[detail.eventId]??>
                                                    ${eventsMap[detail.eventId].eventName}
                                                <#else>
                                                    N/A
                                                </#if>
                                            </td>
                                            <#if detail.checkedInBy?? && users[detail.checkedInBy]??>
                                            <td class="hide-on-md">${users[detail.checkedInBy].fullName}</td>
                                            <#else>
                                            <td class="hide-on-md"></td>
                                            </#if>
                                        </tr>
                                    <#else>
                                        <tr>
                                            <td>
                                                <div>
                                                    <input type="checkbox" name="ticketIds" value="${detail.detailId}" class="btn-check" id="check_${detail.detailId}" autocomplete="off">
                                                    <label for="check_${detail.detailId}" class="btn btn-outline-primary">&#9678;</label>
                                                </div>
                                            </td>
                                            <td>${detail.fullName}</td>
                                            <td>${detail.getUniqueCode()}</td>
                                            <td>${detail.pricingOptionName}</td>
                                            <td class="hide-on-md">
                                                <#if detail.eventId?? && eventsMap[detail.eventId]??>
                                                    ${eventsMap[detail.eventId].eventName}
                                                <#else>
                                                    N/A
                                                </#if>
                                            </td>
                                            <#if detail.checkedInBy?? && users[detail.checkedInBy]??>
                                            <td class="hide-on-md">${users[detail.checkedInBy].fullName}</td>
                                            <#else>
                                            <td class="hide-on-md"></td>
                                            </#if>
                                        </tr>
                                    </#if>
                                </#list>
                                    </tbody>
                                </table>

                            </div>
                        </div>
                    </div>
                </form>

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
    function searchFunction() {
        // Declare variables
        var input, filter, table, tr, td, i, txtValue;
        input = document.getElementById("searchInput");
        filter = input.value.toUpperCase();
        table = document.getElementById("myTable");
        tr = table.getElementsByTagName("tr");

        // Loop through all table rows, and hide those who don't match the search query
        for (i = 0; i < tr.length; i++) {
            // Search in name (column 1), ticket code (column 2), ticket type (column 3), and event (column 4)
            var nameCol = tr[i].getElementsByTagName("td")[1];
            var codeCol = tr[i].getElementsByTagName("td")[2];
            var typeCol = tr[i].getElementsByTagName("td")[3];
            var eventCol = tr[i].getElementsByTagName("td")[4];
            
            if (nameCol || codeCol || typeCol || eventCol) {
                var nameValue = nameCol ? (nameCol.textContent || nameCol.innerText) : "";
                var codeValue = codeCol ? (codeCol.textContent || codeCol.innerText) : "";
                var typeValue = typeCol ? (typeCol.textContent || typeCol.innerText) : "";
                var eventValue = eventCol ? (eventCol.textContent || eventCol.innerText) : "";
                
                var allText = (nameValue + " " + codeValue + " " + typeValue + " " + eventValue).toUpperCase();
                
                if (allText.indexOf(filter) > -1) {
                    tr[i].style.display = "";
                } else {
                    tr[i].style.display = "none";
                }
            }
        }
    }

    document.getElementById('toggleButton').addEventListener('click', function() {
        const button = document.getElementById('toggleButton');
        console.log('clicked');
        const rows = document.querySelectorAll('.toggle-row');
        rows.forEach(row => {
            if(row.classList.contains('d-none')){
                row.classList.remove('d-none');
                button.textContent = 'Pending Check-Ins';
            } else {
                row.classList.add('d-none');
                button.textContent = 'Show All';
            }
        });
    });
    
    const myModal = new bootstrap.Modal('#messageModal');
    
    const checkboxes = document.querySelectorAll('#checkInForm input[type="checkbox"]');
    const submitButton = document.getElementById('checkInForm').querySelector('button[type="submit"]');

    function checkForCheckedBoxes() {
        const atLeastOneChecked = Array.from(checkboxes).some(checkbox => checkbox.checked);
        submitButton.disabled = !atLeastOneChecked;
    }

    checkForCheckedBoxes();

    checkboxes.forEach(checkbox => {
        checkbox.addEventListener('change', checkForCheckedBoxes);
    });

    window.addEventListener('DOMContentLoaded', () => {
        myModal.show();
    });

    function filterByEvent() {
        const selectedEventId = document.getElementById('eventFilter').value;
        const currentUrl = new URL(window.location);
        
        if (selectedEventId) {
            currentUrl.searchParams.set('eventId', selectedEventId);
        } else {
            currentUrl.searchParams.delete('eventId');
        }
        
        window.location.href = currentUrl.toString();
    }

    
</script>
</body>
</html>