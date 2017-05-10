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
        - gestione-gradient
        - gradient-colors
        - gestione-pattern
-->

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ TEMPLATE: GESTIONE-GRADIENT **************************** -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template name="gestione-gradient">

<!-- crea un elemento gradient (da inserire in defs) di tipo linear o radial
     per ogni gradiente usato nel documento vml
-->

        <xsl:for-each select="(//v:fill[@type = 'gradient']) |
                              (//v:fill[@type = 'gradientradial'])">

            <xsl:variable name="identificatore">
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
                        <xsl:value-of select="position()" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="@type = 'gradient'">
                    <linearGradient>
                        <xsl:attribute name="id">
                            <xsl:value-of select="$identificatore" />
                        </xsl:attribute>
                        <xsl:attribute name="spreadMethod">
                            <xsl:text>repeat</xsl:text>                    
                        </xsl:attribute>
                        <xsl:variable name="angolo">
                            <xsl:choose>
                                <xsl:when test="@angle"><xsl:value-of select="@angle" />
                                </xsl:when>
                                <xsl:otherwise><xsl:text>0</xsl:text></xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:attribute name="gradientTransform">
                            <xsl:text>rotate(</xsl:text>
                            <xsl:value-of select="270 + $angolo" />
                            <xsl:text>)</xsl:text>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="@colors">
                                <stop offset="0%">
                                    <xsl:attribute name="stop-color">
                                        <xsl:choose>
                                            <xsl:when test="@color">
                                                <xsl:value-of select="@color" />
                                            </xsl:when>
                                            <xsl:when test="parent::*[@fillcolor]">
                                                <xsl:for-each select="parent::*[@fillcolor]">
                                                    <xsl:value-of select="@fillcolor" />
                                                </xsl:for-each>                         
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:text>white</xsl:text>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                </stop>
                                <!-- gestione colors -->                                
                                <xsl:call-template name="gradient-colors">
                                    <xsl:with-param name="stringa">
                                        <xsl:value-of select="@colors" />
                                    </xsl:with-param>
                                </xsl:call-template>
                                <stop offset="100%">
                                    <xsl:attribute name="stop-color">
                                        <xsl:choose>
                                            <xsl:when test="@color2">
                                                <xsl:value-of select="@color2" />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:text>white</xsl:text>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                </stop>
                            </xsl:when>
                            <xsl:when test="@color and @color2">
                                <stop offset="5%">
                                    <xsl:attribute name="stop-color">
                                        <xsl:value-of select="@color" />
                                    </xsl:attribute>
                                </stop>
                                <stop offset="95%">
                                    <xsl:attribute name="stop-color">
                                        <xsl:value-of select="@color2" />
                                    </xsl:attribute>
                                </stop>
                            </xsl:when>
                            <xsl:when test="@color">
                                <stop offset="5%">
                                    <xsl:attribute name="stop-color">
                                        <xsl:value-of select="@color" />
                                    </xsl:attribute>
                                </stop>
                                <stop offset="95%" stop-color="white" />
                            </xsl:when>
                            <xsl:when test="@color2">
                                <xsl:choose>
                                    <xsl:when test="parent::*[@fillcolor]">
                                        <stop offset="5%">
                                            <xsl:attribute name="stop-color">
                                                <xsl:for-each select="parent::*[@fillcolor]">
                                                        <xsl:value-of select="@fillcolor" />
                                                </xsl:for-each>
                                            </xsl:attribute>
                                        </stop>
                                    </xsl:when>
                                    <xsl:otherwise>            
                                        <stop offset="5%" stop-color="white" />
                                    </xsl:otherwise>
                                </xsl:choose>
                                <stop offset="95%">
                                    <xsl:attribute name="stop-color">
                                        <xsl:value-of select="@color2" />
                                    </xsl:attribute>
                                </stop>
                            </xsl:when>
                            <xsl:otherwise>
                                <stop offset="100%" stop-color="white" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </linearGradient>

                </xsl:when>
                <xsl:otherwise>
                    <!-- XXXXXXXXXXXXXXXXXXXX radial XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->
                    <radialGradient  r="100%">
                        <xsl:attribute name="id">
                            <xsl:value-of select="$identificatore" />
                        </xsl:attribute>
                        <xsl:attribute name="cx">
                            <xsl:choose>
                                <xsl:when test="@focusposition">
                                    <xsl:call-template name="primo-valore">
                                        <xsl:with-param name="stringa">
                                            <xsl:value-of select="@focusposition" />
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>0</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:attribute name="cy">
                            <xsl:choose>
                               <xsl:when test="@focusposition">
                                    <xsl:call-template name="secondo-valore">
                                        <xsl:with-param name="stringa">
                                            <xsl:value-of select="@focusposition" />
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>0</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>                        
                        <xsl:choose>
                            <xsl:when test="@colors">
                                <stop offset="0%">
                                    <xsl:attribute name="stop-color">
                                        <xsl:choose>
                                            <xsl:when test="@color">
                                                <xsl:value-of select="@color" />
                                            </xsl:when>
                                            <xsl:when test="parent::*[@fillcolor]">
                                                <xsl:for-each select="parent::*[@fillcolor]">
                                                    <xsl:value-of select="@fillcolor" />
                                                </xsl:for-each>                         
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:text>white</xsl:text>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                </stop>
                                <!-- gestione colors -->
                                <!-- i valori sarebbero da invertire, 100% -> 0%
                                                                       30$ -> 70%
                                     e bisogna invertire l'ordine -->
                                <xsl:call-template name="gradient-colors">
                                    <xsl:with-param name="stringa">
                                        <xsl:value-of select="@colors" />
                                    </xsl:with-param>
                                </xsl:call-template>
                                <stop offset="100%">
                                    <xsl:attribute name="stop-color">
                                        <xsl:choose>
                                            <xsl:when test="@color2">
                                                <xsl:value-of select="@color2" />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:text>white</xsl:text>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                </stop>
                            </xsl:when>
                            <xsl:when test="@color and @color2">
                                <stop offset="5%">
                                    <xsl:attribute name="stop-color">
                                        <xsl:value-of select="@color" />
                                    </xsl:attribute>
                                </stop>
                                <stop offset="95%">
                                    <xsl:attribute name="stop-color">
                                        <xsl:value-of select="@color2" />
                                    </xsl:attribute>
                                </stop>
                            </xsl:when>
                            <xsl:when test="@color">
                                <stop offset="5%">
                                    <xsl:attribute name="stop-color">
                                        <xsl:value-of select="@color" />
                                    </xsl:attribute>
                                </stop>
                                <stop offset="95%" stop-color="white" />
                            </xsl:when>
                            <xsl:when test="@color2">
                                <xsl:choose>
                                    <xsl:when test="parent::*[@fillcolor]">
                                        <stop offset="5%">
                                            <xsl:attribute name="stop-color">
                                                <xsl:for-each select="parent::*[@fillcolor]">
                                                        <xsl:value-of select="@fillcolor" />
                                                </xsl:for-each>
                                            </xsl:attribute>
                                        </stop>
                                    </xsl:when>
                                    <xsl:otherwise>            
                                        <stop offset="5%" stop-color="white" />
                                    </xsl:otherwise>
                                </xsl:choose>
                                <stop offset="95%">
                                    <xsl:attribute name="stop-color">
                                        <xsl:value-of select="@color2" />
                                    </xsl:attribute>
                                </stop>
                            </xsl:when>
                            <xsl:otherwise>
                                <stop offset="100%" stop-color="white" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </radialGradient>
                
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
</xsl:template>

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ TEMPLATE: GRADIENT-COLORS ****************************** -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template name="gradient-colors" >
    <xsl:param name="stringa" />
<!-- gestisce il gradiente i cui valori sono contenuti nell'attributo colors,
     cerca ogni valore e lo inserisce in un apposito elemento stop.
     Procedura ricorsiva
-->


<xsl:choose>
    <xsl:when test="normalize-space($stringa) != ''"> <!-- ci sono ancora dei valori -->
    
        <xsl:variable name="stringa-actual">
            <xsl:choose>
                <xsl:when test="contains($stringa,'rgb(')">
                    <xsl:value-of select="normalize-space(
                                          concat(substring-before($stringa,')'),')')) " />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="contains($stringa,',')">
                            <xsl:value-of select="normalize-space(
                                                  substring-before($stringa,','))" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$stringa" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="stringa-succ">
            <xsl:choose>
                <xsl:when test="contains($stringa,'rgb(')">
                    <xsl:variable name="after-rgb">
                        <xsl:value-of select="substring-after($stringa,')') " />
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="contains($after-rgb,',')">
                            <xsl:value-of select="normalize-space(
                                                  substring-after($after-rgb,','))" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text></xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>                                  
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="contains($stringa,',')">
                            <xsl:value-of select="normalize-space(
                                                  substring-after($stringa,','))" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text></xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>        
        
        <stop>
        
<!-- eventualmente before/after % e poi concat -->
            <xsl:attribute name="offset">
                <xsl:value-of select="normalize-space(
                                      substring-before($stringa-actual,' '))" />
            </xsl:attribute>
            <xsl:attribute name="stop-color">
                <xsl:value-of select="normalize-space(
                                      substring-after($stringa-actual,' '))" />
            </xsl:attribute>            
        </stop>
        
        <xsl:call-template name="gradient-colors">
            <xsl:with-param name="stringa">
                <xsl:value-of select="$stringa-succ" />
            </xsl:with-param>
        </xsl:call-template>
        
    </xsl:when>
</xsl:choose>
</xsl:template>

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ TEMPLATE: GESTIONE-PATTERN ***************************** -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template name="gestione-pattern">

<!-- crea un elemento pattern per ogni pattern (frame) usato nel documento.
     Quest'elemento verrà inserito in defs
-->

<!-- type = FRAME -->
        <xsl:for-each select="(//v:fill[@type = 'frame']) |
                              (//v:fill[@type = 'frame'])"> <!-- anche stroke !!! -->

            <xsl:variable name="identificatore">
                <xsl:choose>
                    <xsl:when test="@id">
                        <xsl:value-of select="@id" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>frame</xsl:text>
                        <xsl:value-of select="position()" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            
            <pattern width="100%" height="100%">
                <xsl:attribute name="id">
                    <xsl:value-of select="$identificatore" />
                </xsl:attribute>
                
                <image width="100%" height="100%">
                    <xsl:attribute name="xlink:href">
                        <xsl:value-of select="@src" />
                    </xsl:attribute>
                </image>                
            </pattern>                
        </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
