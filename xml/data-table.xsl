<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="tei"
    version="2.0">
    
    <xsl:output method="html" indent="yes" encoding="UTF-8"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <title>CBML Bold Word Frequency</title>
                <style>
                    body { font-family: sans-serif; padding: 20px; }
                    table { border-collapse: collapse; width: 60%; margin-top: 20px; }
                    th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
                    th { background-color: #f4f4f4; border-bottom: 2px solid #333; }
                    tr:nth-child(even) { background-color: #f9f9f9; }
                    .count-col { text-align: right; width: 20%; }
                </style>
            </head>
            <body>
                <h1>Most Used Bold Words</h1>
                <p>This table lists words found inside elements with <code>rendition="#b"</code>, ranked by frequency.</p>
                
                <table>
                    <thead>
                        <tr>
                            <th>Bolded Word/Phrase</th>
                            <th class="count-col">Frequency</th>
                        </tr>
                    </thead>
                    <tbody>
                        <xsl:for-each-group select="//*[@rendition='#b']" 
                            group-by="lower-case(normalize-space(.))">
                            
                            <xsl:sort select="count(current-group())" order="descending" data-type="number"/>
                            
                            <tr>
                                <td>
                                    <xsl:value-of select="normalize-space(current-group()[1])"/>
                                </td>
                                <td class="count-col">
                                    <xsl:value-of select="count(current-group())"/>
                                </td>
                            </tr>
                        </xsl:for-each-group>
                    </tbody>
                </table>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>