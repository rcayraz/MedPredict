-- Eliminar la tabla si existe
DROP TABLE IF EXISTS stage.ordenes_compras;

-- Crear la tabla con los datos requeridos
CREATE TABLE stage.ordenes_compras AS
WITH temp1 AS (
    SELECT
        ch."OrdenCompra" AS "OrdenCompra",
        im."Descripcion" AS "Descripcion",
        ch."CantidadPedida" AS CantidadPedida,
        ch."CantidadRecibida" as   CantidadRecibida,
        ch."PrecioUnitario" as PrecioUnitario,
        ch."Total" as MontoTotalPagado,
        ch."Estado Orden de  Compra" AS EstadoOrdenCompra,
        ch."Proveedor" as Proveedor,
        ch."Fecha Preparación" AS fecha_preparacion,
        ch."Fecha Entrega" AS fecha_entrega
    FROM raw.compras_historicas ch
    INNER JOIN items_medicamentos im ON ch."Item" = im."Item"
)
SELECT
    t1.*,
    ordm."Numero" AS "numero_compra",
    ordm."Forma_Pago" AS "Forma_Pago"
FROM temp1 t1
LEFT JOIN ordenes_compras_med_form_pag ordm ON t1."OrdenCompra" = CASE
    WHEN ordm."Numero" ~ '^\d+$' THEN CAST(ordm."Numero" AS INTEGER)
    ELSE NULL
END
commit