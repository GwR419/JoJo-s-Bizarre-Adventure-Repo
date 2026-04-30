<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:cbml="http://www.cbml.org/ns/1.0"
  exclude-result-prefixes="xs tei cbml">

  <xsl:output method="text" encoding="UTF-8"/>

  <!-- ============================================================
       COLLECTION PATH
       Point this at the folder containing your manga XML files.
       Adjust the path as needed for your local environment.
       ============================================================ -->
  <xsl:variable name="mangaColl" as="document-node()+"
    select="collection('?select=*.xml')"/>

  <!-- ============================================================
       TSV HELPERS
       ============================================================ -->
  <xsl:variable name="tab" as="xs:string">
    <xsl:text>&#x9;</xsl:text>
  </xsl:variable>

  <xsl:variable name="newline" as="xs:string">
    <xsl:text>&#10;</xsl:text>
  </xsl:variable>

  <!-- ============================================================
       STOPWORDS  (merged from both original stylesheets)
       ============================================================ -->
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

  <!-- ============================================================
       MAIN TEMPLATE
       ============================================================ -->
  <xsl:template match="/">

    <!-- TSV header — mirrors the anime_word_network column layout -->
    <xsl:text>currentWord</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:text>currentWordCount</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:text>targetNodeAtt</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:text>chapterName</xsl:text>
    <xsl:value-of select="$newline"/>

    <!-- ── Step 1: collect every word across the whole corpus ── -->
    <xsl:variable name="all-text">
      <xsl:for-each select="$mangaColl//cbml:balloon//tei:p
                           | $mangaColl//cbml:balloon//tei:emph
                           | $mangaColl//cbml:panel//tei:p
                           | $mangaColl//cbml:panel//tei:emph
                           | $mangaColl//cbml:caption">
        <xsl:value-of select="lower-case(.)"/>
        <xsl:text> </xsl:text>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="raw-tokens" select="tokenize($all-text, '\s+')"/>

    <xsl:variable name="words" as="xs:string*">
      <xsl:for-each select="$raw-tokens">
        <xsl:variable name="w"  select="replace(., &quot;^[^a-z']+|[^a-z']+$&quot;, '')"/>
        <xsl:variable name="w2" select="replace($w, &quot;^'+|'+$&quot;, '')"/>
        <xsl:if test="string-length($w2) gt 1 and not($w2 = $stopwords)">
          <xsl:sequence select="$w2"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <!-- ── Step 2: distinct word list ── -->
    <xsl:variable name="distinctWords" as="xs:string+"
      select="$words => distinct-values()"/>

    <!-- ── Step 3: for each word × chapter, emit one TSV row ── -->
    <xsl:for-each select="$distinctWords">
      <xsl:variable name="currentWord" as="xs:string" select="current()"/>

      <xsl:for-each select="$mangaColl">

        <!-- Derive a human-readable chapter name from the filename -->
        <xsl:variable name="chapterName" as="xs:string"
          select="current()
                  ! base-uri()
                  ! tokenize(., '/')[last()]
                  ! substring-before(., '.xml')"/>

        <!-- Count occurrences: any balloon/caption text node that contains
             the word as a whole token (case-insensitive).
             We reuse the same match style as the anime stylesheet. -->
        <xsl:variable name="currentWordCount" as="xs:integer"
          select="(current()//cbml:balloon//tei:p
                 | current()//cbml:balloon//tei:emph
                 | current()//cbml:panel//tei:p
                 | current()//cbml:panel//tei:emph
                 | current()//cbml:caption)
                 ! lower-case(.)[matches(., $currentWord)]
                 => count()"/>

        <xsl:if test="$currentWordCount gt 0">
          <xsl:value-of select="$currentWord"/>
          <xsl:value-of select="$tab"/>
          <xsl:value-of select="$currentWordCount"/>
          <xsl:value-of select="$tab"/>
          <xsl:text>Chapter Name</xsl:text>
          <xsl:value-of select="$tab"/>
          <xsl:value-of select="$chapterName"/>
          <xsl:value-of select="$newline"/>
        </xsl:if>

      </xsl:for-each>
    </xsl:for-each>

  </xsl:template>

</xsl:stylesheet>
