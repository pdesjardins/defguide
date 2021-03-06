<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
		xmlns:html="http://www.w3.org/1999/xhtml"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:t="http://docbook.org/xslt/ns/template"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:mp="http://docbook.org/xslt/ns/mode/private"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="f rng html db m t xs"
                version="2.0">

<xsl:param name="output.media" select="'web'"/>
<xsl:param name="refentry.generate.title" select="1"/>
<xsl:param name="refentry.generate.name" select="0"/>
<xsl:param name="refentry.separator" select="0"/>
<xsl:param name="css.decoration" select="1"/>
<xsl:param name="docbook.css">css/defguide.css</xsl:param>
<xsl:param name="callout.graphics.path" select="'figs/web/callouts/'"/>

<xsl:param xmlns="http://docbook.org/ns/docbook"
           name="generate.toc" as="element()*">
  <tocparam path="book" toc="1" title="1" figure="1" table="1" example="1" equation="1"/>
  <tocparam path="part" toc="1"/>
</xsl:param>

<xsl:param name="autolabel.elements">
  <db:appendix format="A"/>
  <db:chapter/>
  <db:figure/>
  <db:example/>
  <db:table/>
  <db:equation/>
  <db:part format="I"/>
  <db:reference format="I"/>
  <db:section/>
</xsl:param>

<xsl:param name="linenumbering" as="element()*" xmlns="http://docbook.org/ns/docbook">
<ln path="literallayout" everyNth="0"/>
<ln path="programlisting" everyNth="2" width="3" separator=" " padchar=" " minlines="3"/>
<ln path="programlistingco" everyNth="2" width="3" separator=" " padchar=" " minlines="3"/>
<ln path="screen" everyNth="2" width="3" separator=" " padchar=" " minlines="3"/>
<ln path="synopsis" everyNth="2" width="3" separator=" " padchar=" " minlines="3"/>
<ln path="address" everyNth="0"/>
<ln path="epigraph/literallayout" everyNth="0"/>
</xsl:param>

<xsl:variable name="rngfile"
	      select="'../tools/lib/defguide.rnd'"/>

<xsl:variable name="rng" select="document($rngfile)"/>

<xsl:template name="border">
  <xsl:param name="side" required="yes"/>
  <xsl:param name="padding" select="0"/>
  <xsl:param name="style" select="$table.cell.border.style"/>
  <xsl:param name="color" select="$table.cell.border.color"/>
  <xsl:param name="thickness" select="$table.cell.border.thickness"/>
  <!-- nop -->
</xsl:template>

<xsl:template match="*" mode="m:javascript-head">
  <script type="text/javascript"
          src="{concat($resource.root, 'js/prism.js')}"/>
  <script type="text/javascript"
          src="{concat($resource.root, 'js/jquery-1.6.4.min.js')}"/>
  <script type="text/javascript"
          src="{concat($resource.root, 'js/refentry.js')}"/>
</xsl:template>

<xsl:template match="*" mode="m:head-content">
  <link rel="icon" href="{/db:book/db:info/db:releaseinfo[@role='icon']}"
        type="image/png" />
</xsl:template>

<xsl:template name="revision.graphic">
  <xsl:param name="node" select="."/>
  <xsl:param name="large" select="'0'"/>
  <xsl:param name="align" select="''"/>

  <xsl:variable name="revision" as="xs:string?" select="$node/@revision"/>
  <xsl:variable name="arch" as="xs:string?" select="$node/@arch"/>

  <xsl:if test="$revision or $arch">
    <xsl:choose>
      <xsl:when test="($arch = 'defguide5' or $arch = 'publishers')
                      and empty($revision)">
        <!-- nop, expected -->
      </xsl:when>

      <xsl:when test="empty($revision)">
        <xsl:message>
          <xsl:text>Element with arch=</xsl:text>
          <xsl:value-of select="$arch"/>
          <xsl:text> but no revision!?</xsl:text>
        </xsl:message>
      </xsl:when>

      <xsl:when test="$revision='5.2' and empty($arch)">
        <img src="figs/web/rev_5.2.png" alt="[5.2]">
          <xsl:if test="$align != ''">
            <xsl:attribute name="align">
              <xsl:value-of select="$align"/>
            </xsl:attribute>
          </xsl:if>
        </img>
      </xsl:when>
      <xsl:when test="$revision='5.1' and empty($arch)">
        <img src="figs/web/rev_5.1.png" alt="[5.1]">
          <xsl:if test="$align != ''">
            <xsl:attribute name="align">
              <xsl:value-of select="$align"/>
            </xsl:attribute>
          </xsl:if>
        </img>
      </xsl:when>
      <xsl:when test="$revision='5.1' and $arch='assembly'">
        <img src="figs/web/rev_5.1_assembly.png" alt="[5.1 Assembly]">
          <xsl:if test="$align != ''">
            <xsl:attribute name="align">
              <xsl:value-of select="$align"/>
            </xsl:attribute>
          </xsl:if>
        </img>
      </xsl:when>
      <xsl:when test="$revision='5.0' and $arch='publishers'">
        <img src="figs/web/rev_5.0p.png" alt="[5.0 Publishers]">
          <xsl:if test="$align != ''">
            <xsl:attribute name="align">
              <xsl:value-of select="$align"/>
            </xsl:attribute>
          </xsl:if>
        </img>
      </xsl:when>
      <xsl:when test="$revision='5.0' and $arch='slides'">
        <img src="figs/web/rev_5.0s.png" alt="[5.0 Slides]">
          <xsl:if test="$align != ''">
            <xsl:attribute name="align">
              <xsl:value-of select="$align"/>
            </xsl:attribute>
          </xsl:if>
        </img>
      </xsl:when>
      <xsl:when test="$revision='5.0' and $arch='website'">
        <img src="figs/web/rev_5.0w.png" alt="[5.0 Website]">
          <xsl:if test="$align != ''">
            <xsl:attribute name="align">
              <xsl:value-of select="$align"/>
            </xsl:attribute>
          </xsl:if>
        </img>
      </xsl:when>
      <xsl:when test="$revision='5.0' and empty($arch)">
        <img src="figs/web/rev_5.0.png" alt="[5.0]">
          <xsl:if test="$align != ''">
            <xsl:attribute name="align">
              <xsl:value-of select="$align"/>
            </xsl:attribute>
          </xsl:if>
        </img>
      </xsl:when>
      <xsl:when test="$revision='4.3' and empty($arch)">
        <img src="figs/web/rev_4.3.png" alt="[4.3]">
          <xsl:if test="$align != ''">
            <xsl:attribute name="align">
              <xsl:value-of select="$align"/>
            </xsl:attribute>
          </xsl:if>
        </img>
      </xsl:when>
      <xsl:when test="$revision='4.2' and empty($arch)">
        <img src="figs/web/rev_4.2.png" alt="[4.2]">
          <xsl:if test="$align != ''">
            <xsl:attribute name="align">
              <xsl:value-of select="$align"/>
            </xsl:attribute>
          </xsl:if>
        </img>
      </xsl:when>
      <xsl:when test="$revision='4.0' and empty($arch)">
        <img src="figs/web/rev_4.0.png" alt="[4.0]">
          <xsl:if test="$align != ''">
            <xsl:attribute name="align">
              <xsl:value-of select="$align"/>
            </xsl:attribute>
          </xsl:if>
        </img>
      </xsl:when>
      <xsl:when test="$revision='3.1' and empty($arch)">
        <!-- nop; 3.1 isn't interesting anymore -->
      </xsl:when>
      <xsl:when test="$revision='EBNF'">
        <img src="figs/web/rev_ebnf.png" alt="[EBNF]">
          <xsl:if test="$align != ''">
            <xsl:attribute name="align">
              <xsl:value-of select="$align"/>
            </xsl:attribute>
          </xsl:if>
        </img>
      </xsl:when>
      <xsl:when test="$revision='SVG' and empty($arch)">
        <img src="figs/web/rev_svg.png" alt="[SVG]">
          <xsl:if test="$align != ''">
            <xsl:attribute name="align">
              <xsl:value-of select="$align"/>
            </xsl:attribute>
          </xsl:if>
        </img>
      </xsl:when>
      <xsl:when test="$revision='MathML' and empty($arch)">
        <img src="figs/web/rev_mathml.png" alt="[MathML]">
          <xsl:if test="$align != ''">
            <xsl:attribute name="align">
              <xsl:value-of select="$align"/>
            </xsl:attribute>
          </xsl:if>
        </img>
      </xsl:when>
      <xsl:when test="$revision='HTMLForms' and empty($arch)">
        <img src="figs/web/rev_htmlforms.png" alt="[HTML Forms]">
          <xsl:if test="$align != ''">
            <xsl:attribute name="align">
              <xsl:value-of select="$align"/>
            </xsl:attribute>
          </xsl:if>
        </img>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>
          <xsl:text>Unexpected revision/arch '</xsl:text>
          <xsl:value-of select="$revision"/>
          <xsl:text>/</xsl:text>
          <xsl:value-of select="$arch"/>
          <xsl:text>' on </xsl:text>
          <xsl:value-of select="local-name(.)"/>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template match="db:book">
  <article>
    <xsl:sequence select="f:html-attributes(.,f:node-id(.))"/>

    <xsl:call-template name="titlepage-block"/>

    <xsl:if test="not(db:toc)">
      <!-- only generate a toc automatically if there's no explicit toc -->
      <xsl:apply-templates select="." mode="m:toc"/>
    </xsl:if>

    <xsl:apply-templates/>
  </article>
</xsl:template>

<xsl:template name="titlepage-block">
  <xsl:variable name="isbn" select="db:info/db:biblioid[@class='isbn'][1]"/>
  <xsl:variable name="version" select="db:info/db:releaseinfo[1]"/>
  <xsl:variable name="date" select="db:info/db:pubdate[1]"/>
  <xsl:variable name="copyright" select="db:info/db:copyright"/>

  <div>
    <xsl:apply-templates select="db:info/db:mediaobject"/>

    <h1><xsl:value-of select="db:info/db:title"/></h1>

    <p class="titlepage-block">
      <span class="authorgroup">
        <xsl:text>by </xsl:text>
        <xsl:apply-templates select="db:info/db:author" mode="titleblock"/>
      </span>
      <br/>
      <span class="editor">
        <xsl:text>Edited by </xsl:text>
        <xsl:apply-templates select="db:info/db:editor" mode="titleblock"/>
      </span>
      <br/>
      <xsl:if test="$isbn">
        <span class="isbn">
          <xsl:text>ISBN: </xsl:text>
          <a href="http://oreilly.com/catalog/{$isbn}/">
            <xsl:value-of select="$isbn"/>
          </a>
        </span>
        <xsl:text>, published in conjunction with </xsl:text>
        <a href="http://xmlpress.net/">XML Press</a>.
        <br/>
      </xsl:if>
      <span class="version">
        <xsl:text>Version </xsl:text>
        <xsl:apply-templates select="$version/node()"/>
      </span>
      <br/>
      <span class="date">
        <xsl:variable name="pubdate" select="$date cast as xs:date" as="xs:date"/>
        <xsl:text>Updated: </xsl:text>
        <xsl:value-of select="format-date($pubdate, '[D1] [MNn], [Y0001]')"/>
      </span>
    </p>

    <p class="copyright">
      <a href="dbcpyright.html">Copyright</a>
      <xsl:text> &#xA9; </xsl:text>
      <xsl:for-each select="/db:book/db:info/db:copyright/db:year">
        <xsl:if test="position() &gt; 1">, </xsl:if>
        <xsl:value-of select="."/>
      </xsl:for-each>
      <xsl:text> </xsl:text>
      <xsl:value-of select="/db:book/db:info/db:copyright/db:holder"/>
      <xsl:text>.</xsl:text>
    </p>

    <br clear="all"/>

    <xsl:if test="/db:book/db:info/db:releaseinfo[@role='backcover']">
      <p id="backcover">
        <xsl:text>(</xsl:text>
        <a href="{/db:book/db:info/db:releaseinfo[@role='backcover']}">back cover</a>
        <xsl:text>)</xsl:text>
      </p>
    </xsl:if>

    <hr/>
  </div>

  <xsl:result-document href="{$base.dir}dbcpyright.html" method="xhtml" indent="no">
    <html>
      <head>
        <xsl:apply-templates select="/*" mode="mp:html-head"/>
      </head>
      <body>
        <div class="page">
          <xsl:call-template name="t:body-attributes"/>
          <xsl:if test="@status">
            <xsl:attribute name="class" select="@status"/>
          </xsl:if>

          <!-- irrelevant, as long as it's in a different chunk from us! -->
          <xsl:variable name="link-context" select="(/db:book/db:part/db:chapter)[1]"/>

          <div class="content">
            <xsl:apply-templates select="." mode="m:user-header-content">
              <xsl:with-param name="node" select="$link-context"/>
              <xsl:with-param name="up" select="root(.)/*"/>
            </xsl:apply-templates>

            <div class="body">
              <xsl:apply-templates select="db:info/db:legalnotice/*"/>
            </div>
          </div>

          <xsl:apply-templates select="." mode="m:user-footer-content">
            <xsl:with-param name="node" select="$link-context"/>
            <xsl:with-param name="up" select="root(.)/*"/>
          </xsl:apply-templates>
        </div>
      </body>
    </html>
  </xsl:result-document>
</xsl:template>

<xsl:template match="db:info/db:author|db:info/db:editor" mode="titleblock">
  <xsl:if test="position() &gt; 1 and last() &gt; 2">,</xsl:if>
  <xsl:if test="position() &gt; 1 and position() = last()"> and</xsl:if>
  <xsl:if test="position() &gt; 1">&#160;</xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="db:authorgroup/db:othercredit" mode="titleblock">
  <xsl:if test="position() &gt; 1 and last() &gt; 2">,</xsl:if>
  <xsl:if test="position() &gt; 1 and position() = last()"> and</xsl:if>
  <xsl:if test="position() &gt; 1"> </xsl:if>
  <xsl:apply-templates select="."/>
  <xsl:if test="contrib">
    <xsl:text> (</xsl:text>
    <xsl:apply-templates select="contrib" mode="titleblock"/>
    <xsl:text>)</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="db:othercredit/db:contrib" mode="titleblock">
  <xsl:apply-templates/>
</xsl:template>

<!-- Override this template in order to put revision graphics in the TOC -->
<xsl:template match="db:refentry" mode="mp:toc"
              xmlns:mp="http://docbook.org/xslt/ns/mode/private">
  <xsl:param name="toc-context" select="."/>

  <xsl:variable name="refmeta" select=".//db:refmeta"/>
  <xsl:variable name="refentrytitle" select="$refmeta//db:refentrytitle"/>
  <xsl:variable name="refnamediv" select=".//db:refnamediv"/>
  <xsl:variable name="refname" select="$refnamediv//db:refname"/>
  <xsl:variable name="title">
    <xsl:choose>
      <xsl:when test="$refentrytitle">
        <xsl:apply-templates select="$refentrytitle[1]" mode="m:titleabbrev-content"/>
      </xsl:when>
      <xsl:when test="$refname">
        <xsl:apply-templates select="$refname[1]" mode="m:titleabbrev-content"/>
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <li>
    <span class='refentrytitle'>
      <a href="{f:href(/,.)}">
        <xsl:copy-of select="$title"/>
      </a>
    </span>
    <span class='refpurpose'>
      <xsl:if test="$annotate.toc != 0">
        <xsl:text> — </xsl:text>
        <xsl:apply-templates select="db:refnamediv/db:refpurpose/node()"/>
      </xsl:if>
    </span>

    <xsl:call-template name="revision.graphic">
      <xsl:with-param name="node" select="."/>
      <xsl:with-param name="large" select="'0'"/>
      <xsl:with-param name="align" select="''"/>
    </xsl:call-template>
  </li>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:refentrytitle">
  <xsl:call-template name="revision.graphic">
    <xsl:with-param name="node" select="ancestor::db:refentry[1]"/>
    <xsl:with-param name="large" select="'1'"/>
    <xsl:with-param name="align" select="'right'"/>
  </xsl:call-template>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="db:phrase[@role='cceq']">
  <xsl:apply-imports/>

  <xsl:if test="ancestor::db:refsynopsisdiv//db:itemizedlist[contains(@role,'patnlist')]">
    <span id="cmshow" style="display: none;">
      <xsl:text>&#160;</xsl:text>
      <a href="javascript:showAll()">
	<img src="figs/web/nav/right.gif" border="0" alt="[+]"/>
      </a>
    </span>
    <span id="cmhide">
      <xsl:text>&#160;</xsl:text>
      <a href="javascript:hideAll()">
	<img src="figs/web/nav/down.gif" border="0" alt="[-]"/>
      </a>
    </span>
  </xsl:if>
</xsl:template>

<xsl:template match="db:info/db:mediaobject">
  <div class="covergraphic">
    <xsl:apply-imports/>
  </div>
</xsl:template>

<xsl:template match="db:emphasis[@role='patnlink']">
  <xsl:variable name="id" select="ancestor::db:listitem[1]/@xml:id"/>
  <xsl:variable name="list"
		select="following::db:itemizedlist[contains(@role,'patnlist')][1]"/>

  <xsl:variable name="title">
    <xsl:for-each select="$list//db:tag">
      <xsl:if test="position() &gt; 1 and last() &gt; 2">, </xsl:if>
      <xsl:if test="position() = last() and last() &gt; 1"> and </xsl:if>
      <xsl:value-of select="."/>
    </xsl:for-each>
  </xsl:variable>

  <em title="{$title}" class='patnlink'>
    <xsl:apply-templates/>
  </em>

  <xsl:if test="$id != ''">
    <span id="pls.{$id}" style="display: none;">
      <xsl:text>&#160;</xsl:text>
      <a href="javascript:show('{$id}')">
	<img src="figs/web/nav/right.gif" border="0" alt="[+]"/>
      </a>
    </span>
    <span id="plh.{$id}">
      <xsl:text>&#160;</xsl:text>
      <a href="javascript:hide('{$id}')">
	<img src="figs/web/nav/down.gif" border="0" alt="[-]"/>
      </a>
    </span>
  </xsl:if>
</xsl:template>

<xsl:template match="db:itemizedlist[contains(@role,'patnlist')]">
  <!-- don't apply imports because we don't want the anchor name -->
  <div class="patnlist" id="{@xml:id}">
    <div>
      <xsl:call-template name="class"/>
      <xsl:if test="db:title">
	<xsl:call-template name="t:formal-object-heading"/>
      </xsl:if>

      <!-- Preserve order of PIs and comments -->
      <xsl:apply-templates
	  select="*[not(self::db:listitem
		    or self::db:title
		    or self::db:titleabbrev)]
		    |comment()[not(preceding-sibling::db:listitem)]
		    |processing-instruction()[not(preceding-sibling::db:listitem)]"/>

      <ul>
        <xsl:if test="$css.decoration != 0">
          <xsl:attribute name="type" select="f:itemizedlist-symbol(.)"/>
        </xsl:if>

        <xsl:if test="@spacing='compact'">
          <xsl:attribute name="compact">
            <xsl:value-of select="@spacing"/>
          </xsl:attribute>
        </xsl:if>

        <xsl:apply-templates
            select="db:listitem
                    |comment()[preceding-sibling::db:listitem]
                    |processing-instruction()[preceding-sibling::db:listitem]"/>
      </ul>
    </div>
  </div>
</xsl:template>

<xsl:template match="db:example-wrapper">
  <div class="example-output">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="db:phrase">
  <xsl:choose>
    <xsl:when test="@conformance = 'inschema'">
      <xsl:variable name="conforms">
        <xsl:for-each select="db:tag">
          <xsl:variable name="class">
            <xsl:choose>
              <xsl:when test="@class">
                <xsl:value-of select="@class"/>
              </xsl:when>
              <xsl:otherwise>element</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="id">
            <xsl:apply-templates select="." mode="idvalue"/>
          </xsl:variable>

          <xsl:choose>
            <xsl:when test="$id = 'NOTEXPECTED'">
              <xsl:value-of select="concat(.,':2 ')"/>
            </xsl:when>
            <xsl:when test="$class = 'element' and count(key('id', $id)) &gt; 0">
              <xsl:value-of select="concat(.,':1 ')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat(.,':0 ')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="contains($conforms, '0')">
          <xsl:message>
            <xsl:text>Suppressing inschema (</xsl:text>
            <xsl:value-of select="local-name(.)"/>
            <xsl:text>): </xsl:text>
            <xsl:value-of select="$conforms"/>
          </xsl:message>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-imports/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-imports/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:para[ancestor::db:itemizedlist[@role='element-synopsis']]"
	      priority="100">
  <!-- force this kind of list to be "compact" -->
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="db:para">
  <xsl:choose>
    <xsl:when test="@conformance = 'inschema'">
      <xsl:variable name="conforms">
        <xsl:for-each select="db:tag">
          <xsl:variable name="class">
            <xsl:choose>
              <xsl:when test="@class">
                <xsl:value-of select="@class"/>
              </xsl:when>
              <xsl:otherwise>element</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="id">
            <xsl:apply-templates select="." mode="idvalue"/>
          </xsl:variable>

          <xsl:choose>
            <xsl:when test="$id = 'NOTEXPECTED'">
              <xsl:value-of select="concat(.,':2 ')"/>
            </xsl:when>
            <xsl:when test="$class = 'element' and count(key('id', $id)) &gt; 0">
              <xsl:value-of select="concat(.,':1 ')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat(.,':0 ')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="contains($conforms, '0')">
          <xsl:message>
            <xsl:text>Suppressing inschema (</xsl:text>
            <xsl:value-of select="local-name(.)"/>
            <xsl:text>): </xsl:text>
            <xsl:value-of select="$conforms"/>
          </xsl:message>
        </xsl:when>
        <xsl:otherwise>
          <p>
            <xsl:if test="@xml:id">
              <xsl:attribute name="id" select="@xml:id"/>
            </xsl:if>
            <xsl:call-template name="revision.graphic"/>
            <xsl:apply-templates/>
          </p>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <p>
        <xsl:if test="@xml:id">
          <xsl:attribute name="id" select="@xml:id"/>
        </xsl:if>
        <xsl:call-template name="revision.graphic"/>
        <xsl:apply-templates/>
      </p>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:tag" mode="idvalue">
  <xsl:variable name="class">
    <xsl:choose>
      <xsl:when test="@class">
        <xsl:value-of select="@class"/>
      </xsl:when>
      <xsl:otherwise>element</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="lcname"
		select="translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ:',
			            'abcdefghijklmnopqrstuvwxyz.')"/>

  <xsl:variable name="elemidval">
    <xsl:choose>
      <xsl:when test="(@namespace
	               and @namespace != 'http://docbook.org/ns/docbook')
		      or @role = 'nonexistant'">
	<xsl:value-of select="'NOTEXPECTED'"/>
      </xsl:when>
      <xsl:when test="$lcname = 'indexterm'">
	<xsl:value-of select="'element.db.indexterm.singular'"/>
      </xsl:when>
<!--
      <xsl:when test="$lcname = 'resource'">
	<xsl:value-of select="'element.db.file.resource'"/>
      </xsl:when>
      <xsl:when test="$lcname = 'module'">
	<xsl:value-of select="'element.db.resource.module'"/>
      </xsl:when>
-->
      <xsl:when test="$lcname = 'mml.*'">
	<xsl:value-of select="'element.db._any.mml'"/>
      </xsl:when>
      <xsl:when test="$lcname = 'svg.*'">
	<xsl:value-of select="'element.db._any.svg'"/>
      </xsl:when>
      <xsl:when test="$lcname = '*.*'">
	<xsl:value-of select="'element.db._any'"/>
      </xsl:when>
      <xsl:when test="starts-with($lcname, 'dcterms.')">
	<xsl:value-of select="$lcname"/>
      </xsl:when>
      <xsl:when test="count(key('id', concat('element.db.', $lcname))) &gt; 0">
	<xsl:value-of select="concat('element.db.', $lcname)"/>
      </xsl:when>
      <xsl:when test="count(key('id', concat('element.db.html.', $lcname))) &gt; 0">
	<xsl:value-of select="concat('element.db.html.', $lcname)"/>
      </xsl:when>
      <xsl:when test="count(key('id', concat('element.db.cals.', $lcname))) &gt; 0">
	<xsl:value-of select="concat('element.db.cals.', $lcname)"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="concat('element.db.', $lcname)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$class = 'element'
		    and following-sibling::*[1]/self::db:phrase
		    and contains(following-sibling::db:phrase[1], '(')">
      <!-- handle <tag>phrase</tag> (<phrase>db._phrase</phrase>) -->
      <xsl:variable name="pattern"
		    select="substring-before(
			      substring-after(
			        following-sibling::db:phrase[1],'('),')')"/>

      <xsl:value-of select="concat('element.',$pattern)"/>
    </xsl:when>

    <xsl:otherwise>
      <xsl:value-of select="$elemidval"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:tag">
  <xsl:variable name="class">
    <xsl:choose>
      <xsl:when test="@class">
        <xsl:value-of select="@class"/>
      </xsl:when>
      <xsl:otherwise>element</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="elemidval">
    <xsl:apply-templates select="." mode="idvalue"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$elemidval = 'NOTEXPECTED'">
      <xsl:apply-templates/>
    </xsl:when>

    <xsl:when test="$class = 'element' and count(key('id', $elemidval)) &gt; 0">
      <xsl:variable name="target" select="key('id', $elemidval)[1]"/>
      <a href="{f:href(/,$target)}">
        <xsl:apply-imports/>
      </a>
    </xsl:when>

    <xsl:when test="$class = 'element'">
      <xsl:message>
	<xsl:text>Failed to find </xsl:text>
	<xsl:value-of select="$elemidval"/>
	<xsl:text> for "</xsl:text>
	<xsl:value-of select="."/>
	<xsl:text>" (2)</xsl:text>
      </xsl:message>
      <xsl:apply-imports/>
    </xsl:when>

    <xsl:otherwise>
      <xsl:apply-imports/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:refsection">
  <xsl:variable name="html" as="element(html:div)">
    <xsl:apply-imports/>
  </xsl:variable>

  <xsl:variable name="titlepage" select="$html/html:div"/>
  <xsl:variable name="elemlist" select="$html/html:p"/>
  <xsl:variable name="count" select="count($elemlist//html:code)"/>

  <xsl:choose>
    <xsl:when test="(contains(@condition, 'ref.desc.parents')
                     or contains(@condition, 'ref.desc.children'))
                    and ($count &gt; 10)">
      <div>
        <div>
          <xsl:copy-of select="$titlepage/@*"/>
          <xsl:for-each select="$titlepage/*">
            <xsl:choose>
              <xsl:when test="self::html:h3">
                <h4>
                  <xsl:copy-of select="@*"/>
                  <xsl:copy-of select="node()"/>
                  <xsl:text>&#160;</xsl:text>
                  <span id="dls.{generate-id($html)}" style="display: inline;">
                    <a href="javascript:showDetail('{generate-id($html)}')">
                      <img src="figs/web/nav/right.gif" border="0" alt="[+]"/>
                    </a>
                  </span>
                  <span id="dlh.{generate-id($html)}" style="display: none;">
                    <a href="javascript:hideDetail('{generate-id($html)}')">
                      <img src="figs/web/nav/down.gif" border="0" alt="[+]"/>
                    </a>
                  </span>
                </h4>
              </xsl:when>
              <xsl:otherwise>
                <xsl:sequence select="."/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </div>
        <div class="shownlist" id="summary-{generate-id($html)}" style="display: block;">
          <xsl:choose>
            <xsl:when test="contains(@condition, 'ref.desc.parents')">
              <xsl:text>This element occurs in </xsl:text>
            </xsl:when>
            <xsl:when test="contains(@condition, 'ref.desc.children')">
              <xsl:text>This element contains </xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:message terminate="yes">What? That's broken.</xsl:message>
            </xsl:otherwise>
          </xsl:choose>

          <a href="javascript:showDetail('{generate-id($html)}')">
            <xsl:value-of select="$count"/>
            <xsl:text> element</xsl:text>
            <xsl:if test="count($elemlist//html:code) != 1">s</xsl:if>
          </a>
          <xsl:text>.</xsl:text>
        </div>
        <div class="hiddenlist" id="detail-{generate-id($html)}" style="display: none;">
          <xsl:sequence select="$elemlist"/>
        </div>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="$html"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="processing-instruction('lb')">
  <br/>
</xsl:template>

</xsl:stylesheet>
