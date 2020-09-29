<?php include('../templates/header.html');   ?>

<body>
<?php
  #Llama a conexión, crea el objeto PDO y obtiene la variable $db
  require("../config/conexion.php");

  $nombre = $_POST["nombre_elegido"];
  //      select psnombre from personal, instalaciones, puertos where personal.inid = instalaciones.inid and personal.psesjefe = 'si' and puertos.puid = instalaciones.puid and puertos.punombre = 'Mejillones';
 	$query = "select psnombre from personal, instalaciones, puertos where personal.inid = instalaciones.inid and personal.psesjefe = 'si' and puertos.puid = instalaciones.puid and puertos.punombre = 'Mejillones';";
	$result = $db -> prepare($query);
	$result -> execute();
	$pokemones = $result -> fetchAll();
  ?>

	<table>
    <tr>
      <th>Jefesito</th>
    </tr>
  <?php
	foreach ($pokemones as $pokemon) {
  		echo "<tr><td>$pokemon[0]</td></tr>";
	}
  ?>
	</table>

<?php include('../templates/footer.html'); ?>
