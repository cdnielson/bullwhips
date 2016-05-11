<?php
$inputdata = @file_get_contents('php://input');
$result = json_decode($inputdata);

$date = $result->date;
$firstName = $result->firstName;
$lastName = $result->lastName;
$email = $result->email;
$phone = $result->phone;
$message = $result->message;

$name =  $firstName . " " . $lastName;

$body = 'Date: ' . $date .
    '<br>
First Name: ' .  $firstName .
    '<br>
Last Name: ' . $lastName .
    '<br>
Email: ' . $email .
    '<br>
Phone: ' . $phone .
    '<br>
Message: ' . $message;
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
    echo $body;
}

?>

