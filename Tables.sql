Create Database if not exists RepasoUniversitario;

Use RepasoUniversitario;

Create table if not exists departamento(
id INT(10) PRIMARY KEY,
nombre VARCHAR(50) NOT NULL
);
Create table if not exists profesor(
id INT(10) PRIMARY KEY,
nif VARCHAR(9),
nombre VARCHAR(25) NOT NULL,
apellido1 VARCHAR(50) NOT NULL,
apellido2 VARCHAR(50),
ciudad VARCHAR(25) NOT NULL,
direccion VARCHAR(50) NOT NULL,
telefono VARCHAR(9),
fecha_nacimiento DATE NOT NULL,
sexo ENUM('H','M'),
id_departamento INT(10),
foreign key (id_departamento) references departamento(id)
);
Create table if not exists Grado(
id INT PRIMARY KEY,
nombre VARCHAR(100)
);

Create table if not exists Asignatura (
id INT(10) PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
creditos FLOAT NOT NULL,
tipo ENUM("basica","obligatoria","optativa") NOT NULL,
curso TINYINT(3) NOT NULL,
cuatrimestre TINYINT(3),
id_profesor INT(10),
id_grado INT(10) NOT NULL,
foreign key (id_profesor) references profesor (id),
foreign key (id_grado) references Grado(id)
);

Create table if not exists Curso_escolar (
id INT PRIMARY KEY,
anyo_inicio VARCHAR(20) NOT NULL,
anyo_fin VARCHAR(20) NOT NULL
);

Create table if not exists Alumno (
id INT PRIMARY KEY,
nif VARCHAR(9),
nombre VARCHAR(25) NOT NULL,
apellido1 VARCHAR(50) NOT NULL,
apellido2 VARCHAR(50),
ciudad VARCHAR(25) NOT NULL,
direccion VARCHAR(50) NOT NULL,
telefono VARCHAR(9),
fecha_nacimiento DATE NOT NULL,
sexo ENUM('H','M') NOT NULL
);

Create table if not exists alumno_se_matricula_asignatura(
id_alumno INT(10),
id_asignatura INT(10),
id_curso_escolar INT(10)
);
