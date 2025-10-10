<html>
<head>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css">
    <link href="/css/style.css" rel="stylesheet" type="text/css" />
    <link href="/css/others.css" rel="stylesheet" type="text/css" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    <title>Item Stock Management</title>
    <style>
        .table-hover tbody tr:hover {
            background-color: #f5f5f5;
        }
        .status-active {
            color: green;
            font-weight: bold;
        }
        .status-inactive {
            color: red;
            font-weight: bold;
        }
        .item-actions {
            display: flex;
            gap: 10px;
        }
        .search-container {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <#include "nav.ftl">
    
    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <h2 class="text-center mb-4">Item Stock Management</h2>
                
                <div class="search-container row">
                    <div class="col-md-6">
                        <form action="/itemstock" method="GET" class="d-flex">
                            <input type="text" name="search" class="form-control me-2" placeholder="Search by item name...">
                            <button type="submit" class="btn btn-primary">Search</button>
                        </form>
                    </div>
                    <div class="col-md-6 text-end">
                        <a href="/itemstock/add" class="btn btn-success">Add New Item</a>
                    </div>
                </div>
                
                <div class="table-responsive">
                    <table class="table table-bordered table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>Item Name</th>
                                <th>Description</th>
                                <th>Purchase Date</th>
                                <th>Amount</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <#if itemStockList?? && itemStockList?size gt 0>
                                <#list itemStockList as item>
                                    <tr>
                                        <td>${item.itemName}</td>
                                        <td>
                                            <#if item.itemDescription?? && item.itemDescription?length gt 50>
                                                ${item.itemDescription[0..49]}...
                                            <#else>
                                                ${item.itemDescription!'No description'}
                                            </#if>
                                        </td>
                                        <td>${item.purchaseDate!'N/A'}</td>
                                        <td>$${item.purchaseAmount?string("0.00")}</td>
                                        <td class="<#if item.active>status-active<#else>status-inactive</#if>">
                                            <#if item.active>Active<#else>Inactive</#if>
                                        </td>
                                        <td>
                                            <div class="item-actions">
                                                <a href="/itemstock/edit/${item.stockId}" class="btn btn-sm btn-primary">Edit</a>
                                                <a href="/itemstock/toggle/${item.stockId}" class="btn btn-sm <#if item.active>btn-warning<#else>btn-success</#if>">
                                                    <#if item.active>Deactivate<#else>Activate</#if>
                                                </a>
                                                <#if loggedInUser?? && loggedInUser.role == "admin">
                                                    <a href="/itemstock/delete/${item.stockId}" class="btn btn-sm btn-danger" 
                                                       onclick="return confirm('Are you sure you want to delete this item?')">Delete</a>
                                                </#if>
                                            </div>
                                        </td>
                                    </tr>
                                </#list>
                            <#else>
                                <tr>
                                    <td colspan="6" class="text-center">No items found</td>
                                </tr>
                            </#if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
</html>