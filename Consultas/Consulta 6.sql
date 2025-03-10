SELECT TO_char(EXTRACT(YEAR FROM fecha)) año, SUM(valor_otorgado) valor_total
FROM Prestamo
GROUP BY EXTRACT(YEAR FROM fecha)
UNION ALL
SELECT  'Suma total' año, SUM(VALOR_OTORGADO) as suma_total
FROM PRESTAMO
ORDER BY año;

