<html>
<head>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css">
    <link href="/css/style.css" rel="stylesheet" type="text/css" />
    <link href="/css/others.css" rel="stylesheet" type="text/css" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    <title><#if isEdit>Edit<#else>Add</#if> Item Stock</title>
    <style>
        .form-container {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .required-field::after {
            content: "*";
            color: red;
            margin-left: 3px;
        }
    </style>
</head>
<body>
    <#include "nav.ftl">
    
    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="form-container">
                    <h2 class="text-center mb-4"><#if isEdit>Edit<#else>Add New</#if> Item</h2>
                    
                    <form action="/itemstock/save" method="POST">
                        <#if isEdit>
                            <input type="hidden" name="stockId" value="${itemStock.stockId}">
                            <input type="hidden" name="isEdit" value="true">
                        </#if>
                        
                        <div class="mb-3">
                            <label for="itemName" class="form-label required-field">Item Name</label>
                            <input type="text" class="form-control" id="itemName" name="itemName" 
                                value="<#if itemStock.itemName??>${itemStock.itemName}</#if>" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="itemDescription" class="form-label">Item Description</label>
                            <textarea class="form-control" id="itemDescription" name="itemDescription" rows="3"><#if itemStock.itemDescription??>${itemStock.itemDescription}</#if></textarea>
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
                                <input type="text" class="form-control" id="handlerId" name="handlerId" 
                                    value="<#if itemStock.handlerId??>${itemStock.handlerId}<#else>${loggedInUser.userId}</#if>">
                                <div class="form-text">Leave empty to assign yourself as the handler.</div>
                            </div>
                        </#if>
                        
                        <div class="mb-3 form-check">
                            <input type="checkbox" class="form-check-input" id="isActive" name="active" 
                                <#if itemStock.active?? && itemStock.active>checked</#if>>
                            <label class="form-check-label" for="isActive">Item is active</label>
                        </div>
                        
                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                            <a href="/itemstock" class="btn btn-secondary me-md-2">Cancel</a>
                            <button type="submit" class="btn btn-primary">Save Item</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>