while (<>) {
	s/<</“/g; 
	s/>>/”/g;
	s/\\h /\\h \n\\tx /;
	s/\\li1 /\\li1 \n\\tx /;
	s/\\m /\\m \n\\tx /;
	s/\\mt /\\mt \n\\tx /;
	s/\\mt1 /\\mt1 \n\\tx /;
	s/\\mt2 /\\mt2 \n\\tx /;
	s/\\p /\\p \n\\tx /;
	s/\\pi /\\pi \n\\tx /;
	s/\\q /\\q \n\\tx /;
	s/\\q1 /\\q1 \n\\tx /;
	s/\\q2 /\\q2 \n\\tx /;
	s/\\q /\\q \n\\tx /;
	# s/\\r /\\r \n\\tx /;
	s/\\s /\\s \n\\tx /;
	s/(\\v [0-9]+(\-[0-9]+)* )/$1\n\\tx /;
	s/(\\v [0-9]+(\-[0-9]+)*\n)/$1\\tx /;
# inline formatting is kept, but a space is added so that it's not a part of the word
	s/([\S])\\/$1 \\/g;
	s/\-/~/g; #hyphen is used for morpheme breaking, change to tilde
	s/([0-9])~([0-9])/$1\-$2/g; #change back tilde when a verse bridge.
		s/> ”/>”/g;
	print;
}