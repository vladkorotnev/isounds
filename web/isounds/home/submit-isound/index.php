<?php
	// Start session.
	session_start();
	
	// Set a key, checked in mailer, prevents against spammers trying to hijack the mailer.
	$security_token = $_SESSION['security_token'] = uniqid(rand());
	
	if ( ! isset($_SESSION['formMessage'])) {
		$_SESSION['formMessage'] = 'Fill in the form below to submit to iSoundStore.';	
	}
	
	if ( ! isset($_SESSION['formFooter'])) {
		$_SESSION['formFooter'] = '';
	}
	
	if ( ! isset($_SESSION['form'])) {
		$_SESSION['form'] = array();
	}
	
	function check($field, $type = '', $value = '') {
		$string = "";
		if (isset($_SESSION['form'][$field])) {
			switch($type) {
				case 'checkbox':
					$string = 'checked="checked"';
					break;
				case 'radio':
					if($_SESSION['form'][$field] === $value) {
						$string = 'checked="checked"';
					}
					break;
				case 'select':
					if($_SESSION['form'][$field] === $value) {
						$string = 'selected="selected"';
					}
					break;
				default:
					$string = $_SESSION['form'][$field];
			}
		}
		return $string;
	}
?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		
		<title>iSounds | Submit to iSoundStore</title>
		<link rel="stylesheet" type="text/css" media="screen" href="../rw_common/themes/realmacsoftware06/styles.css"  />
		<link rel="stylesheet" type="text/css" media="screen" href="../rw_common/themes/realmacsoftware06/colourtag-theme-default.css"  />
		<!--[if IE 6]><link rel="stylesheet" type="text/css" media="screen" href="../rw_common/themes/realmacsoftware06/ie6.css"  /><![endif]-->
		<!--[if IE 7]><link rel="stylesheet" type="text/css" media="screen" href="../rw_common/themes/realmacsoftware06/ie7.css"  /><![endif]-->
		<link rel="stylesheet" type="text/css" media="screen" href="../rw_common/themes/realmacsoftware06/css/width/900.css" />
		<link rel="stylesheet" type="text/css" media="screen" href="../rw_common/themes/realmacsoftware06/css/sidebar/right.css" />
		
		<link rel="stylesheet" type="text/css" media="print" href="../rw_common/themes/realmacsoftware06/print.css"  />
		<script type="text/javascript" src="../rw_common/themes/realmacsoftware06/javascript.js"></script>
		
		
		
		
		<!--[if IE 6]><script type="text/javascript" charset="utf-8">
			var blankSrc = "../rw_common/themes/realmacsoftware06/png/blank.gif";
		</script>	
		<style type="text/css">

		img {
				behavior: url("../rw_common/themes/realmacsoftware06/png/pngbehavior.htc");
			}
		
		</style><![endif]-->
	</head>
<body>
	<div id="topbar"></div>
	<div id="pageHeader">
		<div id="title">
			
			<h1>iSounds</h1>
			<h2>Hear the sound of your i...</h2>
		</div>
		<div id="navcontainer"><ul><li><a href="../index.html" rel="self">Welcome</a></li><li><a href="../styled/index.html" rel="self">Developer Documentation</a></li><li><a href="../blog/page1.html" rel="self">News & updates</a></li><li><a href="index.php" rel="self" id="current">Submit to iSoundStore</a></li><li><a href="../contact-form/index.php" rel="self">Contact me</a></li></ul></div>
	</div>
	<div id="headerBottomGrad">
		<img src="../rw_common/themes/realmacsoftware06/images/bottom_grad.png" alt="" style="width: 3000px; height: 12px;" />
	</div>

	<div id="container">
		<div id="sidebarContainer">
			<div id="sidebar">
				<h1 class="sideHeader"></h1>
				
				
			</div>
		</div>
		
		<div id="contentContainer">
			<div id="content">
				
<div class="message-text"><?php echo $_SESSION['formMessage']; unset($_SESSION['formMessage']); ?></div><br />

<form action="./files/mailer.php" method="post" enctype="multipart/form-data">
	 <div>
		<label>Your Name:</label> *<br />
		<input class="form-input-field" type="text" value="<?php echo check('element0'); ?>" name="form[element0]" size="40"/><br /><br />

		<label>Your Email:</label> *<br />
		<input class="form-input-field" type="text" value="<?php echo check('element1'); ?>" name="form[element1]" size="40"/><br /><br />

		<label>Description:</label> *<br />
		<input class="form-input-field" type="text" value="<?php echo check('element2'); ?>" name="form[element2]" size="40"/><br /><br />

		<label>File:</label> *<br />
		<input type="file" name="element3" /><br /><br />

		<div style="display: none;">
			<label>Spam Protection: Please don't fill this in:</label>
			<textarea name="comment" rows="1" cols="1"></textarea>
		</div>
		<input type="hidden" name="form_token" value="<?php echo $security_token; ?>" />
		<input class="form-input-button" type="reset" name="resetButton" value="Reset" />
		<input class="form-input-button" type="submit" name="submitButton" value="Submit" />
	</div>
</form>

<br />
<div class="form-footer"><?php echo $_SESSION['formFooter']; unset($_SESSION['formFooter']); ?></div><br />

<?php unset($_SESSION['form']); ?>
			</div>
			<div class="clearer"></div>
			<div id="breadcrumbcontainer"></div>
		</div>

		<div id="footer">
			<p>&copy; 2011-EOL Vladislav Korotnev. Hosted by <a href="http://ig33kstas.com">iG33kstas!</a></p>
		</div>
	</div>
	<div id="footerBottomGrad">
		<img src="../rw_common/themes/realmacsoftware06/images/bottom_grad.png" alt="" style="width: 3000px; height: 12px;" />
	</div>
</body>
</html>
