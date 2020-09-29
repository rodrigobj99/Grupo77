<?php include('../templates/header.html');   ?>

<body>

  <?php
  require("../config/conexion.php"); #Llama a conexión, crea el objeto PDO y obtiene la variable $db

  # $var = $_POST["tipo"];
  $query = "SELECT punombre FROM puertos, instalaciones WHERE puertos.puid = instalaciones.consulta_puertos_ciudad AND instalaciones.intipo = 'astillero';";
  $result = $db -> prepare($query);
  $result -> execute();
  $dataCollected = $result -> fetchAll(); #Obtiene todos los resultados de la consulta en forma de un arreglo
  ?>

  <table>
    <tr>
      <th>Nombre Puerto</th>
    </tr>
  <?php
  foreach ($dataCollected as $p) {
    echo "<tr> <td>$p[0]</td>  </tr>";
  }
  ?>
  </table>

<?php include('../templates/footer.html'); ?>
