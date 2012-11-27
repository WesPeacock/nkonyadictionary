	print `scripts\\guidgencmd`;
	print "\n";
	
	 use Data::UUID;

   # this creates a new UUID in string form, based on the standard namespace
   # UUID NameSpace_URL and name "www.mycompany.com"

   $ug = new Data::UUID;
   $uuid = $ug->create();
	print $ug->to_string($uuid), "\n";
   $ug = new Data::UUID;
	$uuid = $ug->create();
	print $ug->to_string($uuid), "\n";
