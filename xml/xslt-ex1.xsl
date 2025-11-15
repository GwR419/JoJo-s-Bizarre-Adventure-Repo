<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:template match="/">
        <html>
            <head><title>My Transformation</title></head>
            <body>
                <h1>Output from My XML</h1>
                <xsl:apply-templates/>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="div[@type='chapter']">
        <h1><xsl:apply-templates select="head"/></h1>
        <ul>
            <xsl:apply-templates select=".//placeName"/>
        </ul>
    </xsl:template>
    
    <xsl:template match="placeName">
        <li><xsl:apply-templates/></li>
    </xsl:template>
    
</xsl:stylesheet>