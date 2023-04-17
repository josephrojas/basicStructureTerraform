import json

def lambda_handler(event,context):
    return {
        "statuscode" : 200,
        "body" : json.dumps("Hola Mundo")
    }