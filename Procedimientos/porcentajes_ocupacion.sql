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