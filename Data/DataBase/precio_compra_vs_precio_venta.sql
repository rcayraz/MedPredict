IF OBJECT_ID('dbo.precio_compra_vs_precio_venta') IS NOT NULL
    DROP TABLE dbo.precio_compra_vs_precio_venta;
IF OBJECT_ID('tempdb..#precio_compra_tmp') IS NOT NULL
    DROP TABLE dbo.#precio_compra_tmp;
WITH RankedOrders AS (
    SELECT
        Descripcion_items as Descripcion,
        ROUND(PrecioUnitario, 2) AS precioUnCompra,
        FORMAT(FechaPreparación, 'yyyyMM') AS PeriodoCompra,
        Proveedor,
        FechaPreparación,
        ROW_NUMBER() OVER (
            PARTITION BY Descripcion, FORMAT(FechaPreparación, 'yyyyMM')
            ORDER BY FechaPreparación DESC
        ) AS rn
    FROM dbo.ordenes_compras_medicamentos
    WHERE EstadoOrdenCompra = 'Completada'
)
SELECT
    DISTINCT
    Descripcion,
    precioUnCompra,
    PeriodoCompra,
    Proveedor
INTO #precio_compra_tmp
FROM RankedOrders
WHERE rn = 1;
SELECT pc.*,ROUND(pv.KAYROS ,2) AS precio_venta
into dbo.precio_compra_vs_precio_venta
FROM #precio_compra_tmp as pc
inner join dbo.precio_venta as pv on ltrim(rtrim(pc.Descripcion))=ltrim(rtrim(pv.COMPONENTE)) AND

