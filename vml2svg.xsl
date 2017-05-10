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
        - vml-shape
    * match:
        - /
        - v:group
        - v:shape
-->

<!-- XXXXXXXXXXXXXXXX VARIABILI GLOBALI XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->
<xsl:variable name="n-elementi">
    <xsl:value-of select="count(//*)" />
</xsl:variable>

<!-- Queste variabili rappresentano una dimensione "standard" in pixel della parte di
     schermo usabile per rappresentare l'immagine (escludendo la porzione occupata dalla
     barra dei browser), per schermi di 17 pollici, con risoluzione 800x600.
     Si usano come approssimazione quando un immagine non specifica la
     sua dimensioni oppure è espressa tramite percentuale.
-->
<xsl:variable name="schermo-x">
    <xsl:text>750</xsl:text>
</xsl:variable>

<xsl:variable name="schermo-y">
    <xsl:text>400</xsl:text>
</xsl:variable>
<!-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->

<!-- ********************************************************************************* -->
<!-- ********************************* RADICE **************************************** -->
<!-- ********************************************************************************* -->
<xsl:template match="/">

<!-- creo un elemento svg contenitore, che non influenza nessun altra misura, serve solo
     da contenitore, in quanto svg ha bisogno di un elemento radice.
     Inoltre questo elemento conterrà un elemento defs con tutti i riferimenti contenuti
     nel documento.
-->

<svg preserveAspectRatio="none" 
     overflow="visible">
  
<!-- NB: da aggiungere un choose per vml non contenuti in un documento html -->

<xsl:for-each select="//html:BODY | //html:body">

    <!-- gestione di defs -->
    <defs>
        <xsl:call-template name="gestione-textpath" />        
        <xsl:call-template name="gestione-gradient" />
        <xsl:call-template name="gestione-pattern" />
    </defs>
    
    <xsl:apply-templates />
    
</xsl:for-each>
</svg>
</xsl:template>

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ ELEMENTO GROUP ***************************************** -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template match="v:group">

<!-- per ogni gruppo trovaro creo un elemento svg -->
<svg>
    <xsl:call-template name="core-attrs" />
    <xsl:call-template name="attributo-viewbox" />
        <!-- svg di default fa clipping, vml non lo fa, quindi devo impostare un attributo
             per segnalare di far vedere il contenuto fuori dai margini
        -->
    <xsl:attribute name="overflow"><xsl:text>visible</xsl:text></xsl:attribute>
    <xsl:call-template name="attributo-title" />

<!-- controllo un eventuale presenza di rotazioni -->
<xsl:variable name="r">
    <xsl:call-template name="attributo-rotation" />
</xsl:variable>
    
    <xsl:variable name="v-coordsize">
        <xsl:call-template name="valore-coordsize" />
    </xsl:variable>
    <xsl:variable name="vb_x"> 
        <xsl:value-of select="substring-before(normalize-space($v-coordsize),' ')" />
    </xsl:variable>
    <xsl:variable name="vb_y"> 
        <xsl:value-of select="substring-after(normalize-space($v-coordsize),' ')" />
    </xsl:variable>

    <xsl:choose>
        <!-- se ho una rotazione nell'elemento group, creo un gruppo per gestire
             questa rotazione, posizionandomi nel centro della figura, perchè
             svg e vml gestiscono in modo diverso le rotazioni: il primo 
             rispetto al punto in alto a sinistra (salvo diversa disposizione)
             e l'altro rispetto al centro.
        -->
        <xsl:when test="$r != '0'">
            <g>
                <xsl:attribute name="transform">
                    <xsl:text>rotate(</xsl:text>
                    <xsl:value-of select="$r" />
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="($vb_x div 2)" />
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="($vb_y div 2)" />
                    <xsl:text>)</xsl:text>
                </xsl:attribute>
                
                <xsl:apply-templates />
            </g>
        </xsl:when>
        <xsl:otherwise>
            <xsl:apply-templates />
        </xsl:otherwise>
    </xsl:choose>
</svg>

</xsl:template>

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ ELEMENTO SHAPE ***************************************** -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template match="v:shape">

<!-- per ogni elemento shape creo un elemento svg, impostando opportunamente gli attributi
     e gestendo/creando gli altri elementi per rappresentare eventuali path, testi o 
     immagini esterno (in quanto questi elementi sono esclusivamente contenuti in shape).
     Vengono gestiti inoltre eventuali riferimenti a shapetype, considerando gli 
        attributi sia di quest'elemento shape, sia dei shapetype riferiti, poi si
        impostano i valori dando precedenza agli attributi di shape, poi vengono quelli di
        shapetype, altrimenti si usano i valori di default o quelli ereditati
-->

<!-- cerco un eventuale riferimento a un elemento shapetype -->
<xsl:variable name="id-of-shapetype">
    <xsl:value-of select="substring-after(@type,'#')" />
</xsl:variable>

<!-- cerco un eventuale riferimento ad un immagine, contenuto o in questo elemento
     shape o in elementi shapetype riferiti
-->
<xsl:variable name="image_present">
    <xsl:choose>
        <xsl:when test="(//v:shapetype[@id = $id-of-shapetype]/v:imagedata) 
                        or (v:imagedata)" ><xsl:text>yes</xsl:text></xsl:when>
        <xsl:otherwise><xsl:text></xsl:text></xsl:otherwise>
    </xsl:choose>
</xsl:variable>

<!-- contiene yes o stringa vuota a seconda che debba o meno effettuare un riempimento:
      la scelta è dovuta alla presenza di un immagine o all'impostazione di un attributo
      per segnalare di non effettuare il riempiemento (fillok dell'elemento path)
-->
<xsl:variable name="no-fill">
   <xsl:choose>
        <xsl:when test="$image_present = 'yes'">
            <xsl:text>yes</xsl:text>
        </xsl:when>
        <xsl:when test="v:path[@fillok = 'true']">
            <xsl:text></xsl:text>
        </xsl:when>
        <xsl:when test="v:path[@fillok = 'false']">
            <xsl:text>yes</xsl:text>
        </xsl:when>
        <xsl:when test="(//v:shapetype[@id = $id-of-shapetype]/v:path[@fillok = 'true'])">
            <xsl:text></xsl:text>
        </xsl:when>  
        <xsl:when test="(//v:shapetype[@id = $id-of-shapetype]/v:path[@fillok = 'false'])">
            <xsl:text>yes</xsl:text>
        </xsl:when>         
        <xsl:otherwise>
            <xsl:text></xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:variable>

<!-- segnala se devo disegnare i bordi, determinato dal valore dell'attributo strokeok, presente
     in elementi path, figli di shape o di shapetype riferiti
-->
<xsl:variable name="no-stroke">
   <xsl:choose>
        <xsl:when test="v:path[@strokeok = 'true']">
            <xsl:text></xsl:text>
        </xsl:when>
        <xsl:when test="v:path[@strokeok = 'false']">
            <xsl:text>yes</xsl:text>
        </xsl:when>
        <xsl:when test="(//v:shapetype[@id = $id-of-shapetype]/v:path[@strokeok = 'true'])">
            <xsl:text></xsl:text>
        </xsl:when>  
        <xsl:when test="(//v:shapetype[@id = $id-of-shapetype]/v:path[@strokeok = 'false'])">
            <xsl:text>yes</xsl:text>
        </xsl:when>         
        <xsl:otherwise>
            <xsl:text></xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:variable>

        <!-- creo l'elemento svg -->
        <svg>
            <xsl:call-template name="core-attrs" />
            
            <!-- imposto coordsize (viewbox di svg):
                    prima lo cerco nell'elemento shape e se c'è lo imposto,
                    poi lo cerco in shapetype ed eventualmente lo imposto,
                    altrimenti cerco negli elementi ancestor 
             -->
            <xsl:choose>
                <xsl:when test="@coordsize">
                    <xsl:call-template name="attributo-viewbox" />
                </xsl:when>
                <xsl:when test="//v:shapetype[@id = $id-of-shapetype]">
                    <xsl:for-each select="//v:shapetype[@id = $id-of-shapetype]">
                        <xsl:call-template name="attributo-viewbox" />
                    </xsl:for-each>   
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="attributo-viewbox" />
                </xsl:otherwise>
            </xsl:choose>
            
            <!-- imposto le proprietà di fill e stroke:
                    - prima le cerco in eventuali shapetype e imposto gli 
                        attributi;
                    - poi le cerco in shape, creando gli attributi che 
                        sovrascriveranno quelli impostati in precedenza e 
                        specifico (parametro default = no) che nel caso non
                        vengano trovate le proprietà non si devono impostare
                        i valori di default, altrimenti questi sovrascriverebbero
                        i valori impostati con shapetype (da notare che se una 
                        proprietà non è presente ne in shape che in shapetype, 
                        quando cerco i valori in st, non trovandoli vengono 
                        impostati con i valori di default e la successiva
                        ricerca in shape li lascerà inalterati.
            -->
            <xsl:choose>
                <xsl:when test="//v:shapetype[@id = $id-of-shapetype]">
                    <xsl:for-each select="//v:shapetype[@id = $id-of-shapetype]">
                        <xsl:call-template name="attributi-paint">
                            <xsl:with-param name="no-fill">
                                <xsl:value-of select="$image_present" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:for-each>
                    <xsl:call-template name="attributi-paint">
                        <xsl:with-param name="default">
                            <xsl:text>no</xsl:text>
                        </xsl:with-param>
                        <xsl:with-param name="no-fill">
                            <xsl:value-of select="$no-fill" />
                        </xsl:with-param>   
                        <xsl:with-param name="no-stroke">
                            <xsl:value-of select="$no-stroke" />
                        </xsl:with-param>                      
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="attributi-paint">
                        <xsl:with-param name="no-fill">
                            <xsl:value-of select="$no-fill" />
                        </xsl:with-param>
                        <xsl:with-param name="no-stroke">
                            <xsl:value-of select="$no-stroke" />
                        </xsl:with-param>    
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
            
            <!-- vml non presenta questa proprietà, tuttavia il comportamento
                 di vml equivale in svg alla proprietà impostata con evenodd,
                 mentre svg per default ha questa proprietà impostata a nonzero
            -->
            <xsl:attribute name="fill-rule">
                <xsl:text>evenodd</xsl:text>
            </xsl:attribute>
            
            <xsl:call-template name="attributo-title" />
            
            
            <xsl:variable name="r">
                <xsl:call-template name="attributo-rotation" />
            </xsl:variable>
            
            <!-- gestisco il contenuto di shape, controllando l'eventuale 
                 presenza di rotazioni (in caso affermativo creo un
                 gruppo con trasform, posizionandolo opportunamente), poi
                 cerco eventuali link associati alla figura, tramite il template
                 gestione-href, il quale in caso di link, creerà un elemento a e
                 chiamarà un template per gestire il contenuto di shape (vml-shape).
                 In caso non siano presenti link verrà chiamato ugualmente il 
                 template vml-shape (senza creare l'elemento a).
            -->
            <xsl:choose>
                <xsl:when test="$r != '0'">
                    <g>
                        <!-- devo calcolare questi valori per spostare l'asse 
                             di rotazione: dall'angolo in alto a sx (comportamento
                             di default di svg) al centro della regione.
                        -->
                        <xsl:variable name="cs-w">
                            <xsl:call-template name="valore-coordsize">
                                <xsl:with-param name="parametro"><xsl:text>w</xsl:text>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="cs-h">
                            <xsl:call-template name="valore-coordsize">
                                <xsl:with-param name="parametro"><xsl:text>h</xsl:text>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>

                        <xsl:attribute name="transform">
                            <xsl:text>rotate(</xsl:text>
                            <xsl:value-of select="$r" />
                            <xsl:text>, </xsl:text>
                            <xsl:value-of select="($cs-w div 2)" /> <!-- $x + .. -->
                            <xsl:text>, </xsl:text>
                            <xsl:value-of select="($cs-h div 2)" />
                            <xsl:text>)</xsl:text>
                        </xsl:attribute>
            
                        <xsl:call-template name="gestione-href">
                            <xsl:with-param name="nome-template">
                                <xsl:text>vml-shape</xsl:text>   
                            </xsl:with-param>
                        </xsl:call-template>        
                    </g>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="gestione-href">
                        <xsl:with-param name="nome-template">
                            <xsl:text>vml-shape</xsl:text>   
                        </xsl:with-param>
                    </xsl:call-template>  
                </xsl:otherwise>
            </xsl:choose>     
            
        </svg>
</xsl:template>

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ***************************** VML SHAPE ***************************************** -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template name="vml-shape">

<xsl:variable name="id-of-shapetype">
    <xsl:value-of select="substring-after(@type,'#')" />
</xsl:variable>

<!-- valore di coordsize(w) / w di tutti gli elementi ancestor: rappresenta la dimensione
      di un user unit.
-->
<xsl:variable name="aggiustamento">
    <xsl:for-each select="v:*">
        <xsl:if test="position() = last()">
            <xsl:call-template name="calcola-scala" />
        </xsl:if>
    </xsl:for-each>
</xsl:variable>
           
            <!-- XXXXXXXXXXXXXX GESTIONE IMAGEDATA XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->
            <xsl:for-each select="//v:shapetype[@id = $id-of-shapetype]/v:imagedata">
                <xsl:call-template name="elemento-imagedata" />
            </xsl:for-each>
            <xsl:for-each select="v:imagedata">
                <xsl:call-template name="elemento-imagedata" />
            </xsl:for-each>
            
            <!-- XXXXXXXXXXXXXX GESTIONE PATH - TEXTPATH XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->
            <xsl:choose>
                <!-- devo rappresentare textpath -->
                <xsl:when test="((v:path[@textpathok = 'true' or @textpathok = 't']) or
                                (//v:shapetype[@id = $id-of-shapetype]/v:path
                                [@textpathok = 'true' or @textpathok = 't'])) and 
                                ((v:textpath) or 
                                (//v:shapetype[@id = $id-of-shapetype]/v:textpath))">
                    <xsl:choose>
                        <xsl:when test="v:textpath[@string]">
                            <xsl:for-each select="v:textpath[@string]">
                                <xsl:if test="position() = last()">
                                    <xsl:call-template name="elemento-textpath" />
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="v:textpath">
                            <xsl:variable name="stringa-st">
                                <xsl:for-each select="
                                        //v:shapetype[@id = $id-of-shapetype]/
                                        v:textpath[@string]">
                                    <xsl:if test="position() = last()">
                                        <xsl:value-of select="@string" />             
                                    </xsl:if>
                                </xsl:for-each>
                                
                            </xsl:variable>
                            
                            <xsl:for-each select="v:textpath">
                                <xsl:if test="position() = last()">
                                    <xsl:call-template name="elemento-textpath" >
                                        <xsl:with-param name="stringa">
                                            <xsl:value-of select="$stringa-st" />
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:for-each>

                        </xsl:when>
                        <xsl:when test="//v:shapetype[@id = $id-of-shapetype]/v:textpath">
                            <xsl:variable name="path-id">
                                <xsl:choose>
                                    <xsl:when test="v:path[@v != ''] or @path != ''">
                                        <xsl:value-of select="count(preceding::v:*) + 
                                                              count(ancestor::v:*)" />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text></xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            
                            <xsl:for-each select="
                                    //v:shapetype[@id = $id-of-shapetype]/v:textpath">
                                <xsl:if test="position() = last()">
                                    <xsl:choose>
                                        <xsl:when test="$path-id = ''">
                                            <xsl:call-template name="elemento-textpath">
                                                <xsl:with-param name="aggiustamento">
                                                    <xsl:value-of select="$aggiustamento" />
                                                </xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:call-template name="elemento-textpath" >
                                                <xsl:with-param name="path-id">
                                                    <xsl:value-of select="$path-id" />
                                                </xsl:with-param>
                                                <xsl:with-param name="aggiustamento">
                                                    <xsl:value-of select="$aggiustamento" />
                                                </xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise><!-- in teoria qui non dovrebbe andarci mai -->
                            <XXX></XXX>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <!-- devo rappresentare path -->
                
                <xsl:when test="v:path[@v != '']">
                    <xsl:for-each select="v:path[@v != '']">
                        <xsl:if test="position() = last()">
                            <xsl:call-template name="gestione-path" />
                        </xsl:if>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="@path != ''">
                    <xsl:call-template name="elemento-path">
                        <xsl:with-param name="v">
                            <xsl:value-of select="@path" />
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="//v:shapetype[@id = $id-of-shapetype]">
                        <xsl:choose>
                            <xsl:when test="v:path[@v != '']">
                                <xsl:for-each select="v:path[@v != '']">
                                    <xsl:if test="position() = last()">
                                        <xsl:call-template name="gestione-path" />
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="@path != ''">
                                <xsl:call-template name="elemento-path">
                                    <xsl:with-param name="v">
                                        <xsl:value-of select="@path" />
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
            
            <!-- XXXXXXXXXXXXXXXXXXX GESTIONE TEXTBOX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -->
            <xsl:if test="(v:textbox)">
               <xsl:call-template name="elemento-textbox"> 
                    <xsl:with-param name="id-of-shapetype">
                        <xsl:value-of select="$id-of-shapetype" />
                    </xsl:with-param>
                    <xsl:with-param name="aggiustamento">
                        <xsl:value-of select="$aggiustamento" />
                    </xsl:with-param>
               </xsl:call-template>
            </xsl:if>
            
            <xsl:apply-templates />
</xsl:template>

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ ELEMENTO SHAPETYPE ************************************* -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template name="elemento-shapetype">
<!-- shapetype viene gestito quando e' richiamato da shape -->
</xsl:template>

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ TEMPLATE GESTIONE-SHAPETYPE **************************** -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template name="gestione-shapetype">
<!-- shapetype viene gestito quando e' richiamato da shape -->
</xsl:template>

<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<!-- ************************ ELEMENTO A ***************************************** -->
<!-- ********************************************************************************* -->
<!-- ********************************************************************************* -->
<xsl:template match="html:a">
<xsl:choose>
    <xsl:when test="@href">
        <a>
            <xsl:attribute name="xlink:href">
                <xsl:value-of select="@href" />
            </xsl:attribute>
            <xsl:apply-templates />
        </a>
    </xsl:when>
    <xsl:otherwise>
        <xsl:apply-templates />
    </xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:include href="XSL/varie.xsl" />
<xsl:include href="XSL/predef.xsl" />
<xsl:include href="XSL/gradient-pattern.xsl" />
<xsl:include href="XSL/attributi.xsl" />
<xsl:include href="XSL/path.xsl" />
    
</xsl:stylesheet>
