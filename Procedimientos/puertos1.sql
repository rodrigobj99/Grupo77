#Funcion que al darle dos fechas inserta todas las fechas entremedio (incluyendo ectremos) en otra tabla

CREATE OR REPLACE FUNCTION recorrer_dias (inicio TIMESTAMP, fin TIMESTAMP) RETURNS void AS $$
BEGIN
WHILE date(inicio) < date(fin) LOOP
INSERT INTO intervalo values (inicio);
inicio := inicio + INTERVAL '1 day';
END LOOP;
INSERT INTO intervalo values (inicio);
END
$$ language plpgsql;

#La idea es que a futuro en vez de insertar llame a otra funcion que informe capacidad de ese día.


SELECT recorrer_dias ('2018-09-28 06:06:35', '2018-10-02 06:06:35');

SELECT recorrer_dias ('2018-09-28', '2018-10-02');


\COPY permisos from permisos_norm.csv DELIMITER ',' CSV HEADER;
\COPY permisos from '/Users/rodrigobloomfieldjoannon/Library/Application Support/Postgres/permisos_norm.csv' DELIMITER ',' CSV HEADER;

\COPY permisosastilleros from '/Users/rodrigobloomfieldjoannon/Library/Application Support/Postgres/permisos_astilleros_norm.csv' DELIMITER ',' CSV HEADER;

\COPY permisoscargadescarga from '/Users/rodrigobloomfieldjoannon/Library/Application Support/Postgres/permisos_carga_norm.csv' DELIMITER ',' CSV HEADER;

\COPY instalaciones from '/Users/rodrigobloomfieldjoannon/Library/Application Support/Postgres/instalaciones_norm.csv' DELIMITER ',' CSV HEADER;

\COPY barcos from '/Users/rodrigobloomfieldjoannon/Library/Application Support/Postgres/barcos_norm.csv' DELIMITER ',' CSV HEADER;

path relativo!

CREATE OR REPLACE FUNCTION capacidad_dia (dia DATE) RETURNS void AS $$
DECLARE
temp integer;
BEGIN
temp:= 0
FOR tupla IN SELECT * FROM instalaciones,permisos WHERE instalaciones.inid = permisos.inid LOOP
IF tupla.intipo = 'astillero' THEN
SELECT tupla.pmatraque,permisosastilleros.pmasalida FROM tupla,permisosastilleros WHERE permisos.pmid = permisosastilleros.pmid
AND dia BETWEEN tupla.pmatraque AND permisosastilleros.pmasalida;
ELSE
temp:= SELECT COUNT(tupla.pmatraque) WHERE dia = permisos.pmatraque;
END IF;
END LOOP;
END
$$ language plpgsql;


CREATE OR REPLACE FUNCTION capacidad_dia (dia DATE) RETURNS TABLE (inid INTEGER, inocupacion INTEGER, incapacidad INTEGER) AS $$
DECLARE
tupla RECORD;
ocupacion integer;
BEGIN
FOR tupla IN SELECT * FROM Instalaciones LOOP
ocupacion:= 0;
IF tupla.intipo = 'astillero' THEN
ocupacion := ocupacion + COUNT(permisos.pmatraque) FROM instalaciones,permisos,permisosastilleros WHERE tupla.inid = instalaciones.inid AND instalaciones.inid = permisos.inid AND permisos.pmid = permisosastilleros.pmid
AND dia BETWEEN permisos.pmatraque AND permisosastilleros.pmasalida;
ELSE
ocupacion:= ocupacion + COUNT(permisos.pmatraque) FROM instalaciones,permisos WHERE tupla.inid = instalaciones.inid AND tupla.inid = permisos.inid AND dia = permisos.pmatraque;
END IF;
inid := tupla.inid;
inocupacion := ocupacion;
incapacidad := tupla.incapacidad;
RETURN NEXT;
INSERT INTO ocupacion_capacidad values (tupla.inid,ocupacion,tupla.incapacidad);
END LOOP;
END
$$ language plpgsql;

SELECT capacidad_dia ('2018-12-09 10:29:06');
2017-02-17
SELECT * FROM capacidad_dia ('2017-02-17 10:29:06') ORDER BY inid;

CREATE OR REPLACE FUNCTION capacidad_dia (dia DATE) RETURNS void AS $$
DECLARE
tupla RECORD;
temp integer;
BEGIN
temp:= 0;
FOR tupla IN SELECT * FROM Instalaciones LOOP
temp:= temp + 1;
END LOOP;
END
$$ language plpgsql;



SELECT * FROM PERMISOS,PERMISOS2,permisosastilleros,permisosastilleros2 WHERE permisos.inid = permisos2.inid
AND permisos.pmid <> permisos2.pmid AND permisosastilleros.pmid = permisos.pmid
AND permisosastilleros2.pmid = permisos2.pmid
AND permisosastilleros.pmasalida BETWEEN permisos2.pmatraque AND permisosastilleros2.pmasalida
ORDER BY permisos.inid,permisos.pmatraque;


CREATE OR REPLACE FUNCTION capacidad_dia (dia DATE) RETURNS TABLE (inid INTEGER, inocupacion INTEGER, incapacidad INTEGER) AS $$
DECLARE
tupla RECORD;
ocupacion integer;
BEGIN
FOR tupla IN SELECT * FROM Instalaciones LOOP
ocupacion:= 0;
IF tupla.intipo = 'astillero' THEN
ocupacion := ocupacion + COUNT(permisos.pmatraque) FROM instalaciones,permisos,permisosastilleros WHERE tupla.inid = instalaciones.inid AND instalaciones.inid = permisos.inid AND permisos.pmid = permisosastilleros.pmid
AND dia BETWEEN permisos.pmatraque AND permisosastilleros.pmasalida;
ELSE
ocupacion:= ocupacion + COUNT(permisos.pmatraque) FROM instalaciones,permisos WHERE tupla.inid = instalaciones.inid AND tupla.inid = permisos.inid AND dia = permisos.pmatraque;
END IF;
IF ocupacion <> tupla.incapacidad THEN
inid := tupla.inid;
inocupacion := ocupacion;
incapacidad := tupla.incapacidad;
RETURN NEXT;
END IF;
END LOOP;
END
$$ language plpgsql;


CREATE OR REPLACE FUNCTION dias_disponibles (dia DATE) RETURNS TABLE (inid INTEGER, dia_disponible DATE, ocupacion_diaria FLOAT) AS $$
DECLARE
tupla RECORD;
ocupacion FLOAT;
BEGIN
FOR tupla IN SELECT * FROM Instalaciones LOOP
ocupacion:= 0;
IF tupla.intipo = 'astillero' THEN
ocupacion := ocupacion + COUNT(permisos.pmatraque) FROM instalaciones,permisos,permisosastilleros WHERE tupla.inid = instalaciones.inid AND instalaciones.inid = permisos.inid AND permisos.pmid = permisosastilleros.pmid
AND dia BETWEEN permisos.pmatraque AND permisosastilleros.pmasalida;
ELSE
ocupacion:= ocupacion + COUNT(permisos.pmatraque) FROM instalaciones,permisos WHERE tupla.inid = instalaciones.inid AND tupla.inid = permisos.inid AND dia = permisos.pmatraque;
END IF;
inid := tupla.inid;
dia_disponible := dia;
ocupacion_diaria := ocupacion / tupla.incapacidad;
RETURN NEXT;
END LOOP;
END
$$ language plpgsql;

SELECT * FROM dias_disponibles ('2017-02-17 10:29:06') ORDER BY inid;



CREATE OR REPLACE FUNCTION fechas_disponibles (inicio TIMESTAMP, fin TIMESTAMP) RETURNS TABLE (inid INTEGER, dias_con_capacidad DATE) AS $$
DECLARE
tupla RECORD;
BEGIN
WHILE date(inicio) < (date(fin) + INTERVAL '1 day')  LOOP
FOR tupla IN SELECT * FROM dias_disponibles(DATE(inicio)) LOOP
IF tupla.ocupacion_diaria <> 1 THEN
inid := tupla.inid;
dias_con_capacidad := tupla.dia_disponible;
END IF;
RETURN NEXT;
END LOOP;
inicio := inicio + INTERVAL '1 day';
END LOOP;
END
$$ language plpgsql;


SELECT * FROM fechas_disponibles ('2018-09-28', '2018-10-02') ORDER BY inid,dias_con_capacidad;
SELECT * FROM fechas_disponibles ('2017-02-15 10:29:06', '2017-02-19 10:29:06') ORDER BY inid,dias_con_capacidad;



CREATE OR REPLACE FUNCTION ocupaciones_diarias (inicio TIMESTAMP, fin TIMESTAMP) RETURNS TABLE (inid INTEGER, porcentaje_ocupacion FLOAT) AS $$
DECLARE
tupla RECORD;
BEGIN
WHILE date(inicio) < (date(fin) + INTERVAL '1 day')  LOOP
FOR tupla IN SELECT * FROM dias_disponibles(DATE(inicio)) LOOP
inid := tupla.inid;
porcentaje_ocupacion := tupla.ocupacion_diaria;
RETURN NEXT;
END LOOP;
inicio := inicio + INTERVAL '1 day';
END LOOP;
END
$$ language plpgsql;


CREATE OR REPLACE FUNCTION porcentajes_ocupacion (inicio TIMESTAMP, fin TIMESTAMP) RETURNS TABLE (inid INTEGER, porcentaje_ocupacion FLOAT) AS $$
DECLARE
tupla RECORD;
BEGIN
FOR tupla IN SELECT ocupaciones_diarias.inid,AVG(ocupaciones_diarias.porcentaje_ocupacion) FROM ocupaciones_diarias (inicio, fin) GROUP BY ocupaciones_diarias.inid LOOP
inid := tupla.inid;
porcentaje_ocupacion := tupla.avg;
RETURN NEXT;
END LOOP;
END
$$ language plpgsql;



SELECT * FROM ocupaciones_diarias ('2017-02-15 10:29:06', '2017-02-19 10:29:06') ORDER BY inid,dia_disponible;


SELECT * FROM porcentajes_ocupacion ('2017-02-15 10:29:06', '2017-02-19 10:29:06') ORDER BY inid;

SELECT inid,MAX(porcentaje_ocupacion) FROM ocupaciones_diarias ('2017-02-15 10:29:06', '2017-02-19 10:29:06') GROUP BY inid;


CREATE OR REPLACE FUNCTION crear_permiso (tipo_instalacion VARCHAR(100), inicio TIMESTAMP, fin TIMESTAMP, patente VARCHAR(10)) RETURNS TABLE (instalacion_id INTEGER) AS $$
DECLARE
tupla1 RECORD;
tupla2 RECORD;
pmid INTEGER;
BEGIN
IF tipo_instalacion = 'astillero' THEN
FOR tupla1 IN SELECT inid,MAX(porcentaje_ocupacion) FROM ocupaciones_diarias (inicio, fin) WHERE ocupaciones_diarias.intipo = 'astillero' GROUP BY ocupaciones_diarias.inid ORDER BY ocupaciones_diarias.inid LOOP
IF tupla1.max <> 1 THEN
instalacion_id := tupla1.inid;
pmid := 1 + max(permisos.pmid) FROM permisos;
INSERT INTO permisos values (pmid, instalacion_id, patente, inicio);
INSERT INTO permisosastilleros values (pmid, fin);
RETURN NEXT;
EXIT;
END IF;
END LOOP;
ELSE
FOR tupla2 IN SELECT * FROM ocupaciones_diarias(inicio, inicio) WHERE ocupaciones_diarias.intipo = 'muelle' ORDER BY ocupaciones_diarias.inid LOOP
IF tupla2.porcentaje_ocupacion <> 1 THEN
instalacion_id := tupla2.inid;
pmid := 1 + max(permisos.pmid) FROM permisos;
INSERT INTO permisos values (pmid, instalacion_id, patente, inicio);
RETURN NEXT;
EXIT;
END IF;
END LOOP;
END IF;
END
$$ language plpgsql;


SELECT instalacion_id as inid FROM crear_permiso ('astillero', '2017-02-10 10:29:06', '2017-02-11 10:29:06', 'CX2345');


SELECT instalacion_id as inid FROM crear_permiso ('muelle', '2017-02-10 10:29:06', '2017-02-11 10:29:06', 'CX2345');

SELECT inid,MAX(porcentaje_ocupacion) FROM ocupaciones_diarias ('2017-02-10 10:29:06', '2017-02-11 10:29:06') GROUP BY inid;