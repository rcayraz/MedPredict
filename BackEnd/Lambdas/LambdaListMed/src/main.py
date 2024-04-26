import json
import pandas as pd
from s3fs import S3FileSystem

def lambda_handler(event, context):
    # Inicializar conexión a S3 solo una vez (considera usar variables de entorno o AWS Lambda Layers)
    s3 = S3FileSystem(anon=False)
    bucket_name = "medpredict"
    file_key = "data_files/precios_vs.parquet"
    file_path = f's3://{bucket_name}/{file_key}'
    df = pd.read_parquet(file_path, filesystem=s3)

    try:
        
        filtered_df=df['Descripcion'].unique().tolist()
        result = json.dumps(filtered_df)
        return {"statusCode": 200, 
                
        'headers': {
            'Content-Type': 'application/json'
        },
                "body": result}
    except KeyError as e:
        return { "estatusCode":500,
                "body":"Error en el resquest"
            
        }
