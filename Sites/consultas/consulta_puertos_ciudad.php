<?php include('../templates/header.html');   ?>

<body>

<?php
  #Llama a conexión, crea el objeto PDO y obtiene la variable $db
  require("../config/conexion.php");

	// $tipo = $_POST["tipo_elegido"];
	// $nombre = $_POST["nombre_pokemon"];
 	$query = "SELECT punombre, ciunombre FROM puertos, ciudad WHERE puertos.ciuid = ciudad.ciuid;";
	$result = $db -> prepare($query);
	$result -> execute();
	$pokemones = $result -> fetchAll();
  ?>

	<table>
    <tr>
      <th>ID</th>
      <th>Nombre</th>
      <th>Tipo</th>
    </tr>
  <?php
	foreach ($pokemones as $pokemon) {
  		echo "<tr> <td>$pokemon[0]</td> <td>$pokemon[1]</td> </tr>";
	}
  ?>
	</table>

<?php include('../templates/footer.html'); ?>
