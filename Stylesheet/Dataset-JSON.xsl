<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:odm="http://www.cdisc.org/ns/odm/v1.3" 
	xmlns:def="http://www.cdisc.org/ns/def/v2.x" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
<xsl:output method="text" version="1.0" encoding="UTF-8" indent="yes"/>

<!-- Root of the metadata -->
<xsl:variable name="root" select="/odm:ODM"/> 
	
<!-- Variables -->
<xsl:variable name="lf" select="'&#xA;'"/> 

<!-- Parameters -->
<xsl:param name="libname"/>
<xsl:param name="xpt" select="'N'"/>
<xsl:param name="pretty" select="'N'"/>
	
<xsl:template match="/"> 
	<xsl:choose>
		<xsl:when test="$xpt = ('N', 'Y') and $pretty = ('N', 'Y')"/>
		<xsl:otherwise>
			<xsl:message terminate="yes"/>
		</xsl:otherwise>
	</xsl:choose>	
	<xsl:variable name="fileOID" select="normalize-space($root/@FileOID)"/> 
	<xsl:variable name="studyOID" select="normalize-space($root/odm:Study/@OID)"/> 
	<xsl:variable name="metaDataVersionOID" select="normalize-space($root/odm:Study/odm:MetaDataVersion/@OID)"/> 
	<xsl:variable name="originator" select="normalize-space($root/@Originator)"/> 
	<xsl:text>%let __creationDateTime = %sysfunc(datetime(),is8601dt.);</xsl:text> 
	<xsl:value-of select="$lf"/> 
	<xsl:value-of select="$lf"/> 
	<xsl:text>%macro __checkds(__dsn);</xsl:text> 
  <xsl:value-of select="$lf"/> 
	<xsl:text>%global __nobs;</xsl:text> 
  <xsl:value-of select="$lf"/> 
  <xsl:value-of select="$lf"/> 
	<xsl:choose>
		<xsl:when test="upper-case($xpt) = 'Y'">
		  <xsl:text>%if %sysfunc(fileexist(&quot;</xsl:text> <xsl:value-of select="$libname"/> <xsl:text>/&amp;__dsn..xpt&quot;)) %then %do;;</xsl:text> 
		  <xsl:value-of select="$lf"/> 
		  <xsl:text>libname __tmp xport &quot;</xsl:text> <xsl:value-of select="$libname"/> <xsl:text>/&amp;__dsn..xpt&quot;;</xsl:text> 
		</xsl:when>
		<xsl:when test="upper-case($xpt) = 'N'">
		  <xsl:text>libname __tmp &quot;</xsl:text> <xsl:value-of select="$libname"/> <xsl:text>&quot;;</xsl:text> 
		  <xsl:value-of select="$lf"/> 
			<xsl:text>%if %sysfunc(exist(__tmp.&amp;__dsn.)) %then %do;</xsl:text> 
		</xsl:when>
		<xsl:otherwise/>		
	</xsl:choose>	
  <xsl:value-of select="$lf"/> 
	<xsl:value-of select="$lf"/> 
	<xsl:text>data __data_&amp;__dsn.;</xsl:text> 
  <xsl:value-of select="$lf"/> 
	<xsl:text> retain ITEMGROUPDATASEQ;</xsl:text> 
	<xsl:value-of select="$lf"/> 
	<xsl:text> set __tmp.&amp;__dsn.;</xsl:text> 
	<xsl:value-of select="$lf"/> 
	<xsl:text> ITEMGROUPDATASEQ+1;</xsl:text> 
	<xsl:value-of select="$lf"/> 
	<xsl:text>run;</xsl:text> 
	<xsl:value-of select="$lf"/> 
	<xsl:value-of select="$lf"/> 
	<xsl:text>%let __dsid = %sysfunc(open(__data_&amp;__dsn.,i));</xsl:text> 
  <xsl:value-of select="$lf"/> 
	<xsl:text>%let __nobs  = %sysfunc(attrn(&amp;__dsid.,nlobsf));</xsl:text> 
  <xsl:value-of select="$lf"/> 
	<xsl:text>%let __rc   = %sysfunc(close(&amp;__dsid.));</xsl:text> 
	<xsl:value-of select="$lf"/> 
	<xsl:text>libname __tmp clear;</xsl:text>   
	<xsl:value-of select="$lf"/> 
	<xsl:text>%end;</xsl:text> 
	<xsl:value-of select="$lf"/> 
	<xsl:text>%else %do;</xsl:text> 
	<xsl:value-of select="$lf"/> 
	<xsl:text>%let __nobs  = 0;</xsl:text> 
	<xsl:value-of select="$lf"/> 
	<xsl:value-of select="$lf"/> 
	<xsl:text>data __data_&amp;__dsn.;</xsl:text> 
	<xsl:value-of select="$lf"/> 
	<xsl:text>run;</xsl:text> 
	<xsl:value-of select="$lf"/> 
	<xsl:text>%end;</xsl:text> 		  
	<xsl:value-of select="$lf"/> 
 	<xsl:text>%mend __checkds;</xsl:text> 
  <xsl:value-of select="$lf"/> 
  <xsl:value-of select="$lf"/> 
  <xsl:for-each select="$root/odm:Study/odm:MetaDataVersion/odm:ItemGroupDef">
    <xsl:variable name="OID" select="@OID"/>
    <xsl:variable name="Name" select="@Name"/>
    <xsl:variable name="Data" select="if (@IsReferenceData = 'No') then 'clinicalData' else if (@IsReferenceData = 'Yes') then 'referenceData' else ' '"/>
    <xsl:variable name="Label" select="odm:Description/odm:TranslatedText"/>
		<xsl:text>%__checkds(</xsl:text> <xsl:value-of select="$Name"/> <xsl:text>);</xsl:text> 
		<xsl:value-of select="$lf"/> 
		<xsl:value-of select="$lf"/> 
		<xsl:text>filename __out  &quot;</xsl:text> <xsl:value-of select="$libname"/> <xsl:text>/</xsl:text><xsl:value-of select="$Name"/><xsl:text>.json&quot;;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:value-of select="$lf"/> 
		<xsl:text>proc json out=__out </xsl:text> <xsl:value-of select="if ($pretty = 'N') then 'nopretty' else if ($pretty = 'Y') then 'pretty' else 'nopretty'"/> <xsl:text> nosastags scan trimblanks nofmtcharacter nofmtdatetime nofmtnumeric;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>	write open object;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>		write values &quot;creationDateTime&quot; &quot;&amp;__creationDateTime. &quot;;</xsl:text> 
		<xsl:value-of select="$lf"/> 
		<xsl:text>		write values &quot;datasetJSONVersion&quot; &quot;1.0.0&quot;;</xsl:text> 
		<xsl:value-of select="$lf"/> 
		<xsl:if test="$fileOID">
			<xsl:text>		write values &quot;fileOID&quot; &quot;</xsl:text> <xsl:value-of select="$fileOID"/> <xsl:text>.</xsl:text> <xsl:value-of select="$Name"/> <xsl:text>&quot;;</xsl:text>
			<xsl:value-of select="$lf"/> 
		</xsl:if>
		<xsl:if test="$originator">
			<xsl:text>		write values &quot;originator&quot; &quot;</xsl:text> <xsl:value-of select="$originator"/> <xsl:text>&quot;;</xsl:text> 
			<xsl:value-of select="$lf"/>
		</xsl:if>
		<xsl:text>		write values &quot;</xsl:text> <xsl:value-of select="$Data"/> <xsl:text>&quot;;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>		write open object;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>			write values &quot;studyOID&quot; &quot;</xsl:text> <xsl:value-of select="$studyOID"/> <xsl:text>&quot;;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>			write values &quot;metaDataVersionOID&quot; &quot;</xsl:text> <xsl:value-of select="$metaDataVersionOID"/> <xsl:text>&quot;;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>			write values &quot;itemGroupData&quot;;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>			write open object;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>				write values &quot;</xsl:text> <xsl:value-of select="$OID"/> <xsl:text>&quot;;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>				write open object;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>					write values &quot;records&quot; &amp;__nobs.;</xsl:text>
		<xsl:value-of select="$lf"/>
		<xsl:text>					write values &quot;name&quot; &quot;</xsl:text> <xsl:value-of select="$Name"/> <xsl:text>&quot;;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<!--xsl:text>					write values &quot;label&quot; %sysfunc(quote(</xsl:text> <xsl:value-of select="$Label"/> <xsl:text>));</xsl:text-->
		<xsl:text>					write values &quot;label&quot; &quot;</xsl:text> <xsl:value-of select="$Label"/> <xsl:text>&quot;;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>					write values &quot;items&quot;;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>					write open array;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>						write open object;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>							write values &quot;OID&quot; &quot;ITEMGROUPDATASEQ&quot;;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>							write values &quot;name&quot; &quot;ITEMGROUPDATASEQ&quot;;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>							write values &quot;label&quot; &quot;Record identifier&quot;;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>							write values &quot;type&quot; &quot;integer&quot;;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>						write close;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:for-each select="odm:ItemRef">
			<xsl:variable name="ItemOID" select="@ItemOID"/>
			<xsl:variable name="OID" select="normalize-space($root/odm:Study/odm:MetaDataVersion/odm:ItemDef[@OID=$ItemOID]/@OID)"/>
			<xsl:variable name="Name" select="normalize-space($root/odm:Study/odm:MetaDataVersion/odm:ItemDef[@OID=$ItemOID]/@Name)"/>
			<xsl:variable name="Label" select="normalize-space($root/odm:Study/odm:MetaDataVersion/odm:ItemDef[@OID=$ItemOID]/odm:Description/odm:TranslatedText)"/>
			<xsl:variable name="DataType" select="normalize-space($root/odm:Study/odm:MetaDataVersion/odm:ItemDef[@OID=$ItemOID]/@DataType)"/>
			<xsl:variable name="Length" select="normalize-space($root/odm:Study/odm:MetaDataVersion/odm:ItemDef[@OID=$ItemOID]/@Length)"/>
			<xsl:variable name="DisplayFormat" select="normalize-space($root/odm:Study/odm:MetaDataVersion/odm:ItemDef[@OID=$ItemOID]/@def:DisplayFormat)"/>
			<xsl:variable name="KeySequence" select="@KeySequence"/>
			<xsl:text>						write open object;</xsl:text>
			<xsl:value-of select="$lf"/> 
			<xsl:text>							write values &quot;OID&quot; &quot;</xsl:text> <xsl:value-of select="$OID"/> <xsl:text>&quot;;</xsl:text>
			<xsl:value-of select="$lf"/> 
			<xsl:text>							write values &quot;name&quot; &quot;</xsl:text> <xsl:value-of select="$Name"/> <xsl:text>&quot;;</xsl:text>
			<xsl:value-of select="$lf"/> 
			<xsl:text>							write values &quot;label&quot; &quot;</xsl:text> <xsl:value-of select="$Label"/> <xsl:text>&quot;;</xsl:text>
			<xsl:value-of select="$lf"/> 
			<xsl:text>							write values &quot;type&quot; &quot;</xsl:text> 
				<xsl:choose>
					<xsl:when test="$DataType = 'text' or $DataType = 'datetime' or $DataType = 'date' or $DataType = 'time' or $DataType = 'partialDate' or $DataType = 'partialTime' or
					                $DataType = 'partialDatetime' or $DataType = 'incompleteDatetime' or $DataType = 'durationDatetime'">
						<xsl:text>string</xsl:text>
					</xsl:when>
					<xsl:when test="$DataType = 'integer'">
						<xsl:text>integer</xsl:text>
					</xsl:when>
					<xsl:when test="$DataType = 'float'">
						<xsl:text>float</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text></xsl:text>
					</xsl:otherwise>
				</xsl:choose> 
			 <xsl:text>&quot;;</xsl:text>
			<xsl:value-of select="$lf"/> 
			<xsl:if test="$Length">
				<xsl:text>							write values &quot;length&quot; </xsl:text> <xsl:value-of select="$Length"/> <xsl:text>;</xsl:text>
				<xsl:value-of select="$lf"/> 
			</xsl:if>
			<xsl:value-of select="$lf"/> 
			<xsl:if test="$DisplayFormat">
				<xsl:text>							write values &quot;displayFormat&quot; &quot;</xsl:text> <xsl:value-of select="$DisplayFormat"/> <xsl:text>&quot;;</xsl:text>
				<xsl:value-of select="$lf"/> 
			</xsl:if>
			<xsl:value-of select="$lf"/> 
			<xsl:if test="$KeySequence">
				<xsl:text>							write values &quot;keySequence&quot; </xsl:text> <xsl:value-of select="$KeySequence"/> <xsl:text>;</xsl:text>
				<xsl:value-of select="$lf"/> 
			</xsl:if>
			<xsl:text>						write close;</xsl:text>
			<xsl:value-of select="$lf"/> 
	      </xsl:for-each>
		<xsl:text>					write close;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>					write values &quot;itemData&quot;;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>					write open array;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>						export __data_</xsl:text> <xsl:value-of select="$Name"/> <xsl:text> / nokeys;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>					write close;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>				write close;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>			write close;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>		write close;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>	write close;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>run;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:value-of select="$lf"/> 
		<xsl:text>filename __out clear;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:value-of select="$lf"/> 
		<xsl:text>proc sql noprint;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>	drop table __data_</xsl:text><xsl:value-of select="$Name"/><xsl:text>;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text>quit;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:value-of select="$lf"/> 
  </xsl:for-each>
	<xsl:value-of select="$lf"/> 
	<xsl:text>%sysmacdelete __checkds;</xsl:text>   
</xsl:template> 
	
</xsl:stylesheet>