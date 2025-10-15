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

</head>
<body>
<div class="d-flex flex-column min-vh-100">
    <#include "nav.ftl">
    <link href="/css/style.css" rel="stylesheet" type="text/css"/>

    <main class="content flex-grow-1">
        <div class="container mt-3">
            <div class="row mt-4">
                <div class="col-sm-8">
                    <h2>Events</h2>
                </div>
                <div class="col-sm-4 text-end">
                    <#if loggedInUser?? && loggedInUser.role == "admin">
                        <a type="button" class="btn btn-success" href="/events/new">+ Add Event</a>
                    </#if>
                </div>
            </div>
            <table class="table mt-5 table-striped">
                <thead>
                <tr>
                    <th>Event Name</th>
                    <th class="d-none d-md-table-cell">Description</th>
                    <th>Date</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <#list events as event>
                    <tr>
                        <#if loggedInUser?? && loggedInUser.role == "admin">
                            <td><a href="/events/edit/${event.eventId}"  title="Edit Event">${event.eventName}</a></td>
                        <#else>
                            <td>${event.eventName}</td>
                        </#if>
                        <td class="d-none d-md-table-cell">
                            <#if (event.eventDescription?length > 40)>
                                ${event.eventDescription?substring(0, 40)}...
                            <#else>
                                ${event.eventDescription}
                            </#if>
                        </td>
                        <td>${event.eventDateTime}</td>
                        <td>${event.status}</td>
                        <td>
                            <#if event.published == 0>
                                <#if loggedInUser?? && loggedInUser.role == "admin">
                                    <#if event.status == "Draft">
                                        <a href="/events/publish/${event.eventId}" type="button" class="btn btn-warning" onclick="return confirm('Are you ready to make ${event.eventName} open for tickets?')" title="Publish Event"><i class="fa-solid fa-paper-plane"></i></a>
                                        <a href="/events/delete/${event.getEventId()}" type="button" class="btn btn-danger" onclick="return confirm('Do you really want to delete this event?')" title="Delete Event"><i class="fa-solid fa-trash"></i></a>
                                    <#else>
                                        <a href="/events/delete/${event.getEventId()}" type="button" class="btn btn-danger" onclick="return confirm('Do you really want to delete this event?')" title="Delete Event"><i class="fa-solid fa-trash"></i></a>
                                    </#if>
                                </#if>
                            <#else>
                                <#if loggedInUser?? && loggedInUser.role == "admin">
                                    <#if event.status == "active" || event.status == "Active">
                                        <a href="/participant_list?eventId=${event.eventId}" type="button" class="btn btn-secondary" title="Participants List"><i class="fa-solid fa-hand"></i></a>                                    <!-- Unpublish and Payment Reminder buttons moved to edit page -->
                                        <a href="/payment_list/${event.eventId}" type="button" class="btn btn-danger" title="Check Payment" ><i class="fa-solid fa-dollar"></i> <i class="fa-solid fa-check"></i></a>
                                        <a href="/checkin?eventId=${event.eventId}" type="button" class="btn btn-warning" title="Checkin"><i class="fa-solid fa-check"></i></a>
                                        <a href="/event/stats/${event.eventId}" type="button" class="btn btn-success" title="Event Stats"><i class="fa-solid fa-chart-simple"></i></a>
                                    <#else>
                                        <!-- Only show stats for non-active events -->
                                        <a href="/event/stats/${event.eventId}" type="button" class="btn btn-success" title="Event Stats"><i class="fa-solid fa-chart-simple"></i></a>
                                    </#if>
                                <#else>
                                    <#if event.status == "active" || event.status == "Active">
                                        <a href="/checkin?eventId=${event.eventId}" type="button" class="btn btn-secondary" title="Checkin"><i class="fa-solid fa-check"></i></a>
                                        <a href="/participant_list?eventId=${event.eventId}" type="button" class="btn btn-secondary" title="Participants List"><i class="fa-solid fa-hand"></i></a>
                                    </#if>
                                </#if>
                            </#if>
                        </td>
                    </tr>
                </#list>
                </tbody>
            </table>
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
</script>
</body>
</html>