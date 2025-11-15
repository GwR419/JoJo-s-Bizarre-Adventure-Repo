<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:cbml="http://www.cbml.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    version="3.0">
    
    <xsl:output method="xhtml" html-version="5" omit-xml-declaration="yes" 
        include-content-type="no" indent="yes"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Diavolo Emerges Part 1</title>
            </head>
            <body>
                <h1>All Dialogue</h1>
                <ul>
                    <xsl:apply-templates select="//cbml:balloon"/>
                </ul> 
            </body> 
            
        </html>
    </xsl:template>
    
    
    <xsl:template match="cbml:balloon">
       
        <li>
            
            <b><xsl:value-of select="@who"/>: </b>
            
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    
    
  
    <xsl:template match="p">
      
        <xsl:apply-templates/>
    </xsl:template>
    
  
    <xsl:template match="emph">
      
        <b><xsl:apply-templates/></b>
    </xsl:template>
    
    
    <xsl:template match="sound">
        
        <i>(<xsl:apply-templates/>)</i>
    </xsl:template>
    
    
    
</xsl:stylesheet>