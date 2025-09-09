<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Performance Signup - Sangam</title>
    <link rel="icon" type="image/x-icon" href="/imgs/logo.jpg">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <script src="https://www.google.com/recaptcha/api.js" async defer></script>
    
</head>
<body>
<div class="d-flex flex-column min-vh-100">
    <#include "nav.ftl">
    <link href="/css/style.css" rel="stylesheet">
    <main class="container flex-grow-1">
    <div class="container">
    <#if event.eventId??>
    <form action="/performance/new/${event.eventId}" method="post" class="mb-5" id="performance-form">
        <input type="text" class="form-control" id="checkHidden" placeholder="John Smith" name="checkHidden" hidden>
        <div class="row">
            <div class="col-md-8">
                <h3 class="mt-4">Participate in ${event.eventName}</h3>
            </div>
            <div class="col-md-4 text-end mt-3">
                <button type="submit" class="g-recaptcha btn btn-primary btn-submit mt-3 text-end" data-sitekey="6LeRCEEqAAAAAEGAoUk5qDCUn-NL1tJ-nhN1xpWH" data-callback="onSubmit" id="submitButton">Submit</button>
            </div>
        </div>
        
        <div class="row">
            <div class="col-md-6">
                <label for="name" class="form-label">Performer Full Name</label>
                <input id="name" class="form-control" name="name" type="text" required maxlength="30">
            </div>
            <div class="col-md-6">
                <label for="type" class="form-label">Type of Performance</label>
                <select id="type" name="type" required class="form-select">
                    <option value="" selected>-- Please Choose an Option --</option>
                    <option value="Dance">Dance</option>
                    <option value="Singing">Singing</option>
                    <option value="Skit">Skit</option>
                    <option value="Other">Other</option>
                </select>
            </div>
        </div> 
        <div class="row">
            <div class="col-md-6">
                <label for="category" class="form-label">Category</label>
                <select id="category" name="category" required class="form-select">
                    <option value="" selected>-- Please Choose an Option --</option>
                    <option value="Group">Group</option>
                    <option value="Solo">Solo</option>
                </select>
            </div>
            <div class="col-md-6">
                <label for="groupName" class="form-label">Name of the Group</label>
                <input id="groupName" class="form-control" name="groupName" type="text" maxlength="30">
            </div>
        </div> 
        <div class="row">
            <div class="col-md-6">
                <label for="ageGroup" class="form-label">Age Group</label>
                <select id="ageGroup" name="ageGroup" required class="form-select">
                    <option value="" selected>-- Please Choose an Option --</option>
                    <option value="Kids">Kids</option>
                    <option value="Teens">Teens</option>
                    <option value="Adults">Adults</option>
                </select>
            </div>
            <div class="col-md-6">
                <label for="contactName" class="form-label">Contact Person Name</label>
                <input id="contactName" class="form-control" name="contactName" type="text" required maxlength="30">
            </div>
        </div>
        <div class="row">
            <div class="col-md-6">
                <label for="contactEmail" class="form-label">Contact Person Email</label>
                <input id="contactEmail" class="form-control" name="contactEmail" type="email" required maxlength="30">
            </div>
            <div class="col-md-6">
                <label for="contactPhone" class="form-label">Contact Phone Number</label>
                <input id="contactPhone" class="form-control" name="contactPhone" type="tel" minlength="10" maxlength="10" placeholder="Format: 1234567890" required>
            </div>
        </div>
        <div class="row">
            <div class="col-md-6">
                <label for="mics" class="form-label">Number of Mics Needed</label>
                <input type="number" step="1" name="mics" class="form-control" min="0" max="4" value="0" id="mics" required>
            </div>
            <div class="col-md-6">
                <label for="chairs" class="form-label">Number of Chairs Needed</label>
                <input type="number" step="1" name="chairs" class="form-control" min="0" max="6" value="0" id="chairs" required>
            </div>
        </div>
        <div class="row">
            <div class="col-md-6 mt-3 mb-3">
                <label class="form-label">Background Music Needed?</label>
                <input type="radio" class="btn-check form-control" name="bgMusic" autocomplete="off" value="no" id="noMusic" checked>
                <label class="btn" for="noMusic">No</label>
                <input type="radio" class="btn-check form-control" name="bgMusic" autocomplete="off" value="yes" id="yesMusic">
                <label class="btn" for="yesMusic">Yes</label>
            </div>
            <div class="col-md-6">
                <label for="comments" class="form-label">Any Other Comments?</label>
                <input id="comments" class="form-control" name="comments" type="text">
            </div>
        </div>
        </form>
        <hr>
        <div class="text-center mt-3 text-danger">
        **Disclaimer**<br>
        Due to the high volume of participation requests, please limit your performance to 3 minutes.<br>
        Skit performances are allowed up to 4 minutes.<br>
        Additionally, we are unable to accommodate performances that require large setups.<br>
        To avoid repeated songs in the event, we would like you to send list of songs ASAP so we can allow or request you to consider another one if it is already selected by someone. Songs will be assigned on First Come First Serve basis.
        </div>
    </#if>
</div>
    </main>
    <footer class="bg-dark text-white text-center py-3 mt-auto">
        <p>2025 Sangam &copy;. All Rights reserved.</p>
    </footer>
</div>
<script>
function onSubmit() {
    var submitButton = document.getElementById('submitButton');
    var form = document.getElementById('performance-form');
    form.submit();
    submitButton.disabled = true;

    return true;
}
</script>
</body>
</html>