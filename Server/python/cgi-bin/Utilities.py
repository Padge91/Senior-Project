__author__ = 'nicholaspadgett'

import json

#success response
def success_response(response):
    print("Content-type:application/json")
    print("")
    if not isinstance(response, list):
        print response.jsonify()
    else:
        print json.dumps([object.jsonify() for object in response])

#failure response
def failure_response(response):
    print("Content-type:application/json")
    print("")
    print json.dumps({"error":response})

#get request parameters
def get_required_parameters(request, required_params):
    form = request.FieldStorage()

    response = dict()
    for param in required_params:
        response[param] = form[param].value

    return response

def get_optional_parameters(request, optional_params):
    form = request.FieldStorage()

    response = dict()
    for param in optional_params:
        response[param] = form[param].value