<!DOCTYPE html>
<html lang="en">
<head>
    <title><#if isEdit>Edit<#else>Add</#if> Stock - Sangam</title>
    <link rel="icon" type="image/x-icon" href="/imgs/logo.jpg">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <link href="/css/style.css" rel="stylesheet" type="text/css"/>
    <script src="https://kit.fontawesome.com/6e1d51a9e9.js" crossorigin="anonymous"></script>
    <style>
        .required-field::after {
            content: "*";
            color: red;
            margin-left: 3px;
        }
    </style>
</head>
<body>
<div class="d-flex flex-column min-vh-100">
    <#include "nav.ftl">
    
    <main class="container mt-3 flex-grow-1">
        <div class="row justify-content-center">
            <div class="col-md-8">
                    <h2 class="text-center mb-4"><#if isEdit>Edit<#else>Add New</#if> Stock</h2>
                    
                    <form action="/itemstock/save" method="POST">
                        <#if isEdit>
                            <input type="hidden" name="stockId" value="${itemStock.stockId}">
                            <input type="hidden" name="isEdit" value="true">
                        </#if>
                        
                        <div class="mb-3">
                            <label for="stockName" class="form-label required-field">Stock Name</label>
                            <input type="text" class="form-control" id="stockName" name="itemName" 
                                value="<#if itemStock.itemName??>${itemStock.itemName}</#if>" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="stockDescription" class="form-label">Stock Description</label>
                            <textarea class="form-control" id="stockDescription" name="itemDescription" rows="3"><#if itemStock.itemDescription??>${itemStock.itemDescription}</#if></textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label for="purchaseDate" class="form-label required-field">Purchase Date</label>
                            <input type="date" class="form-control" id="purchaseDate" name="purchaseDate" 
                                value="<#if itemStock.purchaseDate??>${itemStock.purchaseDate}</#if>" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="purchaseAmount" class="form-label required-field">Purchase Amount ($)</label>
                            <input type="number" step="0.01" class="form-control" id="purchaseAmount" name="purchaseAmount" 
                                value="<#if itemStock.purchaseAmount??>${itemStock.purchaseAmount?string('0.00')}<#else>0.00</#if>" required>
                        </div>
                        
                        <#if loggedInUser.role == "admin">
                            <div class="mb-3">
                                <label for="handlerId" class="form-label">Handler</label>
                                <select class="form-select" id="handlerId" name="handlerId">
                                    <#if adminUsers?? && adminUsers?size gt 0>
                                        <#list adminUsers as admin>
                                            <option value="${admin.userId}" <#if (itemStock.handlerId?? && itemStock.handlerId == admin.userId) || (!itemStock.handlerId?? && loggedInUser.userId == admin.userId)>selected</#if>>${admin.fullName}</option>
                                        </#list>
                                    <#else>
                                        <option value="${loggedInUser.userId}">${loggedInUser.fullName} (You)</option>
                                    </#if>
                                </select>
                                <div class="form-text">Select an admin user to handle this stock.</div>
                            </div>
                        </#if>
                        
                        <div class="mb-3 form-check">
                            <input type="checkbox" class="form-check-input" id="isActive" name="active" 
                                <#if itemStock.active?? && itemStock.active>checked</#if>>
                            <label class="form-check-label" for="isActive">Stock is active</label>
                        </div>
                        
                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                            <#if isEdit && loggedInUser.role == "admin">
                                <a href="/itemstock/delete/${itemStock.stockId}" class="btn btn-danger me-auto" 
                                   onclick="return confirm('Are you sure you want to delete this stock?')">Delete Stock</a>
                            </#if>
                            <a href="/itemstock" class="btn btn-secondary me-md-2">Cancel</a>
                            <button type="submit" class="btn btn-primary">Save Stock</button>
                        </div>
                    </form>
            </div>
        </div>
    </main>
    <footer class="bg-dark text-white text-center py-3 mt-auto">
        <p>2025 Sangam &copy;. All Rights reserved.</p>
    </footer>
</div>
</body>
</html>