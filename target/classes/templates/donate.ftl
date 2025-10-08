<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Donate - Sangam</title>
    <link rel="icon" type="image/x-icon" href="/imgs/logo.jpg">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <script src="https://kit.fontawesome.com/6e1d51a9e9.js" crossorigin="anonymous"></script>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&family=Roboto+Slab:wght@700&display=swap" rel="stylesheet">
    <style>
        /* Keep the construction card styles */
        .construction-card {
            max-width: 800px;
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            position: relative;
        }
        
        .construction-header {
            background-color: #e67817;
            color: white;
            padding: 2rem;
            text-align: center;
        }
        
        .construction-body {
            padding: 2rem;
            text-align: center;
        }
        
        .donation-coming-soon {
            font-size: 2rem;
            font-weight: 600;
            color: #e67817;
            margin: 1.5rem 0;
        }
        
        .construction-icon {
            font-size: 6rem;
            margin-bottom: 1rem;
            color: #e67817;
        }
        
        .btn-return {
            background-color: #e67817;
            border-color: #e67817;
            padding: 0.75rem 2rem;
            font-size: 1.2rem;
            margin-top: 2rem;
            transition: all 0.3s ease;
        }
        
        .btn-return:hover {
            background-color: #d26200;
            border-color: #d26200;
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(230, 120, 23, 0.3);
        }
        
        .construction-decoration {
            position: absolute;
            width: 150px;
            height: 150px;
            background-color: rgba(230, 120, 23, 0.1);
            border-radius: 50%;
        }
        
        .decoration-1 {
            top: -50px;
            left: -50px;
        }
        
        .decoration-2 {
            bottom: -50px;
            right: -50px;
        }
        
        .heartbeat {
            animation: heartbeat 1.5s ease-in-out infinite;
        }
        
        @keyframes heartbeat {
            0% { transform: scale(1); }
            14% { transform: scale(1.1); }
            28% { transform: scale(1); }
            42% { transform: scale(1.1); }
            70% { transform: scale(1); }
        }
        
        .fade-in {
            animation: fadeIn 1s ease-out;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>

<body>
    <div class="d-flex flex-column min-vh-100">
        <#include "nav.ftl">
        <link href="/css/style.css" rel="stylesheet" type="text/css"/>
        
        <main class="flex-grow-1 d-flex align-items-center justify-content-center py-5">
            <div class="container">
                <div class="construction-card fade-in mx-auto">
                    <div class="construction-decoration decoration-1"></div>
                    <div class="construction-decoration decoration-2"></div>
                    
                    <div class="construction-header">
                        <h1>Donation Portal</h1>
                        <p class="mb-0">Supporting Sangam's Mission</p>
                    </div>
                    
                    <div class="construction-body">
                        <i class="fa-solid fa-heart construction-icon heartbeat"></i>
                        <h2 class="donation-coming-soon">Coming Soon</h2>
                        <p class="lead">We are working hard to bring you our new donation platform.</p>
                        <p>Your generous contributions will help us continue to serve our community and organize cultural events.</p>
                        <p>Please check back soon or contact us directly to make a donation.</p>
                        
                        <a href="/" class="btn btn-warning btn-return">
                            <i class="fa-solid fa-house me-2"></i> Return to Homepage
                        </a>
                    </div>
                </div>
                
                <!-- Nonprofit Information Section -->
                <div class="text-center mt-5 mb-4">
                    <div class="bg-light p-4 rounded shadow-sm">
                        <p class="mb-2 fw-bold text-primary">SANGAM Santa Barbara Inc. is a 501(c)(3) nonprofit public Organization!</p>
                        <p class="text-primary mb-0"><strong>Federal Tax ID:</strong> 39-3121864</p>
                    </div>
                </div>
            </div>
        </main>
        
        <footer class="bg-dark text-white text-center py-3 mt-auto">
            <p>2025 Sangam &copy;. All Rights reserved.</p>
        </footer>
    </div>
</body>
</html>