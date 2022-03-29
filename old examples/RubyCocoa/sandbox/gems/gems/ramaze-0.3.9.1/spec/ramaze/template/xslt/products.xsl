<?xml version="1.0" encoding="utf-8"?>
<!--
 ! Excerpted from "RubyCocoa",
 ! published by The Pragmatic Bookshelf.
 ! Copyrights apply to this code. It may not be used to create training material, 
 ! courses, books, articles, and the like. Contact us if you are in doubt.
 ! We make no guarantees that this code is fit for any purpose. 
 ! Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
-->
<xsl:stylesheet version="1.0"
		xmlns:test="urn:test"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		exclude-result-prefixes="test xsl">

  <xsl:output method="xml"
              encoding="utf-8"/>

  <xsl:template match="order">
    <result>
      <xsl:apply-templates/>
    </result>
  </xsl:template>

  <xsl:template match="first">
    <first>
      <xsl:value-of select="test:get-products()/item[1]"/>
    </first>
  </xsl:template>

  <xsl:template match="items">
    <xsl:apply-templates select="test:get-products()" mode="list"/>
  </xsl:template>

  <xsl:template match="item" mode="list">
    <item>
      <xsl:apply-templates mode="list"/>
    </item>
  </xsl:template>

</xsl:stylesheet>
