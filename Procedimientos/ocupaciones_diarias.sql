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