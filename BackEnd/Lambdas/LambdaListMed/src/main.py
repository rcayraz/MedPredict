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
        headers = {
        "Access-Control-Allow-Origin": "*",  # Permite solicitudes de cualquier origen
        "Access-Control-Allow-Methods": "OPTIONS, GET, POST, PUT, DELETE",  # Métodos permitidos
        "Access-Control-Allow-Headers": "Content-Type, X-Amz-Date, Authorization, X-Api-Key, X-Amz-Security-Token",  # Headers permitidos
        "Access-Control-Allow-Credentials": "true"  # Permite credenciales en las solicitudes
    }
        return {"statusCode": 200, 
                
        'headers': headers,
                "body": result}
    except KeyError as e:
        return { "estatusCode":500,
                "body":"Error en el resquest"
            
        }
