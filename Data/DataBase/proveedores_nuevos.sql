
WITH UltimosTresPeriodos AS (
    SELECT DISTINCT TOP 4  Periodo
    FROM evaluacion_proveedores
    ORDER BY Periodo DESC 
),
ProveedoresUltimosTresPeriodos AS (
    SELECT Proveedor
    FROM evaluacion_proveedores
    WHERE Periodo IN (SELECT Periodo FROM UltimosTresPeriodos)
),
ProveedoresAnteriores AS (
    SELECT Proveedor
    FROM evaluacion_proveedores
    WHERE Periodo NOT IN (SELECT Periodo FROM UltimosTresPeriodos)
)
SELECT DISTINCT PUP.Proveedor, 'Nuevos' as Estado INTO dbo.proveedores_Nuevos
FROM ProveedoresUltimosTresPeriodos PUP
LEFT JOIN ProveedoresAnteriores PA ON PUP.Proveedor = PA.Proveedor
WHERE PA.Proveedor IS NULL;