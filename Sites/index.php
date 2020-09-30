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

  <h3 align="center"> ¿Quieres encontrar todass las veces que un barco ha atracado en un puerto?</h3>

  <form align="center" action="consultas/consultas_barco_puerto.php" method="post">
    Nombre del Barco:
    <input type="text" name="barco">
    <br/><br/>
    Nombre del Puerto:
    <input type="text" name="puerto">
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

  <h3 align="center"> ¿Quieres saber el puerto que ha recibido mas barcos en Agosto del 2020?</h3>

  <form align="center" action="consultas/consulta_barcos_por_fecha.php" method="post">
    <br/><br/>
    <input type="submit" value="Buscar">
  </form>

  <br>
  <br>
  <br>

</body>
</html>
