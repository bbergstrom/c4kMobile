<?xml version="1.0"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" media-type="text/html" omit-xml-declaration="yes" indent="yes"/>
	
	<xsl:template match="/">
		<xsl:apply-templates select="location/current_conditions">
			<xsl:with-param name="meridian" select="translate(location/current_conditions/date/ampm, 'AMP', 'amp')"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="current_conditions">
		<xsl:param name="meridian"/>
		
		<div class="cc ui-grid-a">
			<div class="ui-block-a">
					<img src="http://channel4000.live.ib-prod.com/ibsys/static/site/css/packed/images/weatherIcons/80x80/{icon}_{$meridian}.png" alt="conditions_full"/>
			</div>
			<div class="ui-block-b">
				<div class="location">
					<xsl:value-of select="name"/>
				</div>
				<div class="temp">
					<xsl:value-of select="temperature/fahrenheit"/> &#176;F
				</div>
				<div class="text">
					<xsl:value-of select="conditions_full"/>
				</div>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="node()|@*">
	</xsl:template>
	
</xsl:stylesheet>