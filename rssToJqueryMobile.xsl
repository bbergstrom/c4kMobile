<?xml version="1.0"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:esi="http://www.edge-delivery.org/esi/1.0">
	<xsl:output method="html" media-type="text/html" omit-xml-declaration="yes" indent="yes"/>
	<xsl:variable name="domain" select="'http://channel4000.live.ib-prod.com'"/>
	<xsl:variable name="localDocRoot" select="'/sh/esi/dev/bbergstrom/c4kMobile/'"/>
	<xsl:variable name="proxyUrl" select="'http://preview.channel1000.com/sh/esi/dev/bbergstrom/c4kMobile/proxyToC4k.esi?u='"/>
	
	<xsl:template match="/">
		<xsl:apply-templates select="rss/channel"/>
	</xsl:template>
	
	<xsl:template match="channel">
		<div id="{title}-index" data-role="page" class="page">
			<xsl:call-template name="header"/>
			<div data-role="content">
				<ul data-role="listview" data-inset="true" data-theme="d" data-divider-theme="a">
					<li data-role="list-divider">News</li>
					<xsl:apply-templates select="item"/>
				</ul>
			</div>
			<xsl:call-template name="footer"/>
		</div>
		
		<xsl:apply-templates select="item" mode="detailPage"/>
		
	</xsl:template>
	
	<xsl:template match="item">
		
		<li class="ul-li-icon">
			<a>
				<xsl:attribute name="href">
					<xsl:value-of select="concat('#', ../title, '-detail-', position())"/>
				</xsl:attribute>
				<h2><xsl:value-of select="title"/></h2>
				<p><xsl:value-of select="description"/></p>
			</a>
		</li>
	</xsl:template>
	
	<xsl:template name="header">
		<xsl:param name="isDetail" select="'false'"/>
		
		<header data-role="header">
			<div class="ui-grid-a">
				<div class="ui-block-a logo">
					<a href="{$localDocRoot}index.html">
						<img src="{$domain}/image/view/-/132196/highRes/1/-/mrtmkhz/-/site-logo-gif.gif" alt="site_logo" title="site_logo"/>
					</a>
				</div>
				<div class="ui-block-b wx" xmlns:esi="http://www.edge-delivery.org/esi/1.0">
					<xsl:text disable-output-escaping="yes"><![CDATA[
				<esi:try>
					<esi:attempt>
						<esi:include src="http://www.wunderground.com/auto/ibsysXML/geo/conds/index.html?query=55101" ttl="5m" stylesheet="http://preview.channel1000.com/sh/esi/dev/bbergstrom/c4kMobile/currentConditions.xsl" dca="'xslt'"> 
						</esi:include>
					</esi:attempt>
					<esi:except>
						<!-- Error fetching or transforming rss feed. -->
					</esi:except>
				</esi:try>
				]]></xsl:text>
				</div>
			</div>
			
			<nav>
				<xsl:if test="$isDetail = 'true'">
					<a href="#" data-rel="back" data-role="button" data-theme="e">&#171; Back</a>
				</xsl:if>
			</nav>
		</header>
	</xsl:template>
	
	<xsl:template name="footer">
		<xsl:param name="isDetail" select="'false'"/>
		
		<footer data-role="footer">
			<nav>
				<xsl:if test="$isDetail = 'true'">
					<a href="#" data-rel="back" data-role="button" data-theme="e">&#171; Back</a>
				</xsl:if>
			</nav>
			<div class="logo">
				<a href="{$localDocRoot}index.html">
					<img src="{$domain}/image/view/-/132196/highRes/1/-/mrtmkhz/-/site-logo-gif.gif" alt="site_logo" title="site_logo"/>
				</a>
			</div>
		</footer>
	</xsl:template>
	
	<xsl:template match="node()|@*">
	</xsl:template>
	
	<xsl:template match="item" mode="detailPage">
	    <xsl:variable name="id" select="concat(../title, '-detail-', position())"/>
	    
		<div data-role="page" class="page detail" data-title="{concat('Channel 4000 - ', title)}">
			<xsl:attribute name="id">
				<xsl:value-of select="$id"/>
			</xsl:attribute>
			<xsl:call-template name="header">
				<xsl:with-param name="isDetail" select="'true'"/>
			</xsl:call-template>
			
			<div class="content" data-role="content">
			    <ul data-role="listview" data-inset="true" data-theme="d" data-divider-theme="a">
			        <li data-role="list-divider">News</li>
			        <li class="detailContent">
    			    <script type="text/javascript">
    			        <!--$('#<xsl:value-of select="$id"/> div.content li.detailContent').load('<xsl:value-of select="concat($proxyUrl, link)"/>');-->
    			        $.get('<xsl:value-of select="concat($proxyUrl, link)"/>', function(data) {
    			            var newPath = 'http://channel4000.live.ib-prod.com';
    			            while (data.indexOf("src=\"/") != -1) {
        			        	data = data.replace("src=\"/", "src=\""+newPath+"/");
        			        }
        			        
    			            $('#<xsl:value-of select="$id"/> div.content li.detailContent').html(data);
    			    	
    			    		$('#<xsl:value-of select="$id"/> div.content li.detailContent').find( "[src], link[href], a[rel='external'], :jqmData(ajax='false'), a[target]" ).each(function() {
		    			    	var thisAttr = $( this ).is( '[href]' ) ? 'href' :
		    			    	$(this).is('[src]') ? 'src' : 'action',
		    			    	thisUrl = $( this ).attr( thisAttr );
		    			    	
		    			    	// XXX_jblas: We need to fix this so that it removes the document
		    			    	//            base URL, and then prepends with the new page URL.
		    			    	//if full path exists and is same, chop it - helps IE out
		    			    	thisUrl = thisUrl.replace( location.protocol + '//' + location.host + location.pathname, '' );
		    			    	
		    			    	if( !/^(\w+:|#|\/)/.test( thisUrl ) ) {
		    			    	$( this ).attr( thisAttr, newPath + thisUrl );
		    			    	}
	    			    	});
    			        });
    			    </script>
			        </li>
                </ul>
			</div>
			<xsl:call-template name="footer">
				<xsl:with-param name="isDetail" select="'true'"/>
			</xsl:call-template>
		</div>
	</xsl:template>
	
</xsl:stylesheet>
