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
        
        /* Responsive styles */
        @media screen and (max-width: 767px) {
            .desktop-only {
                display: none;
            }
            
            .mobile-only {
                display: table-cell;
            }
            
            .mobile-action-cell {
                display: none;
            }
            
            .mobile-handler {
                font-size: 0.9rem;
                color: #333;
                display: block;
                margin-bottom: 5px;
                font-weight: 500;
            }
            
            .mobile-status {
                display: block;
                font-weight: 600;
            }
            
            .table td {
                padding: 12px 10px;
                vertical-align: middle;
            }
            
            /* Add more visual separation between rows on mobile */
            .table tbody tr {
                border-bottom: 4px solid #e9ecef;
            }
            
            /* Make the item name stand out more */
            .item-name {
                font-weight: bold;
                font-size: 1.05rem;
                color: #000;
            }
        }
        
        @media screen and (min-width: 768px) {
            .mobile-only {
                display: none;
            }
            
            .mobile-handler, .mobile-status {
                display: none;
            }
        }
        
        @media screen and (min-width: 768px) {
            .mobile-handler, .mobile-status {
                display: none;
            }
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
                                <th class="mobile-only">Handler & Status</th>
                                <th class="desktop-only">Purchase Date</th>
                                <th class="desktop-only">Amount</th>
                                <th class="desktop-only">Handler</th>
                                <th class="desktop-only">Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <#if itemStockList?? && itemStockList?size gt 0>
                                <#list itemStockList as item>
                                    <tr>
                                        <td>
                                            <a href="/itemstock/edit/${item.stockId}" class="item-name" style="text-decoration: none;">${item.itemName}</a>
                                            <!-- Add action buttons for mobile but with dropdown -->
                                            <div class="d-flex d-md-none mt-2">
                                                <div class="dropdown">
                                                    <button class="btn btn-sm btn-secondary dropdown-toggle" type="button" id="actionMenu${item.stockId}" data-bs-toggle="dropdown" aria-expanded="false">
                                                        Actions
                                                    </button>
                                                    <ul class="dropdown-menu" aria-labelledby="actionMenu${item.stockId}">
                                                        <li><a class="dropdown-item" href="/itemstock/edit/${item.stockId}">Edit</a></li>
                                                        <li><a class="dropdown-item" href="/itemstock/toggle/${item.stockId}">
                                                            <#if item.active>Deactivate<#else>Activate</#if>
                                                        </a></li>
                                                        <#if loggedInUser?? && loggedInUser.role == "admin">
                                                            <li><a class="dropdown-item text-danger" href="/itemstock/delete/${item.stockId}" 
                                                                onclick="return confirm('Are you sure you want to delete this item?')">Delete</a></li>
                                                        </#if>
                                                    </ul>
                                                </div>
                                            </div>
                                        </td>
                                        <!-- Mobile only column for Handler & Status -->
                                        <td class="mobile-only">
                                            <span class="mobile-handler">
                                                <#if handlers?? && item.handlerId?? && handlers[item.handlerId]??>
                                                    ${handlers[item.handlerId].fullName}
                                                <#else>
                                                    Unknown
                                                </#if>
                                            </span>
                                            <span class="mobile-status <#if item.active>status-active<#else>status-inactive</#if>">
                                                <#if item.active>Active<#else>Inactive</#if>
                                            </span>
                                        </td>
                                        <td class="desktop-only">${item.purchaseDate!'N/A'}</td>
                                        <td class="desktop-only">$${item.purchaseAmount?string("0.00")}</td>
                                        <td class="desktop-only">
                                            <#if handlers?? && item.handlerId?? && handlers[item.handlerId]??>
                                                ${handlers[item.handlerId].fullName}
                                            <#else>
                                                Unknown
                                            </#if>
                                        </td>
                                        <td class="desktop-only <#if item.active>status-active<#else>status-inactive</#if>">
                                            <#if item.active>Active<#else>Inactive</#if>
                                        </td>
                                    </tr>
                                </#list>
                            <#else>
                                <tr>
                                    <td colspan="8" class="text-center">No items found</td>
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