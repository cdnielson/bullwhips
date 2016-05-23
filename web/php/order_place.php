<?php
/*
 * Store user is redirected here once he has chosen
 * a payment method.
 */
require_once __DIR__ . '/bootstrap.php';
//session_start();

/*$body = @file_get_contents('php://input');

$resultArray = array(json_decode($body));

$orderAmount = $resultArray[0]->amounts;*/

$orderAmount = $_GET['order_amount'];
$orderDescription = "Folk Prophet Whips Order - $" . $orderAmount;

//$itemsListArray = $resultArray[0]->items_list;

/*if($_SERVER['REQUEST_METHOD'] == 'POST') {
    $order = $_REQUEST['order'];*/
    try {
        /*if($order['payment_method'] == 'credit_card') {

            // Make a payment using credit card.
            $user = getUser(getSignedInUser());
            $payment = makePaymentUsingCC($user['creditcard_id'], $order['amount'], 'USD', $order['description']);
            $orderId = addOrder(getSignedInUser(), $payment->getId(), $payment->getState(),
                $order['amount'], $order['description']);
            $message = "Your order has been placed successfully. Your Order id is <b>$orderId</b>";
            $messageType = "success";

        } else if($order['payment_method'] == 'paypal') {*/

            $orderId = "123"; // TODO replace with variable from POST or get rid of it entirely
            // Create the payment and redirect buyer to paypal for payment approval.
            $baseUrl = getBaseUrl() . "/order_completion.php?orderId=$orderId";
            $payment = makePaymentUsingPayPal($orderAmount, 'USD', $orderDescription,
                "$baseUrl&success=true", "$baseUrl&success=false");
//            updateOrder($orderId, $payment->getState(), $payment->getId());
            header("Location: " . getLink($payment->getLinks(), "approval_url") );
            exit;
        /*}*/
    } catch (\PayPal\Exception\PPConnectionException $ex) {
        $message = parseApiError($ex->getData());
        $messageType = "error";
    } catch (Exception $ex) {
        $message = $ex->getMessage();
        $messageType = "error";
    }
/*}*/
//require_once 'orders.php';

function parseApiError($errorJson) {
    $msg = '';

    $data = json_decode($errorJson, true);
    if(isset($data['name']) && isset($data['message'])) {
        $msg .= $data['name'] . " : " .  $data['message'] . "<br/>";
    }
    if(isset($data['details'])) {
        $msg .= "<ul>";
        foreach($data['details'] as $detail) {
            $msg .= "<li>" . $detail['field'] . " : " . $detail['issue'] . "</li>";
        }
        $msg .= "</ul>";
    }
    if($msg == '') {
        $msg = $errorJson;
    }
    return $msg;
}

function getLink(array $links, $type) {
    foreach($links as $link) {
        if($link->getRel() == $type) {
            return $link->getHref();
        }
    }
    return "";
}

function getBaseUrl() {

    $protocol = 'http';
    if ($_SERVER['SERVER_PORT'] == 443 || (!empty($_SERVER['HTTPS']) && strtolower($_SERVER['HTTPS']) == 'on')) {
        $protocol .= 's';
    }

    $host = $_SERVER['HTTP_HOST'];
    $request = $_SERVER['PHP_SELF'];
    return dirname($protocol . '://' . $host . $request);
}