<?php include('../templates/header.html');   ?>

<body>
<?php
  #Llama a conexión, crea el objeto PDO y obtiene la variable $db
  require("../config/conexion.php");

  $fecha = $_POST["fecha"];

 	$query = "SELECT puertos.punombre, COUNT(barcos.bpatente) as llegadas FROM PERMISOS, BARCOS, INSTALACIONES, PUERTOS WHERE permisos.inid = instalaciones.inid AND instalaciones.puid = puertos.puid AND barcos.bpatente = permisos.bpatente AND permisos.pmatraque >= '2020-'.'08'.'-01' AND permisos.pmatraque <= '2020-08-31' GROUP BY (puertos.puid) HAVING COUNT(barcos.bpatente) = (SELECT MAX(llegadas) FROM (SELECT puertos.punombre, COUNT(barcos.bpatente) as llegadas FROM PERMISOS, BARCOS, INSTALACIONES, PUERTOS WHERE permisos.inid = instalaciones.inid AND instalaciones.puid = puertos.puid AND barcos.bpatente = permisos.bpatente AND permisos.pmatraque >= '2020-08-01' AND permisos.pmatraque <= '2020-08-31' GROUP BY (puertos.puid)) as FOO);";
	$result = $db -> prepare($query);
	$result -> execute();
	$pokemones = $result -> fetchAll();
  ?>

	<table>
    <tr>
      <th>Puerto</th>
      <th>Numero de llegadas</th>
    </tr>
  <?php
	foreach ($pokemones as $pokemon) {
  		echo "<tr> <td> $pokemon[0] </td> <td> $pokemon[1] </td>  </tr>";
	}
  ?>
	</table>

<?php include('../templates/footer.html'); ?>
