<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&family=Roboto+Slab:wght@700&display=swap" rel="stylesheet">
    <style>
        /* Add drop shadow to the navbar brand */
        .navbar-brand {
            font-size: 3rem; /* Larger font size for the site title */ 
            font-weight: bold;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5); /* Drop shadow effect */
            color: white;
        }

        /* Style the navbar links */
        .navbar-nav .nav-link {
            font-size: 1.2rem; /* Larger font size for links */
            margin-left: 1rem; /* Add spacing between links */
            margin-right: 1rem;
        }

        /* Adjust the navbar styling */
        .navbar {
            font-family: 'Roboto', sans-serif;
            margin: 0;
            background: linear-gradient(180deg, #f4c542, #fff, #a8d8a3);
            color: white;
            border-radius: 5px;
            padding: 0.5rem 1rem; /* Adjust navbar padding */
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); /* Subtle shadow for navbar */
        }
        .navbar ul li a {
            color: #fff;
            text-decoration: none;
            font-weight: bold;
            font-family: 'Roboto Slab', serif;
            padding: 0.5em .2em;
            border-radius: 5px;
            transition: background 0.3s ease, color 0.3s ease;
        }
        .navbar ul li a {
            color: #76b5c5;
        }
        .navbar-nav > li > .dropdown-menu { 
            background: linear-gradient(45deg, #f4c542, #fff, #a8d8a3);
        }
        
        /* Global Loading Overlay */
        #global-loader {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.7);
            z-index: 999999;
            display: none;
            justify-content: center;
            align-items: center;
            backdrop-filter: blur(5px);
        }
        
        #global-loader.active {
            display: flex;
        }
        
        .loader-content {
            text-align: center;
            color: white;
        }
        
        /* Spinner Animation */
        .spinner {
            width: 80px;
            height: 80px;
            margin: 0 auto 20px;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .spinner-ring {
            position: absolute;
            width: 100%;
            height: 100%;
            border: 4px solid transparent;
            border-top-color: #f4c542;
            border-radius: 50%;
            animation: spin 1.5s cubic-bezier(0.68, -0.55, 0.265, 1.55) infinite;
            top: 0;
            left: 0;
        }
        
        .spinner-ring:nth-child(2) {
            border-top-color: #a8d8a3;
            animation-delay: -0.5s;
        }
        
        .spinner-ring:nth-child(3) {
            border-top-color: #76b5c5;
            animation-delay: -1s;
        }
        
        @keyframes spin {
            0% {
                transform: rotate(0deg);
            }
            100% {
                transform: rotate(360deg);
            }
        }
        
        /* Sangam Logo Animation */
        .loader-logo {
            width: 50px;
            height: 50px;
            position: absolute;
            top: 19%;
            left: 19%;
            z-index: 10;
            animation: pulse 2s ease-in-out infinite;
        }
        
        .loader-logo img {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            object-fit: cover;
            box-shadow: 0 0 20px rgba(244, 197, 66, 0.5);
        }
        
        @keyframes pulse {
            0%, 100% {
                transform: scale(1);
                opacity: 1;
            }
            50% {
                transform: scale(1.1);
                opacity: 0.8;
            }
        }
        
        .loader-text {
            font-size: 1.2rem;
            font-weight: 600;
            margin-top: 20px;
            animation: fadeInOut 2s ease-in-out infinite;
        }
        
        @keyframes fadeInOut {
            0%, 100% {
                opacity: 0.5;
            }
            50% {
                opacity: 1;
            }
        }
        
        /* Dots animation */
        .loading-dots span {
            animation: blink 1.4s infinite;
            animation-fill-mode: both;
        }
        
        .loading-dots span:nth-child(2) {
            animation-delay: 0.2s;
        }
        
        .loading-dots span:nth-child(3) {
            animation-delay: 0.4s;
        }
        
        @keyframes blink {
            0%, 80%, 100% {
                opacity: 0;
            }
            40% {
                opacity: 1;
            }
        }
    </style>
</head>
<body>
    <!-- Global Loading Overlay -->
    <div id="global-loader">
        <div class="loader-content">
            <div class="spinner">
                <div class="loader-logo">
                    <img src="/imgs/logo1.png" alt="Sangam Logo">
                </div>
                <div class="spinner-ring"></div>
                <div class="spinner-ring"></div>
                <div class="spinner-ring"></div>
            </div>
            <div class="loader-text">
                Loading<span class="loading-dots"><span>.</span><span>.</span><span>.</span></span>
            </div>
        </div>
    </div>
    
    <nav class="navbar navbar-expand-lg bg-body-tertiary">
        <div class="container-fluid">
            <a class="navbar-brand fs-1" href="/dashboard">
                <img src="/imgs/logo1.png" width="60" height="60" alt="Logo">
                Sangam
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav mb-2 mb-lg-0 ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" aria-current="page" href="/dashboard">Home</a>
                    </li>
                    <#if loggedInUser??>
                        <li class="nav-item">
                            <a class="nav-link" aria-current="page" href="/event_list">Events</a>
                        </li>
                        <#--  <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                Events
                            </a>
                            <ul class="dropdown-menu p-2">
                                <#if loggedInUser.role == "admin">
                                    <li><a class="dropdown-item text-center" href="/event_list">All Events</a></li>
                                    <li><a class="dropdown-item text-center" href="/payment_list">Receive Payments</a></li>
                                </#if>
                                <li><a class="dropdown-item text-center" href="/participant_list">Participants</a></li>
                                <li><a class="dropdown-item text-center" href="/checkin">Check In Tickets</a></li>
                            </ul>
                        </li>  -->
                    </#if>
                    <li class="nav-item">
                        <a class="nav-link" href="/about_us">About Us</a>
                    </li>
                    
                    <#if loggedInUser??>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            ${(loggedInUser.email)!}
                        </a>
                        <ul class="dropdown-menu p-2">
                            <#if loggedInUser.role == "admin" || loggedInUser.role == "staff">
                            <li><a class="dropdown-item text-center" href="/itemstock">Stock Management</a></li>
                            </#if>
                            <#if loggedInUser.role == "admin">
                            <li><a class="dropdown-item text-center" href="/user_list">All Users</a></li>
                            </#if>
                            <li><a class="dropdown-item text-center" href="/signout">Logout</a></li>
                        </ul>
                    </li>
                    <#else>
                    <li class="nav-item">
                        <a class="nav-link" href="/signin">Login</a>
                    </li>
                    </#if>
                    
                </ul>
            </div>
        </div>
    </nav>

    <script>
        // Global Loading Animation Controller
        (function() {
            const loader = document.getElementById('global-loader');
            
            // Show loader when page starts loading
            window.addEventListener('beforeunload', function() {
                showLoader();
            });
            
            // Hide loader when page is fully loaded
            window.addEventListener('load', function() {
                hideLoader();
            });
            
            // Show loader on initial page load
            document.addEventListener('DOMContentLoaded', function() {
                hideLoader();
            });
            
            // Intercept all link clicks
            document.addEventListener('click', function(e) {
                const target = e.target.closest('a');
                
                if (target && target.href) {
                    // Check if it's an external link or special link
                    const href = target.getAttribute('href');
                    
                    // Don't show loader for:
                    // - Hash links (#)
                    // - JavaScript links (javascript:)
                    // - External links (different domain)
                    // - Download links
                    // - Links that open in new tab
                    if (href && 
                        !href.startsWith('#') && 
                        !href.startsWith('javascript:') &&
                        !target.hasAttribute('download') &&
                        target.target !== '_blank' &&
                        target.hostname === window.location.hostname) {
                        
                        showLoader();
                    }
                }
            });
            
            // Intercept form submissions
            document.addEventListener('submit', function(e) {
                const form = e.target;
                
                // Don't show loader for forms with certain classes or attributes
                if (!form.classList.contains('no-loader') && 
                    !form.hasAttribute('data-no-loader')) {
                    showLoader();
                }
            });
            
            // Show loader for AJAX requests (if using fetch)
            const originalFetch = window.fetch;
            window.fetch = function() {
                showLoader();
                return originalFetch.apply(this, arguments).finally(() => {
                    setTimeout(hideLoader, 300); // Small delay for better UX
                });
            };
            
            function showLoader() {
                if (loader) {
                    loader.classList.add('active');
                    document.body.style.overflow = 'hidden'; // Prevent scrolling
                }
            }
            
            function hideLoader() {
                if (loader) {
                    // Small delay to ensure smooth transition
                    setTimeout(() => {
                        loader.classList.remove('active');
                        document.body.style.overflow = ''; // Restore scrolling
                    }, 100);
                }
            }
            
            // Expose functions globally for manual control
            window.showLoader = showLoader;
            window.hideLoader = hideLoader;
            
            // Handle browser back/forward buttons
            window.addEventListener('pageshow', function(event) {
                if (event.persisted) {
                    hideLoader();
                }
            });
            
            // Fallback: auto-hide loader after 10 seconds (in case something goes wrong)
            setTimeout(() => {
                if (loader && loader.classList.contains('active')) {
                    console.warn('Loader was active for too long, auto-hiding');
                    hideLoader();
                }
            }, 10000);
        })();
    </script>

</body>
</html>
