<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 

	xmlns:odm="http://www.cdisc.org/ns/odm/v1.3" 
	xmlns:def="http://www.cdisc.org/ns/def/v2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:fn="http://www.w3.org/2005/xpath-functions">
	
<xsl:output method="text" version="1.0" encoding="UTF-8" indent="yes"/>

<!-- Root of the metadata -->
<xsl:variable name="root" select="/odm:ODM"/> 
	
<!-- Variables -->
<xsl:variable name="lf" select="'&#xA;'"/> 

<!-- Parameters -->
<xsl:param name="libname"/>

	
<xsl:template match="/"> 

    <xsl:text>libname __tmp &quot;</xsl:text> <xsl:value-of select="$libname"/> <xsl:text>&quot;;</xsl:text> 
    <xsl:value-of select="$lf"/> 
    <xsl:value-of select="$lf"/> 
    <xsl:for-each select="$root/odm:Study/odm:MetaDataVersion/odm:ItemGroupDef">
        <xsl:variable name="OID" select="@OID"/>
        <xsl:variable name="SASDatasetName" select="@SASDatasetName"/>
        
		<xsl:text>%let __dsid = %sysfunc(open(__tmp.</xsl:text> <xsl:value-of select="$SASDatasetName"/> <xsl:text>,i));</xsl:text> 
		<xsl:value-of select="$lf"/> 
		<xsl:text>%let __nobs  = %sysfunc(attrn(&amp;__dsid.,nlobsf));</xsl:text> 
		<xsl:value-of select="$lf"/> 
		<xsl:text>%let __rc   = %sysfunc(close(&amp;__dsid.));</xsl:text> 
		<xsl:value-of select="$lf"/> 
		<xsl:value-of select="$lf"/> 
		
		
		<xsl:text>data __metadata_cols_</xsl:text> <xsl:value-of select="$SASDatasetName"/> <xsl:text>;</xsl:text>
		<xsl:text> retain ITEMGROUPDATASEQ;</xsl:text>
		<xsl:text> set __tmp.</xsl:text> <xsl:value-of select="$SASDatasetName"/> <xsl:text>;</xsl:text>
		<xsl:text> ITEMGROUPDATASEQ+1;</xsl:text>
		<xsl:text>run;</xsl:text>
		
		<!--HERE-->
		
		
		
		
   
		<xsl:text>data __metadata_</xsl:text> <xsl:value-of select="$SASDatasetName"/> <xsl:text>;</xsl:text>
		<xsl:value-of select="$lf"/> 
		<xsl:text> length OID $200 name $8 label $200 referencedata $5 varOID varname varlabel $200 type $20 length 8;</xsl:text>
		<xsl:value-of select="$lf"/> 
        <xsl:text> OID=&quot;</xsl:text><xsl:value-of select="$OID"/><xsl:text>&quot;;</xsl:text> 
		<xsl:value-of select="$lf"/> 
        <xsl:text> name=&quot;</xsl:text><xsl:value-of select="$SASDatasetName"/><xsl:text>&quot;;</xsl:text> 
		<xsl:value-of select="$lf"/> 
        <xsl:text> label=&quot;</xsl:text><xsl:value-of select="odm:Description/odm:TranslatedText"/><xsl:text>&quot;;</xsl:text>  
        <xsl:value-of select="$lf"/>
        <xsl:text> referencedata=&quot;</xsl:text><xsl:value-of select="normalize-space(@IsReferenceData)"/><xsl:text>&quot;;</xsl:text> 
		<xsl:value-of select="$lf"/> 
        <xsl:text> varOID=&quot;ITEMGROUPDATASEQ&quot;;</xsl:text> 
		<xsl:value-of select="$lf"/> 
        <xsl:text> varname=&quot;ITEMGROUPDATASEQ&quot;;</xsl:text> 
		<xsl:value-of select="$lf"/> 
        <xsl:text> varlabel=&quot;Record Identifier&quot;;</xsl:text> 
		<xsl:value-of select="$lf"/> 
        <xsl:text> type=&quot;integer&quot;;</xsl:text> 
		<xsl:value-of select="$lf"/> 
        <xsl:text> call missing(length);</xsl:text> 
		<xsl:value-of select="$lf"/> 
        <xsl:text> output;</xsl:text> 
		
        <xsl:for-each select="odm:ItemRef">
			<xsl:variable name="OID" select="@ItemOID"/>
			<xsl:value-of select="$lf"/> 
			<xsl:text> varOID=&quot;</xsl:text><xsl:value-of select="normalize-space($root/odm:Study/odm:MetaDataVersion/odm:ItemDef[@OID=$OID]/@OID)"/><xsl:text>&quot;;</xsl:text> 
			<xsl:value-of select="$lf"/> 
			<xsl:text> varname=&quot;</xsl:text><xsl:value-of select="normalize-space($root/odm:Study/odm:MetaDataVersion/odm:ItemDef[@OID=$OID]/@Name)"/><xsl:text>&quot;;</xsl:text> 
			<xsl:value-of select="$lf"/> 
			<xsl:text> varlabel=&quot;</xsl:text><xsl:value-of select="normalize-space($root/odm:Study/odm:MetaDataVersion/odm:ItemDef[@OID=$OID]/odm:Description/odm:TranslatedText)"/><xsl:text>&quot;;</xsl:text> 
			<xsl:value-of select="$lf"/> 
			<xsl:text> type=&quot;</xsl:text>
			<xsl:choose>
				<xsl:when test="normalize-space($root/odm:Study/odm:MetaDataVersion/odm:ItemDef[@OID=$OID]/@DataType) = 'text'">
					<xsl:text>string</xsl:text>
				</xsl:when>
				<xsl:when test="normalize-space($root/odm:Study/odm:MetaDataVersion/odm:ItemDef[@OID=$OID]/@DataType) = 'datetime'">
					<xsl:text>string</xsl:text>
				</xsl:when>
				<xsl:when test="normalize-space($root/odm:Study/odm:MetaDataVersion/odm:ItemDef[@OID=$OID]/@DataType) = 'date'">
					<xsl:text>string</xsl:text>
				</xsl:when>
				<xsl:when test="normalize-space($root/odm:Study/odm:MetaDataVersion/odm:ItemDef[@OID=$OID]/@DataType) = 'time'">
					<xsl:text>string</xsl:text>
				</xsl:when>
				<xsl:when test="normalize-space($root/odm:Study/odm:MetaDataVersion/odm:ItemDef[@OID=$OID]/@DataType) = 'partialDate'">
					<xsl:text>string</xsl:text>
				</xsl:when>
				<xsl:when test="normalize-space($root/odm:Study/odm:MetaDataVersion/odm:ItemDef[@OID=$OID]/@DataType) = 'partialTime'">
					<xsl:text>string</xsl:text>
				</xsl:when>
				<xsl:when test="normalize-space($root/odm:Study/odm:MetaDataVersion/odm:ItemDef[@OID=$OID]/@DataType) = 'partialDatetime'">
					<xsl:text>string</xsl:text>
				</xsl:when>
				<xsl:when test="normalize-space($root/odm:Study/odm:MetaDataVersion/odm:ItemDef[@OID=$OID]/@DataType) = 'incompleteDatetime'">
					<xsl:text>string</xsl:text>
				</xsl:when>
				<xsl:when test="normalize-space($root/odm:Study/odm:MetaDataVersion/odm:ItemDef[@OID=$OID]/@DataType) = 'durationDatetime'">
					<xsl:text>string</xsl:text>
				</xsl:when>
				<xsl:when test="normalize-space($root/odm:Study/odm:MetaDataVersion/odm:ItemDef[@OID=$OID]/@DataType) = 'integer'">
					<xsl:text>integer</xsl:text>
				</xsl:when>
				<xsl:when test="normalize-space($root/odm:Study/odm:MetaDataVersion/odm:ItemDef[@OID=$OID]/@DataType) = 'float'">
					<xsl:text>float</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text></xsl:text>
				</xsl:otherwise>
			</xsl:choose> 
			<xsl:text>&quot;;</xsl:text> 
			<xsl:value-of select="$lf"/> 
			<xsl:choose>
				<xsl:when test="normalize-space($root/odm:Study/odm:MetaDataVersion/odm:ItemDef[@OID=$OID]/@Length)">
					<xsl:text> length=</xsl:text><xsl:value-of select="normalize-space($root/odm:Study/odm:MetaDataVersion/odm:ItemDef[@OID=$OID]/@Length)"/><xsl:text>;</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text> call missing(length);</xsl:text>
				</xsl:otherwise>
			</xsl:choose> 
			<xsl:value-of select="$lf"/> 
			<xsl:text> output;</xsl:text> 
        </xsl:for-each>
   
    
    
    </xsl:for-each>
 
</xsl:template> 
	
	
</xsl:stylesheet>