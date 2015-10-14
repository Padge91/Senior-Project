__author__ = 'nicholaspadgett'

import json
import decimal

#success response
def success_response(response):
    print("Content-type:application/json")
    print("")
    if response is True:
        print json.dumps({"success":True},default=decimal_default)
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

#get request parameters
def get_required_parameters(request, required_params):
    form = request.FieldStorage()

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