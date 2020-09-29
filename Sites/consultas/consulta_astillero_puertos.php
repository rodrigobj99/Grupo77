<?php include('../templates/header.html');   ?>

<body>

<?php
  #Llama a conexión, crea el objeto PDO y obtiene la variable $db
  require("../config/conexion.php");

	// $tipo = $_POST["tipo_elegido"];
	// $nombre = $_POST["nombre_pokemon"];

 	$query = "SELECT punombre from puertos, instalaciones where puertos.puid = instalaciones.puid and instalaciones.intipo = 'astillero';";
	$result = $db -> prepare($query);
	$result -> execute();
	$pokemones = $result -> fetchAll();
  ?>

	<table>
    <tr>
      <th>Nombre puerto</th>
    </tr>
  <?php
	foreach ($pokemones as $pokemon) {
  		echo "<tr> <td>$pokemon[0]</td>  </tr>";
	}
  ?>
	</table>

<?php include('../templates/footer.html'); ?>
