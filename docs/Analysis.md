# Analysis




---
## quali1



### Description

 Generates a table of two qualitative variables with descriptive measures such as n and %.




### Details



Example with Macro Call

**Usage:**

	%quali1(DS=SASHELP.Cars, qualiVari=Origin, qualiLab=Origin, groupVari=Type, groupLabel=Type);
	%quali1(DS=SASHELP.Baseball, qualiVari=League, qualiLab=League, groupVari=Team, groupLabel=Team);
	
**Parameter:**

Parameter           | Explanation
:---           		| :---
**DS**      		| dataset name in SAS
**qualiVari**       | qualitative variable
**qualiLab**   		| label of qualitative variable
**groupVari**   	| variable of grouping 
**groupLabel**   	| label of grouping variable




### Return value

 Output table with descriptive measures




### Version

 1.0



### Author

 Philipp Seboek



```sas
%macro quali1(DS=, qualiVari=, qualiLab=, groupVari=, groupLabel=);
	PROC TABULATE DATA=&DS. MISSING;
		CLASS &groupVari. &qualiVari. / ORDER=FORMATTED;
		TABLE &groupVari. ,  &qualiVari. * (N='Frequency'*F=NUMX12.0 ROWPCTN='Percentage in %'*F=NUMX12.2) ALL="Total"*F=NUMX12.0 /misstext='0' ;
		LabEL &qualiVari.="&qualiLab." &groupVari.="&groupLabel.";
	RUN;
%mend;
```







---
## quanti1



### Description

 Generates a table of a quantitative variable with descriptive figures such as mean, median, std.




### Details



Example with Macro Call

**Usage:**

	%quanti1(DS=SASHELP.Cars, quantiVari=Invoice, quantiLab=Invoice, grpVari=Origin, grpLabel=Origin);
	%quanti1(DS=SASHELP.Stocks, quantiVari=Volume, quantiLab=Volume, grpVari=Stock, grpLabel=Stock);
	
**Parameter:**

Parameter           | Explanation
:---           		| :---
**DS**      		| dataset name in SAS
**quantiVari**      | quantitative variable
**quantiLab**   	| label of quantitative variable
**grpVari**   		| variable of grouping 
**grpLabel**   		| label of grouping variable




### Return value

 Output table with descriptive measures




### Version

 1.0



### Author

 Philipp Seboek



```sas
%macro quanti1(DS=, quantiVari=, quantiLab=, grpVari=, grpLabel=);
	PROC TABULATE DATA=&DS. MISSING;
	Class &grpVari.;
		VAR  &quantiVari.;
		TABLE &grpVari., &quantiVari. *(N='Frequency'*F=NUMX12.0 MEAN='Mean'*F=NUMX12.2  MEDIAN='Median'*F=NUMX12.2 
			STD='STD'*F=NUMX12.2 CV='CV'*F=NUMX12.2  MIN='Minimum'*F=NUMX12.2  p25='25%-Quantil'*F=NUMX12.2 
			P75='75%-Quantil'*F=NUMX12.2 MAX='Maximum'*F=NUMX12.2 NMISS='Missing'*F=NUMX12.0) ;
		LABEL &quantiVari.="&quantiLab." &grpVari.="&grpLabel.";
		FORMAT &grpVari.;
	RUN;
%mend;
```






