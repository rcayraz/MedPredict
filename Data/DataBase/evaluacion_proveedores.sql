WITH BASE AS (
select  count(1) as count_orders,Proveedor ,EstadoOrdenCompra ,FechaPreparación AS FechaInicio ,FechaEntrega as FechaFin ,ISNULL(REPLACE(RazonRechazo,'.',' ') ,'SIN MOTIVO') AS Motivo,
DATEDIFF(day, FechaPreparación, FechaEntrega) AS TiempoCumplimiento from  dbo.datamodel_demanda_compras   group by Proveedor ,EstadoOrdenCompra ,FechaPreparación,FechaEntrega,RazonRechazo
), puntuaciones as (SELECT 
        Proveedor,EstadoOrdenCompra,FechaInicio,count_orders,
        SUM(
            CASE 
                WHEN EstadoOrdenCompra = 'Completada' THEN 
                    CASE 
                        WHEN TiempoCumplimiento <= 5 THEN 10
                        WHEN TiempoCumplimiento <= 10 THEN 7
                        ELSE 5
                    END
                WHEN EstadoOrdenCompra = 'Anulada' THEN 
                    CASE 
                        WHEN Motivo LIKE '%STOCK%' THEN -5
                        ELSE -3
                    END
                ELSE 0
            END
        ) AS PuntuacionTotal
    FROM (
        SELECT 
            Proveedor,count_orders,
            EstadoOrdenCompra,
            FechaInicio,
            DATEDIFF(day, ISNULL(FechaInicio, '2000-01-01'), ISNULL(FechaFin, '2000-01-01')) AS TiempoCumplimiento,
            Motivo
        FROM BASE
    ) AS T
    GROUP BY Proveedor,EstadoOrdenCompra,FechaInicio,count_orders
) , pre_data as(
SELECT 
    Proveedor,EstadoOrdenCompra,FechaInicio,FORMAT(FechaInicio, 'yyyyMM') AS Periodo,count_orders,
    CAST(10 * (CAST(PuntuacionTotal AS FLOAT) - MIN(PuntuacionTotal) OVER()) / (MAX(PuntuacionTotal) OVER() - MIN(PuntuacionTotal) OVER()) AS DECIMAL(10, 2)) + 1 AS PuntuacionFinal
FROM puntuaciones)
select proveedor ,EstadoOrdenCompra, Periodo, avg(PuntuacionFinal)  as Puntuacion ,sum(count_orders) as ordenes_compras into dbo.evaluacion_proveedores from pre_data group by  proveedor ,EstadoOrdenCompra, Periodo
