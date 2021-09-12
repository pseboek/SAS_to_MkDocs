import glob, re, io, shutil, os, sys, subprocess
from shutil import copyfile
from pathlib import Path

PATH1 = r"C:\SAS_to_MkDocs"
PATH2 = r"C:\SAS_to_MkDocs\docs"

# Execute SAS script to generate variable yaml file
def call_sas_script():
    cmd = 'C:\\Program Files\\SAS\SASFoundation\\9.2(32-bit)\\Sas.exe -SYSIN ' + PATH1 + '\\sas_mkdocs.sas -NOSPLASH -ICON'
    #cmd = 'C:\\Program Files\\SASHome\\SASFoundation\\9.4\\Sas.exe -SYSIN ' + PATH1 + '\\sas_mkdocs.sas -NOSPLASH -ICON'
    subprocess.call(cmd)

# Copy .sas files to .md files
def copy_sas_to_md(src, dest):
    #shutil.rmtree(src + r"\docs", ignore_errors=True)
    dir_path = PATH2
    try:
        shutil.rmtree(dir_path)
    except OSError as e:
        print("Error: %s : %s" % (dir_path, e.strerror))

    os.mkdir("docs")

    for file_path in glob.glob(os.path.join(src, '**', '*.sas'), recursive=True):
        new_path = os.path.join(dest, os.path.basename(file_path))
        shutil.copy(file_path, new_path)
    
    os.mkdir("docs\pics")

    shutil.copy2("pics\\favicon.ico", "docs\\pics\\favicon.ico")
    shutil.copy2("extra.js", "docs\\extra.js")
    shutil.copy2("extra.css", "docs\\extra.css")
    #shutil.copy2("index.md", "docs\\index.md")

# Rename .sas files to .md files
def replace_sas_with_md(path):
    for filename in glob.iglob(os.path.join(path, '*.sas')):
        os.rename(filename, filename[:-4] + '.md')

# Replace *Umlaute* in filenames
def replace_ae():
    counter = 0
    path = PATH2
    for file in os.listdir(path):
        if file.endswith(".md"):
            if file.find("ä") > 0:
                counter = counter + 1
                os.rename(os.path.join(path, file), os.path.join(path, file.replace("ä", "ae")))
    if counter == 0:
        print("No file has been found")
def replace_oe():
    counter = 0
    path = PATH2
    for file in os.listdir(path):
        if file.endswith(".md"):
            if file.find("ö") > 0:
                counter = counter + 1
                os.rename(os.path.join(path, file), os.path.join(path, file.replace("ö", "oe")))
    if counter == 0:
        print("No file has been found")
def replace_ue():
    counter = 0
    path = PATH2
    for file in os.listdir(path):
        if file.endswith(".md"):
            if file.find("ü") > 0:
                counter = counter + 1
                os.rename(os.path.join(path, file), os.path.join(path, file.replace("ü", "ue")))
    if counter == 0:
        print("No file has been found")

# Generate YAML File for MkDocs
def combine_yml():
    with open('mkdocs.yml','wb') as wfd:
        for f in ['mkdocs1.yml','mkdocs2.yml','mkdocs3.yml']:
            with open(f,'rb') as fd:
                shutil.copyfileobj(fd, wfd)

# Replace Strings for YAML file
def yaml_replacements():
    fin = open(PATH1 + "\\mkdocs.yml", "rt", errors='ignore', encoding="cp437")
    data = fin.read()
    data = data.replace('\t-', '\t - ')
    data = data.replace('\t', '  ')
    data = data.replace('\:', ':')
    data = data.replace("\n   - sas_mkdocs: 'sas_mkdocs.md'","")
    data = data.replace("ö","oe")
    data = data.replace("ü","ue")
    data = data.replace("ä","ae")
    data = data.replace("ß","ss")
    data = data.replace("�","")
    data = data.replace("MACROS\\","")
    data = data.replace("MACROS:","SASFiles:")
    data = data.replace("\n \n", "\n")
    fin.close()
    fin = open(PATH1 + "\\mkdocs.yml", "wt", errors='ignore')
    fin.write(data)
    fin.close()

# Copy of SAS scripts to Doku folder
def copySAStoMD(file):
    src = file + '.md'
    dst = file + '_temp.md'
    copyfile(src, dst)

# Replace Strings for Markdown Syntax/Output
def replaceStrings(file):
    f1 = file + '_temp.md'
    f2 = file + '.md'
    with open(f1, "rt", encoding="ISO-8859-1") as fin:
        with open(f2, "wt", encoding="UTF-8") as fout:
        #with open(f2, "wt", encoding="ISO-8859-1") as fout:
            #fout.write("# " + file.split("\\")[-1] + "\n\n```sas\n")
            fout.write("# " + file.split("\\")[-1] + "\n\n\n")
            for line in fin:
                fout.write(line.replace("/**","")
                               .replace("@macro","\n---\n##")
                               .replace("@brief","\n\n\n### Description\n\n")
                               .replace("**/","\n\n\n```sas")
                               .replace("%mend;","%mend;\n```\n\n\n\n")
                               .replace("@details","\n\n\n### Details\n\n")
                               .replace("@return","\n\n\n### Return value\n\n")
                               .replace("@warning","\n\n\n### Warning\n\n")
                               .replace("@version","\n\n\n### Version\n\n")
                               .replace("@author","\n\n\n### Author\n\n")
                               .replace("/*```*/","```")
                               .replace("ö","oe")
                               .replace("ü","ue")
                               .replace("ä","ae")
                               .replace("ß","ss")
                ) 
    with open(f2, 'r') as original: data = original.read()
    with open(f2, 'w') as modified: modified.write(data + "\n")  
    #with open(f2, 'w') as modified: modified.write("\n\n```sas\n" + data + "\n```")     

# Delete all _temp files
def deleteTemp(path):
    for p in Path(path).glob("*_temp.md"):
        p.unlink()

# Copy SAS to MD: copySAStoMD() + replace strings: replaceStrings()
def replace_and_copy_sas_to_md(path):
    for filename in glob.iglob(os.path.join(path, '*.md')):
        copySAStoMD(filename[:-3])
        replaceStrings(filename[:-3])

# Function calls
call_sas_script()
copy_sas_to_md(PATH1,"docs")
replace_sas_with_md(PATH2)
replace_ae()
replace_oe()
replace_ue()
combine_yml()
yaml_replacements()
os.remove(PATH2 + "\\sas_mkdocs.md") 
replace_and_copy_sas_to_md(PATH2)
deleteTemp('docs\\')
shutil.copy2("index.md", "docs\\index.md")