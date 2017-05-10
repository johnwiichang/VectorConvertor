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
        - gestione-path
        - elemento-path
        - traduzione-path
        - gestione-valori-path
        - before-string
    (gestione stringhe:)    
        - primo-valore
        - secondo-valore
        - dal-terzo-valore
        - ultimo-valore
        - penultimo-valore
-->

<!-- per maggiori informazioni sui template si rimanda al file ../../SVG/XSL/path.xsl in 
        cui sono definiti i medesimi template
-->

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ GESTIONE PATH ****************************************** -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template name="gestione-path">
        <xsl:call-template name="elemento-path">
            <xsl:with-param name="v">
                <xsl:value-of select="@v" />
            </xsl:with-param>
        </xsl:call-template>
</xsl:template>

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ ELEMENTO PATH ****************************************** -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template name="elemento-path">
    <xsl:param name="v" />
<path>
        <xsl:if test="$v != ''">
            <xsl:attribute name="d">
                <xsl:call-template name="traduzione-path">
                    <xsl:with-param name="v">
                        <xsl:value-of select="$v" /> 
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:attribute>
        </xsl:if>
</path>
</xsl:template>

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ TEMPLATE TRADUZIONE PATH ******************************* -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template name="traduzione-path">
    <xsl:param name="v" />
    
            <xsl:variable name="v-temp">
                <xsl:call-template name="gestione-valori-path">
                    <xsl:with-param name="v">
                        <xsl:value-of select="$v" />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="$v-temp" />

</xsl:template>


<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ TEMPLATE GESTIONE VALORI PATH ************************** -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template name="gestione-valori-path">
    <xsl:param name="v" />
    <!-- funzione ricorsiva -->

<!-- nota sulla traduzione:
    Valori tradotti correttamente:
        - m
        - l
        - c
        - x
        - e
        - t
        - r
        - v
    Valori approssimati:
        - qx
        - qy
        - qb
        - ae
        - al
        - at
        - ar
        - wa
        - wr
    Valori scartati:
        - nf
        - ns

-->
    
    <xsl:choose>
    
        <!-- XXXXXXXXXXXX , XXXXXXXXXX -->  
        <xsl:when test="contains($v,',,')">
            <xsl:variable name="new-v">
                <xsl:value-of select="concat(substring-before($v,',,'),',0,',
                                             substring-after($v,',,'))" />
            </xsl:variable>
            <xsl:call-template name="gestione-valori-path">
                <xsl:with-param name="v">
                    <xsl:value-of select="$new-v" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        
        <!-- XXXXXXXXXXXX qx XXXXXXXXXX -->  
        <xsl:when test="contains($v,'qx')">
            <xsl:variable name="prec">
                <xsl:value-of select="substring-before($v,'qx')" />
            </xsl:variable>
            <xsl:variable name="succ-temp"> <!-- tutto quello che segue qx -->
                <xsl:value-of select="substring-after($v,'qx')" />
            </xsl:variable>
            <xsl:variable name="inside"> <!-- i punti di qx -->
                <xsl:call-template name="before-string">
                    <xsl:with-param name="v">
                        <xsl:value-of select="$succ-temp" />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="succ"> <!-- tutto quello che segue i punti di qx -->
                <xsl:value-of select="substring-after($succ-temp,$inside)" />
            </xsl:variable>
            
            <!-- da prendere gli ultimi due punti di prec e gestire il tutto con i punti
                 di inside -->
            <xsl:variable name="control-point">
                <xsl:variable name="last-y">
                    <xsl:call-template name="ultimo-valore">
                        <xsl:with-param name="stringa">
                            <xsl:value-of select="normalize-space($prec)" />
                        </xsl:with-param>  
                    </xsl:call-template>              
                </xsl:variable>
                <xsl:variable name="val-x">
                    <xsl:call-template name="primo-valore">
                        <xsl:with-param name="stringa">
                            <xsl:value-of select="normalize-space($inside)" />
                        </xsl:with-param>  
                    </xsl:call-template>              
                </xsl:variable>
                <xsl:value-of select="$val-x" />
                <xsl:text> </xsl:text>
                <xsl:value-of select="$last-y" />
            </xsl:variable>
            
            <xsl:variable name="new-v">
                <xsl:value-of select="concat($prec,' Q ',$control-point,' ',
                                             $inside,' ',$succ)" />
            </xsl:variable>
            <xsl:call-template name="gestione-valori-path">
                <xsl:with-param name="v">
                    <xsl:value-of select="$new-v" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        
        <!-- XXXXXXXXXXXX qy XXXXXXXXXX -->  
        <xsl:when test="contains($v,'qy')">
            <xsl:variable name="prec">
                <xsl:value-of select="substring-before($v,'qy')" />
            </xsl:variable>
            <xsl:variable name="succ-temp"> <!-- tutto quello che segue qy -->
                <xsl:value-of select="substring-after($v,'qy')" />
            </xsl:variable>
            <xsl:variable name="inside"> <!-- i punti di qy -->
                <xsl:call-template name="before-string">
                    <xsl:with-param name="v">
                        <xsl:value-of select="$succ-temp" />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="succ"> <!-- tutto quello che segue i punti di qy -->
                <xsl:value-of select="substring-after($succ-temp,$inside)" />
            </xsl:variable>
            
            <!-- da prendere gli ultimi due punti di prec e gestire il tutto con 
                 i punti di inside -->
            <xsl:variable name="control-point">
                <xsl:variable name="last-x">
                    <xsl:call-template name="penultimo-valore">
                        <xsl:with-param name="stringa">
                            <xsl:value-of select="normalize-space($prec)" />
                        </xsl:with-param>       
                    </xsl:call-template>         
                </xsl:variable>
                <xsl:variable name="val-y">
                    <xsl:call-template name="secondo-valore">
                        <xsl:with-param name="stringa">
                            <xsl:value-of select="normalize-space($inside)" />
                        </xsl:with-param>  
                    </xsl:call-template>              
                </xsl:variable>
                <xsl:value-of select="$last-x" />
                <xsl:text> </xsl:text>
                <xsl:value-of select="$val-y" />
            </xsl:variable>
            
            <xsl:variable name="new-v">
                <xsl:value-of select="concat($prec,' Q ',$control-point,' ',
                                             $inside,' ',$succ)" />
            </xsl:variable>
            <xsl:call-template name="gestione-valori-path">
                <xsl:with-param name="v">
                    <xsl:value-of select="$new-v" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        
        <!-- XXXXXXXXXXXX ae (??) XXXXXXXXXX -->  
        <xsl:when test="contains($v,'ae')">
            <xsl:variable name="prec">
                <xsl:value-of select="substring-before($v,'ae')" />
            </xsl:variable>
            <xsl:variable name="succ-temp"> <!-- tutto quello che segue ae -->
                <xsl:value-of select="substring-after($v,'ae')" />
            </xsl:variable>
            <xsl:variable name="inside"> <!-- i punti di ae -->
                <xsl:call-template name="before-string">
                    <xsl:with-param name="v">
                        <xsl:value-of select="$succ-temp" />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            
            <xsl:variable name="succ"> <!-- tutto quello che segue i punti di ae -->
                <xsl:value-of select="substring-after($succ-temp,$inside)" />
            </xsl:variable>
            
            <xsl:variable name="primo-punto-ae">
                 <xsl:call-template name="primo-valore">
                    <xsl:with-param name="stringa">
                        <xsl:value-of select="normalize-space($inside)" />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="terzo-punto-ae">
                 <xsl:call-template name="primo-valore">
                    <xsl:with-param name="stringa">                    
                        <xsl:call-template name="dal-terzo-valore">
                            <xsl:with-param name="stringa">
                                <xsl:value-of select="normalize-space($inside)" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            
            <xsl:variable name="punti-ae">
                <xsl:value-of select="$primo-punto-ae + $terzo-punto-ae" />
                <xsl:text> </xsl:text>
                <xsl:call-template name="secondo-valore">
                    <xsl:with-param name="stringa">
                        <xsl:value-of select="normalize-space($inside)" />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            
            <!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->     
            <!-- Difficile gestione, da capire come funziona                    -->
            <!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->     
            
            <xsl:variable name="new-v">
                <xsl:value-of select="concat($prec,'L ',$punti-ae,' ',$succ)" />
            </xsl:variable>
            <xsl:call-template name="gestione-valori-path">
                <xsl:with-param name="v">
                    <xsl:value-of select="$new-v" />
                </xsl:with-param>
            </xsl:call-template>
            
        </xsl:when>
        
        <!-- XXXXXXXXXXXX al (??) XXXXXXXXXX -->  
        <xsl:when test="contains($v,'al')">
            <xsl:variable name="prec">
                <xsl:value-of select="substring-before($v,'al')" />
            </xsl:variable>
            <xsl:variable name="succ-temp"> <!-- tutto quello che segue al -->
                <xsl:value-of select="substring-after($v,'al')" />
            </xsl:variable>
            <xsl:variable name="inside"> <!-- i punti di al -->
                <xsl:call-template name="before-string">
                    <xsl:with-param name="v">
                        <xsl:value-of select="$succ-temp" />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="succ"> <!-- tutto quello che segue i punti di al -->
                <xsl:value-of select="substring-after($succ-temp,$inside)" />
            </xsl:variable>
            
            <!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->     
            <!-- Difficile gestione, da capire come funziona                    -->
            <!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->     
            
            <xsl:variable name="primo-punto-al">
                 <xsl:call-template name="primo-valore">
                    <xsl:with-param name="stringa">
                        <xsl:value-of select="normalize-space($inside)" />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="terzo-punto-al">
                 <xsl:call-template name="primo-valore">
                    <xsl:with-param name="stringa">                    
                        <xsl:call-template name="dal-terzo-valore">
                            <xsl:with-param name="stringa">
                                <xsl:value-of select="normalize-space($inside)" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            
            <xsl:variable name="punti-al">
                <xsl:value-of select="$primo-punto-al + $terzo-punto-al" />
                <xsl:text> </xsl:text>
                <xsl:call-template name="secondo-valore">
                    <xsl:with-param name="stringa">
                        <xsl:value-of select="normalize-space($inside)" />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            
            <xsl:variable name="new-v">
                <xsl:value-of select="concat($prec,' M ',$punti-al,' ',$succ)" />
            </xsl:variable>
            <xsl:call-template name="gestione-valori-path">
                <xsl:with-param name="v">
                    <xsl:value-of select="$new-v" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        
        <!-- XXXXXXXXXXXX at XXXXXXXXXX -->  
        <xsl:when test="contains($v,'at')">
            <xsl:variable name="prec">
                <xsl:value-of select="substring-before($v,'at')" />
            </xsl:variable>
            <xsl:variable name="succ-temp"> <!-- tutto quello che segue at -->
                <xsl:value-of select="substring-after($v,'at')" />
            </xsl:variable>
            <xsl:variable name="inside"> <!-- i punti di at -->
                <xsl:call-template name="before-string">
                    <xsl:with-param name="v">
                        <xsl:value-of select="$succ-temp" />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="succ"> <!-- tutto quello che segue i punti di at -->
                <xsl:value-of select="substring-after($succ-temp,$inside)" />
            </xsl:variable>
            
            <!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->     
            <!-- Approssimato, con un rettangolo                                -->
            <!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->     
            
            <xsl:variable name="primo-punto-at">
                 <xsl:call-template name="primo-valore">
                    <xsl:with-param name="stringa">
                        <xsl:value-of select="normalize-space($inside)" />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="secondo-punto-at">
                 <xsl:call-template name="secondo-valore">
                    <xsl:with-param name="stringa">
                        <xsl:value-of select="normalize-space($inside)" />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="ultimo-punto-at">
                 <xsl:call-template name="ultimo-valore">
                    <xsl:with-param name="stringa">
                        <xsl:value-of select="normalize-space($inside)" />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="penultimo-punto-at">
                 <xsl:call-template name="penultimo-valore">
                    <xsl:with-param name="stringa">
                        <xsl:value-of select="normalize-space($inside)" />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            
             <xsl:variable name="rx-at">
                 <xsl:call-template name="primo-valore">
                    <xsl:with-param name="stringa">                    
                        <xsl:call-template name="dal-terzo-valore">
                            <xsl:with-param name="stringa">                    
                                <xsl:value-of select="normalize-space($inside)" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="ry-at">
                 <xsl:call-template name="secondo-valore">
                    <xsl:with-param name="stringa">                    
                        <xsl:call-template name="dal-terzo-valore">
                            <xsl:with-param name="stringa">                    
                                <xsl:value-of select="normalize-space($inside)" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            
            <xsl:variable name="punti-arc">
                <xsl:value-of select="concat(($rx-at div 2),' ',($ry-at div 2),' 0,1,0 ',
                                              $penultimo-punto-at,' ',$ultimo-punto-at)" />
            </xsl:variable>
            
            <!-- RETTANGOLO -->
            <xsl:variable name="p2">
                <xsl:value-of select="concat($primo-punto-at,' ',$secondo-punto-at)" />
            </xsl:variable>
            
            <xsl:variable name="rett">
                <xsl:text> # </xsl:text>
                <xsl:value-of select="concat(($rx-at - $primo-punto-at),' 0')" />
                <xsl:text> # </xsl:text>
                <xsl:value-of select="concat('0 ',($ry-at - $secondo-punto-at))" />
                <xsl:text> # </xsl:text>
                <xsl:value-of select="concat( - ($rx-at - $primo-punto-at),' 0')" />
                <xsl:text> # </xsl:text>
                <xsl:value-of select="concat('0 ', - ($ry-at - $secondo-punto-at))" />
                <xsl:text> # </xsl:text>
                <xsl:value-of select="concat(($rx-at - $primo-punto-at),' 0')" />
            </xsl:variable>
                        
            <xsl:variable name="new-v">         
                <xsl:value-of select="concat($prec,'L ',$p2,$rett,' ',$succ)" />
            </xsl:variable>
            <xsl:call-template name="gestione-valori-path">
                <xsl:with-param name="v">
                    <xsl:value-of select="$new-v" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
                
        <!-- XXXXXXXXXXXX ar XXXXXXXXXX -->  
        <xsl:when test="contains($v,'ar')">
            <xsl:variable name="prec">
                <xsl:value-of select="substring-before($v,'ar')" />
            </xsl:variable>
            <xsl:variable name="succ-temp"> <!-- tutto quello che segue ar -->
                <xsl:value-of select="substring-after($v,'ar')" />
            </xsl:variable>
            <xsl:variable name="inside"> <!-- i punti di ar -->
                <xsl:call-template name="before-string">
                    <xsl:with-param name="v">
                        <xsl:value-of select="$succ-temp" />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="succ"> <!-- tutto quello che segue i punti di ar -->
                <xsl:value-of select="substring-after($succ-temp,$inside)" />
            </xsl:variable>
            
            <!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->     
            <!-- Approssimato, con un rettangolo                                -->
            <!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->     
            
            <xsl:variable name="primo-punto-ar">
                 <xsl:call-template name="primo-valore">
                    <xsl:with-param name="stringa">
                        <xsl:value-of select="normalize-space($inside)" />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="secondo-punto-ar">
                 <xsl:call-template name="secondo-valore">
                    <xsl:with-param name="stringa">
                        <xsl:value-of select="normalize-space($inside)" />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="ultimo-punto-ar">
                 <xsl:call-template name="ultimo-valore">
                    <xsl:with-param name="stringa">
                        <xsl:value-of select="normalize-space($inside)" />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="penultimo-punto-ar">
                 <xsl:call-template name="penultimo-valore">
                    <xsl:with-param name="stringa">
                        <xsl:value-of select="normalize-space($inside)" />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            
             <xsl:variable name="rx-ar">
                 <xsl:call-template name="primo-valore">
                    <xsl:with-param name="stringa">                    
                        <xsl:call-template name="dal-terzo-valore">
                            <xsl:with-param name="stringa">                    
                                <xsl:value-of select="normalize-space($inside)" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="ry-ar">
                 <xsl:call-template name="secondo-valore">
                    <xsl:with-param name="stringa">                    
                        <xsl:call-template name="dal-terzo-valore">
                            <xsl:with-param name="stringa">                    
                                <xsl:value-of select="normalize-space($inside)" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            
            <!-- RETTANGOLO -->
            <xsl:variable name="p2">
                <xsl:value-of select="concat($primo-punto-ar,' ',$secondo-punto-ar)" />
            </xsl:variable>
            
            <xsl:variable name="rett">
                <xsl:text> ^ </xsl:text>
                <xsl:value-of select="concat(($rx-ar - $primo-punto-ar),' 0')" />
                <xsl:text> # </xsl:text>
                <xsl:value-of select="concat('0 ',($ry-ar - $secondo-punto-ar))" />
                <xsl:text> # </xsl:text>
                <xsl:value-of select="concat( - ($rx-ar - $primo-punto-ar),' 0')" />
                <xsl:text> # </xsl:text>
                <xsl:value-of select="concat('0 ', - ($ry-ar - $secondo-punto-ar))" />
                <xsl:text> # </xsl:text>
                <xsl:value-of select="concat(($rx-ar - $primo-punto-ar),' 0')" />
            </xsl:variable>
                        
            <xsl:variable name="new-v">         
                <xsl:value-of select="concat($prec,'^ ',$p2,$rett,' ',$succ)" />
            </xsl:variable>
            <xsl:call-template name="gestione-valori-path">
                <xsl:with-param name="v">
                    <xsl:value-of select="$new-v" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        
        <!-- XXXXXXXXXXXX wa XXXXXXXXXX -->  
        <xsl:when test="contains($v,'wa')">
            <xsl:variable name="prec">
                <xsl:value-of select="substring-before($v,'wa')" />
            </xsl:variable>
            <xsl:variable name="succ-temp"> <!-- tutto quello che segue wa -->
                <xsl:value-of select="substring-after($v,'wa')" />
            </xsl:variable>
            <xsl:variable name="inside"> <!-- i punti di wa -->
                <xsl:call-template name="before-string">
                    <xsl:with-param name="v">
                        <xsl:value-of select="$succ-temp" />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="succ"> <!-- tutto quello che segue i punti di wa -->
                <xsl:value-of select="substring-after($succ-temp,$inside)" />
            </xsl:variable>
            
            <!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->
            <!-- Approssimato, con un rettangolo                                -->
            <!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->
            
            <xsl:variable name="primo-punto-wa">
                 <xsl:call-template name="primo-valore">
                    <xsl:with-param name="stringa">
                        <xsl:value-of select="normalize-space($inside)" />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="secondo-punto-wa">
                 <xsl:call-template name="secondo-valore">
                    <xsl:with-param name="stringa">
                        <xsl:value-of select="normalize-space($inside)" />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="ultimo-punto-wa">
                 <xsl:call-template name="ultimo-valore">
                    <xsl:with-param name="stringa">
                        <xsl:value-of select="normalize-space($inside)" />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="penultimo-punto-wa">
                 <xsl:call-template name="penultimo-valore">
                    <xsl:with-param name="stringa">
                        <xsl:value-of select="normalize-space($inside)" />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            
             <xsl:variable name="rx-wa">
                 <xsl:call-template name="primo-valore">
                    <xsl:with-param name="stringa">                    
                        <xsl:call-template name="dal-terzo-valore">
                            <xsl:with-param name="stringa">                    
                                <xsl:value-of select="normalize-space($inside)" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="ry-wa">
                 <xsl:call-template name="secondo-valore">
                    <xsl:with-param name="stringa">                    
                        <xsl:call-template name="dal-terzo-valore">
                            <xsl:with-param name="stringa">                    
                                <xsl:value-of select="normalize-space($inside)" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            
            <xsl:variable name="punti-arc">
                <xsl:value-of select="concat(($rx-wa div 2),' ',($ry-wa div 2),' 0,1,0 ',
                                              $penultimo-punto-wa,' ',$ultimo-punto-wa)" />
            </xsl:variable>
            
            <!-- RETTANGOLO -->
            <xsl:variable name="p2">
                <xsl:value-of select="concat($primo-punto-wa,' ',$secondo-punto-wa)" />
            </xsl:variable>
            
            <xsl:variable name="rett">
                <xsl:text> # </xsl:text>
                <xsl:value-of select="concat(($rx-wa - $primo-punto-wa),' 0')" />
                <xsl:text> # </xsl:text>
                <xsl:value-of select="concat('0 ',($ry-wa - $secondo-punto-wa))" />
                <xsl:text> # </xsl:text>
                <xsl:value-of select="concat( - ($rx-wa - $primo-punto-wa),' 0')" />
                <xsl:text> # </xsl:text>
                <xsl:value-of select="concat('0 ', - ($ry-wa - $secondo-punto-wa))" />
                <xsl:text> # </xsl:text>
                <xsl:value-of select="concat(($rx-wa - $primo-punto-wa),' 0')" />
            </xsl:variable>
                        
            
            <xsl:variable name="new-v">         
                <xsl:value-of select="concat($prec,'L ',$p2,$rett,' ',$succ)" />
            </xsl:variable>  
            <xsl:call-template name="gestione-valori-path">
                <xsl:with-param name="v">
                    <xsl:value-of select="$new-v" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        
        <!-- XXXXXXXXXXXX wr XXXXXXXXXX -->  
        <xsl:when test="contains($v,'wr')">
            <xsl:variable name="prec">
                <xsl:value-of select="substring-before($v,'wr')" />
            </xsl:variable>
            <xsl:variable name="succ-temp"> <!-- tutto quello che segue wr -->
                <xsl:value-of select="substring-after($v,'wr')" />
            </xsl:variable>
            <xsl:variable name="inside"> <!-- i punti di wr -->
                <xsl:call-template name="before-string">
                    <xsl:with-param name="v">
                        <xsl:value-of select="$succ-temp" />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="succ"> <!-- tutto quello che segue i punti di wr -->
                <xsl:value-of select="substring-after($succ-temp,$inside)" />
            </xsl:variable>
            
            <!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->
            <!-- Approssimato, con un rettangolo                                -->
            <!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->
            
            <xsl:variable name="primo-punto-wr">
                 <xsl:call-template name="primo-valore">
                    <xsl:with-param name="stringa">
                        <xsl:value-of select="normalize-space($inside)" />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="secondo-punto-wr">
                 <xsl:call-template name="secondo-valore">
                    <xsl:with-param name="stringa">
                        <xsl:value-of select="normalize-space($inside)" />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="ultimo-punto-wr">
                 <xsl:call-template name="ultimo-valore">
                    <xsl:with-param name="stringa">
                        <xsl:value-of select="normalize-space($inside)" />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="penultimo-punto-wr">
                 <xsl:call-template name="penultimo-valore">
                    <xsl:with-param name="stringa">
                        <xsl:value-of select="normalize-space($inside)" />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            
             <xsl:variable name="rx-wr">
                 <xsl:call-template name="primo-valore">
                    <xsl:with-param name="stringa">                    
                        <xsl:call-template name="dal-terzo-valore">
                            <xsl:with-param name="stringa">                    
                                <xsl:value-of select="normalize-space($inside)" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="ry-wr">
                 <xsl:call-template name="secondo-valore">
                    <xsl:with-param name="stringa">                    
                        <xsl:call-template name="dal-terzo-valore">
                            <xsl:with-param name="stringa">                    
                                <xsl:value-of select="normalize-space($inside)" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            
            <!-- RETTANGOLO -->
            <xsl:variable name="p2">
                <xsl:value-of select="concat($primo-punto-wr,' ',$secondo-punto-wr)" />
            </xsl:variable>
            
            <xsl:variable name="rett">
                <xsl:text> ^ </xsl:text>
                <xsl:value-of select="concat(($rx-wr - $primo-punto-wr),' 0')" />
                <xsl:text> # </xsl:text>
                <xsl:value-of select="concat('0 ',($ry-wr - $secondo-punto-wr))" />
                <xsl:text> # </xsl:text>
                <xsl:value-of select="concat( - ($rx-wr - $primo-punto-wr),' 0')" />
                <xsl:text> # </xsl:text>
                <xsl:value-of select="concat('0 ', - ($ry-wr - $secondo-punto-wr))" />
                <xsl:text> # </xsl:text>
                <xsl:value-of select="concat(($rx-wr - $primo-punto-wr),' 0')" />
            </xsl:variable>
                        
            <xsl:variable name="new-v">         
                <xsl:value-of select="concat($prec,'^ ',$p2,$rett,' ',$succ)" />
            </xsl:variable>  
            
            <xsl:call-template name="gestione-valori-path">
                <xsl:with-param name="v">
                    <xsl:value-of select="$new-v" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        
        <!-- XXXXXXXXXXXX nf XXXXXXXXXX -->  
        <xsl:when test="contains($v,'nf')">
            <!-- XXXXXXXXXXXXXXX -->     
            <!-- Non è gestibile -->
            <!-- XXXXXXXXXXXXXXX -->  
            <xsl:variable name="new-v">
                <xsl:value-of select="concat(substring-before($v,'nf'),' ',
                                             substring-after($v,'nf'))" />
            </xsl:variable>
            <xsl:call-template name="gestione-valori-path">
                <xsl:with-param name="v">
                    <xsl:value-of select="$new-v" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        
        <!-- XXXXXXXXXXXX ns XXXXXXXXXX -->  
        <xsl:when test="contains($v,'ns')">
            <!-- XXXXXXXXXXXXXXX -->     
            <!-- Non è gestibile -->
            <!-- XXXXXXXXXXXXXXX -->  
            <xsl:variable name="new-v">
                <xsl:value-of select="concat(substring-before($v,'ns'),' ',
                                             substring-after($v,'ns'))" />
            </xsl:variable>
            <xsl:call-template name="gestione-valori-path">
                <xsl:with-param name="v">
                    <xsl:value-of select="$new-v" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>

        <!-- XXXXXXXXXXXX m XXXXXXXXXX -->  
        <xsl:when test="contains($v,'m')">
            <xsl:variable name="new-v">
                <xsl:value-of select="concat(substring-before($v,'m'),'M',
                                             substring-after($v,'m'))" />
            </xsl:variable>
            <xsl:call-template name="gestione-valori-path">
                <xsl:with-param name="v">
                    <xsl:value-of select="$new-v" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        
        <!-- XXXXXXXXXXXX l XXXXXXXXXX -->  
        <xsl:when test="contains($v,'l')">
            <xsl:variable name="new-v">
                <xsl:value-of select="concat(substring-before($v,'l'),'L',
                                             substring-after($v,'l'))" />
            </xsl:variable>
            <xsl:call-template name="gestione-valori-path">
                <xsl:with-param name="v">
                    <xsl:value-of select="$new-v" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        
        <!-- XXXXXXXXXXXX c XXXXXXXXXX -->  
        <xsl:when test="contains($v,'c')">
            <xsl:variable name="new-v">
                <xsl:value-of select="concat(substring-before($v,'c'),'C',
                                             substring-after($v,'c'))" />
            </xsl:variable>
            <xsl:call-template name="gestione-valori-path">
                <xsl:with-param name="v">
                    <xsl:value-of select="$new-v" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        
        <!-- XXXXXXXXXXXX qb XXXXXXXXXX -->  
        <xsl:when test="contains($v,'qb')">
            <xsl:variable name="new-v">
                <xsl:value-of select="concat(substring-before($v,'qb'),'Q',
                                             substring-after($v,'qb'))" />
            </xsl:variable>
            <xsl:call-template name="gestione-valori-path">
                <xsl:with-param name="v">
                    <xsl:value-of select="$new-v" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        
        <!-- XXXXXXXXXXXX t XXXXXXXXXX -->  
        <xsl:when test="contains($v,'t')">
            <xsl:variable name="new-v">
                <xsl:value-of select="concat(substring-before($v,'t'),'^',
                                             substring-after($v,'t'))" />
            </xsl:variable>
            <xsl:call-template name="gestione-valori-path">
                <xsl:with-param name="v">
                    <xsl:value-of select="$new-v" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        
        <!-- XXXXXXXXXXXX r XXXXXXXXXX -->  
        <xsl:when test="contains($v,'r')">
            <xsl:variable name="new-v">
                <xsl:value-of select="concat(substring-before($v,'r'),'#',
                                             substring-after($v,'r'))" />
            </xsl:variable>
            <xsl:call-template name="gestione-valori-path">
                <xsl:with-param name="v">
                    <xsl:value-of select="$new-v" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        
        <!-- XXXXXXXXXXXX v XXXXXXXXXX -->  
        <xsl:when test="contains($v,'v')">
            <xsl:variable name="new-v">
                <xsl:value-of select="concat(substring-before($v,'v'),'@',
                                             substring-after($v,'v'))" />
            </xsl:variable>
            <xsl:call-template name="gestione-valori-path">
                <xsl:with-param name="v">
                    <xsl:value-of select="$new-v" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        
        <!-- XXXXXXXXXXXX e XXXXXXXXXX -->  
        <xsl:when test="contains($v,'e')">
            <xsl:variable name="new-v">
                <xsl:value-of select="concat(substring-before($v,'e'),' ',
                                             substring-after($v,'e'))" />
            </xsl:variable>
            <xsl:call-template name="gestione-valori-path">
                <xsl:with-param name="v">
                    <xsl:value-of select="$new-v" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        
        <!-- XXXXXXXXXXXX x XXXXXXXXXX -->  
        <xsl:when test="contains($v,'x')">
            <xsl:variable name="new-v">
                <xsl:value-of select="concat(substring-before($v,'x'),'z',
                                             substring-after($v,'x'))" />
            </xsl:variable>
            <xsl:call-template name="gestione-valori-path">
                <xsl:with-param name="v">
                    <xsl:value-of select="$new-v" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        
        <!-- XXXXXXXXXXXX X XXXXXXXXXX -->  
        <xsl:when test="contains($v,'X')">
            <xsl:variable name="new-v">
                <xsl:value-of select="concat(substring-before($v,'X'),'z',
                                             substring-after($v,'X'))" />
            </xsl:variable>
            <xsl:call-template name="gestione-valori-path">
                <xsl:with-param name="v">
                    <xsl:value-of select="$new-v" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="translate(
                                  translate(translate($v,'#','l'),'@','c'),'^','m')" />
        </xsl:otherwise>
    </xsl:choose>

</xsl:template>

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ TEMPLATE: BEFORE STRING********************************* -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template name="before-string">
    <xsl:param name="v" />
    
    <!-- restituisce la parte di v che precedente un qualsiasi comando di path -->
    <!-- cioè solo dei punti -->
    
    <xsl:choose>
        <xsl:when test="contains($v,'#')">
            <xsl:variable name="v-temp">
                <xsl:value-of select="substring-before($v,'#')" />
            </xsl:variable>
            <xsl:call-template name="before-string">
                <xsl:with-param name="v">
                    <xsl:value-of select="$v-temp" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($v,'@')">
            <xsl:variable name="v-temp">
                <xsl:value-of select="substring-before($v,'@')" />
            </xsl:variable>
            <xsl:call-template name="before-string">
                <xsl:with-param name="v">
                    <xsl:value-of select="$v-temp" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
                <xsl:when test="contains($v,'^')">
            <xsl:variable name="v-temp">
                <xsl:value-of select="substring-before($v,'^')" />
            </xsl:variable>
            <xsl:call-template name="before-string">
                <xsl:with-param name="v">
                    <xsl:value-of select="$v-temp" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>


        <xsl:when test="contains($v,'z')">
            <xsl:variable name="v-temp">
                <xsl:value-of select="substring-before($v,'z')" />
            </xsl:variable>
            <xsl:call-template name="before-string">
                <xsl:with-param name="v">
                    <xsl:value-of select="$v-temp" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($v,'s')">
            <xsl:variable name="v-temp">
                <xsl:value-of select="substring-before($v,'s')" />
            </xsl:variable>
            <xsl:call-template name="before-string">
                <xsl:with-param name="v">
                    <xsl:value-of select="$v-temp" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($v,'h')">
            <xsl:variable name="v-temp">
                <xsl:value-of select="substring-before($v,'h')" />
            </xsl:variable>
            <xsl:call-template name="before-string">
                <xsl:with-param name="v">
                    <xsl:value-of select="$v-temp" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($v,'M')">
            <xsl:variable name="v-temp">
                <xsl:value-of select="substring-before($v,'M')" />
            </xsl:variable>
            <xsl:call-template name="before-string">
                <xsl:with-param name="v">
                    <xsl:value-of select="$v-temp" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($v,'Z')">
            <xsl:variable name="v-temp">
                <xsl:value-of select="substring-before($v,'Z')" />
            </xsl:variable>
            <xsl:call-template name="before-string">
                <xsl:with-param name="v">
                    <xsl:value-of select="$v-temp" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($v,'L')">
            <xsl:variable name="v-temp">
                <xsl:value-of select="substring-before($v,'L')" />
            </xsl:variable>
            <xsl:call-template name="before-string">
                <xsl:with-param name="v">
                    <xsl:value-of select="$v-temp" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($v,'H')">
            <xsl:variable name="v-temp">
                <xsl:value-of select="substring-before($v,'H')" />
            </xsl:variable>
            <xsl:call-template name="before-string">
                <xsl:with-param name="v">
                    <xsl:value-of select="$v-temp" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($v,'V')">
            <xsl:variable name="v-temp">
                <xsl:value-of select="substring-before($v,'V')" />
            </xsl:variable>
            <xsl:call-template name="before-string">
                <xsl:with-param name="v">
                    <xsl:value-of select="$v-temp" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($v,'C')">
            <xsl:variable name="v-temp">
                <xsl:value-of select="substring-before($v,'C')" />
            </xsl:variable>
            <xsl:call-template name="before-string">
                <xsl:with-param name="v">
                    <xsl:value-of select="$v-temp" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($v,'S')">
            <xsl:variable name="v-temp">
                <xsl:value-of select="substring-before($v,'S')" />
            </xsl:variable>
            <xsl:call-template name="before-string">
                <xsl:with-param name="v">
                    <xsl:value-of select="$v-temp" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($v,'Q')">
            <xsl:variable name="v-temp">
                <xsl:value-of select="substring-before($v,'Q')" />
            </xsl:variable>
            <xsl:call-template name="before-string">
                <xsl:with-param name="v">
                    <xsl:value-of select="$v-temp" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($v,'T')">
            <xsl:variable name="v-temp">
                <xsl:value-of select="substring-before($v,'T')" />
            </xsl:variable>
            <xsl:call-template name="before-string">
                <xsl:with-param name="v">
                    <xsl:value-of select="$v-temp" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($v,'A')">
            <xsl:variable name="v-temp">
                <xsl:value-of select="substring-before($v,'A')" />
            </xsl:variable>
            <xsl:call-template name="before-string">
                <xsl:with-param name="v">
                    <xsl:value-of select="$v-temp" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>

        <xsl:when test="contains($v,'m')">
            <xsl:variable name="v-temp">
                <xsl:value-of select="substring-before($v,'m')" />
            </xsl:variable>
            <xsl:call-template name="before-string">
                <xsl:with-param name="v">
                    <xsl:value-of select="$v-temp" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($v,'l')">
            <xsl:variable name="v-temp">
                <xsl:value-of select="substring-before($v,'l')" />
            </xsl:variable>
            <xsl:call-template name="before-string">
                <xsl:with-param name="v">
                    <xsl:value-of select="$v-temp" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($v,'c')">
            <xsl:variable name="v-temp">
                <xsl:value-of select="substring-before($v,'c')" />
            </xsl:variable>
            <xsl:call-template name="before-string">
                <xsl:with-param name="v">
                    <xsl:value-of select="$v-temp" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($v,'x')">
            <xsl:variable name="v-temp">
                <xsl:value-of select="substring-before($v,'x')" />
            </xsl:variable>
            <xsl:call-template name="before-string">
                <xsl:with-param name="v">
                    <xsl:value-of select="$v-temp" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($v,'e')">
            <xsl:variable name="v-temp">
                <xsl:value-of select="substring-before($v,'e')" />
            </xsl:variable>
            <xsl:call-template name="before-string">
                <xsl:with-param name="v">
                    <xsl:value-of select="$v-temp" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($v,'t')">
            <xsl:variable name="v-temp">
                <xsl:value-of select="substring-before($v,'t')" />
            </xsl:variable>
            <xsl:call-template name="before-string">
                <xsl:with-param name="v">
                    <xsl:value-of select="$v-temp" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($v,'r')">
            <xsl:variable name="v-temp">
                <xsl:value-of select="substring-before($v,'r')" />
            </xsl:variable>
            <xsl:call-template name="before-string">
                <xsl:with-param name="v">
                    <xsl:value-of select="$v-temp" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($v,'v')">
            <xsl:variable name="v-temp">
                <xsl:value-of select="substring-before($v,'v')" />
            </xsl:variable>
            <xsl:call-template name="before-string">
                <xsl:with-param name="v">
                    <xsl:value-of select="$v-temp" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($v,'n')">
            <xsl:variable name="v-temp">
                <xsl:value-of select="substring-before($v,'n')" />
            </xsl:variable>
            <xsl:call-template name="before-string">
                <xsl:with-param name="v">
                    <xsl:value-of select="$v-temp" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($v,'a')">
            <xsl:variable name="v-temp">
                <xsl:value-of select="substring-before($v,'a')" />
            </xsl:variable>
            <xsl:call-template name="before-string">
                <xsl:with-param name="v">
                    <xsl:value-of select="$v-temp" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>                                         
        <xsl:when test="contains($v,'w')">
            <xsl:variable name="v-temp">
                <xsl:value-of select="substring-before($v,'w')" />
            </xsl:variable>
            <xsl:call-template name="before-string">
                <xsl:with-param name="v">
                    <xsl:value-of select="$v-temp" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($v,'q')">
            <xsl:variable name="v-temp">
                <xsl:value-of select="substring-before($v,'q')" />
            </xsl:variable>
            <xsl:call-template name="before-string">
                <xsl:with-param name="v">
                    <xsl:value-of select="$v-temp" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$v" />
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ GESTIONE STRINGHE ************************************** -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->

<!-- ******************************************************************************** -->
<!-- ***************** TEMPLATE: PRIMO VALORE  ************************************** -->
<!-- ******************************************************************************** -->
<xsl:template name="primo-valore">
    <xsl:param name="stringa" />
    <xsl:param name="default"><xsl:text>0</xsl:text></xsl:param>
    <!-- restituisce il primo valore presente in stringa (stringa può contenere uno o due
         valori, nella forma x1 x2 o x1,x2, oppure 0 valori -->
    <xsl:choose>
        <xsl:when test="contains($stringa,',') and
                        contains(normalize-space($stringa),' ')"> 
                <xsl:choose>
                    <!-- x1,x2 ... xn -->
                    <xsl:when test="contains(substring-before(
                                             normalize-space($stringa),' '),',')">
                        <xsl:value-of select="normalize-space(
                                              substring-before($stringa,','))" />
                    </xsl:when>
                    <!-- x1 x2 ... ,xn -->
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(substring-before(
                                              normalize-space($stringa),' '))" />
                    </xsl:otherwise>
                </xsl:choose>
        </xsl:when> 
        <xsl:when test="contains($stringa,',')"> <!-- x1,x2 -->
            <xsl:value-of select="normalize-space(substring-before($stringa,','))" />
        </xsl:when>
        <xsl:when test="contains(normalize-space($stringa),' ')"> <!-- x1 x2 -->
            <xsl:value-of select="normalize-space(substring-before(
                                  normalize-space($stringa),' '))" />
        </xsl:when>    
        <xsl:when test="normalize-space($stringa) != ''">
            <xsl:value-of select="normalize-space($stringa)" />
        </xsl:when> 
        <xsl:otherwise>
            <xsl:value-of select="$default" />
        </xsl:otherwise>        
    </xsl:choose>
</xsl:template>

<!-- ******************************************************************************** -->
<!-- ***************** TEMPLATE: SECONDO VALORE  ************************************ -->
<!-- ******************************************************************************** -->
<xsl:template name="secondo-valore">
    <xsl:param name="stringa" />
    <xsl:param name="default"><xsl:text>0</xsl:text></xsl:param>
    <!-- restituisce il secondo valore presente in stringa (stringa può contenere molti 
         valori, anche 0) -->
    <xsl:variable name="stringa-temp">
        <xsl:choose>
            <xsl:when test="contains($stringa,',') and 
                            contains(normalize-space($stringa),' ')">
                <xsl:choose>
                    <!-- x1,x2 ... xn -->
                    <xsl:when test="contains(substring-before(
                                             normalize-space($stringa),' '),',')">
                        <xsl:value-of select="normalize-space(
                                              substring-after($stringa,','))" />
                    </xsl:when>
                    <!-- x1 x2 ... ,xn -->
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(substring-after(
                                              normalize-space($stringa),' '))" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="contains($stringa,',')"> <!-- x1,x2 ... -->
                <xsl:value-of select="normalize-space(substring-after($stringa,','))" />
            </xsl:when> 
            <xsl:when test="contains(normalize-space($stringa),' ')"><!-- x1 x2 ... -->
                <xsl:value-of select="normalize-space(substring-after(
                                      normalize-space($stringa),' '))" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$default" />
            </xsl:otherwise>   
        </xsl:choose>
    </xsl:variable>
    <xsl:choose>
        <xsl:when test="contains($stringa-temp,',') and 
                        contains(normalize-space($stringa-temp),' ')">
            <xsl:choose>
                <!-- x2,x3 ... xn -->
                <xsl:when test="contains(substring-before(
                                normalize-space($stringa-temp),' '),',')">
                    <xsl:value-of select="normalize-space(
                                          substring-before($stringa-temp,','))" />
                </xsl:when>
                <!-- x2 x3 ... ,xn -->
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space(substring-before(
                                          normalize-space($stringa-temp),' '))" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:when>
        <xsl:when test="contains($stringa-temp,',')">
            <xsl:value-of select="substring-before($stringa-temp,',')" />
        </xsl:when>
        <xsl:when test="contains($stringa-temp,' ')">
            <xsl:value-of select="normalize-space(
                                  substring-before($stringa-temp,' '))" />        
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$stringa-temp" />
        </xsl:otherwise>        
    </xsl:choose>
</xsl:template>

<!-- ******************************************************************************** -->
<!-- ***************** TEMPLATE: DAL TERZO VALORE  ********************************** -->
<!-- ******************************************************************************** -->
<xsl:template name="dal-terzo-valore">
    <xsl:param name="stringa" />
    <xsl:param name="default"><xsl:text></xsl:text></xsl:param>
    <!-- restituisce i valori dal terzo presenti in stringa (stringa può contenere molti 
         valori, anche 0) -->
    <xsl:variable name="stringa-temp">
        <xsl:choose>
            <xsl:when test="contains($stringa,',') and 
                            contains(normalize-space($stringa),' ')">
                <xsl:choose>
                    <!-- x1,x2 ... xn -->
                    <xsl:when test="contains(substring-before(
                                             normalize-space($stringa),' '),',')">
                        <xsl:value-of select="normalize-space(
                                              substring-after($stringa,','))" />
                    </xsl:when>
                    <!-- x1 x2 ... ,xn -->
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(substring-after(
                                              normalize-space($stringa),' '))" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="contains($stringa,',')"> <!-- x1,x2 ... -->
                <xsl:value-of select="normalize-space(substring-after($stringa,','))" />
            </xsl:when> 
            <xsl:when test="contains(normalize-space($stringa),' ')"><!-- x1 x2 ... -->
                <xsl:value-of select="normalize-space(substring-after(
                                      normalize-space($stringa),' '))" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$default" />
            </xsl:otherwise>   
        </xsl:choose>
    </xsl:variable>
    
    <xsl:choose>
        <xsl:when test="contains($stringa-temp,',') and 
                        contains(normalize-space($stringa-temp),' ')">
            <xsl:choose>
                <!-- x2,x3 ... xn -->
                <xsl:when test="contains(substring-before(
                                normalize-space($stringa-temp),' '),',')">
                    <xsl:value-of select="normalize-space(
                                          substring-after($stringa-temp,','))" />
                </xsl:when>
                <!-- x2 x3 ... ,xn -->
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space(substring-after(
                                          normalize-space($stringa-temp),' '))" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:when>
        <xsl:when test="contains($stringa-temp,',')">
            <xsl:value-of select="substring-after($stringa-temp,',')" />
        </xsl:when>
        <xsl:when test="contains($stringa-temp,' ')">
            <xsl:value-of select="normalize-space(
                                  substring-after($stringa-temp,' '))" />        
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise>        
    </xsl:choose>
</xsl:template>

<!-- ******************************************************************************** -->
<!-- ***************** TEMPLATE: ULTIMO VALORE  ************************************* -->
<!-- ******************************************************************************** -->
<xsl:template name="ultimo-valore">
    <xsl:param name="stringa" />
    <xsl:param name="default"><xsl:text></xsl:text></xsl:param>
    <!-- restituisce l'ultimo valore presente in stringa (stringa può contenere molti 
         valori, anche 0) -->
    <!-- funzione ricorsiva -->
    <xsl:variable name="stringa-temp">
        <xsl:choose>
            <xsl:when test="contains($stringa,',') and 
                            contains(normalize-space($stringa),' ')">
                <xsl:choose>
                    <!-- x1,x2 ... xn -->
                    <xsl:when test="contains(substring-before(
                                             normalize-space($stringa),' '),',')">
                        <xsl:value-of select="normalize-space(
                                              substring-after($stringa,','))" />
                    </xsl:when>
                    <!-- x1 x2 ... ,xn -->
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(substring-after(
                                              normalize-space($stringa),' '))" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="contains($stringa,',')"> <!-- x1,x2 ... -->
                <xsl:value-of select="normalize-space(substring-after($stringa,','))" />
            </xsl:when> 
            <xsl:when test="contains(normalize-space($stringa),' ')"><!-- x1 x2 ... -->
                <xsl:value-of select="normalize-space(substring-after(
                                      normalize-space($stringa),' '))" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="normalize-space($stringa)" />
            </xsl:otherwise>   
        </xsl:choose>
    </xsl:variable>
    
    <xsl:choose>
        <xsl:when test="contains($stringa-temp,',') or
                        contains(normalize-space($stringa-temp),' ')">
            <xsl:call-template name="ultimo-valore">
                <xsl:with-param name="stringa">
                    <xsl:value-of select="normalize-space($stringa-temp)" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$stringa-temp" />
        </xsl:otherwise>        
    </xsl:choose>
</xsl:template>

<!-- ******************************************************************************** -->
<!-- ***************** TEMPLATE: PENULTIMO VALORE  ********************************** -->
<!-- ******************************************************************************** -->
<xsl:template name="penultimo-valore">
    <xsl:param name="stringa" />
    <xsl:param name="default"><xsl:text></xsl:text></xsl:param>
    <!-- restituisce il penultimo valore presente in stringa (stringa può contenere molti 
         valori, anche 0) -->
    <!-- funzione ricorsiva -->
    
    <xsl:variable name="stringa-after">
        <xsl:choose>
            <xsl:when test="contains($stringa,',') and 
                            contains(normalize-space($stringa),' ')">
                <xsl:choose>
                    <!-- x1,x2 ... xn -->
                    <xsl:when test="contains(substring-before(
                                             normalize-space($stringa),' '),',')">
                        <xsl:value-of select="normalize-space(
                                              substring-after($stringa,','))" />
                    </xsl:when>
                    <!-- x1 x2 ... ,xn -->
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(substring-after(
                                              normalize-space($stringa),' '))" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="contains($stringa,',')"> <!-- x1,x2 ... -->
                <xsl:value-of select="normalize-space(substring-after($stringa,','))" />
            </xsl:when> 
            <xsl:when test="contains(normalize-space($stringa),' ')"><!-- x1 x2 ... -->
                <xsl:value-of select="normalize-space(substring-after(
                                      normalize-space($stringa),' '))" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$default" />
            </xsl:otherwise>   
        </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="stringa-before">
        <xsl:choose>
            <xsl:when test="contains($stringa,',') and 
                            contains(normalize-space($stringa),' ')">
                <xsl:choose>
                    <!-- x1,x2 ... xn -->
                    <xsl:when test="contains(substring-before(
                                             normalize-space($stringa),' '),',')">
                        <xsl:value-of select="normalize-space(
                                              substring-before($stringa,','))" />
                    </xsl:when>
                    <!-- x1 x2 ... ,xn -->
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(substring-before(
                                              normalize-space($stringa),' '))" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="contains($stringa,',')"> <!-- x1,x2 ... -->
                <xsl:value-of select="normalize-space(substring-before($stringa,','))" />
            </xsl:when> 
            <xsl:when test="contains(normalize-space($stringa),' ')"><!-- x1 x2 ... -->
                <xsl:value-of select="normalize-space(substring-before(
                                      normalize-space($stringa),' '))" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="normalize-space($stringa)" />
            </xsl:otherwise>   
        </xsl:choose>
    </xsl:variable>
    
    <xsl:choose>
        <xsl:when test="contains($stringa-after,',') or
                        contains(normalize-space($stringa-after),' ')">
            <xsl:call-template name="penultimo-valore">
                <xsl:with-param name="stringa">
                    <xsl:value-of select="normalize-space($stringa-after)" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$stringa-before" />
        </xsl:otherwise>        
    </xsl:choose>
</xsl:template>


</xsl:stylesheet>
