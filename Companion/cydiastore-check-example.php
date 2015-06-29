<?php

function urlsafe_b64encode($string) 
{
    $data = base64_encode($string);
    $data = str_replace(array('+','/','='),array('-','_',''),$data);
    return $data;
}

function validate_uuid($uuid)
{
	$request = array();
	$request['device']=$uuid;
	$request['host']=$_SERVER['REMOTE_ADDR']; // don't send this unless you're a phone
	$request['mode']="local";
	$request['nonce']=time();
	$request['product']="com.phoenix.musiccontrols";
	$request['timestamp']=time();
	$request['vendor']="phoenix";
	
	$secretkey = "**********************"; // get this from saurik
	
	ksort($request);
	$request_presign = http_build_query($request);
	
	$request['signature'] = urlsafe_b64encode(hash_hmac('sha1', $request_presign, $secretkey, true));
	
	$http_request = http_build_query($request);
	$request_url = "http://cydia.saurik.com/api/check?".$http_request;
	
	$fd = fopen($request_url,"r");
	$response_raw = "";
	if($fd)
	{
		while(!feof($fd))
		{
			$response_raw .= fgets($fd, 16384);
		}
		fclose($fd);
	}
		
	// If state=completed exists, we are authorized. Anything else and we are not.
	if($response_raw)
	{
		parse_str($response_raw, $response);
		$return_sig = $response['signature'];
		unset($response['signature']);
		
		ksort($response);
		
		$serialized_response = http_build_query($response);

		$return_chk = urlsafe_b64encode(hash_hmac('sha1', $serialized_response, $secretkey, true));
		
		if($response['state']=="completed" && $return_chk == $return_sig)
		{
			if(array_key_exists('payment', $response))
			{
				return $response['payment'];
			}
			else
			{
				return 1337;
			}
		}
	}
	return '';
}
//	$valid = validate_uuid("429f6e972a837141fe0b8be093697a8a0894d8e6");
?>

