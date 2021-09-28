# Autoexec






### Description

 Include all .sas files during a SAS session.




### Version

 1.0



### Author

 Philipp Seboek



```sas
%let path = C:\MACROS\;

%include "&path.Analysis.sas";
%include "&path.Datamanagement.sas";
%include "&path.Environment.sas";
%include "&path.Filemanagement.sas";
%include "&path.Utilities.sas";
```
