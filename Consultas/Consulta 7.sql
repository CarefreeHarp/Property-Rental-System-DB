SELECT deudor.id identificacion, deudor.numero_doc numero_documento
FROM deudor 
JOIN prestamo ON deudor.id = prestamo.IDDEUDOR 
JOIN banco ON prestamo.IDBANCO = banco.ID
GROUP BY deudor.id, deudor.numero_doc
HAVING COUNT(DISTINCT banco.ID) = (SELECT COUNT(*) FROM banco);
