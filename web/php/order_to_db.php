<?php

$data = file_get_contents('php://input');

$jsonData = json_decode($data);

$firstname = $jsonData->customer->firstName;
$lastname = $jsonData->customer->lastName;
$currency = $jsonData->amounts->currency;
$shipping = $jsonData->amounts->shipping;
$total = $jsonData->amounts->total;

$servername = "mysqlcluster15";
$username = "cdnielson";
$password = "Bryony1!";
$dbname = "folkprophetwhips";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
echo "Connected successfully";

$sql = "INSERT INTO order_master (lastname, firstname, currency, shipping, total)
VALUES ('".$lastname."', '".$firstname."', '".$currency."', '".$shipping."', '".$total."')";
$idx = "";
if ($conn->query($sql) === TRUE) {
    $idx = $conn->insert_id;
} else {
    echo "Error: " . $sql . "<br>" . $conn->error;
}

$items = array($jsonData->items_list);

foreach ($items[0] as $item) {
    $description = $item->name;
    $quantity = $item->quantity;
    $price = $item->price;

    echo $description;


    $sql = "INSERT INTO order_items (order_idx, description, price, quantity)
VALUES ('".$idx."', '".$description."', '".$price."', '".$quantity."')";

    if ($conn->query($sql) === TRUE) {
        echo "order added successfully";
    } else {
        echo "Error: " . $sql . "<br>" . $conn->error;
    }
}

$conn->close();

?>