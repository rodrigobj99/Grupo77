<?php include('../templates/header.html');   ?>

<body>

<?php
  #Llama a conexión, crea el objeto PDO y obtiene la variable $db
  require("../config/conexion.php");

	// $tipo = $_POST["tipo_elegido"];
	// $nombre = $_POST["nombre_pokemon"];

 	$query = "SELECT puertos.punombre, AVG(personal.psedad) FROM PERSONAL, INSTALACIONES, PUERTOS  WHERE personal.inid = instalaciones.inid AND puertos.puid = instalaciones.puid GROUP BY puertos.punombre;";
	$result = $db -> prepare($query);
	$result -> execute();
	$pokemones = $result -> fetchAll();
  ?>

	<table>
    <tr>
      <th>Nombre puerto</th>
      <th>Edad promedio</th>
    </tr>
  <?php
	foreach ($pokemones as $pokemon) {
  		echo "<tr> <td>$pokemon[0]</td> <td>$pokemon[1]</td>  </tr>";
	}
  ?>
	</table>

<?php include('../templates/footer.html'); ?>
