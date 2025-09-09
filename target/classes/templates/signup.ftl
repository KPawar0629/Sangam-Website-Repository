<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Registration - Sangam</title>
    <link rel="icon" type="image/x-icon" href="/imgs/logo.jpg">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
</head>
<body>
<div class="d-flex flex-column min-vh-100">
    <#include "nav.ftl">
    <main class="flex-grow-1">
        <div class="registration-container">
            <link href="./css/style.css" rel="stylesheet" type="text/css"/>
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-md-8">
                        <form class="row signin-form signup-form mb-5" action="/signup" method="post" autocomplete="off" id="registration_form">
                            <h4 class="text-center mb-3">Register</h4>

                            <div class="col-md-6">
                                <label for="inputName" class="form-label">Full Name</label>
                                <input type="text" class="form-control" id="inputName" placeholder="ex: John Smith" name="name" value="${name!}" required><br>
                                <label for="inputEmail" class="form-label">Email Address</label>
                                <input type="email" class="form-control" id="inputEmail" aria-describedby="emailHelp" name="email" placeholder="ex: JohnSmith@gmail.com" value="${email!}" required><br>
                                <label for="inputPhone" class="form-label">Phone Number</label>
                                <input type='tel' name='phone' placeholder='1234567890' id="inputPhone" minlength="10" maxlength="10" class="form-control" value="${phone!}" required ><br>
                            </div>
                            <div class="col-md-1 d-flex align-items-center justify-content-center">
                                <div class="vertical-line"></div>
                            </div>
                            <div class="col-md-5">
                                <label for="inputPassword" class="form-label">Password</label>
                                <input type="password" class="form-control" id="inputPassword" name="password" placeholder="ex: JohnSmith@123" value="${password!}"><br>
                                <label for="inputConfirm" class="form-label">Confirm Password</label>
                                <input type="password" class="form-control" id="inputConfirm" placeholder="ex: JohnSmith@123" value="${password!}"><br>
                                <label for="inputSecCode" class="form-label">Input Sangam Security Code</label>
                                <input type="password" class="form-control" id="inputSecCode" name="code"><br>

                                <span id="warningText" class="text-danger mb-3"></span><br>
                                <span class="text-danger mb-3">${error!}</span><br>

                                <a href="/signin" class="form-text">Already have an account?</a><br>
                                <button type="submit" class="btn btn-primary mt-3">Submit</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </main>
    <footer class="bg-dark text-white text-center py-3 mt-auto">
        <p>2025 Sangam &copy;. All Rights reserved.</p>
    </footer>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const form = document.getElementById('registration_form');
        const passwordInput = document.getElementById('inputPassword');
        const confirmPasswordInput = document.getElementById('inputConfirm');
        const passwordError = document.getElementById('warningText');
        const apiInput = document.getElementById('inputSecCode');

        form.addEventListener('submit', function(event) {

            if (passwordInput.value !== confirmPasswordInput.value) {
                passwordError.textContent = "Passwords do not match";
                event.preventDefault(); // Prevent form submission
            } else if (passwordInput.value.length < 8) {
                passwordError.textContent = "Password too short, min of 8 characters!";
                event.preventDefault();
            } else {
                passwordError.textContent = "";
            }
        });
    });
</script>
</body>
</html>
