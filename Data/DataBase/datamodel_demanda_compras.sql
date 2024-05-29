
WITH LIST_ITEMS AS (
SELECT DISTINCT t1.CODIGO ,PERIODO 
FROM precio_venta   t1
JOIN (
    SELECT CODIGO, MAX(PERIODO) AS ultimo_periodo
    FROM precio_venta
    GROUP BY CODIGO
) t2 ON t1.CODIGO = t2.CODIGO AND t1.PERIODO = t2.ultimo_periodo
WHERE t1.PERIODO > 202301),
items_med as (
SELECT it.Descripcion as item_descricion,it.item  FROM  LIST_ITEMS  AS li  INNER JOIN  dbo.items_medicamentos as it on li.codigo=it.Item)
,items_order as (
select ch.*  from items_med as im left join dbo.compras_hitoricas as ch on im.item = ch.Item_Commodity)
SELECT oc.* , fp.FormadePago ,fp.Observaciones ,fp.RazonRechazo 
into dbo.datamodel_demanda_compras
from items_order as oc left join ordenes_compras_med_form_pag   as fp on oc.OrdenCompra= fp.Numero 
