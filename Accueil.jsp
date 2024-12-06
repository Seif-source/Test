<%@ page language="java"
  errorPage="ErreurFatale.jsp"
  isErrorPage = "false"
  session = "true"
  import="java.util.Enumeration, java.util.Locale, java.text.DateFormat,
           java.util.Calendar,
           java.util.GregorianCalendar,
           java.util.ResourceBundle,
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
<%@page import="com.cacib.ntic.util.commonweb.*" %>

<% String Page = "Accueil" ; boolean sentinel = false;%>
<% String webReportingUrl = ResourceBundle.getBundle("ApplicationConfig").getString("wrUrl"); %>

<!--RECUPERATION DES DONNEES DE LA STRUCTURE EN ENTREE -->
       <%//System.out.println("Acceuil -  01 ");  %>       
<%  if (request.getSession().getAttribute("ST0FAH") == null) 
    {  
%>
    	<HTML>
    	<%@ include file="ProblemeConnecteur.jsp" %>
    	</HTML>
<%  }
    else
    {
        //System.out.println("Acceuil -  02 ");
    	ST0FAH JS0FAH = (ST0FAH) request.getSession().getAttribute("ST0FAH");
%>
       <HTML>
       <head>
          <title>Accueil</title>
          <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
          <link rel="stylesheet" type="text/css" href="FeuilleStyle/FeuilleDeStyle.css">
          <script language="JavaScript1.2" TYPE="text/JavaScript" src="JavaScript/FonctionJavaScript.js"></SCRIPT>
          <script language="JavaScript1.2" TYPE="text/JavaScript" src="JavaScript/JSAccueil.js"></SCRIPT>
          <script language="JavaScript1.2" TYPE="text/JavaScript" src="JavaScript/formulaire.js"></SCRIPT>
          <script language="JavaScript1.2" TYPE="text/JavaScript" src="JavaScript/windowName.js"></SCRIPT>
          <script language="javascript1.2" type="text/javascript" src="JavaScript/init.js"></script>
          <!-- <script language="JavaScript1.2" TYPE="text/JavaScript" src="JavaScript/neige.js"></SCRIPT> -->
       </head>        
       <body 
       <%//System.out.println("Acceuil -  1 ");  %>       
       <% if ( !(  JS0FAH.getCH1LK8().trim().equals("INTERV")
                 //|| 
                 // JS0FAH.getCH1LK8().trim().equals("ADMIN")
                )
             )
          {
             //System.out.println("Acceuil -  2 "); 
       %>    onMouseDown="Javascript:Copyright()"
       <% } %>
       <%System.out.println("Acceuil -  3 ");  %>       
       onLoad="j = new Date();
               horloge = setTimeout('afficheHorloge(' + j.getTime() + ')',5000);
               seconde = setTimeout('document.deconnexion.submit()',<% if (!(   //JS0FAH.getCH1LK8().trim().equals("ADMIN") || 
                                                                                JS0FAH.getCH1LK8().trim().equals("TUTEUR") 
                                                                             || JS0FAH.getCH1LK8().trim().equals("F-CENTRAL")
                                                                             || JS0FAH.getCH1LK8().trim().equals("CMP-RESP")
                                                                             || JS0FAH.getCH1LK8().trim().equals("CMPRESPVAL")
                                                                            )
                                                                          )
                                                                       {
                                                                    %>    600000
                                                                    <% }
                                                                       else
                                                                       {
                                                                    %>    1000000
                                                                    <% } %>
                                    );"
       >    
       <!-- <EMBED SRC="Images/noel.mid" BORDER=0 AUTOSTART=true LOOP=true WIDTH=0 HEIGHT=0> -->
       <form name="deconnexion"  method="post" action="app"><input type="hidden" name="WN">
          <input type="hidden" name="PWN" value=""><input type="hidden" name="CN" VALUE="Deconnexion">
       </form>
       
       <!-- MENU BORDEAU -->
       <div id="Bordeau" class="Bordeau">
          <TABLE border="0" cellspacing="0" cellpadding="0" width="100%">
             <TR>
                <TD width="100%" height="26">&nbsp;</TD>
             </TR>
          </TABLE>
       </div>
       <%=""%>
       <!-- CARTOUCHE GRIS -->
       <div id="Gris" class="Gris">
          <TABLE border="0" cellspacing="0" cellpadding="0">
             <TR>
                <TD width="90" height="26">&nbsp;</TD>
             </TR>
          </TABLE>
       </div>
       
       <!-- IMAGE A GAUCHE AVEC GLOBE -->
       <div id="left2" class="left2">
          <img src="Images/image2bl.jpg">
       </div>
       
       <!-- LOGO  CREDIT AGRICOLE INDOSUEZ -->
       <div id="logotype" class="logotype">
       <!-- Changement de nom START -->
				<!--
          <img src="Images/Accueillogo.gif" width="267" height="46" border="0">
          -->
				<%
					TagImage logo = new TagImage("intranet.img.logo", pageContext);
					logo.setWidth("300");
 				%>
				<%out.println(logo.getContent()); %>
				<!-- Changement de nom END -->
       </div>
       
       <!-- TITRE DE LA PAGE D'Accueil -->
       <div id="TitreAccueil" class="TitreAccueil">
          <img src="Images/TitreAccueil.gif">
       </div>
        
       <% System.out.println(" ------------------------------------  JS0FAH.getCH1LK7().trim() : "+ JS0FAH.getCH1LK7().trim());
          if (JS0FAH.getCH1LK7().trim().equals("OUI")) 
          {  
       %>    <!-- PARTIE NEWS -->
             <div id="news1" class="news1">
                <img src="Images/Accueilnews.gif">
             </div>
             <div id="news2" class="news2">
                <marquee BGCOLOR="#BFDDEA" direction="up" scrollAmount=2 style="width=310;height=360" loop=-1>
                   <div id="Centrer" class="Centrer">
                      <font size="4" color="#990000">
                    <% for(int j=0;JS0FAH.getCH1REU(j).getCH1RE7().trim().length() > 0 ;j++)
                       { //System.out.println(" ------------------------------------  JS0FAH.getCH1REU(j).getCH1RE8() : "+ JS0FAH.getCH1REU(j).getCH1RE8());
                    %>
                   	     <%=JS0FAH.getCH1REU(j).getCH1RE8()%>
                         <BR>
                    <% } %>
                      </font>
                   </div>
                </marquee>
             </div>
               
             <form name="formComptesEnAttenteDeValidation" method="post" action="app">
             	 <%@ include file="WindowName.jsp" %>
             	 <input type="hidden" name="CN">
		         <input type="hidden" name="CH1LK8" value="<%=JS0FAH.getCH1LK8().trim()%>">
		         <input type="hidden" name="CH3HH2" value="<%=JS0FAH.getCH1LGN()%>">
             </form>
             
             <!-- SOUS TITRES -->
             <div id="SousTitreAccueil" class="SousTitreAccueil">
                <form name="Accueil"  method="post" action="app">
                   <%@ include file="WindowName.jsp" %>
                   <input type="hidden" name="CN">
                   <input type="hidden" name="CH1LGN" value="<%=JS0FAH.getCH1LGN()%>">
                   <input type="hidden" name="Erreur" value="OK">
                   <input type="hidden" name="Page" value="<%=Page%>">
                   <input type="hidden" name="CH1LK8" value="<%=JS0FAH.getCH1LK8().trim()%>">
                   <%System.out.println(" ------------------------------------  JS0FAH.getCH1LK8().trim() : "+ JS0FAH.getCH1LK8().trim());%>
                   <!--GESTION DES MENU -->
                   <% String MenuAccueil1 = "alert('Dsol !\\n\\n Vous n\\\'avez pas les autorisations pour accder  ce menu ! ')";%>
                   <% String MenuAccueil2 = "alert('Dsol !\\n\\n Vous n\\\'avez pas les autorisations pour accder  ce menu ! ')";%>
                   <% String MenuAccueil3 = "alert('Dsol !\\n\\n Vous n\\\'avez pas les autorisations pour accder  ce menu ! ')";%>
                   <% String MenuAccueil4 = "alert('Dsol !\\n\\n Vous n\\\'avez pas les autorisations pour accder  ce menu ! ')";%>
                   <% String MenuAccueil5 = "alert('Dsol !\\n\\n Vous n\\\'avez pas les autorisations pour accder  ce menu ! ')";%>
                   <% String MenuAccueil6 = "alert('Dsol !\\n\\n Vous n\\\'avez pas les autorisations pour accder  ce menu ! ')";%>
                   <% String MenuAccueil7 = "alert('Dsol !\\n\\n Vous n\\\'avez pas les autorisations pour accder  ce menu ! ')";%>
                   <% String MenuAccueil8 = "alert('Dsol !\\n\\n Vous n\\\'avez pas les autorisations pour accder  ce menu ! ')";%>
                   <% String MenuAccueil9 = "alert('Dsol !\\n\\n Vous n\\\'avez pas les autorisations pour accder  ce menu ! ')";%>
                   <% String MenuAccueil10 = "alert('Dsol !\\n\\n Vous n\\\'avez pas les autorisations pour accder  ce menu ! ')";%>
                   <% String MenuAccueil11 = "#";%>
       
                   <%
                   boolean isOnlyInterv = false;
                   	  if ( //JS0FAH.getCH1LK8().trim().equals("ADMIN") || 
                           JS0FAH.getCH1LK8().trim().equals("INTERV")
                         )
                      {
                         System.out.println("dans test essai INTERV ");
                         isOnlyInterv = true;
                         MenuAccueil1 = "JavaScript:submitFormCN(document.Accueil,'CondArretes')";
                         MenuAccueil2 = "JavaScript:submitFormCN(document.Accueil,'Soldes')";
                         MenuAccueil3 = "JavaScript:submitFormCN(document.Accueil,'SoldeEscompte')";
                         MenuAccueil4 = "JavaScript:submitFormCN(document.Accueil,'Commandes')";
                         MenuAccueil5 = "JavaScript:submitFormCN(document.Accueil,'Resultats')";
                         MenuAccueil6 = "JavaScript:submitFormCN(document.Accueil,'Association')";
                         MenuAccueil7 = "window.open('" + webReportingUrl + "','Reporting')";
                         MenuAccueil8 = "JavaScript:submitFormCN(document.Accueil,'Outils')";
                         MenuAccueil9 = "JavaScript:submitFormCN(document.Accueil,'Deconnexion')";     
                         MenuAccueil10 = "JavaScript:submitFormCN(document.Accueil,'CommandeMasse')";
                         MenuAccueil11 = "JavaScript:submitFormCN(document.formComptesEnAttenteDeValidation,'ListeDesComptesEnAttenteDeValidation')";
                      }
                   %>
                      
                   <% boolean isOnlyTuteur = false;
                   	  if (JS0FAH.getCH1LK8().trim().equals("TUTEUR"))
                      {
                         System.out.println("dans test essai TUTEUR ");
                         isOnlyTuteur = true;
                         MenuAccueil1 = "JavaScript:submitFormCN(document.Accueil,'CondArretes')";
                         MenuAccueil2 = "JavaScript:submitFormCN(document.Accueil,'Soldes')";
                         MenuAccueil3 = "JavaScript:submitFormCN(document.Accueil,'SoldeEscompte')";
                         MenuAccueil4 = "JavaScript:submitFormCN(document.Accueil,'Commandes')";
                         MenuAccueil5 = "JavaScript:submitFormCN(document.Accueil,'Resultats')";
                         MenuAccueil6 = "JavaScript:submitFormCN(document.Accueil,'Association')";
                         MenuAccueil7 = "window.open('" + webReportingUrl + "','Reporting')";
                         MenuAccueil8 = "JavaScript:submitFormCN(document.Accueil,'Outils')";
                         MenuAccueil9 = "JavaScript:submitFormCN(document.Accueil,'Deconnexion')";
//                          MenuAccueil10 = "JavaScript:submitFormCN(document.Accueil,'CommandeMasse')";
                         MenuAccueil11 = "JavaScript:submitFormCN(document.formComptesEnAttenteDeValidation,'ListeDesComptesEnAttenteDeValidation')";
                      }
                   %>
                   <!--%System.out.println("avant test essai FCEN ");%-->
                      
                   <% boolean isOnlyFCent_ContInt = false;
                      if (JS0FAH.getCH1LK8().trim().equals("F-CENTRAL") || JS0FAH.getCH1LK8().trim().equals("CONT-INT"))
                      {   
                         System.out.println("dans test essai FCEN ");
                         isOnlyFCent_ContInt = true;
                         MenuAccueil1 = "JavaScript:submitFormCN(document.Accueil,'CondArretes')";
                         MenuAccueil6 = "JavaScript:submitFormCN(document.Accueil,'Association')";
                         MenuAccueil8 = "JavaScript:submitFormCN(document.Accueil,'Outils')";
                         MenuAccueil9 = "JavaScript:submitFormCN(document.Accueil,'Deconnexion')";
                      }
                   %>
                      
                   <% if (JS0FAH.getCH1LK8().trim().equals("RESP"))
                      {
                         System.out.println("dans test RESP ");
                         MenuAccueil1 = "JavaScript:submitFormCN(document.Accueil,'CondArretes')";
                         MenuAccueil2 = "JavaScript:submitFormCN(document.Accueil,'Soldes')";
                         MenuAccueil3 = "JavaScript:submitFormCN(document.Accueil,'SoldeEscompte')";
                         MenuAccueil4 = "JavaScript:submitFormCN(document.Accueil,'Commandes')";
                         MenuAccueil5 = "JavaScript:submitFormCN(document.Accueil,'Resultats')";
                         MenuAccueil6 = "JavaScript:submitFormCN(document.Accueil,'Association')";
                         MenuAccueil7 = "window.open('" + webReportingUrl + "','Reporting')";
                         MenuAccueil8 = "JavaScript:submitFormCN(document.Accueil,'Outils')";
                         MenuAccueil9 = "JavaScript:submitFormCN(document.Accueil,'Deconnexion')";             
                      }
                   %>
                   
                   <% if (JS0FAH.getCH1LK8().trim().equals("CMP-RESP") || JS0FAH.getCH1LK8().trim().equals("CMPRESPVAL"))
                      {
                         System.out.println("dans test CMP-RESP | CMPRESPVAL ");
                         MenuAccueil1 = "JavaScript:submitFormCN(document.Accueil,'CondArretes')";
                         MenuAccueil2 = "JavaScript:submitFormCN(document.Accueil,'Soldes')";
                         MenuAccueil3 = "JavaScript:submitFormCN(document.Accueil,'SoldeEscompte')";
                         MenuAccueil4 = "JavaScript:submitFormCN(document.Accueil,'Commandes')";
                         MenuAccueil5 = "JavaScript:submitFormCN(document.Accueil,'Resultats')";
                         MenuAccueil6 = "JavaScript:submitFormCN(document.Accueil,'Association')";
                         MenuAccueil7 = "window.open('" + webReportingUrl + "','Reporting')";
                         MenuAccueil8 = "JavaScript:submitFormCN(document.Accueil,'Outils')";
                         MenuAccueil9 = "JavaScript:submitFormCN(document.Accueil,'Deconnexion')";
                         MenuAccueil11 = "JavaScript:submitFormCN(document.formComptesEnAttenteDeValidation,'ListeDesComptesEnAttenteDeValidation')";
                      }
                   %>
                    
                   <% boolean isConsult_Vtot_Vmoe = false;
                      if ( JS0FAH.getCH1LK8().trim().equals("CONSULT") 
                          ||
                           JS0FAH.getCH1LK8().trim().equals("VISU-TOTAL")
                          ||
                           JS0FAH.getCH1LK8().trim().equals("VISU-MOE")
                         )
                      {
                         System.out.println("dans test CONSULT-VISU-TOTAL-VISU-MOE ");
                         isConsult_Vtot_Vmoe = true;
                         MenuAccueil1 = "JavaScript:submitFormCN(document.Accueil,'CondArretes')";
                         MenuAccueil2 = "JavaScript:submitFormCN(document.Accueil,'Soldes')";
                         MenuAccueil3 = "JavaScript:submitFormCN(document.Accueil,'SoldeEscompte')";
                         MenuAccueil5 = "JavaScript:submitFormCN(document.Accueil,'Resultats')";
                         MenuAccueil6 = "JavaScript:submitFormCN(document.Accueil,'Association')";
                         MenuAccueil7 = "window.open('" + webReportingUrl + "','Reporting')";
                         MenuAccueil8 = "JavaScript:submitFormCN(document.Accueil,'Outils')";
                         MenuAccueil9 = "JavaScript:submitFormCN(document.Accueil,'Deconnexion')";
                      }
                   %>
                      
                   <TABLE border=0 cellspacing=0 cellpadding=0>
                      <TR height="25px">
                         <TD align=left valign=center class="menu-accueil" onMouseOver="style.color='black'" onMouseOut="style.color='#EC870E'" onClick="<%=MenuAccueil1%>">&nbsp;&nbsp;<img src="Images/bulle.jpg" border="0">&nbsp;&nbsp;Conditions d'arrts</TD>
                      </TR>
                      <% if (JS0FAH.getCH1LK8().trim().equals("CMP-RESP") || JS0FAH.getCH1LK8().trim().equals("CMPRESPVAL") || JS0FAH.getCH1LK8().trim().equals("INTERV") || JS0FAH.getCH1LK8().trim().equals("TUTEUR")){%>
	                      <TR height="25px">
	                         <TD align=left valign=center class="menu-accueil" onMouseOver="style.color='black'" onMouseOut="style.color='#EC870E'" onClick="<%=MenuAccueil11%>">&nbsp;&nbsp;<img src="Images/bulle.jpg" border="0">&nbsp;&nbsp;Comptes en attente de validation</TD>
	                      </TR>
                      <%}%>
                      <%if ( !isOnlyFCent_ContInt ) 
                        {   
                      %>     
                      <TR height="25px">
                         <TD align=left valign=center class="menu-accueil" onMouseOver="style.color='black'" onMouseOut="style.color='#EC870E'" onClick="<%=MenuAccueil2%>">&nbsp;&nbsp;<img src="Images/bulle.jpg" border="0">&nbsp;&nbsp;Soldes en valeur et de refinancement</TD>
                      </TR>
<!--                       <TR height="25px"> -->
<%--                          <TD align=left valign=center class="menu-accueil" onMouseOver="style.color='black'" onMouseOut="style.color='#EC870E'" onClick="<%=MenuAccueil3%>">&nbsp;&nbsp;<img src="Images/bulle.jpg" border="0">&nbsp;&nbsp;Soldes  l'escompte</TD> --%>
<!--                       </TR> -->
                      <%if ( !isConsult_Vtot_Vmoe ) 
                        {   
                      %>     
                      <TR height="25px">
                         <TD align=left valign=center class="menu-accueil" onMouseOver="style.color='black'" onMouseOut="style.color='#EC870E'" onClick="<%=MenuAccueil4%>">&nbsp;&nbsp;<img src="Images/bulle.jpg" border="0">&nbsp;&nbsp;Commandes d'arrts</TD>
                      </TR>
                      <%if ( isOnlyInterv ) 
                         {   
                      %>     
                      <TR height="25px">
                         <TD align=left valign=center class="menu-accueil" onMouseOver="style.color='black'" onMouseOut="style.color='#EC870E'" onClick="<%=MenuAccueil10%>">&nbsp;&nbsp;<img src="Images/bulle.jpg" border="0">&nbsp;&nbsp;Commande fictif de masse [VUC]</TD>
                      </TR>
                      <%}%>
                      <%}%>
                      <TR height="25px">
                         <TD align=left valign=center class="menu-accueil" onMouseOver="style.color='black'" onMouseOut="style.color='#EC870E'" onClick="<%=MenuAccueil5%>">&nbsp;&nbsp;<img src="Images/bulle.jpg" border="0">&nbsp;&nbsp;Rsultats d'arrts</TD>
                      </TR>
                      <%}%>
                      <TR height="25px">
                         <TD align=left valign=center class="menu-accueil" onMouseOver="style.color='black'" onMouseOut="style.color='#EC870E'" onClick="<%=MenuAccueil6%>">&nbsp;&nbsp;<img src="Images/bulle.jpg" border="0">&nbsp;&nbsp;Association en intrt</TD>
                      </TR>
                      <%if ( !isOnlyFCent_ContInt ) 
                        {   
                      %>     
                      <TR height="25px">
                         <TD align=left valign=center class="menu-accueil" onMouseOver="style.color='black'" onMouseOut="style.color='#EC870E'" onClick="<%=MenuAccueil7%>">&nbsp;&nbsp;<img src="Images/bulle.jpg" border="0">&nbsp;&nbsp;Reporting</TD>
                      </TR>
                      <%}%>
                      <TR height="25px">
                         <TD align=left valign=center class="menu-accueil" onMouseOver="style.color='black'" onMouseOut="style.color='#EC870E'" onClick="<%=MenuAccueil8%>">&nbsp;&nbsp;<img src="Images/bulle.jpg" border="0">&nbsp;&nbsp;Outils de suivi</TD>
                      </TR>
                      <TR height="25px">
                         <TD align=left valign=center class="menu-accueil" onMouseOver="style.color='black'" onMouseOut="style.color='#EC870E'" onClick="<%=MenuAccueil9%>">&nbsp;&nbsp;<img src="Images/bulle.jpg" border="0">&nbsp;&nbsp;Dconnexion</TD>
                      </TR>
                   </TABLE>
                </form>
             </div>
              
             <!-- BANDE GRISE VERTICALE -->
             <div id="titre3" class="titre3">
                <TABLE border="0" cellspacing="0" cellpadding="0" bgcolor="#999D9F">
                   <TR>
                      <TD width="5" height="280">&nbsp;</TD>
                   </TR>
                </TABLE>
             </div>
              
             <div id="Info1" class="Info1" style="display:none">
                <TABLE width="100%" border="0" cellspacing="0" cellpadding="0" >
                   <TR>
                      <TD><font size="5" color="#990000">Consultation et gestion<BR>des Conditions d'Arrts</font></TD>
                   </TR>
                </TABLE>
              </div>
       <% }   
          else
          {   
       %>      
             <div id="Habilitation" class="Habilitation">
                Vous n'tes pas habilit  cette transaction !
             </div>
       <% } %>            
       </body>        
<%  } %>
    </html>
