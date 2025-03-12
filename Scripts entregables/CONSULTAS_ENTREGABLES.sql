/*CONSULTAS DEL PROYECTO*/

/*CONSULTA 1*/
create view vista_1 as
   select sum(valor_otorgado) suma,
          extract(year from fecha) anio
     from prestamo
    group by extract(year from fecha);

/*CONSULTA 2*/
create view vista_2 as
   select banco.nombre nombre_banco,
          extract(year from prestamo.fecha) anio,
          extract(month from prestamo.fecha) mes,
          sum(prestamo.valor_otorgado) suma_de_prestamos_otorgados
     from banco
     left join prestamo --En caso de existir un banco que no haya otorgado prestamos, 
   on prestamo.idbanco = banco.id  --de todas formas saldra como resultado y sus valores seran nulos
    group by banco.nombre,
             extract(year from prestamo.fecha),
             extract(month from prestamo.fecha)
    order by nombre_banco asc,
             anio asc,
             mes asc;

/*CONSULTA 3*/
create view vista_3 as
   select max(d.nombre) nombre_deudor, -- Se usa la funcion max para asignarle una funcion de agregacion ya que de lo contrario tocaria agregar el atributo del select al group by
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
create view vista_4 as
   select d.nombre nombre_deudor,
          d.tipo_doc,
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
create view vista_5 as
   select d.id,
          d.nombre,
          nvl(
             count(p.id),
             0
          ) cantidad_prestamos
     from deudor d
     left join prestamo p
   on d.id = p.iddeudor
    group by d.id,
             d.nombre
    order by d.id;

 /*CONSULTA 6*/
create view vista_6 as
   select to_char(extract(year from fecha)) anio,
          sum(valor_otorgado) valor_total
     from prestamo
    group by extract(year from fecha)
   union all
   select 'Suma total' anio,
          sum(valor_otorgado) as suma_total
     from prestamo
    order by anio;
 
 /*CONSULTA 7*/
create view vista_7 as
   select deudor.nombre nombre
     from deudor
     join prestamo
   on deudor.id = prestamo.iddeudor
     join banco
   on prestamo.idbanco = banco.id
    group by deudor.id,
             deudor.nombre
   having count(distinct banco.id) = (
      select count(*)
        from banco
   );

 /*CONSULTA 8*/
create view vista_8 as
   select b.nombre as nombre_banco,
          extract(year from p.fecha) as anio,
          round(
             avg(p.valor_otorgado),
             3
          ) as promedio_banco,
          (
             select round(
                avg(valor_otorgado),
                3
             )
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

 /*UPDATE PUNTO 9*/

update prestamo p
   set
   p.pagado = 'SI'
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

/*CONSULTA PUNTO 9*/
create view vista_9 as
   select deudor.nombre,
          prestamo.id,
          prestamo.valor_otorgado,
          prestamo.pagado
     from deudor
     join prestamo
   on deudor.id = prestamo.iddeudor;

 /*CONSULTA 10*/
create view vista_10 as
   select extract(year from fecha) anio,
          extract(month from fecha) mes,
          (
             select count(*)
               from prestamo pf
               join deudor
             on pf.iddeudor = deudor.id
              where deudor.genero = 'F'
                and extract(year from pf.fecha) = extract(year from p.fecha)
                and extract(month from pf.fecha) = extract(month from p.fecha)
          ) femenino,
          (
             select count(*)
               from prestamo pm
               join deudor
             on pm.iddeudor = deudor.id
              where deudor.genero = 'M'
                and extract(year from pm.fecha) = extract(year from p.fecha)
                and extract(month from pm.fecha) = extract(month from p.fecha)
          ) masculino,
          (
             select count(*)
               from prestamo pt
              where extract(year from pt.fecha) = extract(year from p.fecha)
                and extract(month from pt.fecha) = extract(month from p.fecha)
          ) total
     from prestamo p
    group by extract(year from p.fecha),
             extract(month from p.fecha)
    order by extract(year from p.fecha),
             extract(month from p.fecha);