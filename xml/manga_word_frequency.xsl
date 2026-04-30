<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:cbml="http://www.cbml.org/ns/1.0"
  exclude-result-prefixes="xs tei cbml">

  <xsl:output method="text" encoding="UTF-8"/>

  <xsl:variable name="stopwords" select="(
    'a','an','the','and','or','but','in','on','at','to','for','of','with',
    'is','was','are','were','be','been','being','i','you','he','she','it',
    'we','they','me','him','her','us','them','my','your','his','its','our',
    'their','s','t','re','ve','ll','d','m','what','that','this','those',
    'these','so','no','not','do','did','does','have','has','had','will',
    'would','could','should','may','might','shall','just','up','out','all',
    'if','can','who','one','go','get','how','why','into','here','there',
    'now','then','too','more','over','even','back','about','as','well',
    'when','than','also','by','from','which'
  )"/>

  <xsl:template match="/">

    <!-- Collect text from speech balloons (p, emph inside cbml:balloon) -->
    <!-- and captions (cbml:caption), but exclude sound effects (sound) -->
    <xsl:variable name="all-text">
      <xsl:for-each select="//cbml:balloon//tei:p | //cbml:balloon//tei:emph |
                             //cbml:panel//tei:p   | //cbml:panel//tei:emph  |
                             //cbml:caption">
        <xsl:value-of select="lower-case(.)"/>
        <xsl:text> </xsl:text>
      </xsl:for-each>
    </xsl:variable>

    <!-- Tokenize, strip punctuation, filter stopwords and short tokens -->
    <xsl:variable name="raw-tokens" select="tokenize($all-text, '\s+')"/>
    <xsl:variable name="words" as="xs:string*">
      <xsl:for-each select="$raw-tokens">
        <xsl:variable name="w" select="replace(., &quot;^[^a-z']+|[^a-z']+$&quot;, '')"/>
        <xsl:variable name="w2" select="replace($w, &quot;^'+|'+$&quot;, '')"/>
        <xsl:if test="string-length($w2) gt 1 and not($w2 = $stopwords)">
          <xsl:sequence select="$w2"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <!-- Count each distinct word -->
    <xsl:variable name="word-counts" as="element()*">
      <xsl:for-each select="distinct-values($words)">
        <xsl:variable name="w" select="."/>
        <word value="{$w}" count="{count($words[. = $w])}"/>
      </xsl:for-each>
    </xsl:variable>

    <!-- Sort descending by count -->
    <xsl:variable name="sorted" as="element()*">
      <xsl:perform-sort select="$word-counts">
        <xsl:sort select="xs:integer(@count)" order="descending"/>
      </xsl:perform-sort>
    </xsl:variable>

    <!-- TSV header -->
    <xsl:text>rank&#9;word&#9;count&#10;</xsl:text>

    <!-- TSV rows — top 50 -->
    <xsl:for-each select="$sorted[position() le 50]">
      <xsl:value-of select="position()"/>
      <xsl:text>&#9;</xsl:text>
      <xsl:value-of select="@value"/>
      <xsl:text>&#9;</xsl:text>
      <xsl:value-of select="@count"/>
      <xsl:text>&#10;</xsl:text>
    </xsl:for-each>

  </xsl:template>

</xsl:stylesheet>
