<html>
<body>

<?php
echo 'Date: ' . $_POST["date"];
echo "<br>";
echo 'First Name: ' .  $_POST["firstname"];
echo "<br>";
echo 'Last Name: ' . $_POST["lastname"];
echo "<br>";
echo 'Email: ' . $_POST["email"];
echo "<br>";
echo 'Phone: ' . $_POST["phone"];
echo "<br>";
echo 'Zip: ' . $_POST["zip"];
echo "<br>";
echo 'Message: ' . $_POST["message"];

$email =  $_POST["email"];
$name =  $_POST["firstname"] . " " . $_POST["lastname"];

$body = 'Date: ' . $_POST["date"] .
    '<br>
First Name: ' .  $_POST["firstname"] .
    '<br>
Last Name: ' . $_POST["lastname"] .
    '<br>
Email: ' . $_POST["email"] .
    '<br>
Phone: ' . $_POST["phone"] .
    '<br>
Zip: ' . $_POST["zip"] .
    '<br>
Contact by: ' . $_POST["contacted"] .
    '<br>
Message: ' . $_POST["message"];
?>


<?php
require 'PHPMailer-master/PHPMailerAutoload.php';
//Create a new PHPMailer instance
$mail = new PHPMailer;
// Set PHPMailer to use the sendmail transport
$mail->isSendmail();
//Set who the message is to be sent from
$mail->setFrom($email, $name);
//Set an alternative reply-to address
$mail->addReplyTo($email, $name);
//Set who the message is to be sent to
$mail->addAddress('cdnielson@folkprophet.com');
//Set the subject line
$mail->Subject = 'Folk Prophet Whips Form Query';
//Read an HTML message body from an external file, convert referenced images to embedded,
//convert HTML into a basic plain-text alternative body
$mail->msgHTML($body);
//Replace the plain text body with one created manually
$mail->AltBody = $body;
//Attach an image file
//$mail->addAttachment('signatures/signature_' . $_SESSION['data']);



//    $mail->Body = '<img alt="PHPMailer" src="cid:my-logo"><div style="background: white;">' . $body . '<img alt="PHPMailer" src="cid:my-sig"></div>';

//send the message, check for errors
if (!$mail->send()) {
    echo "Mailer Error: " . $mail->ErrorInfo;
} else {
    echo "<br>Message sent!<br><button><a href='http://folkprophet.com/whips'>Home</a></button></body></html>";
}

?>

