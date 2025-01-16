-- ReporteMensualDeAlumnos: Genera un informe mensual con el total de alumnos matriculados por grado y lo almacena automáticamente.

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

-- ActualizarHorasDepartamento: Actualiza el total de horas impartidas por cada departamento al final de cada semestre.

-- AlertaAsignaturaNoCursadaAnual: Envía una alerta cuando una asignatura no ha sido cursada en el último año.

create table alertas (
    id int unsigned auto_increment primary key,
    mensaje VARCHAR(255) NOT NULL
);


DELIMITER //
Create event AlertaAsignaturaNoCursadaAnual
on schedule every 1 year
do
begin
    -- Insertar alerta para las asignaturas que no se han cursado en el último año
    insert into alertas (mensaje)
    select CONCAT('La asignatura "', a.nombre, '" no ha sido cursada en el último año.')
    from asignatura a
    left join alumno_se_matricula_asignatura am on a.id = am.id_asignatura inner join curso_escolar
    where am.id_asignatura and curso_escolar.id = 4;
end//
DELIMITER ;

