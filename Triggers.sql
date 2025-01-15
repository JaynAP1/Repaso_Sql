-- ActualizarTotalAsignaturasProfesor: Al asignar una nueva asignatura a un profesor, actualiza el total de asignaturas impartidas por dicho profesor.

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

-- AuditarActualizacionAlumno: Cada vez que se modifica un registro de un alumno, guarda el cambio en una tabla de auditoría.

Create table Auditoria(
	id INT PRIMARY KEY,
    id_alumno INT NOT NULL,
    nuevodato VARCHAR(100),
    viejodato VARCHAR(100),
    contexto VARCHAR(100)
);


DELIMITER //
create trigger AuditarActualizacionAlumno
after update on alumno
for each row
begin

if old.nombre != new.nombre then


end // 
DELIMITER ;
