

class DataModel1D:
    def __init__(self, unit, data):
        self.unit = unit
        self.data = data
    
    def getString(self):
        return str(self.data) + " " + self.unit

