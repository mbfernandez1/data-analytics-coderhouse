/*
    ENTREGABLE 5 - CONSULTAS CON JOINS PARA EL PROYECTO
    Proyecto: RetailPro
    Base de datos: Ventas_Tech_DB
*/

USE Ventas_Tech_DB;


-- CONSULTA 1 - VISTA BASE DEL PROYECTO (INNER JOIN)
-- Reune en una sola consulta los datos de ventas, clientes, productos
-- y categorias. Esta consulta podra utilizarse como fuente para Power BI.

SELECT
    v.id_venta,
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.email,
    c.ciudad,
    p.id_producto,
    p.nombre_producto,
    ca.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta
FROM ventas AS v
INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos AS p
    ON v.id_producto = p.id_producto
INNER JOIN categorias AS ca
    ON p.id_categoria = ca.id_categoria
ORDER BY v.fecha_venta, v.id_venta;


-- CONSULTA 2 - CLIENTES SIN VENTAS (LEFT JOIN)
-- Busca clientes registrados que todavia no realizaron ninguna compra.

SELECT
    c.nombre AS nombre_cliente,
    c.email,
    c.fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL
ORDER BY c.nombre;


-- CONSULTA 3 - PRODUCTOS SIN VENTAS (LEFT JOIN)
-- Busca productos del catalogo que no aparecen en ninguna venta.

SELECT
    p.nombre_producto,
    ca.nombre_categoria AS categoria,
    p.precio
FROM productos AS p
INNER JOIN categorias AS ca
    ON p.id_categoria = ca.id_categoria
LEFT JOIN ventas AS v
    ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL
ORDER BY p.nombre_producto;


-- CONSULTA 4 - CONSOLIDADO POR CANAL (UNION ALL)
-- Como la tabla ventas no posee una columna canal, se crea una etiqueta
-- literal para cada periodo. El primer periodo contiene las ventas previas
-- al 10 de marzo y el segundo, las ventas desde esa fecha en adelante.

WITH ventas_con_canal AS (
    SELECT
        fecha_venta AS fecha,
        cantidad * precio_unitario AS total,
        'Periodo inicial' AS canal
    FROM ventas
    WHERE fecha_venta < '2024-03-10'

    UNION ALL

    SELECT
        fecha_venta AS fecha,
        cantidad * precio_unitario AS total,
        'Periodo final' AS canal
    FROM ventas
    WHERE fecha_venta >= '2024-03-10'
)
SELECT
    canal,
    COUNT(*) AS cantidad_ventas,
    SUM(total) AS total_facturado
FROM ventas_con_canal
GROUP BY canal
ORDER BY canal;


/*
RESULTADOS ESPERADOS CON LOS DATOS DEL ENTREGABLE 3

- La Consulta 1 devuelve las 10 ventas enriquecidas con los datos del
  cliente, el producto y su categoria.

- La Consulta 2 no devuelve filas porque los 5 clientes registraron ventas.

- La Consulta 3 no devuelve filas porque los 6 productos tienen al menos
  una venta registrada.

- La Consulta 4 devuelve:
    Periodo inicial: 4 ventas y $3.230 facturados.
    Periodo final:   6 ventas y $3.214 facturados.
*/