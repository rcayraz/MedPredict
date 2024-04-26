SET LANGUAGE Spanish;

-- Crear la tabla temporal para datos agregados
IF OBJECT_ID('tempdb..#reporte_costo_medicamentos_temp') IS NOT NULL
    DROP TABLE #reporte_costo_medicamentos_temp;

SELECT 
    ROUND(SUM(total), 2) AS MontoTotal,
    Proveedor,
    FormadePago,
    YEAR(FechaPreparación) AS Año,
    MONTH(FechaPreparación) as MesNum,
    DATENAME(month, FechaPreparación) AS Mes
INTO #reporte_costo_medicamentos_temp
FROM dbo.ordenes_compras_medicamentos where EstadoOrdenCompra in ('Cerrada','Completada','Aprobada')
GROUP BY 
    Proveedor,
    FormadePago,
    YEAR(FechaPreparación),
    DATENAME(month, FechaPreparación), MONTH(FechaPreparación);

-- Verificar si la tabla final ya existe y eliminarla si es necesario
IF OBJECT_ID('dbo.reporte_costo_medicamentos') IS NOT NULL
    DROP TABLE dbo.reporte_costo_medicamentos;

-- Crear la tabla final usando la tabla temporal
SELECT
    MontoTotal,
    Proveedor,
    FormadePago,
    Año,
    Mes,
    MesNum,
    LAG(MontoTotal, 1, 0) OVER (
        PARTITION BY Proveedor, FormadePago 
        ORDER BY Año, CONVERT(int, MONTH(CAST(Mes + ' 1900' AS date)))
    ) AS Proyeccion
INTO dbo.reporte_costo_medicamentos
FROM #reporte_costo_medicamentos_temp
ORDER BY Proveedor, FormadePago, Año, Mes;

-- Eliminar la tabla temporal si ya no se necesita
DROP TABLE #reporte_costo_medicamentos_temp;