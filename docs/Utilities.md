# Utilities




---
## mf_existds



### Description

 Checks whether a dataset OR a view exists.




### Details

 Source: https://github.com/macropeople/macrocore

Can be used in open code, eg as follows:

	%if %mf_existds(libds=work.someview) %then %put  yes it does!;

!!! info "Info"
	Some databases have case sensitive tables, for instance POSTGRES
    with the preserve_tab_names=yes libname setting.  This may impact
    expected results (depending on whether you 'expect' the result to be
    case insensitive in this context!)

Example with Macro Call

**Usage:**

	%put %mf_existds(libds=work.cars);
	%put %mf_existds(libds=sashelp.cars);
	
**Parameter:**

Parameter           | Explanation
:---           		| :---
**libds**      		| Libname.Dataset




### Return value

 Returns 0 if dataset does not exist, returns 1 if is exists




### Warning

 
!!! info "Warning"
	Untested on tables registered in metadata but not physically present




### Version

 1.0



### Author

 Philipp Seboek



```sas
%macro mf_existds(libds);
  /*/STORE SOURCE*/
  %if %sysfunc(exist(&libds)) ne 1 & %sysfunc(exist(&libds,VIEW)) ne 1 %then 0;
  %else 1;
%mend;
```





