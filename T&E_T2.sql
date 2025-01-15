-- ActualizarTotalAsignaturasProfesor: Al asignar una nueva 
-- asignatura a un profesor, actualiza el total de asignaturas 
-- impartidas por dicho profesor.

-- O_O Este trigger será accionado con una modificación en
-- profesor , teniendo una nueva columna para el total de
-- asignaturas llamada "total_asignaturas".

alter table profesor add column total_asignaturas int default 0;

DELIMITER //
create trigger ActualizarTotalAsignaturasProfesor
after insert on asignatura
for each row
begin
	declare total_asignaturas_interna int;
    -- Obtener el total de asignaturas actuales del docente
    select count(*) into total_asignaturas_interna
    from asignatura
    where id_profesor = NEW.id_profesor;
    
    -- Actualizar el total de asignaturas
    -- impartidas por el docente
    update profesor 
    set total_asignaturas = total_asignaturas_interna
    where id = NEW.id_profesor;
    
end // 
DELIMITER ;

-- ReporteMensualDeAlumnos: Genera un informe mensual 
-- con el total de alumnos matriculados por grado 
-- y lo almacena automáticamente.

-- OJO: Hay que tener una tabla que almacene el informe 
-- mensual del total de alumnos. Se propone la siguiente
-- tabla:
create table informe_mensual_matriculas
(
id int unsigned auto_increment primary key,
grado_id int unsigned not null,
total_alumnos int not null,
fecha_informe datetime not null,
foreign key (grado_id) references grado(id)
);

DELIMITER //
create event ReporteMensualDeAlumnos
on schedule every 1 month
do
begin
	insert into informe_mensual_matriculas 
    (grado_id,total_alumnos,fecha_informe)
    select id_grado,count(id_alumno), NOW()
    from alumno_se_matricula_asignatura
    group by id_grado;
end // 
DELIMITER ;
