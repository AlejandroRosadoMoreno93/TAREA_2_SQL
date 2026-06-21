# Proyecto 2 - Elaboración de consultas SQL

## Descripción

En este proyecto se ha trabajado con una base de datos relacional relacionada con el alquiler de películas. El objetivo principal ha sido crear desde cero un conjunto de consultas SQL que permitan extraer, analizar e interpretar información relevante sobre películas, actores, clientes, alquileres, pagos, categorías e inventario.

Las consultas se han desarrollado aplicando progresivamente diferentes conceptos de SQL, desde selecciones simples hasta consultas con varias tablas, agregaciones, subconsultas, vistas y tablas temporales.

## Pasos realizados

### 1. Análisis de la base de datos

El primer paso fue identificar las tablas principales de la base de datos y comprender la relación entre ellas.

Se analizaron tablas como:

- `film`
- `actor`
- `film_actor`
- `category`
- `film_category`
- `customer`
- `rental`
- `payment`
- `inventory`
- `staff`
- `store`

Esto permitió entender qué información contenía cada tabla y qué campos podían utilizarse para relacionarlas correctamente.

### 2. Interpretación de los enunciados

Antes de escribir cada consulta, se revisó el objetivo de cada ejercicio para determinar qué datos era necesario mostrar, de qué tabla o tablas procedía la información, qué filtros debían aplicarse y si era necesario ordenar, agrupar o calcular valores.

Este paso fue importante para asegurar que cada consulta respondiera correctamente a lo solicitado.

### 3. Creación de consultas simples

Se comenzaron creando consultas básicas sobre una sola tabla utilizando instrucciones como:

- `SELECT`
- `FROM`
- `WHERE`
- `ORDER BY`
- `LIMIT`
- `DISTINCT`

Estas consultas permitieron obtener información directa, como películas con una clasificación concreta, actores con un determinado identificador, películas ordenadas por duración o nombres únicos de películas.

### 4. Aplicación de filtros y condiciones

Después se añadieron condiciones para seleccionar solo los registros que cumplían determinados criterios.

Se utilizaron operadores como:

- `=`
- `>`
- `BETWEEN`
- `LIKE`
- `IN`
- `NOT IN`
- `AND`
- `OR`

Estos filtros permitieron realizar búsquedas más específicas, como encontrar actores por apellido, películas con una duración superior a un valor determinado o películas pertenecientes a ciertas clasificaciones.

### 5. Uso de funciones agregadas

Para obtener información resumida y realizar análisis numéricos, se aplicaron funciones agregadas como:

- `COUNT()`
- `SUM()`
- `AVG()`
- `MIN()`
- `MAX()`
- `STDDEV()`
- `VARIANCE()`

Con estas funciones se calcularon totales, promedios, valores máximos y mínimos, desviaciones estándar y varianzas. Esto permitió analizar aspectos como la duración de las películas, el dinero generado por la empresa o la variabilidad del coste de reemplazo.

### 6. Agrupación de datos

Se utilizaron las cláusulas `GROUP BY` y `HAVING` para agrupar registros y analizar resultados por categorías.

Gracias a estas agrupaciones se pudieron resolver consultas como:

- Cantidad de películas por clasificación.
- Promedio de duración por clasificación.
- Número de alquileres por cliente.
- Número de películas por actor.
- Total de alquileres por categoría.

La cláusula `HAVING` se utilizó cuando era necesario filtrar resultados después de haber agrupado los datos.

### 7. Relación entre varias tablas

Una parte importante del proyecto consistió en combinar información de varias tablas mediante distintos tipos de `JOIN`.

Se utilizaron principalmente:

- `INNER JOIN`, para obtener registros con coincidencias entre tablas.
- `LEFT JOIN`, para mantener registros aunque no tuvieran datos relacionados.
- `CROSS JOIN`, para generar combinaciones posibles entre dos tablas.

Estas uniones permitieron consultar información más completa, como actores que participaron en determinadas películas, películas pertenecientes a una categoría concreta, clientes con sus alquileres o películas junto con su disponibilidad en inventario.

### 8. Uso de alias y buenas prácticas

Durante la elaboración de las consultas se utilizaron alias para mejorar la claridad del código.

Ejemplo:
FROM film AS f
INNER JOIN inventory AS i
    ON f.film_id = i.film_id

El uso de alias facilita la lectura, especialmente cuando una consulta utiliza varias tablas. También se aplicó un formato ordenado, separando las cláusulas principales de cada consulta y usando nombres descriptivos para las columnas calculadas.

### 9. Creación de consultas con subconsultas

Se incorporaron subconsultas cuando era necesario comparar un resultado con un valor calculado previamente.

Se utilizaron subconsultas para obtener, por ejemplo:

- Películas con duración superior a la media.
- Películas con precio de alquiler superior al precio medio.
- Películas con la misma duración que una película concreta.
- Actores que no han participado en películas de una categoría determinada.
- Actores relacionados con películas alquiladas después de una fecha concreta.

Estas consultas permitieron realizar análisis más avanzados dentro de una misma sentencia SQL.

### 10. Creación de vistas

Se creó una vista para almacenar una consulta reutilizable con el número de películas en las que ha participado cada actor.

El uso de una vista permite guardar una consulta compleja con un nombre concreto y consultarla posteriormente como si fuera una tabla.

Ejemplo:

CREATE VIEW actor_num_peliculas AS
SELECT
    a.first_name,
    a.last_name,
    COUNT(fa.film_id) AS numero_peliculas
FROM actor AS a
LEFT JOIN film_actor AS fa
    ON a.actor_id = fa.actor_id
GROUP BY
    a.actor_id,
    a.first_name,
    a.last_name;

### 11. Creación de tablas temporales

También se crearon tablas temporales para guardar resultados intermedios durante la sesión de trabajo.

Se elaboraron tablas temporales para:

- Almacenar el total de alquileres por cliente.
- Guardar las películas que habían sido alquiladas al menos 10 veces.

Estas tablas son útiles cuando se necesita reutilizar un resultado durante el análisis sin crear una tabla permanente en la base de datos.

### 12. Análisis de los resultados obtenidos

Tras crear las consultas, se revisaron los resultados obtenidos para comprobar que fueran coherentes con cada enunciado.

No se comprobó únicamente que las consultas funcionaran, sino también que los datos devueltos tuvieran sentido. Por ejemplo, se revisó que las agrupaciones fueran correctas, que los filtros se aplicaran sobre las columnas adecuadas y que los `JOIN` no generaran duplicados innecesarios o relaciones incorrectas.

### 13. Comentarios en consultas complejas

En las consultas más difíciles se añadieron comentarios para explicar partes importantes del código, especialmente en subconsultas, uniones entre varias tablas o cálculos agregados.

Esto facilita la comprensión del código y permite que otra persona pueda entender mejor la lógica utilizada.

### 14. Revisión final del código

Por último, se realizó una revisión general de todas las consultas para comprobar:

- Que la sintaxis fuera correcta.
- Que los alias estuvieran bien definidos.
- Que las columnas calculadas tuvieran nombres claros.
- Que las consultas estuvieran ordenadas y fueran legibles.
- Que cada consulta respondiera al objetivo planteado.

## Buenas prácticas aplicadas

Durante el desarrollo de las consultas se aplicaron buenas prácticas para mejorar la calidad del código SQL:

- Se utilizaron alias claros para las tablas.
- Se nombraron las columnas calculadas con nombres descriptivos.
- Se organizaron las consultas en varias líneas para facilitar la lectura.
- Se usaron comentarios en las partes más complejas.
- Se evitaron relaciones innecesarias entre tablas.
- Se revisó que los resultados obtenidos tuvieran sentido desde el punto de vista del análisis de datos.

## Conclusión

El proyecto ha permitido construir desde cero un conjunto completo de consultas SQL aplicadas al análisis de datos. A través de los ejercicios se han trabajado consultas simples, filtros, funciones agregadas, agrupaciones, relaciones entre tablas, subconsultas, vistas y tablas temporales.

Además, se ha dado importancia a la interpretación de los resultados y al uso de buenas prácticas, para que las consultas no solo funcionen correctamente, sino que también sean claras, ordenadas y fáciles de entender.
