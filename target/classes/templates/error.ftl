<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Sangam</title>
    <link rel="icon" type="image/x-icon" href="/imgs/logo.jpg">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <script src="https://kit.fontawesome.com/6e1d51a9e9.js" crossorigin="anonymous"></script>
    <style>
        .error-container {
            max-width: 700px;
            margin: 50px auto;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            background: linear-gradient(to bottom right, #fff, #f9f9f9);
        }
        
        .error-icon {
            font-size: 80px;
            color: #e67817;
            margin-bottom: 20px;
        }
        
        .error-title {
            color: #e67817;
            font-weight: bold;
            margin-bottom: 20px;
        }
        
        .error-message {
            font-size: 18px;
            color: #555;
            margin-bottom: 30px;
        }
        
        .btn-home {
            background-color: #e67817;
            border-color: #e67817;
            padding: 10px 30px;
            font-weight: bold;
        }
        
        .btn-home:hover {
            background-color: #d06615;
            border-color: #d06615;
        }
    </style>
</head>

<body>
<div class="d-flex flex-column min-vh-100">
    <#include "nav.ftl">
    <link href="/css/style.css" rel="stylesheet" type="text/css"/>
    <main>
        <div class="container flex-grow-1">
            <div class="error-container text-center">
                <div class="error-icon">
                    <i class="fa-solid fa-circle-exclamation"></i>
                </div>
                <h1 class="error-title">Oops! Something went wrong</h1>
                <div class="error-message">
                    <p>We apologize for the inconvenience. Our team has been notified and is working to fix this issue as soon as possible.</p>
                    
                    <#if error??>
                        <div class="alert alert-danger mt-4">
                            ${error}
                        </div>
                    </#if>
                    
                    <#if status?? && message??>
                        <div class="alert alert-info mt-4">
                            <strong>Status:</strong> ${status} <br>
                            <strong>Message:</strong> ${message}
                        </div>
                    </#if>
                </div>
                <div class="mt-4">
                    <a href="/dashboard" class="btn btn-warning btn-home text-white">
                        <i class="fa-solid fa-house me-2"></i> Return to Home Page
                    </a>
                </div>
            </div>
        </div>
    </main>
    <footer class="bg-dark text-white text-center py-3 mt-auto">
        <p>2025 Sangam &copy;. All Rights Reserved.</p>
    </footer>
</div>
</body>
</html>
