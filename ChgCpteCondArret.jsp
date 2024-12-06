<form name="ChangeCompte"  method="post" action="app">
         
<%@ include file="WindowName.jsp" %>

        <input type="hidden" name="CN" value="AccCondArret">
        <input type="hidden" name="CH1LGN" value="<%=JS0FAH.getCH1LGN()%>">
        <input type="hidden" name="AIGUILLEUR" >
        <input type="hidden" name="Erreur" value="OK">
        <input type="hidden" name="PageAppelante" value="<%=request.getParameter("Page")%>">
        <input type="hidden" name="Page" value="<%=Page%>">
        <input type="hidden" name="CH1LK8" value="<%=JS0FAH.getCH1LK8().trim()%>">
	<input type="hidden" name="CH1LHE">


</form>
