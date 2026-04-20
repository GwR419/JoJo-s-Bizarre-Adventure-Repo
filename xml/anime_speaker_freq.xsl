<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" encoding="UTF-8"/>

  <xsl:key name="by-norm-speaker"
           match="dialogue[not(starts-with(normalize-space(name),'JoJo-'))]"
           use="normalize-space(name)"/>

  <xsl:template match="/">
    <xsl:text>anime_title&#9;speaker&#9;line_count&#10;</xsl:text>
    <xsl:variable name="title">JoJo's Bizarre Adventure: Golden Wind - Episode 01 (Gold Experience)</xsl:variable>

    <xsl:for-each select="//dialogue[not(starts-with(normalize-space(name),'JoJo-'))][
        generate-id(.) = generate-id(key('by-norm-speaker', normalize-space(name))[1])
      ]">

      <xsl:variable name="raw" select="normalize-space(name)"/>

      <!-- Skip alias variants; they are summed under the canonical row -->
      <xsl:if test="$raw != 'Gio' and $raw != 'Kochi' and $raw != 'Luda' and $raw != 'Nar'">

        <xsl:variable name="canon">
          <xsl:call-template name="norm"><xsl:with-param name="n" select="$raw"/></xsl:call-template>
        </xsl:variable>

        <xsl:variable name="base" select="count(key('by-norm-speaker', $raw))"/>
        <xsl:variable name="alias">
          <xsl:choose>
            <xsl:when test="$canon = 'Giorno'"><xsl:value-of select="count(key('by-norm-speaker','Gio'))"/></xsl:when>
            <xsl:when test="$canon = 'Koichi'"><xsl:value-of select="count(key('by-norm-speaker','Kochi'))"/></xsl:when>
            <xsl:when test="$canon = 'Luca'"><xsl:value-of select="count(key('by-norm-speaker','Luda'))"/></xsl:when>
            <xsl:when test="$canon = 'Narrator'"><xsl:value-of select="count(key('by-norm-speaker','Nar'))"/></xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:value-of select="$title"/><xsl:text>&#9;</xsl:text>
        <xsl:value-of select="$canon"/><xsl:text>&#9;</xsl:text>
        <xsl:value-of select="$base + $alias"/><xsl:text>&#10;</xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="norm">
    <xsl:param name="n"/>
    <xsl:choose>
      <xsl:when test="$n = 'Gio' or $n = 'Giorno'">Giorno</xsl:when>
      <xsl:when test="$n = 'Kochi' or $n = 'Koichi'">Koichi</xsl:when>
      <xsl:when test="$n = 'Luda' or $n = 'Luca'">Luca</xsl:when>
      <xsl:when test="$n = 'Nar'">Narrator</xsl:when>
      <xsl:when test="starts-with($n,'JoJo-internal')">Narrator</xsl:when>
      <xsl:otherwise><xsl:value-of select="$n"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
