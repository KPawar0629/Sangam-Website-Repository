<!DOCTYPE html>
<html lang="en">
<head>
    <title>Receive Payments - Sangam</title>
    <link rel="icon" type="image/x-icon" href="/imgs/logo.jpg">

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <link href="/css/others.css" rel="stylesheet" type="text/css"/>
    <script src="https://kit.fontawesome.com/6e1d51a9e9.js" crossorigin="anonymous"></script>

    <style>
        /* Custom styles for responsiveness */
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
    <link rel="stylesheet" href="/css/style.css">

    <main class="flex-grow-1">
        <div class="container mt-3">
            <div class="row mb-3">
                <h3 class="col-12 col-md-7">Receive Payments</h3>
                <div class="col-12 col-md-2">
                <button id="toggleButton" class="btn btn-success">Show All</button>
                </div>
                <div class="col-12 col-md-3">
                    <div class="input-group mb-3">
                        <span class="input-group-text" id="basic-addon1">&#128270</span>
                        <input class="form-control" type="text" id="searchInput" onkeyup="searchFunction()" placeholder="Enter search text here...">
                    </div>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table table-striped table-bordered" id="myTable">
                    <thead>
                    <tr>
                        <th>Payment Status</th>
                        <th class="hide-on-md">Name</th>
                        <th class="hide-on-md">Email</th>
                        <th class="hide-on-md">No. of Tickets</th>
                        <th class="hide-on-md">Total Cost</th>
                        <th class="hide-on-md">Received By</th>
                        <th class="hide-on-md">Received On</th>
                        <th class="hide-on-md">Phone Number</th>
                        <th class="show-on-phone">Info</th>
                        <th class="show-on-phone">#Tickets/$Cost</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#list ticketers as master>
                        <#if master.paymentReceived == 0>
                            <tr>
                        <#else>
                            <tr class="toggle-row d-none">
                        </#if>
                            <#if master.paymentReceived == 0>
                                <td><a href="/payment/${master.ticketMasterId}" class="btn btn-primary" onclick="return confirm('Have you received payment from ${master.fullName} for Ticket ${master.ticketMasterId}?')" title="Receive Payment">&dollar;</a></td>
                            <#else>
                                <td><button type="button" class="btn btn-success" disabled title="Payment Received!">&check;</button></td>
                            </#if>
                            <td class="hide-on-md">${master.fullName}</td>
                            <td class="hide-on-md">${master.email}</td>
                            <td class="hide-on-md">${master.totalTickets}</td>
                            <td class="hide-on-md">$${master.totalAmount}</td>
                            
                            <#if master.paymentReceivedBy?? && users[master.paymentReceivedBy]??>
                                <td class="hide-on-md">${users[master.paymentReceivedBy].fullName}</td>
                                <td class="hide-on-md">${master.paymentReceivedAt}</td>
                            <#else>
                                <td class="hide-on-md"></td>
                                <td class="hide-on-md"></td>
                            </#if>

                            <td class="hide-on-md">${master.phoneNumber}</td>
                            <td class="show-on-phone"><a class="btn btn-primary" onclick="return confirm('Phone Number: ${master.phoneNumber}\n')">${master.fullName}</a><br>${master.email}</td>
                            <td class="show-on-phone"># ${master.totalTickets}<br>$ ${master.totalAmount}</td>

                            <td>
                                <#if master.paymentReceived == 1>
                                    <a href="/tickets/undo/${master.ticketMasterId}" type="button" class="btn btn-warning" onclick="return confirm('Do you really want to undo this payment receipt?')" title="Undo Payment Receipt"><i class="fa-solid fa-rotate-left"></i></a>
                                <#else>
                                    <a href="/tickets/delete/${master.ticketMasterId}" type="button" class="btn btn-danger" onclick="return confirm('Do you really want to delete this ticket?')" title="Delete Ticket"><i class="fa-solid fa-trash"></i></a>
                                </#if>
                            </td>
                        </tr>
                    </#list>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

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
        for (i = 1; i < tr.length; i++) {  // Skip header row
            td = tr[i].getElementsByTagName("td")[1];
            if (td) {
                txtValue = td.textContent || td.innerText;
                if (txtValue.toUpperCase().indexOf(filter) > -1) {
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
                button.textContent = 'Show Pending Only';
            } else {
                row.classList.add('d-none');
                button.textContent = 'Show All';
            }
        });
    });
</script>
</body>
</html>
