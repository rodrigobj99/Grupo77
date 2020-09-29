<?php include('templates/header.html');   ?>

<body>
  <h1 align="center">Grupo 77 </h1>
  <p style="text-align:center;">Aquí podrás realzar consultas sobre los datos encontrados en el servidor del grupo 77.</p>

  <br>

  <h3 align="center"> ¿Quieres ver todos los puertos junto a la ciudad que pertenecen?</h3>

  <form align="center" action="consultas/consulta_puertos_ciudad.php" method="post">
    <br/><br/>
    <input type="submit" value="Buscar">
  </form>

  <br>
  <br>
  <br>

  <h3 align="center"> ¿Quieres encontrar todos los jefes de un puerto?</h3>

  <form align="center" action="consultas/jefes_por_puertos.php" method="post">
    Puerto:
    <input type="text" name="nombre_elegido">
    <br/><br/>
    <input type="submit" value="Buscar">
  </form>

  <br>
  <br>
  <br>

  <h3 align="center"> ¿Quieres encontrar todos los puertos con al menos un astillero ?</h3>

  <form align="center" action="consultas/consulta_astillero_puertos.php" method="post">
    <br/><br/>
    <input type="submit" value="Buscar">
  </form>
  <br>
  <br>
  <br>

  <h3 align="center"> ¿Quieres encontrar la edad promedio de cada puerto?</h3>

  <form align="center" action="consultas/consulta_edad_promedio_puertos.php" method="post">
    <br/><br/>
    <input type="submit" value="Buscar">
  </form>
  <br>
  <br>
  <br>

  <h3 align="center">¿Quieres buscar todos los pokemones por tipo?</h3>

  <?php
  #Primero obtenemos todos los tipos de pokemones
  require("config/conexion.php");
  $result = $db -> prepare("SELECT DISTINCT tipo FROM pokemones;");
  $result -> execute();
  $dataCollected = $result -> fetchAll();
  ?>

  <form align="center" action="consultas/consulta_tipo.php" method="post">
    Seleccinar un tipo:
    <select name="tipo">
      <?php
      #Para cada tipo agregamos el tag <option value=value_of_param> visible_value </option>
      foreach ($dataCollected as $d) {
        echo "<option value=$d[0]>$d[0]</option>";
      }
      ?>
    </select>
    <br><br>
    <input type="submit" value="Buscar por tipo">
  </form>

  <br>
  <br>
  <br>
  <br>
</body>
</html>
