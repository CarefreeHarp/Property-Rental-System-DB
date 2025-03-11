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

 /*CONSULTA 4*/
select d.tipo_doc,
       d.numero_doc,
       b.nombre nombre_banco,
       p.fecha,
       p.valor_otorgado
  from deudor d
  join prestamo p
on d.id = p.iddeudor
  join banco b
on p.idbanco = b.id
 order by d.tipo_doc,
          d.numero_doc;
 
/*CONSULTA 5*/
select d.id,
       d.tipo_doc,
       d.numero_doc,
       nvl(
          count(p.id),
          0
       ) cantidad_prestamos
  from deudor d
  left join prestamo p
on d.id = p.iddeudor
 group by d.id,
          d.tipo_doc,
          d.numero_doc
 order by d.id;

 /*CONSULTA 6*/
select to_char(extract(year from fecha)) año,
       sum(valor_otorgado) valor_total
  from prestamo
 group by extract(year from fecha)
union all
select 'Suma total' año,
       sum(valor_otorgado) as suma_total
  from prestamo
 order by año;
 
 /*CONSULTA 7*/
select deudor.id identificacion,
       deudor.numero_doc numero_documento
  from deudor
  join prestamo
on deudor.id = prestamo.iddeudor
  join banco
on prestamo.idbanco = banco.id
 group by deudor.id,
          deudor.numero_doc
having count(distinct banco.id) = (
   select count(*)
     from banco
);

 /*CONSULTA 8*/
select b.nombre as nombre_banco,
       extract(year from p.fecha) as año,
       avg(p.valor_otorgado) as promedio_banco,
       (
          select avg(valor_otorgado)
            from prestamo
           where extract(year from fecha) = extract(year from p.fecha)
       ) as promedio_general
  from prestamo p
  join banco b
on p.idbanco = b.id
 group by b.nombre,
          extract(year from p.fecha)
having avg(p.valor_otorgado) > (
   select avg(valor_otorgado)
     from prestamo
    where extract(year from fecha) = extract(year from p.fecha)
);
         
 /*CONSULTA 9*/
update prestamo p
   set
   p.pagado = 'Sí'
 where p.id in (
   select p.id
     from prestamo p
     left join abono a
   on p.id = a.idprestamo
    group by p.id,
             p.valor_otorgado
   having sum(nvl(
      a.valor_abono,
      0
   )) >= p.valor_otorgado
);

 /*CONSULTA 10*/
 /*. Consulta del valor total de préstamos por año, mes y género femenino*/
select extract(year from p.fecha) as ano,
       extract(month from p.fecha) as mes,
       sum(p.valor_otorgado) as femenino,
       0 as masculino,
       sum(p.valor_otorgado) as total
  from prestamo p
  join deudor d
on p.iddeudor = d.id
 where d.genero = 'f'
 group by extract(year from p.fecha),
          extract(month from p.fecha)
union all
 
 /* Consulta del valor total de préstamos por año, mes y género masculino*/
select extract(year from p.fecha) as ano,
       extract(month from p.fecha) as mes,
       0 as femenino,
       sum(p.valor_otorgado) as masculino,
       sum(p.valor_otorgado) as total
  from prestamo p
  join deudor d
on p.iddeudor = d.id
 where d.genero = 'm'
 group by extract(year from p.fecha),
          extract(month from p.fecha)
union all
 
 /*Fila de totales generales  sin distinción de género)*/
select null as ano,
       null as mes,
       sum(
          case
             when d.genero = 'f' then
                p.valor_otorgado
             else
                0
          end
       ) as femenino,
       sum(
          case
             when d.genero = 'm' then
                p.valor_otorgado
             else
                0
          end
       ) as masculino,
       sum(p.valor_otorgado) as total
  from prestamo p
  join deudor d
on p.iddeudor = d.id
intersect
 
 /*quitar los préstamos con valor otorgado menor a 1000 */
select extract(year from p.fecha) as ano,
       extract(month from p.fecha) as mes,
       sum(p.valor_otorgado) as femenino,
       sum(p.valor_otorgado) as masculino,
       sum(p.valor_otorgado) as total
  from prestamo p
  join deudor d
on p.iddeudor = d.id
 where p.valor_otorgado > 1000
 group by extract(year from p.fecha),
          extract(month from p.fecha)
except all
 
 /* Excluir préstamos totalmente pagados*/
select extract(year from p.fecha) as ano,
       extract(month from p.fecha) as mes,
       sum(p.valor_otorgado) as femenino,
       sum(p.valor_otorgado) as masculino,
       sum(p.valor_otorgado) as total
  from prestamo p
  join deudor d
on p.iddeudor = d.id
 where p.pagado = 'No'
 group by extract(year from p.fecha),
          extract(month from p.fecha);