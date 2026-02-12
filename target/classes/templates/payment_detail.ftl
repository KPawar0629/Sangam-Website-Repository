<!DOCTYPE html>
<html lang="en">
<head>
    <title>Create Event - Sangam</title>
    <link rel="icon" type="image/x-icon" href="/imgs/logo.jpg">

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.12.9/dist/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>

</head>
<body>
<#include "nav.ftl">
<link href="./css/others.css" rel="stylesheet" type="text/css"/>

<div class="container mt-3 mb-3">
    <div class="row">
        <h4 class="col-sm-6">Ticket:</h4>
        <h4 class="col-sm-6">${master.ticketMasterId}</h4>
    </div>
    <div class="row">
        <h4 class="col-sm-6">Full Name:</h4>
        <h4 class="col-sm-6">${master.fullName}</h4>
    </div>
    <div class="row">
        <h4 class="col-sm-6">Total Amount:</h4>
        <h4 class="col-sm-6">${master.totalAmount}</h4>
    </div>
    <table>
        <tr>
            <th>Pricing Name</th>
            <th>Amount</th>
        </tr>
        <#list details as detail>
            <tr>
                <td>${detail.pricingOptionName}</td>
                <td>${detail.amount}</td>
            </tr>
        </#list>
    </table>






</div>

</body>
</html>

