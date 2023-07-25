# Dataset-JSON from Define.xml and SAS datasets

## Description

The main purpose is to create Dataset-JSON files using SAS Procedure XSL. SAS code is generated from a Define.xml using a XSL stylesheet (Dataset-JSON.xsl).

The stylesheet is located in "Stylesheet" folder of this directory. A sample SAS program called "Dataset-JSON.sas" is available in the "Examples" folder. You'll need to update the placeholders <Your path> for the program to execute properly. 

Parameters "pretty" and "xpt" are optional and accept either "Y" or "N" as possible values. They are set to "N" by default.

Also available in this folder are sub-folders with dummy define files and their associated SAS7BDAT and XPT datasets.

The stylesheet is compatible for both Define 2.0 and 2.1 versions.

## Example of SAS program call:

filename xmlfile "C:\Temp\define.xml";

filename xslfile "C:\Folder\Stylesheet\Dataset-JSON.xsl";

filename outfile temp;

proc xsl in=xmlfile xsl=xslfile out=outfile;

parameter "libname" = "C:\Temp" "pretty" = "N" "xpt" = "N";

run;

%inc outfile;

filename xmlfile clear;

filename xslfile clear;

filename outfile clear;

## Feedback
This is a first draft version and comments are welcomed.
