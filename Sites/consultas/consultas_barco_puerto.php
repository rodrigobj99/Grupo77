<?php include('../templates/header.html');   ?>

<body>
<?php
  #Llama a conexión, crea el objeto PDO y obtiene la variable $db
  require("../config/conexion.php");

  $barco = $_POST["barco"];
  $puerto = $_POST["puerto"];

 	$query = "    ";
	$result = $db -> prepare($query);
	$result -> execute();
	$pokemones = $result -> fetchAll();
  ?>

	<table>
    <tr>
      <th>Jefe</th>
    </tr>
  <?php
	foreach ($pokemones as $pokemon) {
  		echo "<tr> <td>$barco</td> <td> $puerto </td> </tr>";
	}
  ?>
	</table>

<?php include('../templates/footer.html'); ?>
