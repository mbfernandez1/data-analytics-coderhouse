ENTREGABLE 4 - CONSULTAS SQL DE NEGOCIO
    Proyecto: RetailPro
    Base de datos: Ventas_Tech_DB
    

    Nota de compatibilidad:
    La consigna propone EXTRACT(MONTH FROM fecha_venta), sintaxis propia
    de PostgreSQL. Como la base del Entregable 3 fue creada en SQL Server,
    en este archivo se utiliza su equivalente: MONTH(fecha_venta).
*/

USE Ventas_Tech_DB;


-- CONSULTA 1 - RESUMEN EJECUTIVO MENSUAL
-- Muestra el total facturado, la cantidad de pedidos y el ticket promedio
-- de cada mes.

SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;


-- CONSULTA 2 - RANKING DE PRODUCTOS
-- Devuelve los cinco productos con mayor facturacion, junto con las
-- unidades vendidas y el importe total generado.

SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;


-- CONSULTA 3 - CLIENTES RECURRENTES
-- Identifica a los clientes que realizaron mas de un pedido.

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;


-- CONSULTA 4 - MESES POR ENCIMA O POR DEBAJO DEL PROMEDIO
-- Primero calcula la facturacion de cada mes y luego la compara con el
-- promedio mensual general.

WITH facturacion_mensual AS (
    SELECT
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)
SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM facturacion_mensual)
            THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio_mensual
FROM facturacion_mensual
ORDER BY mes;


/*
HALLAZGOS

1. En marzo se registraron 10 pedidos por un total facturado de $6.444,
   con un ticket promedio de $644,40 por pedido.

2. El producto con ID 1 lidera el ranking: genero $3.600 mediante la venta
   de 3 unidades y concentro aproximadamente el 55,87% de la facturacion.

3. Los cinco clientes incluidos en la base realizaron 2 pedidos cada uno.
   El cliente con ID 1 fue el de mayor gasto acumulado, con $2.640.

Observacion: la base solo contiene ventas de marzo de 2024. Por ese motivo,
la comparacion entre meses todavia no permite identificar meses realmente
superiores o inferiores al promedio. Con la regla binaria solicitada, marzo
queda etiquetado como 'Por debajo' porque su facturacion es igual, y no
superior, al unico promedio mensual disponible.
*/