<html>
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Folk Prophet Whips</title>

    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="../iron-flex-layout.css">


    <script src="https://www.gstatic.com/firebasejs/live/3.0/firebase.js"></script>
    <script>
        // Initialize Firebase
        var config = {
            apiKey: "AIzaSyA6vxB4OaImEXntU1maVDPyMGp_Yp90Gew",
            authDomain: "project-5745322078275383797.firebaseapp.com",
            databaseURL: "https://project-5745322078275383797.firebaseio.com",
            storageBucket: "project-5745322078275383797.appspot.com",
        };
        firebase.initializeApp(config);
    </script>

</head>
<div id="main" class="layout vertical center">
    <img src="../images/title.png" style="width: 100%; max-width: 1000px;" class="center-block"/>
    <div id="container" class="layout vertical center">
        <h3>Thank you</h3>

                        <?php
                        /*
                         * Order completion page. When PayPal is used as the payment method,
                         * the buyer gets redirected here post approval / cancellation of
                         * payment.
                         */
                        require_once __DIR__ . '/bootstrap.php';

                        if(isset($_GET['success'])) {

                            // We were redirected here from PayPal after the buyer approved/cancelled
                            // the payment
                            //echo $_SERVER["QUERY_STRING"];

                        //    exit;

                            if($_GET['success'] == 'true' && isset($_GET['PayerID']) && isset($_GET['orderId'])) {
                                $orderId = $_GET['orderId'];
                                try {
                                    //$order = getOrder($orderId);
                                    $payment = executePayment($_GET['paymentId'], $_GET['PayerID']);
                                    //updateOrder($orderId, $payment->getState());
                                    $messageType = "success";
                                    echo "Your payment was successful. Your order id is $orderId.";
                                } catch (\PayPal\Exception\PPConnectionException $ex) {
                                    echo parseApiError($ex->getData());
                                    echo "error";
                                } catch (Exception $ex) {
                                    echo $ex->getMessage();
                                    echo "error";
                                }

                            } else {
                                echo "error";
                                echo "Your payment was cancelled.";
                            }
                        }
                        ?>
    </div>
</div>




