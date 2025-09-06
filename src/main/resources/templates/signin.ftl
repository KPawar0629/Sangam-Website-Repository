<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Signin - Sangam</title>
    <link rel="icon" type="image/x-icon" href="/imgs/logo.jpg">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link href="./css/user_login.css" rel="stylesheet" type="text/css"/>
</head>
<body>
<#include "nav.ftl">
<link href="./css/style.css" rel="stylesheet" type="text/css"/>
<div class="container-fluid">
    <form class="mx-auto signin-form" action="/signin" method="post">
        <h4 class="text-center">Sign In</h4>
        <div class="mb-3 mt-4">
            <label for="inputEmail1" class="form-label">Email address</label>
            <input type="email" class="form-control" id="inputEmail1" aria-describedby="emailHelp" name="email" required>
        </div>
        <div class="mb-3">
            <label for="inputPassword1" class="form-label">Password</label>
            <input type="password" class="form-control" id="inputPassword1" name="password" required>
            <div class="mt-4">
                <a href="#" class="form-text">Forgot Password?</a><br>
                <a href="/signup" class="form-text">Create Account</a>
            </div>
        </div>
        <button type="submit" class="btn btn-primary mt-1">Submit</button>
    </form>
</div>
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

<footer class="bg-dark text-white text-center py-3">
        <p>2025 Sangam &copy;. All Rights reserved.</p>    
    </footer>



<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<script>
    const myModal = new bootstrap.Modal('#messageModal');

    window.addEventListener('DOMContentLoaded', () => {
        myModal.show();
    });
</script>
</body>
</html>
