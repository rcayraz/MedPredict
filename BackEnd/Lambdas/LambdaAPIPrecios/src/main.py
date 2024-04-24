import json
import pandas as pd
import pyarrow.parquet as pq
from s3fs import S3FileSystem

def lambda_handler(event, context):
    s3 = S3FileSystem(anon=False)
    bucket_name = "medpredict"
    file_key = "data_files/precios_vs.parquet"
    file_path = f's3://{bucket_name}/{file_key}'
    df = pd.read_parquet(file_path, filesystem=s3)
    try:
        body = event.get('body',None)
        if body is None:
            return {"statusCode":400 , "body":"requiere el body en el request"}
        descripcion = json.loads(body)
        descripcion = descripcion.get('Descripcion')
        filtered_df = df[df['descripcion_columna'].str.contains(descripcion)]
        result = filtered_df.to_json(orient='records')
        return {"statusCode": 200, "body": json.dumps(result)}
    except KeyError as e:
        return e
        

