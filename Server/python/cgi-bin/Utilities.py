__author__ = 'nicholaspadgett'

import json
import decimal
import os

#success response
def success_response(response):
    print("Content-type:application/json")
    print("")
    if response is True or response is False:
        print json.dumps({"success":True, "response":response},default=decimal_default)
    elif isinstance(response, dict):
        print json.dumps({"success":True, "response":response},default=decimal_default)
    elif isinstance(response, str):
        print json.dumps({"success":True, "response":response},default=decimal_default)
    elif isinstance(response, int):
        print json.dumps({"success":True, "response":response},default=decimal_default)
    elif not isinstance(response, list):
        print json.dumps({"success":True, "response":response.jsonify()},default=decimal_default)
    else:
        print json.dumps({"success":True, "response":[object.jsonify() for object in response]},default=decimal_default)

#failure response
def failure_response(response):
    print("Content-type:application/json")
    print("")
    print json.dumps({"success":False,"response":response},default=decimal_default)

def json_request(form, required_params):
    response = str(form)[str(form).index("{"):str(form).index("}")+1]
    response = json.loads(response)

    for param in required_params:
        if param not in response:
            raise Exception(param +" is required")
        response[param] = response[param]

    return response



#get request parameters
def get_required_parameters(request, required_params):
    form = request.FieldStorage()

    if os.environ is not None:
        if "CONTENT_TYPE" in os.environ:
            if os.environ["CONTENT_TYPE"] is not None:
                if "application/json" in os.environ["CONTENT_TYPE"]:
                    return json_request(form, required_params)

    response = dict()
    for param in required_params:
        if param not in form:
            raise Exception(param +" is required")
        response[param] = form[param].value

    return response

def decimal_default(obj):
    if isinstance(obj, decimal.Decimal):
        return float(obj)
    raise TypeError