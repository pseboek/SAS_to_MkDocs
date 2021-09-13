%macro generate_kmf(path=, file=);

	libname kmf "&path" memlib;

	data kmf._kmf_input;
		infile "&path&file";
		input line & $500.;
		if line =: '%macro ';

		_KMF_seq + 1;

		find_end = find(line, '(');
		_KMF_name = "%" || substr(line, 8, find_end - 8);


		_KMF_inStr = compress(tranwrd(line, "macro ", ""));

		drop line find_end;
	run;
%mend;

%macro KMFgenerator(inDS_=, outLoc_=, outFile_=, del_= YES);
	%* activate options compress if this is not yet the case (and store current setting);
	%let _KMG_compress = %sysfunc(getoption(compress, keyword));
	options compress = YES;
	%let _KMG_abort = N;

	%* STAGE 0: ERROR HANDLING;
	%* -----------------------;
	%* error handling and parameter checking is not foreseen (not in the scope of this paper);
	%* STAGE 1: PREPARE ALL INFORMATION TO CONSTRUCT LINES FOR KMF FILE;
	%* ----------------------------------------------------------------;
	%if &_KMG_abort = N %then
		%do;
			%* determine number of definitions provided;
			%let _KMG_dsid = %sysfunc(open(&inDS_,in));
			%let _KMG_noDef = %sysfunc(attrn(&_KMG_dsid,nobs));

			%* retrieve length of name and instr variable provided for use further on;
			%let _KMG_varno = %sysfunc(varnum(&_KMG_dsid, _KMF_name));
			%let _KMG_nameLen = %sysfunc(varlength(&_KMG_dsid, &_KMG_varno));
			%let _KMG_varno = %sysfunc(varnum(&_KMG_dsid, _KMF_instr));
			%let _KMG_instrLen = %sysfunc(varlength(&_KMG_dsid, &_KMG_varno));
			%let _KMG_rc = %sysfunc(close(&_KMG_dsid));

			%* define flexible parts in the KMF file;
			%* details on calculations below are in the paper;
			data _KMG_prep / view = _KMG_prep;
				retain seqno _KMF_name _KMF_instr noLinesIS;
				set &inDS_;

				%* only for first record, define number of definitions;
				if _N_ = 1 then
					do;
						%* translate regular numbers into bytes;
						noDef = &_KMG_noDef;
						tmpByteD2 = floor(noDef/256);
						tmpByteD1 = noDef - (tmpByteD2*256);

						*TVC: use mod function;
						noDefByte = byte(tmpByteD1) || byte(tmpByteD2) || byte(0) || byte(0);
					end;

				%* define number of lines in the insert string;
				noLinesIS = strip(put(count(_KMF_inStr, byte(13)) + 1, best32.));

				%* put sequence number into char;
				seqno = strip(put(_KMF_seq, best3.));

				%* define the number of characters in definition;
				%* - length of name and insert string changes;
				%* - length of sequence number and number of lines in insert string also changes;
				%* - 21 is the amount of characters in the definition that does not change;
				noChar = sum(length(strip(_KMF_name)), length(strip(_KMF_inStr)),
					length(noLinesIS), length(seqno), 21);
				tmpByteC2 = floor(noChar/256);
				tmpByteC1 = noChar - (tmpByteC2*256);
				noCharByte = byte(tmpByteC1) || byte(tmpByteC2) || byte(0) || byte(0);
				drop tmpByte: _KMF_seq;
			run;

		%end;

	%* STAGE 2: CONSTRUCT ENTIRE LINES FOR KMF FILE;
	%* --------------------------------------------;
	%if &_KMG_abort = N %then
		%do;

			data _KMG_lines / view=_KMG_lines;
				retain seqno;
				length line1 $15 line2 $1 line3 $&_KMG_nameLen line4 $1 line5 $1 line6 $3 line7 $1
					line8 $32 line9 $&_KMG_instrLen line10 $3 line11 $1;
				set _KMG_prep;

				%* following lines contain fixed text;
				retain line2 '3' line4 '' line5 '1' line6 '332' line7 '1' line11 '1';

				%* first line: number of characters (+ number of definition for first definition);
				if _N_ = 1 then
					line1 = 'KM' || byte(0) || byte(2) || noDefByte || noCharByte || '252';
				else line1 = noCharByte || '252';

				%* line three contains definition name;
				line3 = strip(_KMF_name);

				%* line eight contains number of lines in insert string;
				line8 = strip(noLinesIS);

				%* line nine contains insert string;
				line9 = strip(_KMF_inStr);

				%* second to last line contains definition sequence number;
				line10 = strip(seqno);
				keep seqno line:;
			run;

		%end;

	%* STAGE 3: CREATE KMF FILE;
	%* ------------------------;
	%if &_KMG_abort = N %then
		%do;
			filename _KMG_out "&outLoc_\&outFile_";

			%* note line4 is not output, since it is always an empty line;
			data _null_;
				set _KMG_lines;
				file _KMG_out termstr=NL lrecl=32767;
				put line1;
				put line2;
				put line3;
				put;
				put line5;
				put line6;
				put line7;
				put line8;
				put line9;
				put line10;
				put line11;
			run;

			filename _KMG_out;
		%end;

	%* restore original setting;
	options &_KMG_compress;

	%if %upcase(&del_) = YES %then
		%do;

			proc datasets nolist;
				delete _KMG_: / memtype=VIEW;
			quit;

		%end;
%mend KMFgenerator;

%let path1 = C:\SAS_to_MkDocs\MACROS\;
%let path2 = C:\SAS_to_MkDocs\kmf\;

%generate_kmf(path=&path1, file=Analysis.sas);
%KMFgenerator(inDS_ = kmf._kmf_input, outLoc_ = &path2, outFile_ = Analysis.kmf);

%generate_kmf(path=&path1, file=Datamanagement.sas);
%KMFgenerator(inDS_ = kmf._kmf_input, outLoc_ = &path2, outFile_ = Datamanagement.kmf);

%generate_kmf(path=&path1, file=Environment\Environment.sas);
%KMFgenerator(inDS_ = kmf._kmf_input, outLoc_ = &path2, outFile_ = Environment.kmf);

%generate_kmf(path=&path1, file=Filemanagement.sas);
%KMFgenerator(inDS_ = kmf._kmf_input, outLoc_ = &path2, outFile_ = Filemanagement.kmf);

%generate_kmf(path=&path1, file=Utilities.sas);
%KMFgenerator(inDS_ = kmf._kmf_input, outLoc_ = &path2, outFile_ = Utilities.kmf);

