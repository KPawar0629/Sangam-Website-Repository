<!DOCTYPE html>
<html lang="en">
<head>
    <title>User List - Sangam</title>
    <link rel="icon" type="image/x-icon" href="/imgs/logo.jpg">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <link href="./css/style.css" rel="stylesheet" type="text/css"/>
    <script src="https://kit.fontawesome.com/6e1d51a9e9.js" crossorigin="anonymous"></script>


</head>
<body>
<#include "nav.ftl">

<div class="container mt-3">
    <div class="row mt-2">
        <div class="col-sm-12 text-center">
            <h2>All Users</h2>
        </div>
    </div>
    <table class="table mt-3">
        <thead>
        <tr>
            <th>User Name</th>
            <th>Email</th>
            <th class="hide-on-md">Phone</th>
            <th>Account Created</th>
        </tr>
        </thead>
        <tbody>
        <#list users as user>
            <tr>
                <td>${user.fullName}</a></td>
                <td>${user.email}</td>
                <td class="hide-on-md">${user.phone}</td>
                <#if user.email == loggedInUser.email || (user.role == "staff" && loggedInUser.role == "admin")>
                <td>${user.account_created} <a href="#" class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#updateUser"
                            data-id="${user.userId}"
                            data-fullname = "${user.fullName}"
                            data-email = "${user.email}"
                            data-password="${user.password}"
                            data-phone="${user.phone}" title="Edit Profile"><i class="fa-solid fa-pen"></i></a></td>
                <#else>
                <td>${user.account_created}</td>
                </#if>
            </tr>
        </#list>
        </tbody>
    </table>

    <div class="modal fade" id="updateUser">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title">Update User Details</h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="/user/modify" method="post" id="userForm">
                        <input type="hidden" name="userId" value="${(user.userId)!}" />
                        <div class="mb-3">
                            <label for="fullName">Full Name:</label>
                            <input type="text" class="form-control" id="fullName" name="fullName" value="${(user.fullName)!}" required>
                        </div>
                        <div class="mb-3">
                            <label for="email">Email:</label>
                            <input type="email" class="form-control" id="email" name="email" value="${(user.email)!}">
                        </div>
                        <div class="mb-3">
                            <label for="password" class="d-block">Password:</label>
                            <input id="password" type="text" name="password" value="${(user.password)!}" required>
                        </div>
                        <div class="mb-3">
                            <label for="phone" class="d-block">Phone:</label>
                            <input id="phone" type="tel" name="phone" value="${(user.phone)!}" required>
                        </div>

                        <button type="submit" class="btn btn-success" id="addButton">Save</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    let userUpdateModal = document.getElementById('updateUser');
    userUpdateModal.addEventListener('show.bs.modal', function (event) {
        // Button that triggered the modal
        let button = event.relatedTarget;

        // Extract data-* attributes from the button
        let id = button.getAttribute('data-id');
        let fullName = button.getAttribute('data-fullname');
        let email = button.getAttribute('data-email');
        let password = button.getAttribute('data-password');
        let phone = button.getAttribute('data-phone');

        // Use the above data to populate the form fields in the modal
        let fullNameInput = userUpdateModal.querySelector('#fullName');
        let emailInput = userUpdateModal.querySelector('#email');
        let passwordInput = userUpdateModal.querySelector('#password');
        let phoneInput = userUpdateModal.querySelector('#phone');
        let hiddenIdInput = userUpdateModal.querySelector('input[name="userId"]');

        fullNameInput.value = fullName;
        emailInput.value = email;
        passwordInput.value = password;
        phoneInput.value = phone;
        hiddenIdInput.value = id;
    });
</script>
</body>
</html>

