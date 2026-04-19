<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:cbml="http://www.cbml.org/ns/1.0">

  <!--
    XSLT 3: Speech Balloon Text Transcript
    Outputs a human-readable transcript of all balloon dialogue,
    keyed by PAGE / PANEL / BALLOON-TYPE / SPEAKER.
    Designed for side-by-side comparison with anime episode subtitles.
    Tagged for @GwR419.
  -->

  <xsl:output method="text" encoding="UTF-8"/>

  <xsl:template match="/">
    <xsl:variable name="title" select="normalize-space(//tei:titleStmt/tei:title)"/>
    <xsl:variable name="author" select="normalize-space(//tei:titleStmt/tei:author[1])"/>
    <xsl:variable name="pub_date" select="normalize-space(//tei:publicationStmt/tei:date)"/>

    <xsl:text>===================================================</xsl:text><xsl:text>&#10;</xsl:text>
    <xsl:text>MANGA SPEECH TRANSCRIPT — FOR ANIME COMPARISON</xsl:text><xsl:text>&#10;</xsl:text>
    <xsl:text>Tagged for: @GwR419</xsl:text><xsl:text>&#10;</xsl:text>
    <xsl:text>===================================================</xsl:text><xsl:text>&#10;</xsl:text>
    <xsl:text>Title : </xsl:text><xsl:value-of select="$title"/><xsl:text>&#10;</xsl:text>
    <xsl:text>Author: </xsl:text><xsl:value-of select="$author"/><xsl:text>&#10;</xsl:text>
    <xsl:text>Year  : </xsl:text><xsl:value-of select="$pub_date"/><xsl:text>&#10;</xsl:text>
    <xsl:text>Source: fan scanlation via MangaDex (see teiHeader for notes)</xsl:text><xsl:text>&#10;</xsl:text>
    <xsl:text>===================================================</xsl:text><xsl:text>&#10;&#10;</xsl:text>

    <!-- Walk page breaks to segment output by page -->
    <xsl:apply-templates select="//tei:pb"/>
  </xsl:template>

  <!-- Page break: print header, then process panels until next pb -->
  <xsl:template match="tei:pb">
    <xsl:variable name="pg" select="@n"/>
    <xsl:text>--- PAGE </xsl:text><xsl:value-of select="$pg"/><xsl:text> ---&#10;</xsl:text>

    <!-- Panels that follow this pb and precede the next pb (or end of document) -->
    <xsl:variable name="next_pb" select="following-sibling::tei:pb[1]"/>
    <xsl:choose>
      <xsl:when test="$next_pb">
        <xsl:apply-templates
          select="following-sibling::cbml:panel[
            generate-id(following-sibling::tei:pb[1]) = generate-id($next_pb)
          ]">
          <xsl:with-param name="page" select="$pg"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="following-sibling::cbml:panel">
          <xsl:with-param name="page" select="$pg"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <!-- Panel: only emit if it has balloons -->
  <xsl:template match="cbml:panel">
    <xsl:param name="page"/>
    <xsl:if test="cbml:balloon">
      <xsl:text>  [Panel </xsl:text><xsl:value-of select="@n"/><xsl:text>]&#10;</xsl:text>
      <xsl:apply-templates select="cbml:balloon"/>
    </xsl:if>
  </xsl:template>

  <!-- Balloon: type, speaker, text -->
  <xsl:template match="cbml:balloon">
    <xsl:variable name="type">
      <xsl:choose>
        <xsl:when test="@type"><xsl:value-of select="@type"/></xsl:when>
        <xsl:otherwise>speech</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="who_raw" select="normalize-space(@who)"/>
    <xsl:variable name="who_clean">
      <xsl:call-template name="strip-hashes">
        <xsl:with-param name="text" select="$who_raw"/>
      </xsl:call-template>
    </xsl:variable>

    <!-- Balloon line: TYPE  SPEAKER: "text" -->
    <xsl:text>    </xsl:text>
    <xsl:value-of select="translate($type,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
    <xsl:text>  </xsl:text>
    <xsl:value-of select="$who_clean"/>
    <xsl:text>: "</xsl:text>
    <xsl:value-of select="normalize-space(.)"/>
    <xsl:text>"&#10;</xsl:text>
  </xsl:template>

  <!-- Strip leading # from space-separated tokens -->
  <xsl:template name="strip-hashes">
    <xsl:param name="text"/>
    <xsl:choose>
      <xsl:when test="contains($text,' ')">
        <xsl:call-template name="strip-one">
          <xsl:with-param name="token" select="substring-before($text,' ')"/>
        </xsl:call-template>
        <xsl:text> </xsl:text>
        <xsl:call-template name="strip-hashes">
          <xsl:with-param name="text" select="substring-after($text,' ')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="strip-one">
          <xsl:with-param name="token" select="$text"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="strip-one">
    <xsl:param name="token"/>
    <xsl:choose>
      <xsl:when test="starts-with($token,'#')"><xsl:value-of select="substring($token,2)"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="$token"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
