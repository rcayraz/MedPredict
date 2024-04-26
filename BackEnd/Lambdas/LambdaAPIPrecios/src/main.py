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
        body = json.loads(event['body'])
        print('body enviado es :',body,'\n')
        if not body:
            return {"statusCode": 400, "body": json.dumps("Requiere el body en el request")}
        
        # Correctamente obtener la descripción
        descripcion = body['Descripcion']
        print('valor del body :::::::',descripcion)
        if descripcion is None:
            return {"statusCode": 400, "body": json.dumps("Descripción no proporcionada")}

        # Usar la descripción según sea necesario
        # Ejemplo: filtrar o procesar datos
        filtered_df = df.loc[df['Descripcion'] == descripcion]
        result = filtered_df.to_json(orient='records')
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
        return {"statusCode": 500, "body": json.dumps(f"Error de clave: {str(e)}")}
