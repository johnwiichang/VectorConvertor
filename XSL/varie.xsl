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
        - valore-whxy           (calcola width, height, x o y, presenti in @style)
        - estrai-valore         (estrae un valore all'interno dell'attributo style)
        - conversione           (conversione da unita' di misura a user unit)
        - unita-di-misura           (unita' di misura)
        - solo-numero               (valore)
        - elemento-textpath
        - gestione-textpath
        - elemento-textbox
        - calcola-font
        
        - calcola-scala
        - calcola-coordsize
        - aggiungi-spazi
            - spazi-iniziali
            - spazi-finali
        
        - gestione-href
   
    - match:
        - v:textbox
        - v:textbox mode="html"
        - html:* (gestione tag a,i,b)
-->

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ TEMPLATE: VALORE-WHXY ********************************** -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template name="valore-whxy">
    <xsl:param name="attributo"><xsl:text>w</xsl:text></xsl:param>
    <xsl:param name="converti"><xsl:text>no</xsl:text></xsl:param>
    
<!-- calcola il valore di width (o di height, x, y dipende dal parametro) e lo restituisce 
     (eventualmente convertito in pixel, dipende dal parametro converti).
     x,y corrisponderebbero a left e top (all'interno di style)
-->

<xsl:variable name="tipo-conv">
    <xsl:choose>
        <xsl:when test="$converti = 'real'">
            <xsl:text>real</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>adatta</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:variable>
     
<xsl:choose>
    <xsl:when test="@style">
        <xsl:choose>
            <xsl:when test="$attributo = 'w'">
                <xsl:choose>
                    <xsl:when test="contains(@style,'width') or contains(@style,'WIDTH')">
                    
                        <xsl:variable name="stringa-temp">
                            <xsl:call-template name="estrai-valore" />
                        </xsl:variable>
                        
                        <xsl:choose>
                            <xsl:when test="$converti = 'no'">
                                <xsl:value-of select="$stringa-temp" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="conversione">
                                    <xsl:with-param name="attributo">
                                        <xsl:value-of select="$stringa-temp" />
                                    </xsl:with-param>
                                    <xsl:with-param name="nome">
                                        <xsl:text>width</xsl:text>
                                    </xsl:with-param>
                                    <xsl:with-param name="tipo">
                                        <xsl:value-of select="$tipo-conv" />
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>0</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$attributo = 'h'"><!-- h -->
                <xsl:choose>
                    <xsl:when test="contains(@style,'height') or contains(@style,'HEIGHT')">
                        <xsl:variable name="stringa-temp">
                            <xsl:call-template name="estrai-valore">
                                <xsl:with-param name="stringa1">
                                    <xsl:text>height</xsl:text>
                                </xsl:with-param>
                                <xsl:with-param name="stringa2">
                                    <xsl:text>HEIGHT</xsl:text>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>
                        
                        <xsl:choose>
                            <xsl:when test="$converti = 'no'">
                                <xsl:value-of select="$stringa-temp" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="conversione">
                                    <xsl:with-param name="attributo">
                                        <xsl:value-of select="$stringa-temp" />
                                    </xsl:with-param>
                                    <xsl:with-param name="nome">
                                        <xsl:text>height</xsl:text>
                                    </xsl:with-param>
                                    <xsl:with-param name="tipo">
                                        <xsl:value-of select="$tipo-conv" />
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>0</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>            
            </xsl:when>
            
            <xsl:when test="$attributo = 'x'"> <!-- x -->
                <xsl:choose>
                    <xsl:when test="contains(@style,'left') or contains(@style,'LEFT')">
                    
                        <xsl:variable name="stringa-temp">
                            <xsl:call-template name="estrai-valore">
                                <xsl:with-param name="stringa1">
                                    <xsl:text>left</xsl:text>
                                </xsl:with-param>
                                <xsl:with-param name="stringa2">
                                    <xsl:text>LEFT</xsl:text>
                                </xsl:with-param>
                            </xsl:call-template>                            
                        </xsl:variable>
                        
                        <xsl:choose>
                            <xsl:when test="$converti = 'no'">
                                <xsl:value-of select="$stringa-temp" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="conversione">
                                    <xsl:with-param name="attributo">
                                        <xsl:value-of select="$stringa-temp" />
                                    </xsl:with-param>
                                    <xsl:with-param name="nome">
                                        <xsl:text>x</xsl:text>
                                    </xsl:with-param>
                                    <xsl:with-param name="tipo">
                                        <xsl:value-of select="$tipo-conv" />
                                    </xsl:with-param> 
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                            <xsl:text>0</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <xsl:otherwise><!-- y -->
                <xsl:choose>
                    <xsl:when test="contains(@style,'top') or contains(@style,'TOP')">
                        <xsl:variable name="stringa-temp">
                            <xsl:call-template name="estrai-valore">
                                <xsl:with-param name="stringa1">
                                    <xsl:text>top</xsl:text>
                                </xsl:with-param>
                                <xsl:with-param name="stringa2">
                                    <xsl:text>TOP</xsl:text>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>
                        
                        <xsl:choose>
                            <xsl:when test="$converti = 'no'">
                                <xsl:value-of select="$stringa-temp" />
                            </xsl:when>
                            <xsl:otherwise>

                                <xsl:call-template name="conversione">
                                    <xsl:with-param name="attributo">
                                        <xsl:value-of select="$stringa-temp" />
                                    </xsl:with-param>
                                    <xsl:with-param name="nome">
                                        <xsl:text>y</xsl:text>
                                    </xsl:with-param>
                                    <xsl:with-param name="tipo">
                                        <xsl:value-of select="$tipo-conv" />
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>0</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>            
            </xsl:otherwise>            
        </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
        <xsl:text>0</xsl:text>
    </xsl:otherwise>
</xsl:choose>
</xsl:template>


<!-- ******************************************************************************** -->
<!-- ***************** TEMPLATE: ESTRAI-VALORE  ************************************* -->
<!-- ******************************************************************************** -->
<xsl:template name="estrai-valore">
<!-- estrae il valore del parametro passato come stringa all'interno dell'attributo style -->
    <xsl:param name="stringa1"><xsl:text>width</xsl:text></xsl:param>
    <xsl:param name="stringa2"><xsl:text>WIDTH</xsl:text></xsl:param>
    
<xsl:variable name="nome">
    <xsl:choose>
        <xsl:when test="contains(@style,$stringa1)">
            <xsl:value-of select="$stringa1" />
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$stringa2" />
        </xsl:otherwise>
    </xsl:choose>
</xsl:variable>

<xsl:choose>
    <xsl:when test="contains(substring-after(@style,$nome),';')">
        <xsl:value-of select="normalize-space(substring-after(
                              normalize-space(substring-before(substring-after(
                              @style,$nome),';')),':'))" />
    </xsl:when>
    <xsl:otherwise>
        <xsl:value-of select="normalize-space(substring-after(
                              normalize-space(substring-after(@style,$nome)),':'))" />
    </xsl:otherwise>
</xsl:choose>

</xsl:template>

<!-- ******************************************************************************** -->
<!-- ***************** TEMPLATE: conversione  *************************************** -->
<!-- ******************************************************************************** -->
<xsl:template name="conversione" >
    <xsl:param name="attributo" />
    <xsl:param name="nome" />
    <xsl:param name="tipo"><xsl:text>adatta</xsl:text></xsl:param>
        <!-- tipo di conversione: se è diverso da adatta, converte con i reali valori
             delle varie unità di misura -->

<!-- NB: conversione è di due tipi:
        per quasi tutti i valori, la conversione in "user unit" è diversa da quella di
        SVG, c'è un diverso rapporto, tranne per alcune proprietà, quali font-size
        e stroke-width che è identica, in quanto i loro valori non vengono influenzati
        dagli altri elementi/attributi (in particolar modo non sono influenzati dagli
        attributi width, height e coordsize di elementi ancestor).
        Si utilizza quindi un parametro per specificare quale conversione effettuare
-->



<!-- funzione analoga a quella utilizzata in svg2vml -->
<!-- attributo serve per sapere a quale attributo ci si deve riferire per valori 
        espressi in percentuale -->

<!-- non gestiti i valori espressi in em ed ex. I valori espressi in % non sono stati
     gestiti tutti i possibili casi (potrebbero essere comunque corretti, lasciando
     il valore espresso in %)
-->

<!-- gli viene passato un attributo che viene convertito in unser unit -->

    <!-- dim contiene l'unità di misura di attributo -->
    <xsl:variable name="dim">
        <xsl:call-template name="unita-di-misura">
            <xsl:with-param name="attributo">
                <xsl:value-of select="$attributo" />
            </xsl:with-param>
        </xsl:call-template>
    </xsl:variable>

    <!-- number contiene il valore di attributo senza unità di misura -->
    <xsl:variable name="number">
        <xsl:call-template name="solo-numero">
            <xsl:with-param name="attributo">
                <xsl:value-of select="$attributo" />
            </xsl:with-param>
            <xsl:with-param name="dim">
                <xsl:value-of select="$dim" />
            </xsl:with-param>
        </xsl:call-template>
    </xsl:variable>

    <!-- valori di conversione per le varie unità di misuara a seconda del
         tipo di conversione da effettuare
    -->
    <xsl:variable name="cm-conv">
        <xsl:choose>
            <xsl:when test="$tipo = 'adatta'">
                <xsl:text>885</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>35.43307</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="in-conv">
        <xsl:choose>
            <xsl:when test="$tipo = 'adatta'">
                <xsl:text>2300</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>96</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="pt-conv">
        <xsl:choose>
            <xsl:when test="$tipo = 'adatta'">
                <xsl:text>32</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>1.25</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="mm-conv">
        <xsl:choose>
            <xsl:when test="$tipo = 'adatta'">
                <xsl:text>88.5</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>3.543307</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="pc-conv">
        <xsl:choose>
            <xsl:when test="$tipo = 'adatta'">
                <xsl:text>385</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>15</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
        
    <!-- qui restituisce il valore dell'attributo convertito in user unit -->
    <xsl:choose>
            <xsl:when test="$dim = 'cm'">
                <xsl:value-of select="$number * $cm-conv" />   
            </xsl:when>
            <xsl:when test="$dim = 'in'">
                <xsl:value-of select="$number * $in-conv" /> 
            </xsl:when>
            <xsl:when test="$dim = 'px'">
                <xsl:value-of select="$number" />
            </xsl:when>
            <xsl:when test="$dim = 'pt'">
                <xsl:value-of select="$number * $pt-conv" />
            </xsl:when>
            <xsl:when test="$dim = 'mm'">
                <xsl:value-of select="$number * $mm-conv" />
            </xsl:when>
            <xsl:when test="$dim = 'pc'">
                <xsl:value-of select="$number * $pc-conv" />
            </xsl:when>
            <xsl:when test="$dim = 'em'">
                <!-- devo cercare font-size -->
                <xsl:variable name="font-s">
                    <!-- da gestire -->
                    <xsl:text>1</xsl:text>
                </xsl:variable>
                <xsl:value-of select="$number * $font-s" />
            </xsl:when>
            <xsl:when test="$dim = '%'">
                <!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->
                <xsl:choose>
                    <xsl:when test="$nome = 'font-size'">
                        <xsl:value-of select="$number" />
                    </xsl:when>
                    <xsl:when test="$nome = 'stroke-width'">
                        <xsl:value-of select="$number" />
                    </xsl:when>
                    <xsl:when test="$nome = 'width'">
                        <xsl:variable name="w-val">
                            <xsl:call-template name="calcola-coordsize" />
                        </xsl:variable>
                        <xsl:value-of select="($number * $w-val) div 100" />
                    </xsl:when>
                    <xsl:when test="$nome = 'height'">
                        <xsl:variable name="h-val">
                            <xsl:call-template name="calcola-coordsize">
                                <xsl:with-param name="attributo">
                                    <xsl:text>h</xsl:text>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="($number * $h-val) div 100" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$number" /><xsl:text>%</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->
            </xsl:when>
            <xsl:when test="$dim = ''">
                <xsl:value-of select="$number" />
            </xsl:when>
            <xsl:otherwise>
                <!-- ex: non gestito, restituisco il valore senza unita
                         di misura -->
                <xsl:value-of select="$number" />
            </xsl:otherwise>
    </xsl:choose>    
</xsl:template>

<!-- ******************************************************************************** -->
<!-- ***************** TEMPLATE: unita di misura ************************************ -->
<!-- ******************************************************************************** -->
<xsl:template name="unita-di-misura">
    <xsl:param name="attributo" />
    <!-- restituisce l'unità di misura di attributo -->
    <xsl:variable name="dim-temp">
        <xsl:value-of select="substring($attributo,string-length($attributo) - 1, 2)" />
    </xsl:variable>
    
    <xsl:choose>
        <xsl:when test="($dim-temp = 'em') or ($dim-temp = 'ex') or 
                        ($dim-temp = 'px') or ($dim-temp = 'pt') or 
                        ($dim-temp = 'pc') or ($dim-temp = 'cm') or 
                        ($dim-temp = 'mm') or ($dim-temp = 'in')" >
                <xsl:value-of select="$dim-temp" />   
        </xsl:when>
        <xsl:when test="substring($dim-temp,2,1) = '%'">
            <xsl:text>%</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text></xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- ******************************************************************************** -->
<!-- ***************** TEMPLATE: solo numero ************************************ -->
<!-- ******************************************************************************** -->
<xsl:template name="solo-numero">
    <xsl:param name="attributo" />
    <xsl:param name="dim" />
    <!-- restituisce il valore di attributo senza l'unità di misura (contenuta in dim) -->
    
    <xsl:choose>
        <xsl:when test="$dim = ''">
            <xsl:value-of select="$attributo" />
        </xsl:when>
        <xsl:when test="$dim = '%'">
            <xsl:value-of select="substring($attributo,1,string-length($attributo) - 1)" />
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="substring($attributo,1,string-length($attributo) - 2)" />
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>


<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ ELEMENTO TEXTPATH ************************************** -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template name="elemento-textpath">
    <xsl:param name="path-id"><xsl:text></xsl:text></xsl:param>
    <xsl:param name="stringa"><xsl:text></xsl:text></xsl:param>
    <xsl:param name="aggiustamento"><xsl:text></xsl:text></xsl:param>
    
<!-- creo l'elemento textPath -->

<!-- id del path, definito in precedenza e contenuto in defs -->
<xsl:variable name="valore-id">
        <xsl:value-of select="count(preceding::v:*) + count(ancestor::v:*)" />
</xsl:variable>

<text stroke-width="1">
<textPath >   

    <!-- questo font-size verrà eventualmente sovrascritto da attributi-style:
         serve per impostare un valore di default di font-size nel caso non sia
         definito in @style -->
    <xsl:attribute name="font-size">
        <xsl:call-template name="calcola-font">
            <xsl:with-param name="font">
                <xsl:text>16</xsl:text>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:attribute>
    

    <xsl:call-template name="attributi-style" >
        <xsl:with-param name="aggiustamento">
            <xsl:value-of select="$aggiustamento" />
        </xsl:with-param>
    </xsl:call-template>

    <xsl:attribute name="xlink:href">
        <xsl:text>#path</xsl:text>
            <xsl:choose>
                <xsl:when test="$path-id = ''">
                    <xsl:value-of select="$valore-id" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$path-id" />                
                </xsl:otherwise>
            </xsl:choose>
    </xsl:attribute>
    
    <xsl:variable name="stringa-temp">
        <xsl:choose>
            <xsl:when test="$stringa != ''">
                <xsl:value-of select="$stringa" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="@string" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:call-template name="aggiungi-spazi">
        <xsl:with-param name="stringa">
            <xsl:value-of select="$stringa-temp" />
        </xsl:with-param>
    </xsl:call-template>
</textPath></text>
</xsl:template>

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ TEMPLATE GESTIONE TEXTPATH ***************************** -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template name="gestione-textpath">

<!-- crea l'elemento path da inserire dentro defs, che verrà utilizzato come path per
     rappresentare il testo.
     Ogni textpath (contenuto in shape) si deve riferire ad un path. In svg i testi in
        un path si rappresentano tramite textPath, in cui c'è un attributo che si
        riferisce ad un elemento path. Quindi per la traduzione bisogna creare questo
        elemento path e lo si fa all'inizio, si creano tutti i path che saranno riferiti
        da un elemento textpath.
     NB: si crea un path per ogni textpath anche se questi textpath non verranno 
         visualizzati o non hanno un path a cui si riferiscono, in questo caso 
         l'attributo d del path sarà vuoto. Per poter definire i path da usare occorre
         quindi definire alcuni path che non saranno usati (e che sono vuoti).
         
     Si crea inolte un path per ogni elemento shape.
-->

<xsl:for-each select="//v:textpath">
    <!-- id univoco per ogni path -->
    <xsl:variable name="valore-id">
        <xsl:value-of select="count(preceding::v:*) + count(ancestor::v:*)" />
    </xsl:variable>
    
    <!-- creo il path associato all'elemento textpath -->
    <path>
        <xsl:attribute name="id">
            <xsl:text>path</xsl:text>
            <xsl:value-of select="$valore-id" />
        </xsl:attribute>
        
        <xsl:attribute name="d">        
            <xsl:for-each select="..">
                <xsl:choose>
                    <xsl:when test="v:path[@v != '']">
                        <xsl:for-each select="v:path[@v != '']">
                            <xsl:if test="position() = last()">
                                <xsl:call-template name="traduzione-path">
                                    <xsl:with-param name="v">
                                        <xsl:value-of select="@v" /> 
                                    </xsl:with-param>
                                </xsl:call-template>                
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="@path"> 
                        <xsl:call-template name="traduzione-path">
                            <xsl:with-param name="v">
                                <xsl:value-of select="@path" /> 
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="@type">
                        <xsl:variable name="id-of-shapetype">
                            <xsl:value-of select="substring-after(@type,'#')" />
                        </xsl:variable>
                        <xsl:for-each select="//v:shapetype[@id = $id-of-shapetype]">
                            <xsl:if test="position() = last()">
                                <xsl:choose>
                                    <xsl:when test="v:path[@v != '']">
                                        <xsl:for-each select="v:path[@v != '']">
                                            <xsl:if test="position() = last()">
                                                <xsl:call-template 
                                                        name="traduzione-path">
                                                    <xsl:with-param name="v">
                                                        <xsl:value-of select="@v" /> 
                                                    </xsl:with-param>
                                                </xsl:call-template>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:when test="@path">
                                        <xsl:call-template name="traduzione-path">
                                            <xsl:with-param name="v">
                                                <xsl:value-of select="@path" /> 
                                            </xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:when>
                                    <xsl:otherwise>    
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:attribute>
    </path>
</xsl:for-each>

<xsl:for-each select="//v:shape[@type]">
    <xsl:variable name="valore-id">
        <xsl:value-of select="count(preceding::v:*) + count(ancestor::v:*)" />
    </xsl:variable>
    
       <path>
        <xsl:attribute name="id">
            <xsl:text>path</xsl:text>
            <xsl:value-of select="$valore-id" />
        </xsl:attribute>
        
        <xsl:attribute name="d">        
            <xsl:choose>
                <xsl:when test="v:path[@v != '']">
                    <xsl:for-each select="v:path[@v != '']">
                        <xsl:if test="position() = last()">
                            <xsl:call-template name="traduzione-path">
                                <xsl:with-param name="v">
                                    <xsl:value-of select="@v" /> 
                                </xsl:with-param>
                            </xsl:call-template>                
                        </xsl:if>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="@path"> 
                    <xsl:call-template name="traduzione-path">
                        <xsl:with-param name="v">
                            <xsl:value-of select="@path" /> 
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </path>
</xsl:for-each>
</xsl:template>

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ ELEMENTO TEXBOX **************************************** -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template name="elemento-textbox">
    <xsl:param name="id-of-shapetype" />
    <xsl:param name="aggiustamento"><xsl:text></xsl:text></xsl:param>
    

<!-- creo un elemento text per rappresentare il testo -->

<text fill="black" stroke="none" font-family="Times">

<!-- valore del testo (quello di default) opportunamente aggiustato -->
<xsl:variable name="font-dim-temp">
        <xsl:call-template name="calcola-font">
            <xsl:with-param name="font">
                <xsl:text>16</xsl:text>
            </xsl:with-param>
            <xsl:with-param name="aggiustamento">
                <xsl:value-of select="$aggiustamento" />
            </xsl:with-param>
        </xsl:call-template>
</xsl:variable>

<xsl:variable name="font-dim">
    <!-- da fare: vai in tutti gli elementi contenuti (html), preleva il 
                  valore di font-size (tieni quello maggiore) e passalo
                  alla funzione calcola-font per gli aggiustamenti.
                  Se lo trovi usa questo, altrimenti usa font-dim-temp
    -->

    <xsl:value-of select="$font-dim-temp" />
</xsl:variable>

    <xsl:attribute name="font-size">
        <xsl:value-of select="$font-dim" />
    </xsl:attribute>
    
    <xsl:choose>
        <!-- imposto eventuali attributi x e y se trovo l'attributo 
              textboxrect
        -->
        <xsl:when test="v:path[@textboxrect]">
            <xsl:for-each select="v:path[@textboxrect]">
                <xsl:if test="position() = last()">
                    <xsl:variable name="x">
                        <xsl:call-template name="primo-valore">
                            <xsl:with-param name="stringa">
                                <xsl:value-of select="@textboxrect" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="y">
                        <xsl:call-template name="secondo-valore">
                            <xsl:with-param name="stringa">
                                <xsl:value-of select="@textboxrect" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:attribute name="x">
                        <xsl:value-of select="$x" /> 
                    </xsl:attribute>
                    <xsl:attribute name="y">
                        <xsl:value-of select="$y + $font-dim" /> 
                    </xsl:attribute>  
                </xsl:if>
            </xsl:for-each>
        </xsl:when>
        <xsl:when test="//v:shapetype[@id = $id-of-shapetype]/v:path[@textboxrect]">
            <xsl:for-each select="//v:shapetype[@id = $id-of-shapetype]
                                  /v:path[@textboxrect]">
                <xsl:if test="position() = last()">
                    <xsl:variable name="x">
                        <xsl:call-template name="primo-valore">
                            <xsl:with-param name="stringa">
                                <xsl:value-of select="@textboxrect" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="y">
                        <xsl:call-template name="secondo-valore">
                            <xsl:with-param name="stringa">
                                <xsl:value-of select="@textboxrect" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:attribute name="x">
                        <xsl:value-of select="$x" /> 
                    </xsl:attribute>
                    <xsl:attribute name="y">
                        <xsl:value-of select="$y + $font-dim" />
                    </xsl:attribute>  
                </xsl:if>
            </xsl:for-each>   
        </xsl:when>
        <!-- se non trovo textboxrect: x = 0, y = dimensione font -->
        <xsl:otherwise>
            <xsl:variable name="x">
                <xsl:text>0</xsl:text>
            </xsl:variable>
            <xsl:variable name="y">
                <xsl:value-of select="$font-dim" />
            </xsl:variable>  
            
            <xsl:attribute name="x">
                <xsl:value-of select="$x" />
            </xsl:attribute>
            <xsl:attribute name="y">
                <xsl:value-of select="$y" />
            </xsl:attribute>            
        </xsl:otherwise>
    </xsl:choose>

    <!-- mi forza la ricerca del contenuto di textbox cercando e 
         gestendo tag html -->    
    <xsl:apply-templates select="v:textbox" mode="html" />
    
</text>
</xsl:template>


<!-- con questi due template faccio in modo che il contenuto di 
     textbox vengo considerato solo dentro il template di 
     gestione di textbox
-->

<xsl:template match="v:textbox">
</xsl:template>


<xsl:template match="v:textbox" mode="html">
    <!-- cerco alcuni elementi html gestendoli in maniera opportuna:
            Tag gestiti: a, i e b
     -->
    <xsl:apply-templates select="html:*" />
</xsl:template>

<xsl:template match="html:*">
<xsl:choose>
<xsl:when test="name() = 'a'">
    <a>
        <xsl:attribute name="xlink:href">
            <xsl:value-of select="@href" />
        </xsl:attribute>
    <tspan>
    <xsl:call-template name="attributi-style" />
    
    <xsl:if test="name() = 'b'">
        <xsl:attribute name="font-weight">
            <xsl:text>bold</xsl:text>
        </xsl:attribute>
    </xsl:if>
    <xsl:if test="name() = 'i'">
        <xsl:attribute name="font-style">
            <xsl:text>italic</xsl:text>
        </xsl:attribute>
    </xsl:if>
    
    <xsl:apply-templates />
    </tspan>
    </a>
</xsl:when>
<xsl:otherwise>

    <tspan>
    <xsl:call-template name="attributi-style" />
    
    <xsl:if test="name() = 'b'">
        <xsl:attribute name="font-weight">
            <xsl:text>bold</xsl:text>
        </xsl:attribute>
    </xsl:if>
    <xsl:if test="name() = 'i'">
        <xsl:attribute name="font-style">
            <xsl:text>italic</xsl:text>
        </xsl:attribute>
    </xsl:if>
    
    <xsl:apply-templates />
    </tspan>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ TEMPLATE CALCOLA FONT ********************************** -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template name="calcola-font">
    <xsl:param name="font" />
    <xsl:param name="aggiustamento"><xsl:text></xsl:text></xsl:param>
    
<!-- restituisce il valore del font scalato in base ai valori di coordsize e width, che 
        sono o passati in input o calcolati
-->
 
<xsl:choose>
    <xsl:when test="$aggiustamento != ''">
        <xsl:value-of select="round($font * $aggiustamento)" />
    </xsl:when>
    <xsl:otherwise>
        <xsl:variable name="scala">
            <xsl:call-template name="calcola-scala" />
        </xsl:variable>
        <xsl:value-of select="round($font * $scala)" />
    </xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ TEMPLATE CALCOLA SCALA ********************************* -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template name="calcola-scala">
    <xsl:param name="valore"><xsl:text>1</xsl:text></xsl:param>
    
<!-- funzione ricorsiva che calcola il valore di coordsize(w) / w per tutti gli
     elementi ancestor a partire dall'elemento corrente.
-->
    
<xsl:choose>
    <xsl:when test="ancestor::v:*">
        <xsl:for-each select="ancestor::v:*">
        <xsl:if test="position() = last()">
        
            <xsl:variable name="id-of-shapetype">
                <xsl:value-of select="substring-after(@type,'#')" />
            </xsl:variable>
            <xsl:variable name="w">
                <xsl:call-template name="valore-whxy">
                    <xsl:with-param name="converti">
                        <xsl:text>real</xsl:text>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="w-size">
                <!-- se l'elemento è shape, bisogna cercare in shapetype!!!! -->
                <xsl:choose>
                    <xsl:when test="@coordsize">
                        <xsl:call-template name="primo-valore">
                            <xsl:with-param name="stringa">
                                <xsl:value-of select="@coordsize" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- se l'elemento è shape, bisogna cercare in shapetype!!!! -->
                    <xsl:when test="(name() = 'v:shape') and (@type) and
                                    (//v:shapetype[@id = $id-of-shapetype][@coordsize]) ">
                            <xsl:for-each select="//v:shapetype[@id = $id-of-shapetype]
                                                  [@coordsize]">
                                <xsl:call-template name="primo-valore">
                                    <xsl:with-param name="stringa">
                                        <xsl:value-of select="@coordsize" />
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="(name() = 'v:shape')">
                        <xsl:text>1000</xsl:text>
                    </xsl:when>
                    <xsl:when test="((ancestor::*[@coordsize]) and (name() != 'v:shape') and 
                                    (name() != 'v:shapetype'))">
                        <xsl:for-each select="ancestor::*[@coordsize]">
                            <xsl:if test="position() = last()">
                                <xsl:call-template name="primo-valore">
                                    <xsl:with-param name="stringa">
                                        <xsl:value-of select="@coordsize" />
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:for-each>    
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>1000</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            
            <xsl:variable name="scala">
                <xsl:choose>
                    <xsl:when test="$w = '0'">
                        <xsl:text>1</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$w-size div $w" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            
            <xsl:call-template name="calcola-scala">
                <xsl:with-param name="valore">          
                    <xsl:value-of select="$valore * $scala" />
                </xsl:with-param>
            </xsl:call-template>      
        </xsl:if>    
        </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
        <xsl:value-of select="$valore" />
    </xsl:otherwise>
</xsl:choose>  
</xsl:template>

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ TEMPLATE CALCOLA COORDSIZE ***************************** -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template name="calcola-coordsize">
    <xsl:param name="attributo"><xsl:text>w</xsl:text></xsl:param>
    
    <!-- calcola il valore di coordsize (primo o secondo valore dipende dall'attributo)
         se non lo trova nell'elemento padre lo cerca nel precedente, se non lo trova
         in nessun elemento restituisce 1000. Se sono nel primo elemento  restituisce 
         SCHEMO-X o SCHERMO-Y
    -->
<xsl:choose>
    <xsl:when test="ancestor::v:*">
        <xsl:for-each select="ancestor::v:*">
        <xsl:if test="position() = last()">
        
            <xsl:variable name="id-of-shapetype">
                <xsl:value-of select="substring-after(@type,'#')" />
            </xsl:variable>
                <!-- se l'elemento è shape, bisogna cercare in shapetype!!!! -->
                <xsl:choose>
                    <xsl:when test="@coordsize">
                        <xsl:choose>
                        <xsl:when test="$attributo = 'w'">
                            <xsl:call-template name="primo-valore">
                                <xsl:with-param name="stringa">
                                    <xsl:value-of select="@coordsize" />
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="secondo-valore">
                                <xsl:with-param name="stringa">
                                    <xsl:value-of select="@coordsize" />
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <!-- se l'elemento è shape, bisogna cercare in shapetype!!!! -->
                    <xsl:when test="(name() = 'v:shape') and (@type) and
                                    (//v:shapetype[@id = $id-of-shapetype][@coordsize]) ">
                            <xsl:for-each select="//v:shapetype[@id = $id-of-shapetype]
                                                  [@coordsize]">
                                <xsl:choose>
                                <xsl:when test="$attributo = 'w'">
                                    <xsl:call-template name="primo-valore">
                                        <xsl:with-param name="stringa">
                                            <xsl:value-of select="@coordsize" />
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:call-template name="secondo-valore">
                                        <xsl:with-param name="stringa">
                                            <xsl:value-of select="@coordsize" />
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="(name() = 'v:shape')">
                        <xsl:text>1000</xsl:text>
                    </xsl:when>
                    <xsl:when test="((ancestor::*[@coordsize]) and (name() != 'v:shape') and 
                                    (name() != 'v:shapetype'))">
                        <xsl:for-each select="ancestor::*[@coordsize]">
                            <xsl:if test="position() = last()">
                                <xsl:choose>
                                <xsl:when test="$attributo = 'w'">
                                    <xsl:call-template name="primo-valore">
                                        <xsl:with-param name="stringa">
                                            <xsl:value-of select="@coordsize" />
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:call-template name="secondo-valore">
                                        <xsl:with-param name="stringa">
                                            <xsl:value-of select="@coordsize" />
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                        </xsl:for-each>    
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>1000</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                
        </xsl:if>    
        </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
        <xsl:choose>
            <xsl:when test="$attributo = 'w'">
                <xsl:value-of select="$schermo-x" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$schermo-y" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:otherwise>
</xsl:choose>  
</xsl:template>

<!-- ******************************************************************************** -->
<!-- ***************** TEMPLATE: aggiungi-spazi ************************************* -->
<!-- ******************************************************************************** -->
<xsl:template name="aggiungi-spazi">
    <xsl:param name="stringa" />
    
    <!-- rimpiazza gli spazi iniziali e finali con &#160; -->
    
    <!-- richiama due funzioni: spazi-iniziali e spazi-finali -->
    
    <xsl:variable name="stringa-iniziale">
            <xsl:choose>
                <xsl:when test="starts-with($stringa,' ')">     
                    <xsl:call-template name="spazi-iniziali">
                        <xsl:with-param name="stringa">
                            <xsl:value-of select="$stringa" />
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$stringa" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:choose>
        <xsl:when test="substring($stringa-iniziale,
                                  string-length($stringa-iniziale),1) = ' '">     
            <xsl:call-template name="spazi-finali">
                <xsl:with-param name="stringa">
                    <xsl:value-of select="$stringa-iniziale" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$stringa-iniziale" />
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- ******************************************************************************** -->
<!-- ***************** TEMPLATE: spazi-iniziali ************************************* -->
<!-- ******************************************************************************** -->
<xsl:template name="spazi-iniziali">
    <xsl:param name="stringa" />
    <!-- sostituisce tutti gli spazi iniziali della stringa con 2 caratteri &#160; -->
    <!-- ricorsiva -->
    <xsl:choose>
        <xsl:when test="$stringa = ''">
            <xsl:value-of select="$stringa" />
        </xsl:when>
        <xsl:when test="starts-with($stringa,' ')">
            <xsl:call-template name="spazi-iniziali">
                <xsl:with-param name="stringa">
                    <xsl:value-of select="concat('&#160;&#160;',
                                          substring-after($stringa,' '))" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$stringa" />
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- ******************************************************************************** -->
<!-- ***************** TEMPLATE: spazi-finali *************************************** -->
<!-- ******************************************************************************** -->
<xsl:template name="spazi-finali">
    <xsl:param name="stringa" />
    <!-- sostituisce tutti gli spazi finali della stringa con 2 caratteri &#160; -->
    <!-- ricorsiva -->
    <xsl:choose>
        <xsl:when test="$stringa = ''">
            <xsl:value-of select="$stringa" />
        </xsl:when>
        <xsl:when test="substring($stringa,string-length($stringa),1) = ' '">   
            <xsl:call-template name="spazi-finali">
                <xsl:with-param name="stringa">
                    <xsl:value-of select="concat(substring(
                                          $stringa,1,string-length($stringa) - 1),
                                          '&#160;&#160;')" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$stringa" />
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- ******************************************************************************** -->
<!-- ***************** TEMPLATE: gestione href ************************************** -->
<!-- ******************************************************************************** -->
<xsl:template name="gestione-href">
    <xsl:param name="nome-template"><xsl:text>vml-rect</xsl:text></xsl:param>
    
<!-- cerca il parametro href, se lo trova crea un elemento a con il relativo link e gli 
    inserisce all'interno l'elemento opportuno in base a nome template.
    Comunque, in base all'elemento chiamante chiamerà il template opportuno per gestirne
    il contenuto.
    Si ricorda che per assegnare un link ad un dato elemento, prima si crea l'elemento
        a, che permette di associare un riferimento esterno, poi al suo interno si 
        inserisce l'elemento.
-->

<!-- contiene il valore di un eventuale attributo href (altrimenti: stringa vuota) -->
<xsl:variable name="href">
    <xsl:choose>
        <xsl:when test="name() = 'v:shape'">
            <xsl:variable name="id-of-shapetype">
                <xsl:value-of select="substring-after(@type,'#')" />
            </xsl:variable>
            
            <xsl:choose>
                <xsl:when test="@href">
                    <xsl:value-of select="@href" />
                </xsl:when>
                <xsl:when test="//v:shapetype[(@id = $id-of-shapetype) and (@href)]">
                    <xsl:for-each select="//v:shapetype[(@id = $id-of-shapetype) 
                                         and (@href)]">
                        <xsl:if test="position() = last()">
                            <xsl:value-of select="@href" />
                        </xsl:if>
                    </xsl:for-each>
                </xsl:when>        
                <xsl:otherwise>
                    <xsl:text></xsl:text>
                </xsl:otherwise>                    
            </xsl:choose>
        </xsl:when>    
        <xsl:when test="@href">
            <xsl:value-of select="@href" />
        </xsl:when>
        <xsl:otherwise>
            <xsl:text></xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:variable>

<!-- se è presente un riferimento esterno, creo l'elemento a e chiamo
     l'opportuno template per gestire l'elemento. Altrimenti chiamo il
     template senza creare l'elemento a.
-->
<xsl:choose>
    <xsl:when test="$href != ''">
        <a>
            <xsl:attribute name="xlink:href">            
                <xsl:value-of select="$href" />
            </xsl:attribute>
            
            <xsl:choose>
                <xsl:when test="$nome-template = 'vml-rect'">
                    <xsl:call-template name="vml-rect" />
                </xsl:when>
                <xsl:when test="$nome-template = 'vml-roundrect'">
                    <xsl:call-template name="vml-roundrect" />
                </xsl:when>
                <xsl:when test="$nome-template = 'vml-line'">
                    <xsl:call-template name="vml-line" />
                </xsl:when>
                <xsl:when test="$nome-template = 'vml-polyline'">
                    <xsl:call-template name="vml-polyline" />
                </xsl:when>
                <xsl:when test="$nome-template = 'vml-curve'">
                    <xsl:call-template name="vml-curve" />
                </xsl:when>
                <xsl:when test="$nome-template = 'vml-oval'">
                    <xsl:call-template name="vml-oval" />
                </xsl:when>
                <xsl:when test="$nome-template = 'vml-arc'">
                    <xsl:call-template name="vml-arc" />
                </xsl:when>
                <xsl:when test="$nome-template = 'vml-image'">
                    <xsl:call-template name="vml-image" />
                </xsl:when>
                <xsl:when test="$nome-template = 'vml-shape'">
                    <xsl:call-template name="vml-shape" />
                </xsl:when>
            </xsl:choose>                        
       </a>     
    </xsl:when>
    <xsl:otherwise>
            <xsl:choose>
                <xsl:when test="$nome-template = 'vml-rect'">
                    <xsl:call-template name="vml-rect" />
                </xsl:when>
                <xsl:when test="$nome-template = 'vml-roundrect'">
                    <xsl:call-template name="vml-roundrect" />
                </xsl:when>
                <xsl:when test="$nome-template = 'vml-line'">
                    <xsl:call-template name="vml-line" />
                </xsl:when>
                <xsl:when test="$nome-template = 'vml-polyline'">
                    <xsl:call-template name="vml-polyline" />
                </xsl:when>
                <xsl:when test="$nome-template = 'vml-curve'">
                    <xsl:call-template name="vml-curve" />
                </xsl:when>
                <xsl:when test="$nome-template = 'vml-oval'">
                    <xsl:call-template name="vml-oval" />
                </xsl:when>
                <xsl:when test="$nome-template = 'vml-arc'">
                    <xsl:call-template name="vml-arc" />
                </xsl:when>
                <xsl:when test="$nome-template = 'vml-image'">
                    <xsl:call-template name="vml-image" />
                </xsl:when>
                <xsl:when test="$nome-template = 'vml-shape'">
                    <xsl:call-template name="vml-shape" />
                </xsl:when>
            </xsl:choose>
    </xsl:otherwise>
</xsl:choose>




</xsl:template>

</xsl:stylesheet>
