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
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		exclude-result-prefixes="xsl">

<xsl:output method="xml"
            version="1.0"
            encoding="utf-8"
            doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
            doctype-system="DTD/xhtml1-strict.dtd"
            indent="yes"/>

  <xsl:template match="/page">
    <html>
      <head>
	<title>
	  <xsl:value-of select="@title"/>
	</title>
      </head>
      <body>
	<xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="heading">
    <h1>
      <xsl:apply-templates/>
    </h1>
  </xsl:template>

  <xsl:template match="list">
    <ul>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <xsl:template match="list/item">
    <li>
      <xsl:apply-templates/>
    </li>
  </xsl:template>

  <xsl:template match="link">
    <a href="{@href}">
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <xsl:template match="text">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

</xsl:stylesheet>
