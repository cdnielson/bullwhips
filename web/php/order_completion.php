<html>
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Folk Prophet Whips</title>

    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="../iron-flex-layout.css">


</head>
<div id="main" class="layout vertical center">
    <img src="../images/title.png" style="width: 100%; max-width: 1000px;" class="center-block"/>
    <div id="container" class="layout vertical center">

                        <?php
                        /*
                         * Order completion page. When PayPal is used as the payment method,
                         * the buyer gets redirected here post approval / cancellation of
                         * payment.
                         */
                        $firstname = "";
                        $lastname = "";
                        $total = "";
                        $shipping = "";
                        $id = $_GET['orderId'];

                        include 'bootstrap_db.php';

                        // Create connection
                        $conn = new mysqli($servername, $username, $password, $dbname);

                        // Check connection
                        if ($conn->connect_error) {
                            die("Connection failed: " . $conn->connect_error);
                        }

                        $sql = "SELECT * FROM order_master WHERE idx = ('$id')";
                        $result = $conn->query($sql);

                        if ($result->num_rows > 0) {
                            // output data of each row
                            while($row = $result->fetch_assoc()) {
                                $firstname = $row["firstname"];
                                $lastname = $row["lastname"];
                                $total = $row["total"];
                                $shipping = $row["shipping"];
                            }
                        } else {
                            echo "0 results";
                        }

                        $sql = "SELECT * FROM order_items WHERE order_idx = ('$id')";
                        $result = $conn->query($sql);
                        $itemsArray = array();
                        while($row = mysqli_fetch_assoc($result)) {
                            $itemsArray[] = $row;
                        };
                        //var_dump($itemsArray);
                        require_once __DIR__ . '/bootstrap.php';

                        if(isset($_GET['success'])) {

                            // We were redirected here from PayPal after the buyer approved/cancelled
                            // the payment
                            //echo $_SERVER["QUERY_STRING"];

                        //    exit;

                            if($_GET['success'] == 'true' && isset($_GET['PayerID']) && isset($_GET['orderId'])) {
                                //$orderId = $_GET['orderId'];
                                try {
                                    //$order = getOrder($orderId);
                                    $payment = executePayment($_GET['paymentId'], $_GET['PayerID']);
                                    //updateOrder($orderId, $payment->getState());
                                    $messageType = "success";
                                    echo "<h3>Thank you</h3>";
                                    echo "Your payment was successful.<br>Your order id is $id<br>";
                                    echo "Order Details:<br>";
                                    echo "Name: " . $firstname . " " . $lastname . "<br><br>";
                                    foreach ($itemsArray as $item) {
                                        echo "Item:<br>";
                                        echo "Description: " . $item['description'] . "<br>";
                                        echo "Price $" . $item['price'] . "<br>";
                                        echo "Quantity: " . $item['quantity'] . "<br>";
                                        echo "<br>";
                                    }
                                    echo "Shipping: " . $shipping . "<br>";
                                    echo "Order Total: " . $total;

                                    $sql = "UPDATE order_master SET paid = true WHERE idx = ('$id')";
                                    if (!mysqli_query($conn, $sql)) {
                                        die('Error: ' . mysqli_error($conn));
                                    }

                                } catch (\PayPal\Exception\PPConnectionException $ex) {
                                    echo parseApiError($ex->getData());
                                    echo "error";
                                } catch (Exception $ex) {
                                    echo $ex->getMessage();
                                    echo "error";
                                }

                            } else {
                                echo "Your payment was cancelled.";
                            }
                        }
                        ?>
        <a href="../">Return to shopping.</a>
    </div>
</div>




