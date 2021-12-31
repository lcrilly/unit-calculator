<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.github.cliftonlabs.json_simple.JsonObject" %>
<%@ page import="com.github.cliftonlabs.json_simple.JsonArray" %>
<%@ page import="com.github.cliftonlabs.json_simple.Jsoner" %>

<%@ page language="java" contentType="application/json; charset=utf-8" %>

<%
BufferedReader  br = request.getReader();
JsonObject      res = new JsonObject();
JsonObject      deserializedObject;
JsonArray       operands;
BigDecimal      operand = new BigDecimal(0);
BigDecimal      product = new BigDecimal(1); // Init to 1 so we can multiply in a loop
String          body = "";
String          line = br.readLine();
while (line != null) {
    body += line;
    line = br.readLine();
}

deserializedObject = Jsoner.deserialize(body, new JsonObject());
operands = (JsonArray) deserializedObject.get("operands");
for (int i = 0; i < operands.size(); i++) {
    operand = (BigDecimal) operands.get(i);
    product = product.multiply(operand);
}
res.put("result", product.stripTrailingZeros());

out.println(Jsoner.prettyPrint((Jsoner.serialize(res))));
%>