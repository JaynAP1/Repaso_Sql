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
        insert into Auditoria(id_alumno, nuevodato, viejodato, contexto)
        values (old.id, new.nombre, old.nombre, 'nombre');
    end if;

    if old.apellido != new.apellido then
        insert into Auditoria(id_alumno, nuevodato, viejodato, contexto)
        values (old.id, new.apellido, old.apellido, 'apellido');
    end if;

end // 
DELIMITER ;


-- RegistrarHistorialCreditos: Al modificar los créditos de una asignatura, guarda un historial de los cambios.

create table HistorialCreditos (
    id_historial INT PRIMARY KEY AUTO_INCREMENT,
    id_asignatura INT UNSIGNED,
    creditos_anterior INT,
    creditos_nuevos INT,
    foreign key (id_asignatura) references asignatura(id)
);

DELIMITER //
create trigger RegistrarHistorialCreditos
after update on Asignatura
for each row
begin
    if old.creditos != new.creditos then
        insert into HistorialCreditos (id_asignatura, creditos_anterior, creditos_nuevos, modificado_por)
        values (NEW.id, OLD.creditos, NEW.creditos);
    end if;
end //
DELIMITER ;

-- NotificarCancelacionMatricula: Registra una notificación cuando se elimina una matrícula de un alumno.

create table Notificaciones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_alumno INT UNSIGNED,
    mensaje VARCHAR(255),
    foreign key (id_alumno) references Alumno(id)
);

DELIMITER //
create trigger NotificarCancelacionMatricula
after delete on alumno
for each row
begin
    -- Insertar una notificación cuando se elimina una matrícula
    insert into Notificaciones (id_alumno, mensaje)
    values (old.id, CONCAT('Se ha cancelado la matrícula del alumno ', old.id));
end //
DELIMITER ;

-- RestringirAsignacionExcesiva: Evita que un profesor tenga más de 10 asignaturas asignadas en un semestre.

DELIMITER //
create trigger restringir_asignacion_excesiva
before insert on profesor
for each row
begin
    declare cantidad_asignaturas int;
    
    select  COUNT(a.id) into cantidad_asignaturas from profesor p left join asignatura a on p.id = a.id_profesor group by p.id;

    if cantidad_asignaturas >= 10 then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El profesor ya tiene 10 asignaturas asignadas en este semestre.';
    end if;
end//
DELIMITER ;

select p.id, p.nombre, p.apellido1, COUNT(a.id) as cantidad_asignaturas from profesor p left join asignatura a on p.id = a.id_profesor group by p.id;

