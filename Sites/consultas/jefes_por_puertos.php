<?php include('../templates/header.html');   ?>

<body>
<?php
  #Llama a conexión, crea el objeto PDO y obtiene la variable $db
  require("../config/conexion.php");

  $nombre = $_POST["nombre_elegido"];
  // select  psnombre from personal, instalaciones where personal.inid = instalaciones.inid and personal.psesjefe = ‘si’
 	$query = "SELECT psnombre FROM personal, instalaciones, puertos WHERE personal.inid = instalciones.inid AND personal.psesjefe = 'si' AND puertos.puid = instalaciones.inid AND puertos.punombre LIKE '%$nombre%';";
	$result = $db -> prepare($query);
	$result -> execute();
	$pokemones = $result -> fetchAll();
  ?>

	<table>
    <tr>
      <th>Jefes</th>
    </tr>
  <?php
	foreach ($pokemones as $pokemon) {
  		echo "<tr><td>$pokemon[0]</td></tr>";
	}
  ?>
	</table>

<?php include('../templates/footer.html'); ?>
