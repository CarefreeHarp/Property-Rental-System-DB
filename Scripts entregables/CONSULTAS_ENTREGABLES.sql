/*CONSULTAS DEL PROYECTO*/

/*CONSULTA 1*/
SELECT sum(valor_otorgado), EXTRACT(year from FECHA)
FROM PRESTAMO
GROUP BY EXTRACT(year from FECHA);

/*CONSULTA 2*/
select banco.nombre nombre_banco,
       extract(year from prestamo.fecha) anio,
       extract(month from prestamo.fecha) mes,
       sum(prestamo.valor_otorgado) suma_de_prestamos_otorgados
  from banco
  left join prestamo --En caso de existir un banco que no haya otorgado prestamos, de todas formas saldra como resultado y sus valores seran nulos
on prestamo.idbanco = banco.id --Revisar resultado #139 "Banco Sin Plata"
 group by banco.nombre,
          extract(year from prestamo.fecha),
          extract(month from prestamo.fecha)
order by nombre_banco asc, anio asc , mes asc;

/*CONSULTA 3*/
SELECT  numero_doc NOMBRE_DEUDOR,
        valor_otorgado,
        NVL(SUM(valor_abono), 0) VALOR_ABONADO,-- NVL es una funcion que me sirve de que en caso de que el prestamo no tenga ningun abono el valor sea 0 en vez de nulo
        valor_otorgado - NVL(SUM(valor_abono), 0) SALDO
FROM deudor d
JOIN prestamo p ON d.id = p.iddeudor
LEFT JOIN abono a ON p.id = a.idprestamo
GROUP BY numero_doc, valor_otorgado;
        
