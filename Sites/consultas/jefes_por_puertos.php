<?php include('../templates/header.html');   ?>

<body>
<?php
  #Llama a conexión, crea el objeto PDO y obtiene la variable $db
  require("../config/conexion.php");

  $nombre = $_POST["nombre_elegido"];
  //      select psnombre from personal, instalaciones, puertos where personal.inid = instalaciones.inid and personal.psesjefe = 'si' and puertos.puid = instalaciones.puid and puertos.punombre = 'Mejillones';
 	$query = "SELECT psnombre FROM personal, instalaciones, puertos WHERE personal.inid = instalciones.inid AND personal.psesjefe = 'si' AND puertos.puid = instalaciones.puid AND puertos.punombre = 'Mejillones';";
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
