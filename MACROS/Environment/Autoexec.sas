/**
@brief Include all .sas files during a SAS session.

@version 1.0
@author Philipp Seboek
**/
%let path = C:\MACROS\;

%include "&path.Analysis.sas";
%include "&path.Datamanagement.sas";
%include "&path.Environment.sas";
%include "&path.Filemanagement.sas";
%include "&path.Utilities.sas";
/*```*/