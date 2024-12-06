<%@ page language="java"
  errorPage="ErreurFatale.jsp"
  isErrorPage = "false"
  session = "true"
  import="com.cai.acint.spirit.testconnector.*,
          com.cai.acint.classes.*,
          java.text.ParseException,
          java.text.SimpleDateFormat,
          java.util.Calendar,
          java.util.Date"
%>
<% String Page = "ComptesEnAttenteDeValidation"; %>
<% ST0FAH JS0FAH = (ST0FAH) request.getSession().getAttribute("ST0FAH"); %>
<% ST0T5G JS0T5G = (ST0T5G) request.getAttribute("ST0T5G"); %>
<html>
<head>
   <title>Comptes en attente de validation</title>
   <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
   <link rel="stylesheet" type="text/css" href="FeuilleStyle/FeuilleDeStyle.css">
   
   <script language="JavaScript1.2" TYPE="text/JavaScript" src="JavaScript/FonctionJavaScript.js"></SCRIPT>
   <script language="JavaScript1.2" TYPE="text/JavaScript" src="JavaScript/formulaire.js"></SCRIPT>
   <script language="JavaScript1.2" TYPE="text/JavaScript" src="JavaScript/windowName.js"></SCRIPT>
   <script language="Javascript1.2" TYPE="text/javascript" src="JavaScript/init.js"></script>
   <script language="Javascript1.2" TYPE="text/javascript" src="JavaScript/JSComptesEnAttenteDeValidation.js"></script>
</head>

<body>	
	<%@ include file="Mask.jsp" %>
	
	<div id="Titre" class="Titre"> 
      <img src="Images/TitreComptesEnAttenteDeValidation.gif">
    </div>
    
    <div id="Formulaire" class="Formulaire">		
		<div style="height:280;<% if (JS0T5G.getCH1ISN()> 11) {%>overflow-y:scroll<%}%>">
			<form name="formComptesEnAttenteDeValidation"  method="post" action="app">
				 <%@ include file="WindowName.jsp" %>
				 <input type="hidden" name="CN" value="AccCondArret">
		         <input type="hidden" name="CH1LGN" value="<%=JS0FAH.getCH1LGN()%>">
		         <input type="hidden" name="AIGUILLEUR" >
		         <input type="hidden" name="Page" value="<%=Page%>">
		         <input type="hidden" name="Libelle" value="">
		         <input type="hidden" name="Erreur" value="OK">
		         <input type="hidden" name="CH1LHE" value="">
		         <input type="hidden" name="CH1LK8" value="<%=JS0FAH.getCH1LK8().trim()%>">
		         
				<table border="0" bordercolor="#FFFFFF" cellspacing="4" nowrap>
					<tr style="background-color:#71BDD4">
					    <th class="colonneResp1" align="center" valign="center"></th>
					    <th class="colonneResp2" align="center" valign="center">Compte</th>
					    <th class="colonneResp2" align="center" valign="center">UT modifieur</th>
					    <th class="colonneResp3" align="center" valign="center">Date modification</th>
					    <th class="colonneResp2" align="center" valign="center">Statut</th>
					    <th class="colonneResp3" align="center" valign="center">Ecrans modifis</th>
					</tr>
					<%  	
						String couleurArrierePlan = "" ;
			    		String couleurPolice = "";
			    		String couleurAlerteArrierePlan = "";
			    		String couleurAlertePolice = "";
						int nombreDeLigneEnBase = JS0T5G.getCH1ISN();
						int nombreDeLigneAfficher = nombreDeLigneEnBase;
						if (nombreDeLigneEnBase>=250){
							nombreDeLigneAfficher = 250;
					%>
							<script language="JavaScript"> alert("Attention.  La liste de compte en attente de validation est incomplte..."); </script>
					<%	}
						
					    for (int i = 0; i < nombreDeLigneAfficher; i++ ) {
					    	
				     		String numeroDeCompte = JS0T5G.getCH0T5L(i).getCH1LHE();
				     		String utDeDerniereMiseAJour = JS0T5G.getCH0T5L(i).getCH1LGN();				     		
				     		String dateDeDerniereMiseAJour = String.valueOf(JS0T5G.getCH0T5L(i).getCH1LGM());
				     		String dateDeDerniereMiseAJourFormat = dateDeDerniereMiseAJour.substring(6,8) + "/" + dateDeDerniereMiseAJour.substring(4,6) + "/" + dateDeDerniereMiseAJour.substring(0,4);
				     		String statutDuCompte = JS0T5G.getCH0T5L(i).getCH3HGO();
				     		String ongletsModifies = JS0T5G.getCH0T5L(i).getCH3HGE();
				     		
				     		couleurPolice = "rgb(0, 0, 0)";
				     		if ((i % 2) == 0) {couleurArrierePlan = "#FFFFFF";} else {couleurArrierePlan = "#D7EAF1";}
				     		
				     		couleurAlertePolice = couleurPolice;
				    		couleurAlerteArrierePlan = couleurArrierePlan;
				    		
				     		Date dateDeDerniereMiseAJourFormatDate = null;
				    		try {
				    			dateDeDerniereMiseAJourFormatDate = new SimpleDateFormat("dd/MM/yyyy").parse(dateDeDerniereMiseAJourFormat);
				    		} catch (ParseException e) {}			
				    						    		
				    		Calendar calendarDeDerniereMiseAJour = Calendar.getInstance();
				    		calendarDeDerniereMiseAJour.setTime(dateDeDerniereMiseAJourFormatDate);
				    		calendarDeDerniereMiseAJour.add(Calendar.DAY_OF_YEAR, 2);

				    		Calendar calendarAujourdhui = Calendar.getInstance();
				    		Date aujourdhui = new Date();
				    		calendarAujourdhui.setTime(aujourdhui);	    		
				    		
				    		if (calendarAujourdhui.compareTo(calendarDeDerniereMiseAJour) > 0) {
				    			couleurAlertePolice = "rgb(255, 255, 255)"; couleurAlerteArrierePlan = "rgb(190, 80, 0)";
				    		}
				     		
					%>
						<tr style="color: <%=couleurPolice%>; background-color:<%=couleurArrierePlan%>">
							<td><%=i + 1%></td>
						    <td><a href="JAVASCRIPT:soumet('<%=numeroDeCompte%>');"><%=numeroDeCompte%></a></td>
						    <td><%=utDeDerniereMiseAJour%></td>
						    <td align="center" style="color: <%=couleurAlertePolice%>; background-color:<%=couleurAlerteArrierePlan%>"><%=dateDeDerniereMiseAJourFormat%></td>
						    <td align="center"><%=statutDuCompte%></td>
						    <td align="center"><%=ongletsModifies%></td>
						</tr>
					<%}%>
				</table>
			</form>
		</div>
	</div>
</body>
