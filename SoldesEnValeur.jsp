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



<% String Page = "SoldesEnValeur" ;%>
<% String PageAppelante = request.getParameter("Page") ;%>


<!--RECUPERATION DES DONNEES DE LA STRUCTURE EN ENTREE -->
<%  ST0FAH JS0FAH = (ST0FAH) request.getSession().getAttribute("ST0FAH"); %>
<%  ST0FJK JS0FJK = (ST0FJK) request.getSession().getAttribute("ST0FJK"); %>



<html>
<head>
<title>SoldesEnValeur</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" type="text/css" href="FeuilleStyle/FeuilleDeStyle.css">

<script language="JavaScript1.2" TYPE="text/JavaScript" src="JavaScript/FonctionJavaScript.js"></SCRIPT>
<script language="JavaScript1.2" TYPE="text/JavaScript" src="JavaScript/JSSoldesEnValeur.js"></SCRIPT>
<script language="JavaScript1.2" TYPE="text/JavaScript" src="JavaScript/formulaire.js"></SCRIPT>
<script language="JavaScript1.2" TYPE="text/JavaScript" src="JavaScript/windowName.js"></SCRIPT>
<script language="javascript1.2" type="text/javascript" src="JavaScript/init.js"></script>

</head>

<body <% if (!JS0FAH.getCH1LK8().trim().equals("ADMIN") && !JS0FAH.getCH1LK8().trim().equals("INTERV")) {%>onMouseDown="Javascript:Copyright()"<% } %> ONLOAD="j = new Date();horloge = setTimeout('afficheHorloge(' + j.getTime() + ')',5000);seconde = setTimeout('document.deconnexion.submit()',<% if (!(JS0FAH.getCH1LK8().trim().equals("ADMIN") || JS0FAH.getCH1LK8().trim().equals("TUTEUR") || JS0FAH.getCH1LK8().trim().equals("F-CENTRAL") || JS0FAH.getCH1LK8().trim().equals("CMP-RESP") || JS0FAH.getCH1LK8().trim().equals("CMPRESPVAL"))) {%>600000<%} else {%>1000000<%}%>);prelimFormulaire();parametreIFRAME()">

<%@ include file="Mask.jsp" %>


<% if (JS0FJK.getCH1LHE().equals("XXXXXXXXXXX")  || JS0FJK.getCH1M4S().equals("N")) { %>
<form name="Erreur"  method="post" action="app">
         <%@ include file="WindowName.jsp" %>
        <input type="hidden" name="CN">
        <input type="hidden" name="CH1LGN" value="<%=JS0FAH.getCH1LGN()%>">
        <input type="hidden" name="AIGUILLEUR" >
        <input type="hidden" name="Erreur" value="Erreur">
        <input type="hidden" name="Page" value="<%=Page%>">
        <input type="hidden" name="CH1LK8" value="<%=JS0FAH.getCH1LK8().trim()%>">
        <input type="hidden" name="CH1MYV" value="<%=request.getParameter("CH1MYV")%>">
        <%if (JS0FJK.getCH1M4T().equals("N")) { %>
        	<%JS0FJK.setCH1LHE("XXXXXXXXXXX");%>
        	<input type="hidden" name="Libelle" value="Le compte <%=request.getParameter("CH1LHE")%> ne fait pas partie du primtre Acint.">
        <% } else { %>
        	<input type="hidden" name="Libelle" value="<%=JS0FJK.getCH1PR6()%>">
        <% } %>

<SCRIPT language="Javascript">
submitFormCN(document.Erreur,'Soldes')
</SCRIPT>
</form>
<% } else { %>


<!-- HISTORIQUE -->
<div id="Historique" class="Historique">
<table border="0" width="98%">
   <tr>
     <td align="right">
        <a href="JavaScript:submitFormCN(document.SoldesEnValeur,'Accueil2')"><span id="Font1" class="Font1">Accueil</span></a>
        <span id="Font1" class="Font1">/</span>
        <a href="JavaScript:submitFormCN(document.SoldesEnValeur,'Soldes')"><span id="Font1" class="Font1">Soldes</span></a>
     </td>
   </tr>
</table>
</div>

<!-- TITRE DE LA PAGE D'SoldesEnValeur -->
<span id="Titre" class="Titre">
   <img src="Images/TitreSoldesEnValeur.gif">
</span>

<!-- FORMULAIRE -->
<span id="Formulaire" class="Formulaire">
<form name="SoldesEnValeur"  method="post" action="app" onSubmit="rajouteLesZero(document.<%=Page%>.BandeauCH1LHE2,11);return false;">
        <%@ include file="WindowName.jsp" %>
        <input type="hidden" name="CN">
        <input type="hidden" name="CH1LGN" value="<%=JS0FAH.getCH1LGN()%>">
        <input type="hidden" name="AIGUILLEUR" >
        <input type="hidden" name="Erreur" value="OK">
        <input type="hidden" name="Page" value="<%=Page%>">
        <input type="hidden" name="CH1LK8" value="<%=JS0FAH.getCH1LK8().trim()%>">
        <input type="hidden" name="Libelle" value="">
        <%@ include file="Bandeau.jsp" %>

        <input type="hidden" name="CH1LHEprec" value="<%=request.getParameter("CH1LHE")%>">
        <input type="hidden" name="CH1LHE2" value="<%=JS0FJK.getCH1LHE()%>">

        <input type="hidden" name="CH1N34" value=0>
        <input type="hidden" name="CH1N35" value=0>
        <input type="hidden" name="CH1N36" value="">

<table border="0">
    <tr>
        <td width="135" align="left"><B>Soldes  partir du </B></td>
        <td width="350" align="left"><input type="text" onFocus="this.select()" name="txJJDebut" size="2" maxlength="2" onkeyup="Javascript:if(this.value.length > 1 && event.keyCode >= 96 && event.keyCode <= 105) {this.form.txMMDebut.focus();this.form.txMMDebut.select();}"><b> /</b>
                                     <input type="text" onFocus="this.select()" name="txMMDebut" size="2" maxlength="2" onkeyup="Javascript:if(this.value.length > 1 && event.keyCode >= 96 && event.keyCode <= 105) {this.form.txAADebut.focus();this.form.txAADebut.select();}"><b> /</b>
                                     <input type="text" onFocus="this.select()" name="txAADebut" size="4" maxlength="4" onkeyup="Javascript:if(this.value.length > 3 && event.keyCode >= 96 && event.keyCode <= 105) {this.form.txJJFin.focus();this.form.txJJFin.select();}"><b>&nbsp; au&nbsp; </b>
                                     <input type="text" onFocus="this.select()" name="txJJFin"   size="2" maxlength="2" onkeyup="Javascript:if(this.value.length > 1 && event.keyCode >= 96 && event.keyCode <= 105) {this.form.txMMFin.focus();this.form.txMMFin.select();}"><b> /</b>
                                     <input type="text" onFocus="this.select()" name="txMMFin"   size="2" maxlength="2" onkeyup="Javascript:if(this.value.length > 1 && event.keyCode >= 96 && event.keyCode <= 105) {this.form.txAAFin.focus();this.form.txAAFin.select();}"><b> /</b>
                                     <input type="text" onFocus="this.select()" name="txAAFin"   size="4" maxlength="4"></td>

        <% String typeAsso = "";
	   typeAsso = JS0FJK.getCH1MNX().trim();
           if (typeAsso.equals("PRINCIPAL") || typeAsso.equals("SECONDAIRE SFUS")) { %>
              <td width="50" align="left"><B>Soldes cumuls</B></td>
              <td width="50" align="left">
    		   	<fieldset style="border-style:outset;width:60">
                            <label for=rbCumul_OUI><input type=radio id="rbCumul_OUI" name="rbCumul" value="O">Oui&nbsp;</label><br>
                            <label for=rbCumul_NON><input type=radio id="rbCumul_NON" name="rbCumul" value="N" checked>Non</label>
                        </fieldset></td>
        <% } %>

    </tr>
</table>

<input type=submit style="width:0;height:0;">

<img src="Images/BEnvoyer.gif" onclick="soumet();" style="cursor:hand;position:relative;left:+400" border=0>

<table border="0" cellspacing="0" nowrap style="position:relative;left:+52;">
  <tr>
    <th bgcolor="#71BDD4" class=espaceGrand></th>
    <th bgcolor="#71BDD4" class=colonneDate   align=center valign=center>Dates</th>
    <th bgcolor="#71BDD4" class=colonneSolde  align=center valign=center><span id="colonneSoldes1">Soldes en date de valeur</span></th>
    <th bgcolor="#71BDD4" class=colonneDevise align=center valign=center></th>
    <th bgcolor="#71BDD4" class=espaceGrand></th>
    <th bgcolor="#71BDD4" class=colonneDate align=center valign=center>Dates</th>
    <th bgcolor="#71BDD4" class=colonneSolde align=center valign=center><span id="colonneSoldes2">Solde en date de refinancement</span></th>
    <th bgcolor="#71BDD4" class=colonneDevise align=center valign=center></th>
  </tr>
</table>

<span style="position:absolute;left:30;top:180;width:60;z-index:300">
    <fieldset style="border-style:outset;background-color:#D7EAF1">
       <label for="tabAsc" ><input type=radio id="tabAsc"  name=tri value="Asc"  onclick="selectTri()" tabindex=15>Asc</label><br>
       <label for="tabDesc"><input type=radio id="tabDesc" name=tri value="Desc" onclick="selectTri()" tabindex=15 checked>Desc</label>
    </fieldset>
</span>

<script language="JavaScript">
function selectTri() {
   if (document.SoldesEnValeur.tri[0].checked) {
      LaiFrame.document.all.tabDescendant.style.display = 'none';
      LaiFrame.document.all.tabAscendant.style.display = '';
   }
   if (document.SoldesEnValeur.tri[1].checked) {
      LaiFrame.document.all.tabDescendant.style.display = '';
      LaiFrame.document.all.tabAscendant.style.display = 'none';
   }
}
</script>

<IFRAME SRC="" NAME="LaiFrame" WIDTH="700" HEIGHT="235" FrameBorder=0 MarginWidth=0 MarginHeight=0 HSpace=0 VSpace=0
        style="position:relative;left:+105;">
</IFRAME>
<% } %>
</form>
</span>

<%@ include file="ChgCpteSoldeValeur.jsp" %>

</body>
</html>
