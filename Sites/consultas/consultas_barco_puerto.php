<?php include('../templates/header.html');   ?>

<body>
<?php
  #Llama a conexión, crea el objeto PDO y obtiene la variable $db
  require("../config/conexion.php");

  $barco = $_POST["barco"];
  $puerto = $_POST["puerto"];

 	$query = "SELECT barcos.bnombre, puertos.punombre, permisos.pmatraque FROM PERMISOS, BARCOS, INSTALACIONES, PUERTOS WHERE permisos.inid = instalaciones.inid AND instalaciones.puid = puertos.puid AND barcos.bpatente = permisos.bpatente AND LOWER(barcos.bnombre) LIKE LOWER('%$barco%') AND LOWER(puertos.punombre) LIKE LOWER('%$puerto%')";
	$result = $db -> prepare($query);
	$result -> execute();
	$pokemones = $result -> fetchAll();
  ?>

	<table>
    <tr>
      <th>Barco</th>
      <th>Puerto</th>
      <th>Fecha de Atraque</th>
    </tr>
  <?php
	foreach ($pokemones as $pokemon) {
  		echo "<tr> <td> $pokemon[0] </td> <td> $pokemon[1] </td> <td> $pokemon[2] </td> </tr>";
	}
  ?>
	</table>

<?php include('../templates/footer.html'); ?>
