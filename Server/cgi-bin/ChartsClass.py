__author__ = 'nicholaspadgett'

class Chart(object):
    def __init__(self, name, objects):
        self.name = name
        self.objects = objects

    def jsonify(self):
        obj = self.__dict__

        if self.objects is not None:
            obj["objects"] = [object.jsonify() for object in self.objects]
        return obj