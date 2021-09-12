%let path = C:\SAS_to_MkDocs\;
Filename filelist pipe "dir /b /s &path*.sas"; 
                                                                                   
Data files;    
	nr + 1; 
	Infile filelist truncover;
	Input filename $400.;
	Put filename=;
    
	file_sas = substr(filename,length(filename) - length(scan(filename,-1,'\')) + 1,100);
	file_md = tranwrd(file_sas, ".sas", ".md");
	file_md = file_md;
	file_name = substr(file_sas,1,length(file_sas)-4);
	file_yml = cats(file_name, ': ''', file_md, '''');
	
	folder = substr(filename, 1, length(filename) - length(scan(filename,-1,'\')));
	mainfolder = "&path";
	subfolder = tranwrd(folder, "&path", "");
	lag_subfolder = lag(subfolder);

	if subfolder ne lag_subfolder then change=1; else change=0;

	ebene=1;
	do while(scan(subfolder, ebene, "\") ne "");
		ebene+1;
	end;
	ebene = ebene - 1;
	
	*if change = 0 and ebene = 0 then yml = cats('09'x, '- ', file_yml);
	if change = 0 and ebene = 0 then yml = cats('09'x, '09'x, '- ', subfolder, ':', '0a'x, '09'x, '09'x, '- ', file_yml);
	if change = 1 and ebene = 0 then yml = cats('09'x, '- ', subfolder, ':', '0a'x, '09'x, '09'x, '- ', file_yml);
	if change = 1 and ebene = 1 then yml = cats('09'x, '- ', subfolder, ':', '0a'x, '09'x, '09'x, '- ', file_yml);
	if change = 1 and ebene = 2 then yml = cats('09'x, '- ', subfolder, ':', '0a'x, '09'x, '09'x, '- ', file_yml);
	if change = 1 and ebene = 3 then yml = cats('09'x, '- ', subfolder, ':', '0a'x, '09'x, '09'x, '- ', file_yml);
	if change = 1 and ebene = 4 then yml = cats('09'x, '- ', subfolder, ':', '0a'x, '09'x, '09'x, '- ', file_yml);
	if change = 1 and ebene = 5 then yml = cats('09'x, '- ', subfolder, ':', '0a'x, '09'x, '09'x, '- ', file_yml);
	if change = 1 and ebene = 6 then yml = cats('09'x, '- ', subfolder, ':', '0a'x, '09'x, '09'x, '- ', file_yml);
	if change = 0 and ebene = 1 then yml = cats('09'x, '09'x, '- ', file_yml);
	if change = 0 and ebene = 2 then yml = cats('09'x, '09'x, '- ', file_yml);
	if change = 0 and ebene = 3 then yml = cats('09'x, '09'x, '- ', file_yml);
	if change = 0 and ebene = 4 then yml = cats('09'x, '09'x, '- ', file_yml);
	if change = 0 and ebene = 5 then yml = cats('09'x, '09'x, '- ', file_yml);
	if change = 0 and ebene = 6 then yml = cats('09'x, '09'x, '- ', file_yml);

	ebene = ebene - 1;
	if ebene < 0 then delete;

Run; 

data _null_;
  set files;
  file "&path.mkdocs2.yml";
  *file "&path.mkdocs2.yml" encoding="utf-8";
  put yml;
  file print;
  put yml;
run;

