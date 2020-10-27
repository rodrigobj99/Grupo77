Funciones usadas en procedimientos almacenados:

dias_disponibles (fecha, puerto_id): recibe una fecha y un id de un puerto y retorna una tabla con el id de la instalación perteneciente al puerto, la fecha ingresada y el porcentaje de ocupación de ese día.

fechas_disponibles (inicio, fin, puerto_id): recibe un intervalo de fechas y un puerto id y retorna una tabla con el id de la instalación perteneciente al puerto y la fechas en las cuales hay capacidad disponible. Utiliza la función dias_disponibles. Corresponde al boton 1 i) de puertos.

ocupaciones_diarias (inicio, fin, puerto_id): recibe un intervalo de fechas y un puerto id y retorna una tabla con el id de la instalación perteneciente al puerto, las fechas y la ocupaciones de cada fecha. Utiliza la función dias_disponibles.

porcentajes_ocupacion (inicio, fin, puerto_id): recibe un intervalo de fechas y un puerto id y retorna una tabla con el id de la instalación perteneciente al puerto, y los promedios de ocupación en ese intervalo. Utiliza la función ocupaciones_diarias. Corresponde al boton 1 ii) de puertos.

crear_permiso (tipo_instalacion, inicio, fin, patente, puerto_id): recibe un tipo de instalacion, un intervalo de fechas (o una fecha), una patente de un buque y un puerto id y retorna el id de la instalación donde se genera el permiso, siesque hay capacidad disponible, ademas agrega el permiso a las tablas correspondientes. Utiliza la función ocupaciones_diarias. Corresponde al boton 2 i) y ii) de puertos.