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