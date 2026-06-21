/*
PROYECTO 2 - CONSULTAS SQL CORREGIDAS Y ADAPTADAS

/* 1. Crea el esquema de la BBDD.
  Archivo ya incorporado. */
CREATE SCHEMA IF NOT EXISTS proyecto_2


/* 2. Películas con clasificación por edades 'R'.*/
SELECT
    f.title
FROM film AS f
WHERE f.rating = 'R'
ORDER BY f.title;


/* 3. Actores con actor_id entre 30 y 40, ambos incluidos.*/
SELECT
    a.actor_id,
    a.first_name,
    a.last_name
FROM actor AS a
WHERE a.actor_id BETWEEN 30 AND 40
ORDER BY a.actor_id;


/* 4. Películas cuyo idioma coincide con el idioma original.
   original_language_id puede contener NULL; por eso se excluyen los nulos antes de comparar. */
SELECT
    f.title,
    l.name AS idioma
FROM film AS f
INNER JOIN language AS l
    ON f.language_id = l.language_id
WHERE f.original_language_id IS NOT NULL
  AND f.language_id = f.original_language_id
ORDER BY f.title;


/* 5. Películas ordenadas por duración ascendente.*/
SELECT
    f.title,
    f.length AS duracion_minutos
FROM film AS f
ORDER BY f.length ASC, f.title;


/* 6. Actores cuyo apellido contiene 'Allen'.
   Uso ILIKE para no depender de mayúsculas/minúsculas. */
SELECT
    a.first_name,
    a.last_name
FROM actor AS a
WHERE a.last_name ILIKE '%Allen%'
ORDER BY a.last_name, a.first_name;


/* 7. Cantidad de películas por clasificación. */
SELECT
    f.rating,
    COUNT(*) AS total_peliculas
FROM film AS f
GROUP BY f.rating
ORDER BY total_peliculas DESC, f.rating;


/* 8. Películas que son PG-13 o duran más de 3 horas.
   La duración está en minutos; 3 horas = 180 minutos. */
SELECT
    f.title,
    f.rating,
    f.length AS duracion_minutos
FROM film AS f
WHERE f.rating = 'PG-13'
   OR f.length > 180
ORDER BY f.title;


/* 9. Variabilidad del coste de reemplazo de las películas. */
SELECT
    ROUND(AVG(f.replacement_cost), 2) AS coste_reemplazo_medio,
    ROUND(STDDEV_SAMP(f.replacement_cost), 2) AS desviacion_coste_reemplazo,
    ROUND(VARIANCE(f.replacement_cost), 2) AS varianza_coste_reemplazo
FROM film AS f;


/* 10. Mayor y menor duración de una película. */
SELECT
    MIN(f.length) AS duracion_minima,
    MAX(f.length) AS duracion_maxima
FROM film AS f;


/* 11. Coste del antepenúltimo alquiler ordenado por fecha.
   OFFSET 2 devuelve el tercer registro tras ordenar. */
SELECT
    r.rental_id,
    r.rental_date,
    p.amount AS importe_pagado
FROM rental AS r
INNER JOIN payment AS p
    ON r.rental_id = p.rental_id
ORDER BY r.rental_date DESC, r.rental_id DESC
LIMIT 1 OFFSET 2;


/* 12. Películas cuya clasificación no sea NC-17 ni G. */
SELECT
    f.title,
    f.rating
FROM film AS f
WHERE f.rating NOT IN ('NC-17', 'G')
ORDER BY f.title;


/* 13. Promedio de duración por clasificación. */
SELECT
    f.rating,
    ROUND(AVG(f.length), 2) AS duracion_media
FROM film AS f
GROUP BY f.rating
ORDER BY f.rating;


/* 14. Películas con duración mayor a 180 minutos. */
SELECT
    f.title,
    f.length AS duracion_minutos
FROM film AS f
WHERE f.length > 180
ORDER BY f.length DESC, f.title;


/* 15. Dinero total generado por la empresa. */
SELECT
    ROUND(SUM(p.amount), 2) AS ingresos_totales
FROM payment AS p;


/* 16. Los 10 clientes con mayor customer_id. */
SELECT
    c.customer_id,
    c.first_name,
    c.last_name
FROM customer AS c
ORDER BY c.customer_id DESC
LIMIT 10;


/* 17. Actores que aparecen en la película 'EGG IGBY'. */
SELECT
    a.first_name,
    a.last_name,
    f.title
FROM actor AS a
INNER JOIN film_actor AS fa
    ON a.actor_id = fa.actor_id
INNER JOIN film AS f
    ON fa.film_id = f.film_id
WHERE f.title = 'EGG IGBY'
ORDER BY a.last_name, a.first_name;


/* 18. Títulos únicos de películas. */
SELECT DISTINCT
    f.title
FROM film AS f
ORDER BY f.title;


/* 19. Películas de comedia con duración mayor a 180 minutos. */
SELECT
    f.title,
    c.name AS categoria,
    f.length AS duracion_minutos
FROM film AS f
INNER JOIN film_category AS fc
    ON f.film_id = fc.film_id
INNER JOIN category AS c
    ON fc.category_id = c.category_id
WHERE c.name = 'Comedy'
  AND f.length > 180
ORDER BY f.length DESC, f.title;


/* 20. Categorías con promedio de duración superior a 110 minutos. */
SELECT
    c.name AS categoria,
    ROUND(AVG(f.length), 2) AS duracion_media
FROM category AS c
INNER JOIN film_category AS fc
    ON c.category_id = fc.category_id
INNER JOIN film AS f
    ON fc.film_id = f.film_id
GROUP BY c.name
HAVING AVG(f.length) > 110
ORDER BY duracion_media DESC;


/* 21. Media de duración del alquiler de las películas.
   rental_duration indica los días de alquiler definidos para cada película. */
SELECT
    ROUND(AVG(f.rental_duration), 2) AS media_duracion_alquiler_dias
FROM film AS f;


/* 22. Columna calculada con nombre completo de actores y actrices. */
SELECT
    CONCAT(a.first_name, ' ', a.last_name) AS nombre_completo
FROM actor AS a
ORDER BY a.last_name, a.first_name;


/* 23. Número de alquileres por día, ordenados por cantidad de alquileres descendente. */
SELECT
    DATE(r.rental_date) AS dia_alquiler,
    COUNT(*) AS numero_alquileres
FROM rental AS r
GROUP BY DATE(r.rental_date)
ORDER BY numero_alquileres DESC, dia_alquiler;


/* 24. Películas con duración superior al promedio.
   La subconsulta calcula una única media global para compararla con cada película. */
SELECT
    f.title,
    f.length AS duracion_minutos,
    ROUND((SELECT AVG(f2.length) FROM film AS f2), 2) AS duracion_media_global
FROM film AS f
WHERE f.length > (
    SELECT AVG(f2.length)
    FROM film AS f2
)
ORDER BY f.length DESC, f.title;


/* 25. Número de alquileres registrados por mes. */
SELECT
    EXTRACT(YEAR FROM r.rental_date) AS anio,
    EXTRACT(MONTH FROM r.rental_date) AS mes,
    COUNT(*) AS numero_alquileres
FROM rental AS r
GROUP BY
    EXTRACT(YEAR FROM r.rental_date),
    EXTRACT(MONTH FROM r.rental_date)
ORDER BY anio, mes;


/* 26. Promedio, desviación estándar y varianza del importe pagado. */
SELECT
    ROUND(AVG(p.amount), 2) AS promedio_pagado,
    ROUND(STDDEV_SAMP(p.amount), 2) AS desviacion_estandar,
    ROUND(VARIANCE(p.amount), 2) AS varianza
FROM payment AS p;


/* 27. Películas cuyo precio de alquiler está por encima del precio medio. */
SELECT
    f.title,
    f.rental_rate
FROM film AS f
WHERE f.rental_rate > (
    SELECT AVG(f2.rental_rate)
    FROM film AS f2
)
ORDER BY f.rental_rate DESC, f.title;


/* 28. Actores que han participado en más de 40 películas. */
SELECT
    fa.actor_id,
    COUNT(*) AS numero_peliculas
FROM film_actor AS fa
GROUP BY fa.actor_id
HAVING COUNT(*) > 40
ORDER BY numero_peliculas DESC, fa.actor_id;


/* 29. Todas las películas y cantidad de copias disponibles en inventario.
   LEFT JOIN conserva películas aunque no tengan copias en inventory. */
SELECT
    f.title,
    COUNT(i.inventory_id) AS cantidad_en_inventario
FROM film AS f
LEFT JOIN inventory AS i
    ON f.film_id = i.film_id
GROUP BY f.film_id, f.title
ORDER BY f.title;


/* 30. Actores y número de películas en las que han actuado. */
SELECT
    a.actor_id,
    a.first_name,
    a.last_name,
    COUNT(fa.film_id) AS numero_peliculas
FROM actor AS a
LEFT JOIN film_actor AS fa
    ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY numero_peliculas DESC, a.last_name, a.first_name;


/* 31. Todas las películas y los actores asociados, incluyendo películas sin actores asociados. */
SELECT
    f.title,
    a.first_name,
    a.last_name
FROM film AS f
LEFT JOIN film_actor AS fa
    ON f.film_id = fa.film_id
LEFT JOIN actor AS a
    ON fa.actor_id = a.actor_id
ORDER BY f.title, a.last_name, a.first_name;


/* 32. Todos los actores y las películas en las que han actuado.
   Se corrige el alias: se usa f.title, no film.title. */
SELECT
    a.first_name,
    a.last_name,
    f.title
FROM actor AS a
LEFT JOIN film_actor AS fa
    ON a.actor_id = fa.actor_id
LEFT JOIN film AS f
    ON fa.film_id = f.film_id
ORDER BY a.last_name, a.first_name, f.title;


/* 33. Todas las películas y sus registros de alquiler, si existen.
   Se corrige el alias de rental: se usa r en SELECT y ORDER BY. */
SELECT
    f.title,
    r.rental_id,
    r.rental_date,
    r.return_date
FROM film AS f
LEFT JOIN inventory AS i
    ON f.film_id = i.film_id
LEFT JOIN rental AS r
    ON i.inventory_id = r.inventory_id
ORDER BY f.title, r.rental_date;


/* 34. Los 5 clientes que más dinero han gastado. */
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ROUND(SUM(p.amount), 2) AS total_gastado
FROM customer AS c
INNER JOIN payment AS p
    ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_gastado DESC
LIMIT 5;


/* 35. Actores cuyo primer nombre es 'JOHNNY'. */
SELECT
    a.actor_id,
    a.first_name,
    a.last_name
FROM actor AS a
WHERE a.first_name = 'JOHNNY'
ORDER BY a.last_name;


/* 36. Renombrar columnas first_name y last_name. */
SELECT
    a.first_name AS nombre,
    a.last_name AS apellido
FROM actor AS a
ORDER BY apellido, nombre;


/* 37. ID de actor más bajo y más alto. */
SELECT
    MIN(a.actor_id) AS id_mas_bajo,
    MAX(a.actor_id) AS id_mas_alto
FROM actor AS a;


/* 38. Número total de actores. */
SELECT
    COUNT(*) AS total_actores
FROM actor AS a;


/* 39. Todos los actores ordenados por apellido ascendente. */
SELECT
    a.actor_id,
    a.first_name,
    a.last_name
FROM actor AS a
ORDER BY a.last_name ASC, a.first_name ASC;


/* 40. Primeras 5 películas de la tabla film.
   Se añade ORDER BY para que el resultado sea reproducible. */
SELECT
    f.film_id,
    f.title,
    f.release_year,
    f.rating
FROM film AS f
ORDER BY f.film_id
LIMIT 5;


/* 41. Nombres de actor más repetidos.
   La CTE calcula primero el número de actores por nombre y después selecciona el máximo. */
WITH conteo_nombres AS (
    SELECT
        a.first_name,
        COUNT(*) AS cantidad_actores
    FROM actor AS a
    GROUP BY a.first_name
)
SELECT
    cn.first_name,
    cn.cantidad_actores
FROM conteo_nombres AS cn
WHERE cn.cantidad_actores = (
    SELECT MAX(cantidad_actores)
    FROM conteo_nombres
)
ORDER BY cn.first_name;

-- Resultado observado en la base usada: Julia, Kenneth y Penelope son los nombres más repetidos.


/* 42. Alquileres y nombres de clientes que los realizaron. */
SELECT
    r.rental_id,
    r.rental_date,
    c.first_name,
    c.last_name
FROM rental AS r
INNER JOIN customer AS c
    ON r.customer_id = c.customer_id
ORDER BY r.rental_date, r.rental_id;


/* 43. Todos los clientes y sus alquileres si existen. */
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    r.rental_id,
    r.rental_date
FROM customer AS c
LEFT JOIN rental AS r
    ON c.customer_id = r.customer_id
ORDER BY c.last_name, c.first_name, r.rental_date;


/* 44. CROSS JOIN entre film y category.
   Resultado esperado: todas las combinaciones posibles película-categoría.
   No representa categorías reales; para eso se debe usar film_category. */
SELECT
    f.title,
    c.name AS categoria
FROM film AS f
CROSS JOIN category AS c
ORDER BY f.title, c.name;

-- Análisis: aporta poco valor analítico directo porque genera combinaciones teóricas, no relaciones reales.
-- Sería útil solo para construir una matriz de posibilidades o detectar combinaciones faltantes.


/* 45. Actores que han participado en películas de la categoría Action. */
SELECT DISTINCT
    a.actor_id,
    a.first_name,
    a.last_name
FROM actor AS a
INNER JOIN film_actor AS fa
    ON a.actor_id = fa.actor_id
INNER JOIN film_category AS fc
    ON fa.film_id = fc.film_id
INNER JOIN category AS c
    ON fc.category_id = c.category_id
WHERE c.name = 'Action'
ORDER BY a.last_name, a.first_name;


/* 46. Actores que no han participado en ninguna película. */
SELECT
    a.actor_id,
    a.first_name,
    a.last_name
FROM actor AS a
LEFT JOIN film_actor AS fa
    ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL
ORDER BY a.last_name, a.first_name;


/* 47. Nombre de actores y cantidad de películas en las que han participado. */
SELECT
    a.first_name,
    a.last_name,
    COUNT(fa.film_id) AS cantidad_peliculas
FROM actor AS a
LEFT JOIN film_actor AS fa
    ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY cantidad_peliculas DESC, a.last_name, a.first_name;


/* 48. Vista actor_num_peliculas.
   CREATE OR REPLACE permite volver a ejecutar el script sin error si la vista ya existe. */
CREATE OR REPLACE VIEW actor_num_peliculas AS
SELECT
    a.first_name,
    a.last_name,
    COUNT(fa.film_id) AS numero_peliculas
FROM actor AS a
LEFT JOIN film_actor AS fa
    ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;


/* 49. Número total de alquileres realizados por cada cliente.
   Se corrige el uso de alias: c y r deben usarse de forma consistente. */
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS total_alquileres
FROM customer AS c
LEFT JOIN rental AS r
    ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_alquileres DESC, c.last_name, c.first_name;


/* 50. Duración total de las películas de la categoría Action. */
SELECT
    c.name AS categoria,
    SUM(f.length) AS duracion_total_minutos
FROM category AS c
INNER JOIN film_category AS fc
    ON c.category_id = fc.category_id
INNER JOIN film AS f
    ON fc.film_id = f.film_id
WHERE c.name = 'Action'
GROUP BY c.name;


/* 51. Tabla temporal con el total de alquileres por cliente.
   DROP evita errores al ejecutar varias veces en la misma sesión. */
DROP TABLE IF EXISTS cliente_rentas_temporal;

CREATE TEMPORARY TABLE cliente_rentas_temporal AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS total_alquileres
FROM customer AS c
LEFT JOIN rental AS r
    ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- Comprobación:
SELECT *
FROM cliente_rentas_temporal
ORDER BY total_alquileres DESC, last_name, first_name;


/* 52. Tabla temporal con películas alquiladas al menos 10 veces. */
DROP TABLE IF EXISTS peliculas_alquiladas;

CREATE TEMPORARY TABLE peliculas_alquiladas AS
SELECT
    f.film_id,
    f.title,
    COUNT(r.rental_id) AS veces_alquilada
FROM film AS f
INNER JOIN inventory AS i
    ON f.film_id = i.film_id
INNER JOIN rental AS r
    ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
HAVING COUNT(r.rental_id) >= 10;

-- Comprobación:
SELECT *
FROM peliculas_alquiladas
ORDER BY veces_alquilada DESC, title;


/* 53. Películas alquiladas por Tammy Sanders y aún no devueltas. */
SELECT
    f.title
FROM customer AS c
INNER JOIN rental AS r
    ON c.customer_id = r.customer_id
INNER JOIN inventory AS i
    ON r.inventory_id = i.inventory_id
INNER JOIN film AS f
    ON i.film_id = f.film_id
WHERE c.first_name = 'TAMMY'
  AND c.last_name = 'SANDERS'
  AND r.return_date IS NULL
ORDER BY f.title;


/* 54. Actores que han actuado en al menos una película Sci-Fi. */
SELECT DISTINCT
    a.first_name,
    a.last_name
FROM actor AS a
INNER JOIN film_actor AS fa
    ON a.actor_id = fa.actor_id
INNER JOIN film_category AS fc
    ON fa.film_id = fc.film_id
INNER JOIN category AS c
    ON fc.category_id = c.category_id
WHERE c.name = 'Sci-Fi'
ORDER BY a.last_name, a.first_name;


/* 55. Actores en películas alquiladas después del primer alquiler de SPARTACUS CHEAPER.
   La subconsulta obtiene la primera fecha de alquiler de esa película. */
SELECT DISTINCT
    a.first_name,
    a.last_name
FROM actor AS a
INNER JOIN film_actor AS fa
    ON a.actor_id = fa.actor_id
INNER JOIN film AS f
    ON fa.film_id = f.film_id
INNER JOIN inventory AS i
    ON f.film_id = i.film_id
INNER JOIN rental AS r
    ON i.inventory_id = r.inventory_id
WHERE r.rental_date > (
    SELECT MIN(r2.rental_date)
    FROM film AS f2
    INNER JOIN inventory AS i2
        ON f2.film_id = i2.film_id
    INNER JOIN rental AS r2
        ON i2.inventory_id = r2.inventory_id
    WHERE f2.title = 'SPARTACUS CHEAPER'
)
ORDER BY a.last_name, a.first_name;


/* 56. Actores que no han actuado en ninguna película de la categoría Music.
   NOT EXISTS evita problemas si la subconsulta pudiera devolver valores NULL. */
SELECT
    a.first_name,
    a.last_name
FROM actor AS a
WHERE NOT EXISTS (
    SELECT 1
    FROM film_actor AS fa
    INNER JOIN film_category AS fc
        ON fa.film_id = fc.film_id
    INNER JOIN category AS c
        ON fc.category_id = c.category_id
    WHERE fa.actor_id = a.actor_id
      AND c.name = 'Music'
)
ORDER BY a.last_name, a.first_name;


/* 57. Películas alquiladas por más de 8 días.
   Solo se consideran alquileres devueltos porque se necesita return_date. */
SELECT DISTINCT
    f.title
FROM film AS f
INNER JOIN inventory AS i
    ON f.film_id = i.film_id
INNER JOIN rental AS r
    ON i.inventory_id = r.inventory_id
WHERE r.return_date IS NOT NULL
  AND r.return_date - r.rental_date > INTERVAL '8 days'
ORDER BY f.title;


/* 58. Películas de la categoría Animation.
   El enunciado habla de 'Animation' como categoría, no como título de película. */
SELECT DISTINCT
    f.title
FROM film AS f
INNER JOIN film_category AS fc
    ON f.film_id = fc.film_id
INNER JOIN category AS c
    ON fc.category_id = c.category_id
WHERE c.name = 'Animation'
ORDER BY f.title;


/* 59. Películas con la misma duración que DANCING FEVER. */
SELECT
    f.title,
    f.length AS duracion_minutos
FROM film AS f
WHERE f.length = (
    SELECT f2.length
    FROM film AS f2
    WHERE f2.title = 'DANCING FEVER'
)
ORDER BY f.title;


/* 60. Clientes que han alquilado al menos 7 películas distintas. */
SELECT
    c.first_name,
    c.last_name,
    COUNT(DISTINCT i.film_id) AS peliculas_distintas
FROM customer AS c
INNER JOIN rental AS r
    ON c.customer_id = r.customer_id
INNER JOIN inventory AS i
    ON r.inventory_id = i.inventory_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT i.film_id) >= 7
ORDER BY c.last_name, c.first_name;


/* 61. Total de películas alquiladas por categoría. */
SELECT
    c.name AS categoria,
    COUNT(r.rental_id) AS total_alquileres
FROM category AS c
INNER JOIN film_category AS fc
    ON c.category_id = fc.category_id
INNER JOIN film AS f
    ON fc.film_id = f.film_id
INNER JOIN inventory AS i
    ON f.film_id = i.film_id
INNER JOIN rental AS r
    ON i.inventory_id = r.inventory_id
GROUP BY c.name
ORDER BY total_alquileres DESC, c.name;


/* 62. Número de películas por categoría estrenadas en 2006. */
SELECT
    c.name AS categoria,
    COUNT(f.film_id) AS numero_peliculas
FROM category AS c
INNER JOIN film_category AS fc
    ON c.category_id = fc.category_id
INNER JOIN film AS f
    ON fc.film_id = f.film_id
WHERE f.release_year = 2006
GROUP BY c.name
ORDER BY numero_peliculas DESC, c.name;


/* 63. Todas las combinaciones posibles de trabajadores con tiendas.
   CROSS JOIN tiene sentido si se quieren ver todas las asignaciones posibles, no las reales. */
SELECT
    s.staff_id,
    s.first_name,
    s.last_name,
    st.store_id
FROM staff AS s
CROSS JOIN store AS st
ORDER BY s.staff_id, st.store_id;


/* 64. Cantidad total de películas alquiladas por cada cliente.
   Aquí se cuenta cada alquiler registrado. Si se quisiera contar títulos distintos, se usaría COUNT(DISTINCT i.film_id). */
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS cantidad_peliculas_alquiladas
FROM customer AS c
LEFT JOIN rental AS r
    ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY cantidad_peliculas_alquiladas DESC, c.last_name, c.first_name;
