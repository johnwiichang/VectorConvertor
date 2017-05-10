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
        - core-attrs
        - attributo-vari-core
        - attributo-title
        - attributi-style
        - attributo-viewbox
            - valore-coordsize
        - attributi-paint     
        - attributo-rotation
        - moltiplicazione-cs
-->

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ TEMPLATE: CORE-ATTRS *********************************** -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template name="core-attrs">
    <xsl:call-template name="attributi-style" />
    <xsl:call-template name="attributo-vari-core" />
</xsl:template>

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ TEMPLATE: ATTRIBUTI VARI CORE ************************** -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template name="attributo-vari-core">
<!-- attributi non gestiti: target, wrapcoords -->
<!-- Nb: l'attributo href e gestito a parte -->

<!-- attributo title gestito a parte, per questioni di eleganza nella posizione degli
     attributi, prima quelli di posizionamento, poi quelli grafici -->

<xsl:if test="@id">
    <xsl:attribute name="id">
        <xsl:value-of select="@id" />
    </xsl:attribute>
</xsl:if>

<xsl:if test="@class">
    <xsl:attribute name="class">
        <xsl:value-of select="@class" />
    </xsl:attribute>
</xsl:if>
<xsl:if test="@alt">
    <xsl:attribute name="alt">
        <xsl:value-of select="@alt" />
    </xsl:attribute>
</xsl:if>

</xsl:template>

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ TEMPLATE: ATTRIBUTO TITLE ****************************** -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template name="attributo-title" >
<xsl:if test="@title">
    <title>
        <xsl:value-of select="@title" />
    </title>
</xsl:if>
</xsl:template>

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ TEMPLATE: ATTRIBUTI-STYLE ****************************** -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template name="attributi-style">
    <xsl:param name="aggiustamento"><xsl:text></xsl:text></xsl:param> 
    <!-- serve per aggiustare il valore di font-size per textpath definiti all'interno di
         shapetype -->
         
<!-- cerca l'attributo style e ne estrae ogni elemento, creando un opportuno attributo -->

<!-- proprietà non gestite: visibility, margin-top, center-y, margin-left,
                            center-x, z-index, flip, position, 
-->
<xsl:if test="@style">
  
        <!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXX LEFT XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->
         <xsl:if test="contains(@style,'left') or contains(@style,'LEFT')">
            <xsl:attribute name="x">
                <xsl:variable name="x-temp">
                    <xsl:call-template name="valore-whxy">
                        <xsl:with-param name="attributo">
                            <xsl:text>x</xsl:text>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="count(ancestor::v:*) &gt; 0">
                        <xsl:call-template name="conversione">
                            <xsl:with-param name="attributo">
                                <xsl:value-of select="$x-temp" />
                             </xsl:with-param>
                           <xsl:with-param name="nome">
                                <xsl:text>x</xsl:text>
                            </xsl:with-param>                                    
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$x-temp" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute> 
        </xsl:if>
        
        <!-- imposto il valore di default di x, per elementi di tipo group --> 
        <xsl:choose>
            <xsl:when test="(name() = 'v:group') and 
                            (contains(@style,'left') or contains(@style,'LEFT'))">
            </xsl:when>
            <xsl:when test="name() = 'v:group'">
                <xsl:attribute name="x">
                    <xsl:text>10</xsl:text>
                </xsl:attribute>
            </xsl:when>
        </xsl:choose>
        
        <!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXX TOP XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->
        <xsl:if test="contains(@style,'top') or contains(@style,'TOP')">
            <xsl:attribute name="y">
                <xsl:variable name="y-temp">
                    <xsl:call-template name="valore-whxy">
                        <xsl:with-param name="attributo">
                            <xsl:text>y</xsl:text>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="count(ancestor::v:*) &gt; 0">
                        <xsl:call-template name="conversione">
                            <xsl:with-param name="attributo">
                                <xsl:value-of select="$y-temp" />
                             </xsl:with-param>
                           <xsl:with-param name="nome">
                                <xsl:text>y</xsl:text>
                            </xsl:with-param>                                    
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$y-temp" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </xsl:if>
        
        <!-- imposto il valore di default di y, per elementi di tipo group -->
        <xsl:choose>
            <xsl:when test="(name() = 'v:group') and 
                            (contains(@style,'top') or contains(@style,'TOP'))">
            </xsl:when>
            <xsl:when test="name() = 'v:group'">
                <xsl:attribute name="y">
                    <xsl:text>15</xsl:text>
                </xsl:attribute>
            </xsl:when>
        </xsl:choose>
        
        <!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXX WIDTH - HEIGHT XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->
         <xsl:if test="contains(@style,'width') or contains(@style,'WIDTH') or 
                       contains(@style,'height') or contains(@style,'HEIGHT')">

            <xsl:attribute name="width">
                <xsl:variable name="w-temp">
                    <xsl:call-template name="valore-whxy" />
                </xsl:variable>
                <xsl:choose>
                    <!-- altrimenti crea dei problemi: divisione per 0 -->
                    <xsl:when test="$w-temp = '0'">
                        <xsl:text>0.001</xsl:text>
                    </xsl:when>
                    <xsl:when test="count(ancestor::v:*) &gt; 0">
                        <xsl:call-template name="conversione">
                            <xsl:with-param name="attributo">
                                <xsl:value-of select="$w-temp" />
                             </xsl:with-param>
                           <xsl:with-param name="nome">
                                <xsl:text>width</xsl:text>
                            </xsl:with-param>                                    
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$w-temp" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute> 
                            
            <xsl:attribute name="height">
            <xsl:variable name="h-temp">
                    <xsl:call-template name="valore-whxy">
                        <xsl:with-param name="attributo">
                            <xsl:text>h</xsl:text>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$h-temp = '0'">
                        <xsl:text>0.001</xsl:text>
                    </xsl:when>
                    <xsl:when test="count(ancestor::v:*) &gt; 0">
                        <xsl:call-template name="conversione">
                            <xsl:with-param name="attributo">
                                <xsl:value-of select="$h-temp" />
                             </xsl:with-param>
                           <xsl:with-param name="nome">
                                <xsl:text>height</xsl:text>
                            </xsl:with-param>                                    
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$h-temp" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>         
        </xsl:if>
        
        <!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXX FONT-SIZE XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->
        <!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->
         <xsl:if test="contains(@style,'font-size') or contains(@style,'FONT-SIZE')">
            <xsl:variable name="attributo">
                <xsl:choose>
                    <xsl:when test="contains(@style,'font-size')">
                        <xsl:text>font-size</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>FONT-SIZE</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="stringa-temp">
                <xsl:choose>
                    <xsl:when test="contains(substring-after(@style,$attributo),';')">
                        <xsl:value-of select="normalize-space(substring-before(
                                      substring-after(@style,$attributo),';'))" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(
                                      substring-after(@style,$attributo))" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            
            <xsl:attribute name="font-size">
                <xsl:variable name="valore-font">
                    <xsl:value-of select="normalize-space(
                                          substring-after($stringa-temp,':'))" />
                </xsl:variable>
                
                <xsl:call-template name="calcola-font">
                    <xsl:with-param name="font">
                        <xsl:call-template name="conversione">
                            <xsl:with-param name="attributo">
                                <xsl:value-of select="$valore-font" />
                            </xsl:with-param>
                            <xsl:with-param name="nome">
                                <xsl:text>font-size</xsl:text>
                            </xsl:with-param>
                            <xsl:with-param name="tipo">
                                <xsl:text>real</xsl:text>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="aggiustamento">
                        <xsl:value-of select="$aggiustamento" />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:attribute>
        </xsl:if>
        
        <!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXX FONT-FAMILY XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->
        <!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->
         <xsl:if test="contains(@style,'font-family') or contains(@style,'FONT-FAMILY')">
            <xsl:variable name="attributo">
                <xsl:choose>
                    <xsl:when test="contains(@style,'font-family')">
                        <xsl:text>font-family</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>FONT-FAMILY</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            
            <xsl:variable name="ff-temp">
                <xsl:choose>
                    <xsl:when test="contains(substring-after(@style,$attributo),';')">
                        <xsl:value-of select="normalize-space(substring-before(
                                      substring-after(@style,$attributo),';'))" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(
                                      substring-after(@style,$attributo))" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            
            <xsl:variable name="ff">
                    <xsl:value-of select="normalize-space(
                                          substring-after($ff-temp,':'))" />
            </xsl:variable>
            <xsl:attribute name="font-family">
                <xsl:value-of select="$ff" />
            </xsl:attribute>
         </xsl:if>
         
        <!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXX FONT-WEIGHT XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->
        <!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->
         <xsl:if test="contains(@style,'font-weight') or contains(@style,'FONT-WEIGHT')">
            <xsl:variable name="attributo">
                <xsl:choose>
                    <xsl:when test="contains(@style,'font-weight')">
                        <xsl:text>font-weight</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>FONT-WEIGHT</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="fw-temp">
                <xsl:choose>
                    <xsl:when test="contains(substring-after(@style,$attributo),';')">
                        <xsl:value-of select="normalize-space(substring-before(
                                      substring-after(@style,$attributo),';'))" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(
                                      substring-after(@style,$attributo))" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="fw">
                    <xsl:value-of select="normalize-space(
                                          substring-after($fw-temp,':'))" />
            </xsl:variable>
            <xsl:attribute name="font-weight">
                <xsl:value-of select="$fw" />
            </xsl:attribute>
         </xsl:if>
         
         <!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX COLOR XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->
         <!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->
         <xsl:if test="contains(@style,'color') or contains(@style,'COLOR')">
            <xsl:variable name="attributo">
                <xsl:choose>
                    <xsl:when test="contains(@style,'color')">
                        <xsl:text>color</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>COLOR</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="color-temp">
                <xsl:choose>
                    <xsl:when test="contains(substring-after(@style,$attributo),';')">
                        <xsl:value-of select="normalize-space(substring-before(
                                      substring-after(@style,$attributo),';'))" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(
                                      substring-after(@style,$attributo))" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="color">
                    <xsl:value-of select="normalize-space(
                                          substring-after($color-temp,':'))" />
            </xsl:variable>
            <xsl:attribute name="fill">
                <xsl:value-of select="$color" />
            </xsl:attribute>
         </xsl:if>
</xsl:if>
</xsl:template>

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ TEMPLATE: ATTRIBUTO-VIEWBOX **************************** -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template name="attributo-viewbox">

<!-- cerca gli attributi coordorigin e coordsize (eventualmente cercando negli 
     elementi ancestor) e crea l'attributo viewbox -->

<xsl:attribute name="viewBox">
<xsl:choose>
    <xsl:when test="@coordorigin">
        <xsl:choose>
            <xsl:when test="contains(@coordorigin,',')">
                <xsl:value-of select="concat(substring-before(@coordorigin,','),' ',
                                             substring-after(@coordorigin,','))" />
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="@coordorigin" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:when>
    <xsl:when test="((ancestor::*[@coordorigin]) and 
                    (name() != 'v:shapetype') and (name() != 'v:shape'))">
        <xsl:for-each select="ancestor::*[@coordorigin]">
            <xsl:if test="position() = last()">
                <xsl:choose>
                    <xsl:when test="contains(@coordorigin,',')">
                        <xsl:value-of select="concat(substring-before(@coordorigin,','),' ',
                                                     substring-after(@coordorigin,','))" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@coordorigin" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>    
    </xsl:when>
    <xsl:otherwise>
        <xsl:text>0 0</xsl:text>
    </xsl:otherwise>
</xsl:choose>
<xsl:text> </xsl:text>

<xsl:call-template name="valore-coordsize" />

</xsl:attribute>

<xsl:attribute name="preserveAspectRatio">
    <xsl:text>none</xsl:text>
</xsl:attribute>

<xsl:attribute name="overflow">
    <xsl:text>visible</xsl:text>
</xsl:attribute>

</xsl:template>
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ TEMPLATE: VALORE-COORDSIZE ***************************** -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template name="valore-coordsize">
<xsl:param name="parametro"><xsl:text>entrambi</xsl:text></xsl:param>

<xsl:choose>
    <xsl:when test="@coordsize">
        <xsl:choose>
            <xsl:when test="$parametro = 'w'">
            <xsl:call-template name="primo-valore">
                        <xsl:with-param name="stringa">
                            <xsl:value-of select="@coordsize" />
                        </xsl:with-param>  
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$parametro = 'h'">
                <xsl:call-template name="secondo-valore">
                        <xsl:with-param name="stringa">
                            <xsl:value-of select="@coordsize" />
                        </xsl:with-param>  
                    </xsl:call-template>   
            </xsl:when>
            <xsl:when test="contains(@coordsize,',')">
                <xsl:value-of select="concat(substring-before(@coordsize,','),' ',
                                             substring-after(@coordsize,','))" />
            </xsl:when>
            <xsl:otherwise>
            <xsl:value-of select="@coordsize" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:when>
    <xsl:when test="((ancestor::*[@coordsize])  and 
                    (name() != 'v:shapetype'))">
        <xsl:for-each select="ancestor::*[@coordsize]">
            <xsl:if test="position() = last()">
                <xsl:choose>
                    <xsl:when test="$parametro = 'w'">
                        <xsl:call-template name="primo-valore">
                            <xsl:with-param name="stringa">
                                <xsl:value-of select="@coordsize" />
                            </xsl:with-param>  
                        </xsl:call-template>   
                    </xsl:when>
                    <xsl:when test="$parametro = 'h'">
                        <xsl:call-template name="secondo-valore">
                                <xsl:with-param name="stringa">
                                    <xsl:value-of select="@coordsize" />
                                </xsl:with-param>  
                            </xsl:call-template>   
                    </xsl:when>
                    <xsl:when test="contains(@coordsize,',')">
                        <xsl:value-of select="concat(substring-before(@coordsize,','),' ',
                                                     substring-after(@coordsize,','))" />
                    </xsl:when>
                    <xsl:otherwise>
                            <xsl:value-of select="@coordsize" />
                    </xsl:otherwise>
                    </xsl:choose>
            </xsl:if>
        </xsl:for-each>    
    </xsl:when>
    <xsl:otherwise>
        <xsl:choose>
            <xsl:when test="($parametro = 'w') or ($parametro = 'h')">
                <xsl:text>1000</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>1000 1000</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ TEMPLATE: ATTRIBUTI-PAINT ****************************** -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template name="attributi-paint">
    <xsl:param name="default"><xsl:text>si</xsl:text></xsl:param>
    <xsl:param name="no-fill"><xsl:text></xsl:text></xsl:param> 
    <xsl:param name="no-stroke"><xsl:text></xsl:text></xsl:param>   
    
<!-- cerca stroke e fill (e relative proprietà) -->

<!-- serve per calcolare l'effettivo valore di stroke-width, in quanto
     in vml il valore di stroke-width non viene influenzato da w,h e cs
     di elementi ancestor, mentre in svg si, quindi questo valore deve 
     venire moltiplicato per quegli attributi in modo che risulti 
     rappresentato con la stessa dimensione.
     moltiplicazione-cs restituisce il prodotto di coordsize(x) / width e
     coordsize(y) / height (poi sommati e diviso per 2)
     di ogni elemento ancestor.
-->

<xsl:variable name="moltiplicazione">
    <xsl:call-template name="moltiplicazione-cs" />
</xsl:variable>

<xsl:choose>
    <!-- no-fill può contenere o stringa vuota (e quindi effettua fill) o
            yes e quindi non effettuare fill 
    -->
    <xsl:when test="$no-fill != ''">
        <xsl:attribute name="fill">
            <xsl:text>none</xsl:text>
        </xsl:attribute>
    </xsl:when>
    <!-- gestisco l'elemento fill ed eventualmente l'attributo fillcolor -->
    <xsl:when test="v:fill">
        <xsl:for-each select="v:fill">
            <xsl:if test="position() = last()">
                        <xsl:choose>
                            <xsl:when test="@on = 'false'">
                                <xsl:attribute name="fill">
                                        <xsl:text>none</xsl:text>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:when test="@type = 'gradient' or @type= 'gradientradial'">
                                <xsl:attribute name="fill">
                                    <xsl:text>url(#</xsl:text>
                                    <xsl:choose>
                                        <xsl:when test="@id">
                                            <xsl:value-of select="@id" />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="@type = 'gradient'">
                                                    <xsl:text>linear</xsl:text>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:text>radial</xsl:text>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <xsl:value-of select="
                                                count(preceding::*[@type = 'gradient' 
                                                    or  @type= 'gradientradial']) + 1" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:text>)</xsl:text>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:when test="@type = 'frame'">
                                <xsl:attribute name="fill">
                                    <xsl:text>url(#</xsl:text>
                                    <xsl:choose>
                                        <xsl:when test="@id">
                                            <xsl:value-of select="@id" />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>frame</xsl:text>
                                            <xsl:value-of select="
                                                count(preceding::*[@type = 'frame']) + 1" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:text>)</xsl:text>
                                </xsl:attribute>
                            </xsl:when>                               
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="@color">
                                        <xsl:attribute name="fill">
                                            <xsl:value-of select="@color" />
                                        </xsl:attribute>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <!-- valore di default di fill -->
                                        <xsl:if test="$default = 'si'">
                                            <xsl:attribute name="fill">
                                                <xsl:text>white</xsl:text>
                                            </xsl:attribute>
                                        </xsl:if>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>

                        <xsl:if test="@fill-rule">
                            <xsl:attribute name="fill-rule">
                                <xsl:value-of select="@fill-rule" />
                            </xsl:attribute>
                        </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:when>
        <xsl:when test="@fillcolor">
        <xsl:attribute name="fill">
            <xsl:value-of select="@fillcolor" />
        </xsl:attribute>
    </xsl:when>
    <!--
    <xsl:when test="@fill = 'false'">
        <xsl:attribute name="fill">
            <xsl:text>none</xsl:text>
        </xsl:attribute>
    </xsl:when>
    -->
    <xsl:otherwise>
        <xsl:if test="$default = 'si'">
            <xsl:attribute name="fill">
                <xsl:text>white</xsl:text>
            </xsl:attribute>
        </xsl:if>
    </xsl:otherwise>
</xsl:choose>   

<xsl:variable name="color-stroke">
    <xsl:choose>
        <xsl:when test="@strokecolor">
            <xsl:value-of select="@strokecolor" />
        </xsl:when>
        <xsl:otherwise>
            <!-- valore di default di stroke -->
            <xsl:text>black</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:variable>

<xsl:variable name="weight-stroke">
    <xsl:choose>
        <xsl:when test="@strokeweight">
            <xsl:variable name="stroke-temp">
                <xsl:call-template name="conversione">
                    <xsl:with-param name="attributo">
                        <xsl:value-of select="@strokeweight" />
                    </xsl:with-param>
                    <xsl:with-param name="nome">
                        <xsl:text>stroke-width</xsl:text>
                    </xsl:with-param>
                    <xsl:with-param name="tipo">
                        <xsl:text>real</xsl:text>
                    </xsl:with-param>                                       
                </xsl:call-template>
            </xsl:variable>    
            <xsl:value-of select="$stroke-temp * $moltiplicazione" />
        </xsl:when>
        <xsl:otherwise>
            <!-- valore di default di strokeweight -->
            <xsl:value-of select="$moltiplicazione" />
        </xsl:otherwise>
    </xsl:choose>
</xsl:variable>



<xsl:choose>
    <xsl:when test="$no-stroke != ''">
        <xsl:attribute name="stroke">
            <xsl:text>none</xsl:text>
        </xsl:attribute>
    </xsl:when>
    <xsl:when test="v:stroke">
        <xsl:for-each select="v:stroke">
            <xsl:if test="position() = last()">
                        <!-- STROKE -->
                        <xsl:choose>
                            <xsl:when test="@on = 'false'">
                                <xsl:attribute name="stroke">
                                        <xsl:text>none</xsl:text>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="@color">
                                        <xsl:attribute name="stroke">
                                            <xsl:value-of select="@color" />
                                        </xsl:attribute>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:if test="$default = 'si'">
                                            <xsl:attribute name="stroke">
                                                <xsl:value-of select="$color-stroke" />
                                            </xsl:attribute>
                                        </xsl:if>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                
                        <!-- WEIGHT -->                
                        <xsl:choose>
                            <xsl:when test="@weight">
                                <xsl:attribute name="stroke-width">
                                    <xsl:variable name="stroke-temp">
                                        <xsl:call-template name="conversione">
                                            <xsl:with-param name="attributo">
                                                <xsl:value-of select="@weight" />
                                            </xsl:with-param>
                                            <xsl:with-param name="nome">
                                                <xsl:text>stroke-width</xsl:text>
                                            </xsl:with-param>
                                            <xsl:with-param name="tipo">
                                                <xsl:text>real</xsl:text>
                                            </xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:value-of select="$stroke-temp * $moltiplicazione" />
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="$default = 'si'">
                                    <xsl:attribute name="stroke-width">
                                        <xsl:value-of select="$weight-stroke" />
                                     </xsl:attribute>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>                
               
                    <!-- STROKE-LINEJOIN -->                
                    <xsl:choose>
                        <xsl:when test="@joinstyle">
                            <xsl:attribute name="stroke-linejoin">
                                <xsl:value-of select="@joinstyle" />  
                            </xsl:attribute>              
                        </xsl:when>
                        <xsl:otherwise>
                            <!--<xsl:if test="$default = 'si'">-->
                                <xsl:attribute name="stroke-linejoin">
                                    <xsl:text>round</xsl:text>
                                </xsl:attribute>
                            <!--</xsl:if>-->
                        </xsl:otherwise>
                    </xsl:choose>
                
                <!-- STROKE-LINECAP -->                
                <xsl:if test="@endcap">
                    <xsl:if test="@endcap != 'flat'">
                        <xsl:attribute name="stroke-linecap">
                            <xsl:value-of select="@endcap" />            
                        </xsl:attribute>
                    </xsl:if>
                </xsl:if>

                <!-- STROKE-DASHOFFSET --> 
                <xsl:if test="@stroke-dashoffset">
                    <xsl:attribute name="stroke-dashoffset">
                        <xsl:value-of select="@stroke-dashoffset" />
                    </xsl:attribute>
                </xsl:if>
                
                <!-- STROKE-DASHARRAY: gestione approssimata -->                
                <!-- PROBLEMI con weight, se non è in user unit!!! (e se non c'è) -->
                <xsl:if test="@dashstyle">
                    <xsl:if test="@dashstyle != 'solid'">
                        <xsl:attribute name="stroke-dasharray">
                            <xsl:variable name="w">
                                <xsl:call-template name="conversione">
                                    <xsl:with-param name="attributo">
                                        <xsl:value-of select="@weight" />
                                    </xsl:with-param>
                                    <xsl:with-param name="nome">
                                        <xsl:text>stroke-width</xsl:text>
                                    </xsl:with-param>                                    
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:choose>
                                <xsl:when test="@dashstyle = 'dash'">

                                    <xsl:value-of select="$w * 1.5" />
                                    <xsl:text>% ,</xsl:text>
                                    <xsl:value-of select="$w" />
                                    <xsl:text>%</xsl:text>
                                </xsl:when>
                                <xsl:when test="@dashstyle = 'longdash'">
                                    <xsl:value-of select="$w * 3" />
                                    <xsl:text>% ,</xsl:text>
                                    <xsl:value-of select="$w" />
                                    <xsl:text>%</xsl:text>
                                </xsl:when>
                                <xsl:when test="(normalize-space(@dashstyle) = '2 2') or 
                                                (normalize-space(@dashstyle) = '2,2') or
                                                (normalize-space(@dashstyle) = '2, 2')  ">
                                    <xsl:value-of select="$w" /><xsl:text>% ,</xsl:text>
                                    <xsl:value-of select="$w div 2" />
                                    <xsl:text>%</xsl:text>
                                </xsl:when>   
                                <xsl:otherwise>
                                    <xsl:value-of select="@dashstyle" />
                                </xsl:otherwise> 
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:if>
               
                    <!-- STROKE-MITERLIMIT-->  
                    <xsl:choose>
                        <xsl:when test="@miterlimit">
                            <xsl:attribute name="stroke-miterlimit">
                                <xsl:value-of select="@miterlimit" />
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:if test="$default = 'si'">
                                <xsl:attribute name="stroke-miterlimit">
                                    <xsl:text>8</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:when>
    <!--<xsl:when test="@stroke = 'false'">
        <xsl:attribute name="stroke">
            <xsl:text>none</xsl:text>
        </xsl:attribute>
    </xsl:when>
    -->
    <xsl:otherwise>
        <xsl:if test="$default = 'si'">
            <xsl:attribute name="stroke">
                <xsl:value-of select="$color-stroke" />
            </xsl:attribute>
            <xsl:attribute name="stroke-width">                                      
                <xsl:value-of select="$weight-stroke" />   
            </xsl:attribute>
        </xsl:if>
    </xsl:otherwise>
</xsl:choose>   

<!-- OPACITY -->
<xsl:variable name="opacity">
<xsl:choose>
    <xsl:when test="@opacity">
            <xsl:value-of select="@opacity" />  
    </xsl:when>        
    <xsl:otherwise>
             <xsl:text>1</xsl:text>
    </xsl:otherwise>
</xsl:choose>
</xsl:variable>

<xsl:choose>
    <xsl:when test="@opacity">
        <xsl:attribute name="opacity">
            <xsl:value-of select="@opacity" />  
        </xsl:attribute>
    </xsl:when>        
    <xsl:otherwise>
        <xsl:if test="$default = 'si'">
            <xsl:attribute name="opacity">
                <xsl:text>1</xsl:text>
            </xsl:attribute>
        </xsl:if>
    </xsl:otherwise>
</xsl:choose>


<xsl:if test="v:fill[@opacity]">
    <xsl:for-each select="v:fill">
        <xsl:if test="position() = last()">
            <xsl:attribute name="fill-opacity">
                <xsl:value-of select="@opacity * (1 div $opacity)" />  
            </xsl:attribute>
        </xsl:if>
    </xsl:for-each>
</xsl:if>

<xsl:if test="v:stroke[@opacity]">
    <xsl:for-each select="v:stroke">
        <xsl:if test="position() = last()">
            <xsl:attribute name="stroke-opacity">
                <xsl:value-of select="@opacity * (1 div $opacity)" />  
            </xsl:attribute> 
        </xsl:if>
    </xsl:for-each>
</xsl:if>
</xsl:template>


<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ TEMPLATE: ATTRIBUTO-ROTATION**************************** -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template name="attributo-rotation">

<!-- cerca nell'attributo style se è presente rotation e ne restituisce il valore (se non
     è presente restituisce 0) -->

<xsl:choose>
    <xsl:when test="@style">
        <xsl:choose>
        <xsl:when test="contains(@style,'rotation') or contains(@style,'ROTATION')">
            <xsl:variable name="attributo">
                <xsl:choose>
                    <xsl:when test="contains(@style,'rotation')">
                        <xsl:text>rotation</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>ROTATION</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="rotation-temp">
                <xsl:choose>
                    <xsl:when test="contains(substring-after(@style,$attributo),';')">
                        <xsl:value-of select="normalize-space(substring-before(
                                      substring-after(@style,$attributo),';'))" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(
                                      substring-after(@style,$attributo))" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="rotation">
                <xsl:value-of select="normalize-space(
                                      substring-after($rotation-temp,':'))" />
            </xsl:variable>
            <xsl:value-of select="$rotation" />
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>0</xsl:text>
        </xsl:otherwise>
        </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
        <xsl:text>0</xsl:text>
    </xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ******************************************************************************** -->
<!-- ***************** TEMPLATE: moltiplicazione cs  ******************************** -->
<!-- ******************************************************************************** -->
<xsl:template name="moltiplicazione-cs">
            <xsl:param name="valore"><xsl:text>1</xsl:text></xsl:param>
            
<!-- funzione ricorsiva calcola il valore di coordsize(x) / width per ogni elemento ancestor
     dell'elemento corrente -->
     
<!-- anche per cs(y) / h, poi somma i due valori e fa div 2 -->

<xsl:variable name="tipo-conversione">
    <xsl:choose>
        <xsl:when test="ancestor::v:*">
            <xsl:text>adatta</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>real</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:variable>
            
            
    <xsl:variable name="val-temp">
        <xsl:choose>
        <xsl:when test="((name() = 'v:shape') or (name() = 'v:group'))">
            <xsl:variable name="cs-x-temp">            
                <xsl:choose>
                  <xsl:when test="@coordsize">
                    <xsl:choose>
                        <xsl:when test="contains(@coordsize,',')">
                            <xsl:value-of select="normalize-space(substring-before(
                                                  @coordsize,','))" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space(substring-before(
                                                  normalize-space(@coordsize),' '))" />
                        </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:when test="((ancestor::*[@coordsize]) and (name() != 'v:shape') and 
                                (name() != 'v:shapetype')) or 
                                ((name() = 'v:shape' and @type and 
                                contains(@type, 'roundrect')))">
                    <xsl:for-each select="ancestor::*[@coordsize]">
                        <xsl:if test="position() = last()">
                            <xsl:choose>
                                <xsl:when test="contains(@coordsize,',')">
                                    <xsl:value-of select="normalize-space(substring-before(
                                                          @coordsize,','))" />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space(substring-before(
                                                    normalize-space(@coordsize),' '))" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                    </xsl:for-each>    
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>1000</xsl:text>
                  </xsl:otherwise>
            </xsl:choose>        
            </xsl:variable>
            <xsl:variable name="cs-y-temp">            
                <xsl:choose>
                  <xsl:when test="@coordsize">
                    <xsl:choose>
                        <xsl:when test="contains(@coordsize,',')">
                            <xsl:value-of select="normalize-space(substring-after(
                                                  @coordsize,','))" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space(substring-after(
                                                  normalize-space(@coordsize),' '))" />
                        </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:when test="((ancestor::*[@coordsize]) and (name() != 'v:shape') and 
                                (name() != 'v:shapetype')) or 
                                ((name() = 'v:shape' and @type and 
                                contains(@type, 'roundrect')))">
                    <xsl:for-each select="ancestor::*[@coordsize]">
                        <xsl:if test="position() = last()">
                            <xsl:choose>
                                <xsl:when test="contains(@coordsize,',')">
                                    <xsl:value-of select="normalize-space(substring-after(
                                                          @coordsize,','))" />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space(substring-after(
                                                    normalize-space(@coordsize),' '))" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                    </xsl:for-each>    
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>1000</xsl:text>
                  </xsl:otherwise>
            </xsl:choose>        
            </xsl:variable>
            <xsl:variable name="w">
                    <xsl:call-template name="valore-whxy">
                            <xsl:with-param name="attributo">
                                <xsl:text>w</xsl:text>
                            </xsl:with-param>
                            <xsl:with-param name="converti">
                                <xsl:value-of select="$tipo-conversione" />
                            </xsl:with-param>
                        </xsl:call-template>
            </xsl:variable>
             <xsl:variable name="h">
                <xsl:call-template name="valore-whxy">
                            <xsl:with-param name="attributo">
                                <xsl:text>h</xsl:text>
                            </xsl:with-param>
                            <xsl:with-param name="converti">
                                <xsl:value-of select="$tipo-conversione" />
                            </xsl:with-param>
                        </xsl:call-template>
            </xsl:variable>
            
            <!--
            <xsl:choose>
                <xsl:when test="$h &gt; $w">
                    <xsl:value-of select="$cs-y-temp div $h" />
                </xsl:when>
                <xsl:otherwise> 
                    <xsl:value-of select="$cs-x-temp div $w" />
                </xsl:otherwise>
            </xsl:choose>
            -->  
            
           <xsl:value-of select="(($cs-x-temp div $w) + ($cs-y-temp div $h)) div 2" />

            
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>1</xsl:text>
        </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
            
            <xsl:choose>
                <xsl:when test="ancestor::v:*">
                    <xsl:for-each select="ancestor::v:*">
                        <xsl:if test="position() = last()">
                            <xsl:call-template name="moltiplicazione-cs">
                                <xsl:with-param name="valore">
                                    <xsl:value-of select="$valore * $val-temp" />
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$valore * $val-temp" />
                </xsl:otherwise>
            </xsl:choose>
</xsl:template>

</xsl:stylesheet>
