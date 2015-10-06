__author__ = 'nicholaspadgett'

import json

#success response
def success_response(response):
    print("Content-type:application/json")
    print("")
    if isinstance(response, dict):
        print json.dumps(response)
    elif not isinstance(response, list):
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
        if param not in form:
            raise Exception(param +" is required")
        response[param] = form[param].value

    return response
