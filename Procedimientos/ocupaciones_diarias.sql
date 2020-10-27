CREATE OR REPLACE FUNCTION ocupaciones_diarias (inicio TIMESTAMP, fin TIMESTAMP, puerto_id INTEGER)
RETURNS TABLE (inid INTEGER, dia_disponible DATE, porcentaje_ocupacion FLOAT, intipo VARCHAR(100)) AS $$
DECLARE
tupla RECORD;
BEGIN
WHILE date(inicio) < (date(fin) + INTERVAL '1 day')  LOOP
FOR tupla IN SELECT * FROM dias_disponibles(DATE(inicio), puerto_id) LOOP
inid := tupla.inid;
porcentaje_ocupacion := tupla.ocupacion_diaria;
dia_disponible := tupla.dia_disponible;
intipo := tupla.intipo;
RETURN NEXT;
END LOOP;
inicio := inicio + INTERVAL '1 day';
END LOOP;
END
$$ language plpgsql;