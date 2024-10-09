<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Timeout</title>
    <link href="<%=request.getContextPath()%>/resources/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>Payment Timeout</h2>
        <p>Your payment session has expired. The transaction has been cancelled.</p>
        <a href="<%=request.getContextPath()%>/customers/home" class="btn btn-primary">Return to Restaurants</a>
    </div>
</body>
</html>
