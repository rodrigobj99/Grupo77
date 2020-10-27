CREATE OR REPLACE FUNCTION crear_permiso (tipo_instalacion VARCHAR(100), inicio TIMESTAMP, fin TIMESTAMP, patente VARCHAR(10), puerto_id INTEGER) RETURNS TABLE (instalacion_id INTEGER) AS $$
DECLARE
tupla1 RECORD;
tupla2 RECORD;
pmid INTEGER;
BEGIN
IF tipo_instalacion = 'astillero' THEN
FOR tupla1 IN SELECT inid,MAX(porcentaje_ocupacion) FROM ocupaciones_diarias (inicio, fin, puerto_id) WHERE ocupaciones_diarias.intipo = 'astillero' GROUP BY ocupaciones_diarias.inid ORDER BY ocupaciones_diarias.inid LOOP
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
FOR tupla2 IN SELECT * FROM ocupaciones_diarias(inicio, inicio, puerto_id) WHERE ocupaciones_diarias.intipo = 'muelle' ORDER BY ocupaciones_diarias.inid LOOP
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