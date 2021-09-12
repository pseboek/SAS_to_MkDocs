/**
@macro datasetexist
@brief Checks if a dataset exists.

@details

Example with Macro Call

**Usage:**

	%datasetexist(file=SASHELP.cars);
	%datasetexist(file=SASHELP.cars2);
	%datasetexist(file=work.cars2);
	
**Parameter:**

Parameter           | Explanation
:---           		| :---
**file**      		| Dataset name with Libname (e.g. SASHELP.cars)

@return Output if dataset exists or not
@warning  An **error** can occur if the user does not have the **appropriate authorization level for a library** (e.g. SASHELP).

@version 1.0
@author Philipp Seboek
**/
%macro datasetexist(file=);
	%if %sysfunc(exist(&file.))>0 %then %do;
		%put Dataset Exists ;
	%end;
	%else %do ;
		%put Dataset doesnt Exists ;
		Data &file.;value='XX';RUN;
	%end ; 
%mend;

/**
@macro export_to_xlsx_csv
@brief Export all tables of a database to either xlsx or csv

@details

**Prerequisites:**

An **ODBC datasource** must be configured for the database that should be exported,
so that SAS can work with that database.

Example with Macro Call

**Usage:**

	%export_to_xlsx_csv(db=test, lib=bot_db, xlsx_csv=csv);
	%export_to_xlsx_csv(db=test, lib=bot_db, xlsx_csv=xlsx);
	%export_to_xlsx_csv(db=test, lib=test, xlsx_csv=csv);
	%export_to_xlsx_csv(db=test, lib=test, xlsx_csv=xlsx);
	
**Parameter:**

Parameter           | Explanation
:---           		| :---
**db**      		| database name in MySQL
**lib**      		| SAS library name (-> max 8 characters!)
**xlsx_csv**   		| Export format: xlsx (Excel) or csv (CSV)

@return Database table as csv or xlsx file
@warning

!!! info "Warning"
	It is neccessary to configure an **ODBC datasource**. See Prerequisites!

@version 1.0
@author Philipp Seboek
**/
%macro export_to_xlsx_csv(db=, lib=, xlsx_csv=);
	*Make data from MySQL available in SAS;
	*An ODBC connection with a DSN needs to be configured;
	LIBNAME &lib ODBC DATABASE=mysql DSN=&lib SCHEMA=&db;

	*Write all tables of a schema into a macro variable (without a pattern like prf_ or view_);
	%global tablelist;
	Proc sql noprint;
		select memname into :tablelist separated by ' '
	    from sashelp.vmember
	    where libname = %UPCASE("&lib") 
	      and memname not like 'prf_%'
	      and memname not like 'view_%';
	quit; 
	%put tablelist=&tablelist;
	
	*Create directory for csv files;
	options dlcreatedir;
	libname newdir "C:/&lib";

	*Export to CSV or XLSX;
	%local i next_value;
	%let i=1;
	%do %while (%scan(&tablelist, &i) ne );
	   	%let next_value = %scan(&tablelist, &i);
	   	data &next_value;
	   	set &lib..&next_value;run;
		%if &xlsx_csv=csv %then
			%do;
				%ds2csv(data=work.&next_value, runmode=b, csvfile=c:\&db\&next_value..csv);
			%end;
		%else %if &xlsx_csv=xlsx %then
			%do;
				PROC EXPORT 
				  DATA=WORK.&next_value. 
				  DBMS=xlsx 
				  OUTFILE="C:\&db\&next_value" 
				  REPLACE;
				run;
			%end;
		%let i = %eval(&i + 1);
	%end;
%mend;
