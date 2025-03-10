/*CONSULTAS DEL PROYECTO*/

/*CONSULTA 1*/
select sum(valor_otorgado),
       extract(year from fecha)
  from prestamo
 group by extract(year from fecha);

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
 order by nombre_banco asc,
          anio asc,
          mes asc;

/*CONSULTA 3*/
select max(d.numero_doc) nombre_deudor, -- Se usa la funcion max para asignarle una funcion de agregacion ya que de lo contrario tocaria agregar el atributo del select al group by
       max(p.valor_otorgado) valor_otorgado, -- Se usa la funcion max para asignarle una funcion de agregacion ya que de lo contrario tocaria agregar el atributo del select al group by
       nvl(
          sum(a.valor_abono),
          0
       ) valor_abonado,-- NVL es una funcion que me sirve de que en caso de que el prestamo no tenga ningun abono el valor sea 0 en vez de nulo
       max(p.valor_otorgado) - nvl(
          sum(a.valor_abono),
          0
       ) saldo
  from (
        deudor d
     join prestamo p
   on d.id = p.iddeudor
)
  left join abono a
on p.id = a.idprestamo
 group by p.id
 order by p.id asc;