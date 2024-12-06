<%@ page language="java"
  errorPage="ErreurFatale.jsp"
  isErrorPage = "false"
  session = "true"
  import="java.util.Enumeration, java.util.Locale, java.text.DateFormat,
           java.util.Calendar,
           java.util.GregorianCalendar,
           com.caindosuez.dsi.common.hashtable.Hashtable,
           com.caindosuez.dsi.common.service.ApplicationConfig,
           com.caindosuez.dsi.common.dictionary.HostDictionary,
           com.caindosuez.dsi.common.dictionary.Repository,
           com.caindosuez.dsi.common.service.JspFormat,
           com.caindosuez.dsi.common.service.Message,
           com.caindosuez.dsi.common.service.UserConfig,
           com.caindosuez.dsi.common.service.NavigationManager,     
           com.cai.acint.spirit.testconnector.*,
           com.cai.acint.classes.*"         
%>


<% String Page = "Evolution" ;%>
<% String leChar = null ;%>
<% int nbDeFrais = 7;%>

<%  ST0FAH JS0FAH = (ST0FAH) request.getSession().getAttribute("ST0FAH"); %>
<%  ST0FJK JS0FJK = (ST0FJK) request.getSession().getAttribute("ST0FJK"); %>
<% 	ST0FSU JS0FSU = (ST0FSU) request.getSession().getAttribute("ST0FSU"); %>
<%  ST0FSS JS0FSS = (ST0FSS) session.getAttribute("ST0FSS"); %>
<%	int periode = Integer.parseInt(JS0FSS.getCH1LGO().trim()); %>
<%	System.out.println("Priodicit = "+periode); %>

<html>
<head>
    <title>Evolution</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <link rel="stylesheet" type="text/css" href="FeuilleStyle/FeuilleDeStyle.css">

    <script language="JavaScript1.2" TYPE="text/JavaScript" src="JavaScript/FonctionJavaScript.js"></SCRIPT>
    <script language="JavaScript1.2" TYPE="text/JavaScript" src="JavaScript/JSEvolution.js"></SCRIPT>
    <script language="JavaScript1.2" TYPE="text/JavaScript" src="JavaScript/formulaire.js"></SCRIPT>
    <script language="JavaScript1.2" TYPE="text/JavaScript" src="JavaScript/windowName.js"></SCRIPT>
    <script language="javascript1.2" type="text/javascript" src="JavaScript/init.js"></script>

</head>

<body <% if (!JS0FAH.getCH1LK8().trim().equals("ADMIN")) {%>onMouseDown="Javascript:Copyright()"<% } %> onload="javascript:j = new Date();horloge = setTimeout('afficheHorloge(' + j.getTime() + ')',5000);seconde = setTimeout('document.deconnexion.submit()',<% if (!(JS0FAH.getCH1LK8().trim().equals("ADMIN") || JS0FAH.getCH1LK8().trim().equals("TUTEUR") || JS0FAH.getCH1LK8().trim().equals("F-CENTRAL") || JS0FAH.getCH1LK8().trim().equals("CMP-RESP") || JS0FAH.getCH1LK8().trim().equals("CMPRESPVAL"))) {%>600000<%} else {%>1000000<%}%>);prelimFormulaire()">

<%@ include file="Mask.jsp" %>



<!-- HISTORIQUE -->
<div id="Historique" class="Historique"> 
 <table border="0" width="98%">
   <tr>
     <td align="right">
        <a href="JavaScript:submitFormCN(document.Evolution,'Accueil2')"><span id="Font1" class="Font1">Accueil</span></a>
        <span id="Font1" class="Font1">/</span>
        <a href="JavaScript:submitFormCN(document.Evolution,'CondArretes')"><span id="Font1" class="Font1">Conditions d'arrts</span></a>
     </td>
   </tr>
</table>
</div>



<!-- TITRE DE LA PAGE D'Evolution -->
<div id="Titre" class="Titre"> 
   <img src="Images/TitreEvolution.gif">
</div>



<!-- FORMULAIRE -->
<div id="form1" class="form1">
    <form name="Evolution"  method="post" action="app">

        <%@ include file="WindowName.jsp" %>

        <input type="hidden" name="CH1LHE" value="<%=request.getParameter("CH1LHE")%>">

        <input type="hidden" name="CN">
        <input type="hidden" name="CH1LGN" value="<%=JS0FAH.getCH1LGN()%>">
        <input type="hidden" name="AIGUILLEUR">
        <input type="hidden" name="Erreur" value="OK">
        <input type="hidden" name="Page" value="<%=Page%>">
        <input type="hidden" name="CH1LK8" value="<%=JS0FAH.getCH1LK8().trim()%>">
        <input type="hidden" name="HistoPage" value="<%=request.getParameter("HistoPage")%>">


        <%@ include file="Bandeau.jsp" %>
    </form>
</div>


<%@ include file="map.jsp" %>

<!-- Srie d'onglet -->
<div id="onglet" class="onglet">
  <img src="Images/onglet<%if (request.getParameter("Page").equals("OngDecompte")) { %>2<%} if (request.getParameter("Page").equals("OngTaux")) { %>3<% } if (request.getParameter("Page").equals("OngCMCCPFD")) { %>4<% } if (request.getParameter("Page").equals("OngFrais")) { %>5<%}%>.gif" usemap="#synthese" border=0 /> 
</div>



<div id="TableOnglet" class="TableOnglet">
  <table border="2" width="100%"  bgcolor="#FDFECD">
    <tr><td>
    <form name="EvolutionValide"  method="post" action="app">
        
        <%@ include file="WindowName.jsp" %>

        <input type="hidden" name="CN">
        <input type="hidden" name="CH1LGN" value="<%=JS0FAH.getCH1LGN()%>">
        <input type="hidden" name="AIGUILLEUR" >
        <input type="hidden" name="Erreur" value="OK">
        <input type="hidden" name="Page" value="<%=Page%>">
        <input type="hidden" name="CH1LK8" value="<%=JS0FAH.getCH1LK8().trim()%>">
        <input type="hidden" name="HistoPage" value="<%=request.getParameter("HistoPage")%>">
 
        <input type="hidden" name="Debut" value="<%=request.getParameter("CH1LGK")%>">
        <input type="hidden" name="DebutJJ" value="<%=request.getParameter("CH1LGK").substring(0,2)%>">
        <input type="hidden" name="DebutMM" value="<%=request.getParameter("CH1LGK").substring(3,5)%>">
        <input type="hidden" name="DebutAAAA" value="<%=request.getParameter("CH1LGK").substring(6,10)%>">
        <input type="hidden" name="Fin" value="<%=request.getParameter("CH1LGL")%>">
        <input type="hidden" name="FinJJ" value="<%=request.getParameter("CH1LGL").substring(0,2)%>">
        <input type="hidden" name="FinMM" value="<%=request.getParameter("CH1LGL").substring(3,5)%>">
        <input type="hidden" name="FinAAAA" value="<%=request.getParameter("CH1LGL").substring(6,10)%>">


    <!-- Donnes pour l'volution -->
        <input type="hidden" name="CH1LHE" value="<%=request.getParameter("CH1LHE")%>">
        <input type="hidden" name="CH1NLL">
        <input type="hidden" name="CH1NLK" value="<%=request.getParameter("Page")%>">

        <input type="hidden" name="BandeauCH1M4U" value="<%=request.getParameter("BandeauCH1M4U")%>">

        <input type="hidden" name="DateDebPeriode">
        <input type="hidden" name="DateFinPeriode" value="<%=request.getParameter("DateFinPeriode")%>">
        
        <input type="hidden" name="DateInit1" value="<%=request.getParameter("DateDebPeriode")%>">
        <input type="hidden" name="DateInit2" value="<%=request.getParameter("DateFinPeriode")%>">


<% if (request.getParameter("Page").equals("OngDecompte")) { %>
<!-- Donnes Modifiables -->
    <input type="hidden" name="CH1LGK">
	<input type="hidden" name="CH1LGL" value="<%=request.getParameter("CH1LGL")%>">
	<input type="hidden" name="CH1LGM" value="<%=request.getParameter("CH1LGM")%>">
	<input type="hidden" name="CH1LGO" value="<%=request.getParameter("CH1LGO")%>">
	<input type="hidden" name="CH1LGP" value="<%=request.getParameter("CH1LGP")%>">
	<input type="hidden" name="CH1LGQ" value="<%=request.getParameter("CH1LGQ")%>">
	<input type="hidden" name="CH1LGR" value="<%=request.getParameter("CH1LGR")%>">
	<input type="hidden" name="CH1LGS" value="<%=request.getParameter("CH1LGS")%>">
	<input type="hidden" name="CH1LGT" value="<%=request.getParameter("CH1LGT")%>">
	<input type="hidden" name="CH1LGU" value="<%=request.getParameter("CH1LGU")%>">
	<input type="hidden" name="CH1LGV" value="<%=request.getParameter("CH1LGV")%>">
	<input type="hidden" name="CH1LHI" value="<%=request.getParameter("CH1LHI")%>">
	<input type="hidden" name="CH1LHK" value="<%=request.getParameter("CH1LHK")%>">
	<input type="hidden" name="CH1LHL" value="<%=request.getParameter("CH1LHL")%>">
	<input type="hidden" name="CH1LOF" value="<%=request.getParameter("CH1LOF")%>">
	<input type="hidden" name="CH1M5X" value="<%=request.getParameter("CH1M5X")%>">
	<input type="hidden" name="CH246A" value="<%=request.getParameter("CH246A")%>">
<% } %>

<% if (request.getParameter("Page").equals("OngTaux")) { %>
<!-- Donnes Modifiables -->
        <input type="hidden" name="CH1LGK">
        <input type="hidden" name="CH1LGL" value="<%=request.getParameter("CH1LGL")%>">
        <input type="hidden" name="ClientTD" value="<%=request.getParameter("ClientTD")%>">
        <input type="hidden" name="ClientMD" value="<%=request.getParameter("ClientMD")%>">
        <input type="hidden" name="ClientTC" value="<%=request.getParameter("ClientTC")%>">
        <input type="hidden" name="ClientMC" value="<%=request.getParameter("ClientMC")%>">
        <input type="hidden" name="RefiTD" value="<%=request.getParameter("RefiTD")%>">
        <input type="hidden" name="RefiMD" value="<%=request.getParameter("RefiMD")%>">
        <input type="hidden" name="RefiTC" value="<%=request.getParameter("RefiTC")%>">
        <input type="hidden" name="RefiMC" value="<%=request.getParameter("RefiMC")%>">
<% } %>

<% if (request.getParameter("Page").equals("OngCMCCPFD")) { %>
<!-- Donnes Modifiables -->
        <input type="hidden" name="CH1LGK">
        <input type="hidden" name="CH1LGL" value="<%=request.getParameter("CH1LGL")%>">
        <input type="hidden" name="CPFD" value="<%=request.getParameter("CPFD")%>">
        <input type="hidden" name="TauxCPFD" value="<%=request.getParameter("TauxCPFD")%>">
        <input type="hidden" name="TauxCMC" value="<%=request.getParameter("TauxCMC")%>">
        <input type="hidden" name="TypeCMC" value="<%=request.getParameter("TypeCMC")%>">
        <input type="hidden" name="MntCMC" value="<%=request.getParameter("MntCMC")%>">
        <input type="hidden" name="Reduction" value="<%=request.getParameter("Reduction")%>">
        <input type="hidden" name="TauxICF" value="<%=request.getParameter("TauxICF")%>">
        <input type="hidden" name="ComptaInd" value="<%=request.getParameter("ComptaInd")%>">
        <input type="hidden" name="ComptaIndPrinc" value="<%=request.getParameter("ComptaIndPrinc")%>">
        <input type="hidden" name="Periode" value="<%=periode%>">
<% } %>


<% if (request.getParameter("Page").equals("OngFrais")) { %>
<!-- Donnes Modifiables -->
        <input type="hidden" name="CH1LGK" value="<%=request.getParameter("CH1LGK")%>">
        <input type="hidden" name="CH1LGL" value="<%=request.getParameter("CH1LGL")%>">
        <input type="hidden" name="FraisN" value="<%=request.getParameter("FraisN")%>">
        <input type="hidden" name="MntN" value="<%=request.getParameter("MntN")%>">

	<% for (int i=10;i<10 + nbDeFrais;i++) { %>
		<% leChar = String.valueOf(Character.toUpperCase(Character.forDigit(i,Character.MAX_RADIX)));%>
        	<input type="hidden" name="Frais<%=leChar%>" value="<%=request.getParameter("Frais" + leChar)%>">
        	<input type="hidden" name="Mnt<%=leChar%>" value="<%=request.getParameter("Mnt" + leChar)%>">

	<% } %>
<% } %>
        

<BR>

<table border="0" width="100%">
    <tr>
        <td width="25%" align="center"></td>
        <td width="50%" align="CENTER" bgcolor="#FFE077" border="1" ><B>Evolution de la priode du <span id="Font1" class="Font1"><%=request.getParameter("CH1LGK")%></span> au <span id="Font1" class="Font1"><%=request.getParameter("CH1LGL")%></span>  </B></td>
        <td width="25%" align="center"></td>
    </tr>
</table>
<BR>
<BR>

       <table border="0" width="100%">
          <tr>
            <td width="100%" align="CENTER">
            <B>Veuillez entrer la date de dbut de la nouvelle priode : </B>
            <input type="text" <%if (request.getParameter("Page").equals("OngCMCCPFD") && periode!=0) { %>disabled="disabled"<%} %> onFocus="this.select()" name="JJ" size="2" maxlength="2" onkeyup="Javascript:if(this.value.length > 1 && event.keyCode >= 96 && event.keyCode <= 105) {this.form.MM.focus();this.form.MM.select();}"> / 
            <input type="text" id="mois" <%if (request.getParameter("Page").equals("OngCMCCPFD") && periode==9) { %>disabled="disabled"<%} %> onFocus="this.select()" name="MM" size="2" maxlength="2" onkeyup="Javascript:if(this.value.length > 1 && event.keyCode >= 96 && event.keyCode <= 105) {this.form.AAAA.focus();this.form.AAAA.select();}"> /
            <input type="text" onFocus="this.select()" name="AAAA" size="4" maxlength="4" >
            <span id="Font11" class="Font11"> (jj/mm/aaaa) </span>
            </td>
          </tr>
       </table>

<BR>
<BR>
        
   <table border="0" width="100%">
      <tr>
         <td width="40%" align="center">&nbsp;</td>
         <td width="10%" align="center">
            <a>
               <span id="Font1" class="Font1">
                  <img src="Images/BValider.gif" border=0 onclick="soumet();">
               </span>
            </a>
         </td>
         <td width="10%" align="center">
            <a href="JavaScript:submitFormCN(document.Evolution,'<%=request.getParameter("Page")%>')">
               <span id="Font1" class="Font1">
                  <img src="Images/BAnnuler.gif" border=0>
               </span>
            </a>
         </td>
         <td width="40%" align="center">&nbsp;</td>
      </tr>
   </table>

        
    </form>
    </td></tr>    
 </table>
</div>





<%@ include file="ChgCpteCondArret.jsp" %>

</body>

</html>
