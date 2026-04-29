<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs">

  <xsl:output method="text" encoding="UTF-8"/>
  
  <xsl:variable name="animeColl" as="document-node()+" select="collection('../xmlCorpus/04/?select=*.xml')"/>
  
  <xsl:variable name="tab" as="xs:string">
    <xsl:text>&#x9;</xsl:text>
  </xsl:variable>
  
  <xsl:variable name="newline" as="xs:string">
    <xsl:text>&#10;</xsl:text>
  </xsl:variable>

  <xsl:variable name="stopwords" select="(
    'a','an','the','and','or','but','in','on','at','to','for','of','with',
    'is','was','are','were','be','been','being','i','you','he','she','it',
    'we','they','me','him','her','us','them','my','your','his','its','our',
    'their','s','t','re','ve','ll','d','m','what','that','this','those',
    'these','so','no','not','do','did','does','have','has','had','will',
    'would','could','should','may','might','shall','just'
  )"/>

  <xsl:template match="/">
    <xsl:text>currentWord</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:text>currentWordCount</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:text>targetNodeAtt</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:text>episodeNumber</xsl:text>
    <xsl:value-of select="$newline"/>

    <xsl:variable name="all-text">
      <xsl:for-each select="$animeColl//speech">
        <xsl:value-of select="lower-case(.)"/>
        <xsl:text> </xsl:text>
      </xsl:for-each>
    </xsl:variable>

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
    
    <xsl:variable name="distinctWords" as="xs:string+" select="$words => distinct-values()"/>
    
    
    <xsl:for-each select="$distinctWords">
      <xsl:variable name="currentWord" as="xs:string" select="current()"/>
      
      <xsl:for-each select="$animeColl">
        <xsl:variable name="episodeFull" as="xs:string" select="current() 
          ! base-uri() ! 
          tokenize(., '/')[last()] ! substring-before(., '.xml')"/>
        <xsl:variable name="episodeNumber" as="xs:string" select="$episodeFull ! 
          tokenize(., '^04x')[last()] 
          ! tokenize(., '_')[1]"/>
        
        
       <xsl:variable name="currentWordCount" as="xs:integer">
         <xsl:value-of select="current()//speech ! lower-case(.)[matches(., $currentWord)] => count()"/>
       </xsl:variable>
    <xsl:if test="$currentWordCount gt 0">    
        <xsl:value-of select="$currentWord"/>
        <xsl:value-of select="$tab"/>
        <xsl:value-of select="$currentWordCount"/>
        <xsl:value-of select="$tab"/>
         <xsl:text>Episode Num</xsl:text>
        <xsl:value-of select="$tab"/>
        <xsl:value-of select="$episodeNumber"/>
        <xsl:value-of select="$newline"/>
    </xsl:if>
      </xsl:for-each>
      
      
    </xsl:for-each>
  </xsl:template>
    
 

</xsl:stylesheet>
