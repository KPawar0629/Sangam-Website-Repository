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
    </style>
</head>
<body>
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
                            <li><a class="dropdown-item text-center" href="/itemstock">Item Stock</a></li>
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


</body>
</html>
