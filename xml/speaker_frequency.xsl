<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:cbml="http://www.cbml.org/ns/1.0">

  <!-- 
    XSLT 1: Speaker Frequency Network TSV
    Columns: manga_title | speaker | balloon_count
    One row per unique speaker (normalized, # stripped).
    Since XSLT 1.0 lacks grouping, we use a Muenchian grouping key.
  -->

  <xsl:output method="text" encoding="UTF-8"/>

  <!-- Muenchian grouping key on normalized speaker value -->
  <xsl:key name="by-speaker" match="cbml:balloon[@who]" use="normalize-space(@who)"/>

  <xsl:template match="/">
    <!-- Header -->
    <xsl:text>manga_title&#9;speaker&#9;balloon_count&#10;</xsl:text>

    <xsl:variable name="title"
      select="normalize-space(//tei:titleStmt/tei:title)"/>

    <!-- Select one representative balloon per distinct @who value -->
    <xsl:for-each select="//cbml:balloon[@who][
        generate-id(.) = generate-id(key('by-speaker', normalize-space(@who))[1])
      ]">
      <xsl:sort select="count(key('by-speaker', normalize-space(@who)))" data-type="number" order="descending"/>

      <xsl:variable name="raw"  select="normalize-space(@who)"/>
      <xsl:variable name="count" select="count(key('by-speaker', $raw))"/>

      <xsl:value-of select="$title"/>
      <xsl:text>&#9;</xsl:text>
      <!-- Strip leading # from each token for display -->
      <xsl:call-template name="strip-hashes">
        <xsl:with-param name="text" select="$raw"/>
      </xsl:call-template>
      <xsl:text>&#9;</xsl:text>
      <xsl:value-of select="$count"/>
      <xsl:text>&#10;</xsl:text>
    </xsl:for-each>
  </xsl:template>

  <!-- Recursively strip # from space-separated tokens -->
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
      <xsl:when test="starts-with($token,'#')">
        <xsl:value-of select="substring($token,2)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$token"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
