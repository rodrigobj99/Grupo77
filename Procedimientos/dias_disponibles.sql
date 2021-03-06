CREATE OR REPLACE FUNCTION dias_disponibles (dia DATE, puerto_id INTEGER) RETURNS TABLE (inid INTEGER, dia_disponible DATE, ocupacion_diaria FLOAT, intipo VARCHAR(100)) AS $$
DECLARE
tupla RECORD;
ocupacion FLOAT;
BEGIN
FOR tupla IN SELECT * FROM Instalaciones WHERE instalaciones.puid = puerto_id LOOP
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
intipo := tupla.intipo;
RETURN NEXT;
END LOOP;
END
$$ language plpgsql;