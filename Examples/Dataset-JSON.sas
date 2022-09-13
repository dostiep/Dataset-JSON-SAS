filename xmlfile "<Your-path>\define.xml";
filename xslfile "<Your-path>\Dataset-JSON.xsl";
filename outfile temp;

proc xsl in=xmlfile xsl=xslfile out=outfile;
	parameter "libname" = "<Your-path>"
	          "pretty" = "N";
run;

%inc outfile;

filename xmlfile clear;
filename xslfile clear;
filename outfile clear;
