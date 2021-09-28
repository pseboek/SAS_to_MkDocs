# README

## Background

There is hardly any modern documentation for a SAS project. It is possible to use doxygen to generate a documentation for SAS files but it lacks a modern style and the syntax highlighting sometimes is not correct. Therefore an alternative for an **HTML documentation generation with means of SAS, Python and MkDocs** is established.

---

## Requirements

- [SAS Base](https://www.sas.com/en_us/software/base-sas.html)
- [MkDocs](https://www.mkdocs.org/)
- [MkDocs-material](https://squidfunk.github.io/mkdocs-material/) 
- [Python](https://www.python.org/)

---

## Directory structure

### Main folder

File                            | Explanation
:---                            | :---
extra.css                       | defines some style sheets for mkdocs; gets copied into the docs folder
extra.js                        | defines some javascript routines for mkdocs; gets copied into the docs folder
generate_documentation.py       | main python script to generate the html documentation
index.md                        | defines the landing page of the mkdocs documentation; gets copied into the docs folder
kmf/\*.kmf						| automaticcaly generated code snippets (.kmf)
mkdocs.yml                      | is generated by **generate_documentation.py**; combines mkdocs1.yml-mkdocs3.yml
mkdocs1.yml                     | static content for the first part of the yaml file (fix content)
mkdocs2.yml                     | variable part of the yaml file (navigation of project structure)
mkdocs3.yml                     | static content for the last part of the yaml file (fix content)
ps_DeleteUnneccessaryFiles.ps1  | delete unneeded files in folder MACROS (png, jpg, doc, xls, ...)
ps_ListReadOnlyFiles.ps1        | lists all read-only files in project folder (all files have to be editable!)
README.md                       | Project description
sas_mkdocs.log                  | Log file when SAS script is executed
sas_mkdocs.lst                  | Log file when SAS script is executed
sas_mkdocs.sas                  | SAS script to generate the filestructure; is called in **generate_documentation.py** 

---

### docs

All generated Markdown files are saved to the docs folder. A subdirectory for all images exists as well.

### MACROS

This is the folder where all the project SAS files need to be copied into.

### pics

All images (e.g. favicon) for the mkdocs documentation are saved in the pics folder. The whole directory is copied into the docs folder while the HTML documentation is generated.

### sites

Each folder in the sites directory is build by mkdocs, i.e. the HTML documentation. The site folder (when run `mkdocs build`) was manually renamed after the project. 

---

## Instructions

1. Empty the folder MACROS

2. **Copy all project files** into the folder MACROS for which an HTML documentation should be generated.

3. Run the Powershell script **ps_DeleteUnneccessaryFiles.ps1** in order to delete unneeded files and reduce the size of the directory.

4. Run the Powershell script **ps_ListReadOnlyFiles.ps1** in order to identify whether there are read-only files in the Project (in folder MACROS). Only if there are no read-only files, the generation of the HTML documentation will be successful. (Possibly the folder docs has to be deleted (if the Python script fails with an error regarding the docs folder).)

5. Run the Python script **generate_documentation.py** in order to generate the documentation (depending on the project size it can last up to 2-3 minutes). In the python script the **path to the SAS executable** has to be specified!

6. Run `mkdocs serve` to see if the documentation runs correctly under **http://localhost:8000/**.

7. Run `mkdocs build` to generate the mkdocs documentation for the project.

8. Copy the new site folder into the **sites** folder and rename it according to your project.

---

Possibly the generated mkdocs.yml file has to be opened and saved again if following error occurs:)

    `MkDocs encountered as error parsing the configuration file: unacceptable character #x00c4: invalid continuation byte in "...\mkdocs.yml", position ...`

---

## MkDocs Documenation

In the following example the mkdocs documentation illustrates the generated HTML output for the SAS routine **export_to_xlsx_csv**. A description as well as some details are shown. Next, the usage and the parameters of the routine are described. The return value is listed and a warning is displayed if needed. Finally, the version and author along with the SAS code are listed.

![example1](https://github.com/pseboek/SAS_to_MkDocs/blob/master/img/p1.PNG)
![example2](https://github.com/pseboek/SAS_to_MkDocs/blob/master/img/p2.PNG)
![example3](https://github.com/pseboek/SAS_to_MkDocs/blob/master/img/p3.PNG)

---

One of the main benefits of the generated html documentation is that a **search** can be performed across all documents.

![search](https://github.com/pseboek/SAS_to_MkDocs/blob/master/img/p4.PNG)

---

Additionally, a syntax highlighting is included for all SAS routines.

![syntaxhighlighting](https://github.com/pseboek/SAS_to_MkDocs/blob/master/img/p5.PNG)

---

## Automatically generated kmf files

Code abbreviations (snippets) in SAS can be used in all 3 environments: SAS Studio, SAS Display Manager, and SAS EG. To use snippets in SAS DM or SAS EG, kmf files are needed. A PhUSE paper from 2012 was modified to automatically generate the snippets for all SAS syntax files in the project. This is achieved by exctracting all necessary information like the MACRO name and the signature. 

In order to track every change in the underlying SAS syntax files and to generate up-to-date kmf files, a **post-commit hook** is added to the project.

[PhUSE 2012](https://www.google.de/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&ved=2ahUKEwjInoWPkPvyAhXVRfEDHXfTC28QFnoECAIQAQ&url=https%3A%2F%2Fwww.lexjansen.com%2Fphuse%2F2012%2Fcc%2FCC03.pdf&usg=AOvVaw3tv8XUPG8rdPJQOAP_nqHB)

---

PS | 2021
