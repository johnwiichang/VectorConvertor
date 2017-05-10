<?xml version="1.0" encoding="ISO-8859-1" ?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2000/svg"
    xmlns:v="urn:schemas-microsoft-com:vml"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"    
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:xlink="http://www.w3.org/1999/xlink"
>

<!-- INDEX:
   * template:
        - vml-rect
        - vml-roundrect
        - vml-line
        - vml-polyline
        - vml-curve
        - vml-oval
        - vml-arc
        - vml-image
        - elemento-imagedata
        
    * match:
        - v:rect
        - v:roundrect
        - v:line
        - v:polyline
        - v:curve
        - v:oval
        - v:arc
        - v:image 
-->

<!-- Tutte le figure di base vengono gestite nel modo seguente:
    - prima si creano eventuali gruppi contenitori (g o a) a seconda che
        siano presenti rotazioni o riferimenti esterni (href), poi vengono
        creati gli opportuni elementi, chiamando i corrispondenti template.
    NB: curve e arc vengono rappresentati (in SVG) tramite path, non avendo elementi
        specifici per rappresentarli.
-->

<!-- image viene trattata come le altre figure predefinite -->
<!-- elemento imagedata crea un elemento image -->

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ ELEMENTO RECT ****************************************** -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template match="v:rect">

<!-- Cerca eventuali rotazioni e crea un eventuale gruppo per effettuarle, posizionandosi
     opportunamente.
     Poi vengono cercati riferimenti esterni (href) e, all'interno del template 
        gestione-href, viene chiamato il template per creare l'elemento rect 
-->

<xsl:variable name="r">
    <xsl:call-template name="attributo-rotation" />
</xsl:variable>

    <xsl:variable name="x">
        <xsl:call-template name="valore-whxy">
            <xsl:with-param name="attributo"><xsl:text>x</xsl:text></xsl:with-param>
            <xsl:with-param name="converti"><xsl:text>si</xsl:text></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="y">
        <xsl:call-template name="valore-whxy">
            <xsl:with-param name="attributo"><xsl:text>y</xsl:text></xsl:with-param>
            <xsl:with-param name="converti"><xsl:text>si</xsl:text></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="w">
        <xsl:call-template name="valore-whxy">
            <xsl:with-param name="converti"><xsl:text>si</xsl:text></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="h">
        <xsl:call-template name="valore-whxy">
            <xsl:with-param name="attributo"><xsl:text>h</xsl:text></xsl:with-param>
            <xsl:with-param name="converti"><xsl:text>si</xsl:text></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>


    <xsl:choose>
        <xsl:when test="$r != '0'">
            <g>
                <xsl:attribute name="transform">
                    <xsl:text>rotate(</xsl:text>
                    <xsl:value-of select="$r" />
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$x + ($w div 2)" />
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$y + ($h div 2)" />
                    <xsl:text>)</xsl:text>
                </xsl:attribute>
            
                <xsl:call-template name="gestione-href">
                    <xsl:with-param name="nome-template">
                        <xsl:text>vml-rect</xsl:text>   
                    </xsl:with-param>
                </xsl:call-template>        
            </g>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="gestione-href">
                    <xsl:with-param name="nome-template">
                        <xsl:text>vml-rect</xsl:text>   
                    </xsl:with-param>
            </xsl:call-template>  
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="vml-rect">
    <rect>
        <xsl:call-template name="core-attrs" />
        <xsl:call-template name="attributi-paint" />
        <xsl:call-template name="attributo-title" />
        <xsl:apply-templates />
    </rect>
</xsl:template>

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ ELEMENTO ROUNDRECT ************************************* -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template match="v:roundrect">

<xsl:variable name="r">
    <xsl:call-template name="attributo-rotation" />
</xsl:variable>

    <xsl:variable name="x">
        <xsl:call-template name="valore-whxy">
            <xsl:with-param name="attributo"><xsl:text>x</xsl:text></xsl:with-param>
            <xsl:with-param name="converti"><xsl:text>si</xsl:text></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="y">
        <xsl:call-template name="valore-whxy">
            <xsl:with-param name="attributo"><xsl:text>y</xsl:text></xsl:with-param>
            <xsl:with-param name="converti"><xsl:text>si</xsl:text></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="w">
        <xsl:call-template name="valore-whxy">
            <xsl:with-param name="converti"><xsl:text>si</xsl:text></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="h">
        <xsl:call-template name="valore-whxy">
            <xsl:with-param name="attributo"><xsl:text>h</xsl:text></xsl:with-param>
            <xsl:with-param name="converti"><xsl:text>si</xsl:text></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    
    <xsl:choose>
        <xsl:when test="$r != '0'">
            <g>
                <xsl:attribute name="transform">
                    <xsl:text>rotate(</xsl:text>
                    <xsl:value-of select="$r" />
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$x + ($w div 2)" />
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$y + ($h div 2)" />
                    <xsl:text>)</xsl:text>
                </xsl:attribute>
            
                <xsl:call-template name="gestione-href">
                    <xsl:with-param name="nome-template">
                        <xsl:text>vml-roundrect</xsl:text>   
                    </xsl:with-param>
                </xsl:call-template>        
            </g>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="gestione-href">
                    <xsl:with-param name="nome-template">
                        <xsl:text>vml-roundrect</xsl:text>   
                    </xsl:with-param>
            </xsl:call-template>  
        </xsl:otherwise>
    </xsl:choose>
    
    
</xsl:template>

<xsl:template name="vml-roundrect">

    <xsl:variable name="w">
        <xsl:call-template name="valore-whxy">
            <xsl:with-param name="converti"><xsl:text>si</xsl:text></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="h">
        <xsl:call-template name="valore-whxy">
            <xsl:with-param name="attributo"><xsl:text>h</xsl:text></xsl:with-param>
            <xsl:with-param name="converti"><xsl:text>si</xsl:text></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>

    <rect>
        <xsl:call-template name="core-attrs" />
    
        <xsl:variable name="valore-rxy">
            <xsl:variable name="valore-arco">
                <xsl:choose>
                    <xsl:when test="@arcsize">
                        <xsl:choose>
                            <xsl:when test="contains(@arcsize,'%')">
                                <xsl:value-of select="normalize-space(
                                                      substring-before(@arcsize,'%')) 
                                                      div 100" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@arcsize" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>0</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
        
            <xsl:choose>
                <xsl:when test="$h &lt; $w">
                    <xsl:choose>
                        <xsl:when test="(($h) * $valore-arco) &gt; ($h div 2)">
                            <xsl:value-of select="$h div 2" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="($h) * $valore-arco" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="(($w) * $valore-arco) &gt; ($w div 2)">
                            <xsl:value-of select="$w div 2" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="($w) * $valore-arco" />
                        </xsl:otherwise>
                    </xsl:choose>         
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
    
        <xsl:attribute name="rx">
            <xsl:value-of select="$valore-rxy" />
        </xsl:attribute>
        <xsl:attribute name="ry">
            <xsl:value-of select="$valore-rxy" />
        </xsl:attribute>
    
        <xsl:call-template name="attributi-paint" />
        <xsl:call-template name="attributo-title" />
        <xsl:apply-templates />
    </rect>
</xsl:template>

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ ELEMENTO LINE ****************************************** -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template match="v:line">

<xsl:variable name="r">
    <xsl:call-template name="attributo-rotation" />
</xsl:variable>

   <xsl:variable name="x1">
        <xsl:choose>
            <xsl:when test="@from">
                <xsl:call-template name="conversione">
                    <xsl:with-param name="attributo">
                        <xsl:call-template name="primo-valore">
                            <xsl:with-param name="stringa">
                                <xsl:value-of select="@from" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="nome">
                      <xsl:text>x</xsl:text>
                    </xsl:with-param>       
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>0</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="y1">
        <xsl:choose>
            <xsl:when test="@from">
                <xsl:call-template name="conversione">
                    <xsl:with-param name="attributo">
                        <xsl:call-template name="secondo-valore">
                            <xsl:with-param name="stringa">
                                <xsl:value-of select="@from" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="nome">
                      <xsl:text>x</xsl:text>
                    </xsl:with-param>       
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>0</xsl:text>
            </xsl:otherwise>
        </xsl:choose>            
    </xsl:variable>
    
    <xsl:variable name="x2">
        <xsl:choose>
            <xsl:when test="@to">
             <xsl:call-template name="conversione">
                    <xsl:with-param name="attributo">
                        <xsl:call-template name="primo-valore">
                            <xsl:with-param name="stringa">
                                <xsl:value-of select="@to" />
                            </xsl:with-param>
                            <xsl:with-param name="default">
                                <xsl:text>30</xsl:text>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="nome">
                      <xsl:text>x</xsl:text>
                    </xsl:with-param>       
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>30</xsl:text>
            </xsl:otherwise>
        </xsl:choose>             
    </xsl:variable>
    <xsl:variable name="y2">
        <xsl:choose>
            <xsl:when test="@to">
                <xsl:call-template name="conversione">
                    <xsl:with-param name="attributo">
                        <xsl:call-template name="secondo-valore">
                            <xsl:with-param name="stringa">
                                <xsl:value-of select="@to" />
                            </xsl:with-param>
                            <xsl:with-param name="default">
                                <xsl:text>20</xsl:text>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="nome">
                      <xsl:text>x</xsl:text>
                    </xsl:with-param>       
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>20</xsl:text>
            </xsl:otherwise>
        </xsl:choose>  
    </xsl:variable>  

    <xsl:choose>
        <xsl:when test="$r != '0'">
            <g>
                <xsl:attribute name="transform">
                    <xsl:text>rotate(</xsl:text>
                    <xsl:value-of select="$r" />
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$x1 + (($x2 - $x1) div 2)" />
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$y1 + (($y2 - $y1)div 2)" />
                    <xsl:text>)</xsl:text>
                </xsl:attribute>
            
                <xsl:call-template name="gestione-href">
                    <xsl:with-param name="nome-template">
                        <xsl:text>vml-line</xsl:text>   
                    </xsl:with-param>
                </xsl:call-template>        
            </g>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="gestione-href">
                    <xsl:with-param name="nome-template">
                        <xsl:text>vml-line</xsl:text>   
                    </xsl:with-param>
            </xsl:call-template>  
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="vml-line">
   <xsl:variable name="x1">
        <xsl:choose>
            <xsl:when test="@from">
                <xsl:call-template name="conversione">
                    <xsl:with-param name="attributo">
                        <xsl:call-template name="primo-valore">
                            <xsl:with-param name="stringa">
                                <xsl:value-of select="@from" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="nome">
                      <xsl:text>x</xsl:text>
                    </xsl:with-param>       
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>0</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="y1">
        <xsl:choose>
            <xsl:when test="@from">
                <xsl:call-template name="conversione">
                    <xsl:with-param name="attributo">
                        <xsl:call-template name="secondo-valore">
                            <xsl:with-param name="stringa">
                                <xsl:value-of select="@from" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="nome">
                      <xsl:text>x</xsl:text>
                    </xsl:with-param>       
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>0</xsl:text>
            </xsl:otherwise>
        </xsl:choose>            
    </xsl:variable>
    
    <xsl:variable name="x2">
        <xsl:choose>
            <xsl:when test="@to">
             <xsl:call-template name="conversione">
                    <xsl:with-param name="attributo">
                        <xsl:call-template name="primo-valore">
                            <xsl:with-param name="stringa">
                                <xsl:value-of select="@to" />
                            </xsl:with-param>
                            <xsl:with-param name="default">
                                <xsl:text>30</xsl:text>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="nome">
                      <xsl:text>x</xsl:text>
                    </xsl:with-param>       
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>30</xsl:text>
            </xsl:otherwise>
        </xsl:choose>             
    </xsl:variable>
    <xsl:variable name="y2">
        <xsl:choose>
            <xsl:when test="@to">
                <xsl:call-template name="conversione">
                    <xsl:with-param name="attributo">
                        <xsl:call-template name="secondo-valore">
                            <xsl:with-param name="stringa">
                                <xsl:value-of select="@to" />
                            </xsl:with-param>
                            <xsl:with-param name="default">
                                <xsl:text>20</xsl:text>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="nome">
                      <xsl:text>x</xsl:text>
                    </xsl:with-param>       
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>20</xsl:text>
            </xsl:otherwise>
        </xsl:choose>  
    </xsl:variable>  

    <line>
        <xsl:call-template name="core-attrs" />
    
        <xsl:attribute name="x1"><xsl:value-of select="$x1" /></xsl:attribute>
        <xsl:attribute name="y1"><xsl:value-of select="$y1" /></xsl:attribute>
        <xsl:attribute name="x2"><xsl:value-of select="$x2" /></xsl:attribute>
        <xsl:attribute name="y2"><xsl:value-of select="$y2" /></xsl:attribute>
    
        <xsl:call-template name="attributi-paint" />
        <xsl:call-template name="attributo-title" />
        <xsl:apply-templates />
    </line>

</xsl:template>

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ ELEMENTO POLYLINE ************************************** -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template match="v:polyline">

<xsl:variable name="r">
    <xsl:call-template name="attributo-rotation" />
</xsl:variable>

    <xsl:variable name="x">
        <xsl:call-template name="valore-whxy">
            <xsl:with-param name="attributo"><xsl:text>x</xsl:text></xsl:with-param>
            <xsl:with-param name="converti"><xsl:text>si</xsl:text></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="y">
        <xsl:call-template name="valore-whxy">
            <xsl:with-param name="attributo"><xsl:text>y</xsl:text></xsl:with-param>
            <xsl:with-param name="converti"><xsl:text>si</xsl:text></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="first-x">
        <xsl:call-template name="primo-valore">
            <xsl:with-param name="stringa">
                <xsl:value-of select="@points" />
            </xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="first-y">
        <xsl:call-template name="secondo-valore">
            <xsl:with-param name="stringa">
                <xsl:value-of select="@points" />
            </xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="last-x">
        <xsl:call-template name="penultimo-valore">
            <xsl:with-param name="stringa">
                <xsl:value-of select="@points" />
            </xsl:with-param>
            <xsl:with-param name="default">
                <xsl:text>20</xsl:text>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="last-y">
        <xsl:call-template name="ultimo-valore">
            <xsl:with-param name="stringa">
                <xsl:value-of select="@points" />
            </xsl:with-param>
            <xsl:with-param name="default">
                <xsl:text>20</xsl:text>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
        <xsl:when test="$r != '0'">
            <g>
                <xsl:attribute name="transform">
                    <xsl:text>rotate(</xsl:text>
                    <xsl:value-of select="$r" />
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$x + $first-x + (($last-x - $first-x) div 2)" />
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$y + $first-y + (($last-y - $first-y) div 2)" />
                    <xsl:text>)</xsl:text>
                </xsl:attribute>
            
                <xsl:call-template name="gestione-href">
                    <xsl:with-param name="nome-template">
                        <xsl:text>vml-polyline</xsl:text>   
                    </xsl:with-param>
                </xsl:call-template>        
            </g>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="gestione-href">
                    <xsl:with-param name="nome-template">
                        <xsl:text>vml-polyline</xsl:text>   
                    </xsl:with-param>
            </xsl:call-template>  
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="vml-polyline">
    <polyline>
        <xsl:call-template name="core-attrs" />
    
        <xsl:attribute name="points">
            <xsl:choose>
                <xsl:when test="@points">
                    <xsl:value-of select="@points" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>0 0 10 10</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <xsl:call-template name="attributi-paint" />
        <xsl:call-template name="attributo-title" />
        <xsl:apply-templates />
    </polyline>
</xsl:template>

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ ELEMENTO CURVE ***************************************** -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template match="v:curve">
<xsl:variable name="r">
    <xsl:call-template name="attributo-rotation" />
</xsl:variable>

   <xsl:variable name="x1">
        <xsl:choose>
            <xsl:when test="@from">
                <xsl:call-template name="conversione">
                    <xsl:with-param name="attributo">
                        <xsl:call-template name="primo-valore">
                            <xsl:with-param name="stringa">
                                <xsl:value-of select="@from" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="nome">
                      <xsl:text>x</xsl:text>
                    </xsl:with-param>       
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>0</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="y1">
        <xsl:choose>
            <xsl:when test="@from">
                <xsl:call-template name="conversione">
                    <xsl:with-param name="attributo">
                        <xsl:call-template name="secondo-valore">
                            <xsl:with-param name="stringa">
                                <xsl:value-of select="@from" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="nome">
                      <xsl:text>x</xsl:text>
                    </xsl:with-param>       
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>0</xsl:text>
            </xsl:otherwise>
        </xsl:choose>            
    </xsl:variable>
    
    <xsl:variable name="x2">
        <xsl:choose>
            <xsl:when test="@to">
             <xsl:call-template name="conversione">
                    <xsl:with-param name="attributo">
                        <xsl:call-template name="primo-valore">
                            <xsl:with-param name="stringa">
                                <xsl:value-of select="@to" />
                            </xsl:with-param>
                            <xsl:with-param name="default">
                                <xsl:text>30</xsl:text>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="nome">
                      <xsl:text>x</xsl:text>
                    </xsl:with-param>       
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>30</xsl:text>
            </xsl:otherwise>
        </xsl:choose>             
    </xsl:variable>
    <xsl:variable name="y2">
        <xsl:choose>
            <xsl:when test="@to">
                <xsl:call-template name="conversione">
                    <xsl:with-param name="attributo">
                        <xsl:call-template name="secondo-valore">
                            <xsl:with-param name="stringa">
                                <xsl:value-of select="@to" />
                            </xsl:with-param>
                            <xsl:with-param name="default">
                                <xsl:text>20</xsl:text>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="nome">
                      <xsl:text>x</xsl:text>
                    </xsl:with-param>       
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>20</xsl:text>
            </xsl:otherwise>
        </xsl:choose>  
    </xsl:variable>  

    <xsl:choose>
        <xsl:when test="$r != '0'">
            <g>
                <xsl:attribute name="transform">
                    <xsl:text>rotate(</xsl:text>
                    <xsl:value-of select="$r" />
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$x1 + (($x2 - $x1) div 2)" />
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$y1 + (($y2 - $y1)div 2)" />
                    <xsl:text>)</xsl:text>
                </xsl:attribute>
            
                <xsl:call-template name="gestione-href">
                    <xsl:with-param name="nome-template">
                        <xsl:text>vml-curve</xsl:text>   
                    </xsl:with-param>
                </xsl:call-template>        
            </g>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="gestione-href">
                    <xsl:with-param name="nome-template">
                        <xsl:text>vml-curve</xsl:text>   
                    </xsl:with-param>
            </xsl:call-template>  
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="vml-curve">

<!-- Crea la curva utilizzando un path -->

    <path>
        <xsl:call-template name="core-attrs" />
    
        <xsl:attribute name="d">
            <xsl:text>m </xsl:text>
            <xsl:choose>
                <xsl:when test="@from">
                    <xsl:value-of select="@from" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>0 0</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text> C </xsl:text>
            <xsl:choose>
                <xsl:when test="@control1">
                    <xsl:value-of select="@control1" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>10 10</xsl:text>
                </xsl:otherwise>
            </xsl:choose>        
            <xsl:text> </xsl:text>
            <xsl:choose>
                <xsl:when test="@control2">
                    <xsl:value-of select="@control2" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>20 0</xsl:text>
                </xsl:otherwise>
            </xsl:choose>         
            <xsl:text> </xsl:text>
            <xsl:choose>
                <xsl:when test="@to">
                    <xsl:value-of select="@to" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>30 20</xsl:text>
                </xsl:otherwise>
            </xsl:choose>    
        </xsl:attribute>
    
        <xsl:call-template name="attributi-paint" />
        <xsl:call-template name="attributo-title" />
        <xsl:apply-templates />
    </path>
</xsl:template>

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ ELEMENTO OVAL ****************************************** -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template match="v:oval">
<xsl:variable name="r">
    <xsl:call-template name="attributo-rotation" />
</xsl:variable>

     <xsl:variable name="x">
        <xsl:call-template name="valore-whxy">
            <xsl:with-param name="attributo"><xsl:text>x</xsl:text></xsl:with-param>
            <xsl:with-param name="converti"><xsl:text>si</xsl:text></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="y">
        <xsl:call-template name="valore-whxy">
            <xsl:with-param name="attributo"><xsl:text>y</xsl:text></xsl:with-param>
            <xsl:with-param name="converti"><xsl:text>si</xsl:text></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="w">
        <xsl:call-template name="valore-whxy">
            <xsl:with-param name="converti"><xsl:text>si</xsl:text></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="h">
        <xsl:call-template name="valore-whxy">
            <xsl:with-param name="attributo"><xsl:text>h</xsl:text></xsl:with-param>
            <xsl:with-param name="converti"><xsl:text>si</xsl:text></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    
    <xsl:choose>
        <xsl:when test="$r != '0'">
            <g>
                <xsl:attribute name="transform">
                    <xsl:text>rotate(</xsl:text>
                    <xsl:value-of select="$r" />
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$x + ($w div 2)" />
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$y + ($h div 2)" />
                    <xsl:text>)</xsl:text>
                </xsl:attribute>
            
                <xsl:call-template name="gestione-href">
                    <xsl:with-param name="nome-template">
                        <xsl:text>vml-oval</xsl:text>   
                    </xsl:with-param>
                </xsl:call-template>        
            </g>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="gestione-href">
                    <xsl:with-param name="nome-template">
                        <xsl:text>vml-oval</xsl:text>   
                    </xsl:with-param>
            </xsl:call-template>  
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="vml-oval">

     <xsl:variable name="x">
        <xsl:call-template name="valore-whxy">
            <xsl:with-param name="attributo"><xsl:text>x</xsl:text></xsl:with-param>
            <xsl:with-param name="converti"><xsl:text>si</xsl:text></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="y">
        <xsl:call-template name="valore-whxy">
            <xsl:with-param name="attributo"><xsl:text>y</xsl:text></xsl:with-param>
            <xsl:with-param name="converti"><xsl:text>si</xsl:text></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="w">
        <xsl:call-template name="valore-whxy">
            <xsl:with-param name="converti"><xsl:text>si</xsl:text></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="h">
        <xsl:call-template name="valore-whxy">
            <xsl:with-param name="attributo"><xsl:text>h</xsl:text></xsl:with-param>
            <xsl:with-param name="converti"><xsl:text>si</xsl:text></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>

    <ellipse>
        <xsl:call-template name="core-attrs" />
    
        <xsl:attribute name="cx">
            <xsl:value-of select="$x + ($w div 2)" />
        </xsl:attribute>
        <xsl:attribute name="cy">
            <xsl:value-of select="$y + ($h div 2)" />
        </xsl:attribute>
        <xsl:attribute name="rx">
            <xsl:value-of select="$w div 2" />
        </xsl:attribute>
        <xsl:attribute name="ry">
            <xsl:value-of select="$h div 2" />
        </xsl:attribute>        
    
        <xsl:call-template name="attributi-paint" />
        <xsl:call-template name="attributo-title" />
        <xsl:apply-templates />
    </ellipse>
</xsl:template>

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ ELEMENTO ARC ******************************************* -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template match="v:arc">

<xsl:variable name="r">
    <xsl:call-template name="attributo-rotation" />
</xsl:variable>

    <xsl:variable name="x">
        <xsl:call-template name="valore-whxy">
            <xsl:with-param name="attributo"><xsl:text>x</xsl:text></xsl:with-param>
            <xsl:with-param name="converti"><xsl:text>si</xsl:text></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="y">
        <xsl:call-template name="valore-whxy">
            <xsl:with-param name="attributo"><xsl:text>y</xsl:text></xsl:with-param>
            <xsl:with-param name="converti"><xsl:text>si</xsl:text></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="w">
        <xsl:call-template name="valore-whxy">
            <xsl:with-param name="converti"><xsl:text>si</xsl:text></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="h">
        <xsl:call-template name="valore-whxy">
            <xsl:with-param name="attributo"><xsl:text>h</xsl:text></xsl:with-param>
            <xsl:with-param name="converti"><xsl:text>si</xsl:text></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
        <xsl:when test="$r != '0'">
            <g>
                <xsl:attribute name="transform">
                    <xsl:text>rotate(</xsl:text>
                    <xsl:value-of select="$r" />
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$x + ($w div 2)" />
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$y + ($h div 2)" />
                    <xsl:text>)</xsl:text>
                </xsl:attribute>
            
                <xsl:call-template name="gestione-href">
                    <xsl:with-param name="nome-template">
                        <xsl:text>vml-arc</xsl:text>   
                    </xsl:with-param>
                </xsl:call-template>        
            </g>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="gestione-href">
                    <xsl:with-param name="nome-template">
                        <xsl:text>vml-arc</xsl:text>   
                    </xsl:with-param>
            </xsl:call-template>  
        </xsl:otherwise>
    </xsl:choose>

</xsl:template>

<xsl:template name="vml-arc">

<!-- Crea l'arco utilizzando un path: per semplicità gli archi vengono approssimati
      tramite l'utilizzo esclusivo di 4 porzioni di arco:
        0-90, 90-180, 180-270, 270-360.
      Cioè, posso utilizzare solo questi quarti di arco, se ho per esempio un arco
       che va da 300 a 120, rappresenterò un arco da 270 a 360, uno da 0 a 90 e uno
       da 90 a 120.
-->

    <xsl:variable name="x">
        <xsl:call-template name="valore-whxy">
            <xsl:with-param name="attributo"><xsl:text>x</xsl:text></xsl:with-param>
            <xsl:with-param name="converti"><xsl:text>si</xsl:text></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="y">
        <xsl:call-template name="valore-whxy">
            <xsl:with-param name="attributo"><xsl:text>y</xsl:text></xsl:with-param>
            <xsl:with-param name="converti"><xsl:text>si</xsl:text></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="w">
        <xsl:call-template name="valore-whxy">
            <xsl:with-param name="converti"><xsl:text>si</xsl:text></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="h">
        <xsl:call-template name="valore-whxy">
            <xsl:with-param name="attributo"><xsl:text>h</xsl:text></xsl:with-param>
            <xsl:with-param name="converti"><xsl:text>si</xsl:text></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    
  <path>
        <xsl:call-template name="attributo-vari-core" />
    
        <xsl:variable name="startangle">
            <xsl:choose>
                <xsl:when test="@startangle">
                    <xsl:value-of select="@startangle" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>0</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="endangle">
            <xsl:choose>
                <xsl:when test="@endangle">
                    <xsl:value-of select="@endangle" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>90</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>        
        
        <xsl:attribute name="d">
            <xsl:text>M </xsl:text>
            
            <xsl:value-of select="$x + ($w div 2)" />
            <xsl:text> </xsl:text>
            <xsl:value-of select="$y" />
            
            <!-- 0 - 90 -->
            <xsl:if test="(($startangle &gt;= '0') and ($startangle &lt;= '90'))">
                <xsl:text>M </xsl:text>
                <xsl:value-of select="$x + ($w div 2)" />
                <xsl:text> </xsl:text>
                <xsl:value-of select="$y" />
                
                <xsl:text> C </xsl:text>
                <xsl:value-of select="$x + $w" />
                <xsl:text> </xsl:text>
                <xsl:value-of select="$y" />
                <xsl:text> </xsl:text>
                
                <xsl:value-of select="$x + $w" />
                <xsl:text> </xsl:text>
                <xsl:value-of select="$y + ($h div 2)" />
                
                <xsl:text> </xsl:text>
                <xsl:value-of select="$x + $w" />
                <xsl:text> </xsl:text>
                <xsl:value-of select="$y + ($h div 2)" />
            </xsl:if>
            
            <!-- 90 - 180 -->
            <xsl:if test="($startangle &gt; '90' and $startangle &lt;'180') or 
                          (($endangle &lt;= '180' and $endangle &gt; '90')) or 
                          (($endangle &gt; '90') and ($endangle &lt;= '180')) or
                          (($endangle &gt;= '180') and ($startangle &lt;= '90'))
                          ">  
                <xsl:text>M </xsl:text>
                <xsl:value-of select="$x + $w" />
                <xsl:text> </xsl:text>
                <xsl:value-of select="$y + ($h div 2)" />       
                          
                <xsl:text> C </xsl:text>
                <xsl:value-of select="$x + $w" />
                <xsl:text> </xsl:text>
                <xsl:value-of select="$y + $h" />
                <xsl:text> </xsl:text>
                
                <xsl:value-of select="$x + ($w div 2)" />
                <xsl:text> </xsl:text>
                <xsl:value-of select="$y + $h" />
                
                <xsl:text> </xsl:text>
                <xsl:value-of select="$x + ($w div 2)" />
                <xsl:text> </xsl:text>
                <xsl:value-of select="$y + $h" />
            </xsl:if>
         
            <!-- 180 - 270 -->  
            <xsl:if test="(($startangle &gt;= '180') and ($startangle &lt;= '270')) or 
                        ($endangle &gt; '180')">    
                <xsl:text>M </xsl:text>
                <xsl:value-of select="$x + ($w div 2)" />
                <xsl:text> </xsl:text>
                <xsl:value-of select="$y + $h" />   
             
                <xsl:text> C </xsl:text>
                <xsl:value-of select="$x" />
                <xsl:text> </xsl:text>
                <xsl:value-of select="$y + $h" />
                <xsl:text> </xsl:text>
                
                <xsl:value-of select="$x" />
                <xsl:text> </xsl:text>
                <xsl:value-of select="$y + ($h div 2)" />
                
                <xsl:text> </xsl:text>
                <xsl:value-of select="$x" />
                <xsl:text> </xsl:text>
                <xsl:value-of select="$y + ($h div 2)" />
            </xsl:if>
            
            <!-- 270 - 360 -->   
            <xsl:if test="(($startangle &gt;= '270') and ($startangle &lt;= '360')) or 
                        ($endangle &gt; '270')">   
                <xsl:text>M </xsl:text>
                <xsl:value-of select="$x" />
                <xsl:text> </xsl:text>
                <xsl:value-of select="$y + ($h div 2)" />

                <xsl:text> C </xsl:text>
                <xsl:value-of select="$x" />
                <xsl:text> </xsl:text>
                <xsl:value-of select="$y" />
                <xsl:text> </xsl:text>
                
                <xsl:value-of select="$x + ($w div 2)" />
                <xsl:text> </xsl:text>
                <xsl:value-of select="$y" />
                
                <xsl:text> </xsl:text>
                <xsl:value-of select="$x + ($w div 2)" />
                <xsl:text> </xsl:text>
                <xsl:value-of select="$y" />
            </xsl:if>
        </xsl:attribute>
    
        <xsl:call-template name="attributi-paint" />
        <xsl:call-template name="attributo-title" />
        <xsl:apply-templates />
    </path>
</xsl:template>

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ ELEMENTO IMAGE ***************************************** -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template match="v:image">
<xsl:variable name="r">
    <xsl:call-template name="attributo-rotation" />
</xsl:variable>

     <xsl:variable name="x">
        <xsl:call-template name="valore-whxy">
            <xsl:with-param name="attributo"><xsl:text>x</xsl:text></xsl:with-param>
            <xsl:with-param name="converti"><xsl:text>si</xsl:text></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="y">
        <xsl:call-template name="valore-whxy">
            <xsl:with-param name="attributo"><xsl:text>y</xsl:text></xsl:with-param>
            <xsl:with-param name="converti"><xsl:text>si</xsl:text></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="w">
        <xsl:call-template name="valore-whxy">
            <xsl:with-param name="converti"><xsl:text>si</xsl:text></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="h">
        <xsl:call-template name="valore-whxy">
            <xsl:with-param name="attributo"><xsl:text>h</xsl:text></xsl:with-param>
            <xsl:with-param name="converti"><xsl:text>si</xsl:text></xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    
    <xsl:choose>
        <xsl:when test="$r != '0'">
            <g>
                <xsl:attribute name="transform">
                    <xsl:text>rotate(</xsl:text>
                    <xsl:value-of select="$r" />
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$x + ($w div 2)" />
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$y + ($h div 2)" />
                    <xsl:text>)</xsl:text>
                </xsl:attribute>
            
                <xsl:call-template name="gestione-href">
                    <xsl:with-param name="nome-template">
                        <xsl:text>vml-image</xsl:text>   
                    </xsl:with-param>
                </xsl:call-template>        
            </g>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="gestione-href">
                    <xsl:with-param name="nome-template">
                        <xsl:text>vml-image</xsl:text>   
                    </xsl:with-param>
            </xsl:call-template>  
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="vml-image">
    <image>
        <xsl:call-template name="core-attrs" />
        <xsl:call-template name="attributo-viewbox" />
        <xsl:call-template name="attributi-paint">
            <xsl:with-param name="default">
                <xsl:text>no</xsl:text>
            </xsl:with-param>
        </xsl:call-template>
    
        <xsl:if test="@src">
            <xsl:attribute name="xlink:href">
                <xsl:value-of select="@src" />
            </xsl:attribute>
        </xsl:if>
    
        <xsl:call-template name="attributo-title" />
        <xsl:apply-templates />
    </image>
</xsl:template>

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ ELEMENTO IMAGEDATA ************************************* -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template name="elemento-imagedata">

<!-- chiamato da shape, crea un immagine grande quanto la dimensione di shape -->

<image width="100%" height="100%">
    <xsl:call-template name="attributi-paint" />
    
    <xsl:if test="@src">
        <xsl:attribute name="xlink:href">
            <xsl:value-of select="@src" />
        </xsl:attribute>
    </xsl:if>
    
    <xsl:call-template name="attributo-title" />
    <xsl:apply-templates />
</image>
</xsl:template>


</xsl:stylesheet>
