
class VehicleProcessor:
    def __init__(self, vehicleMap):
        self.vehicleMap = vehicleMap 

    def getMainOrder(self):
        engineType = self.vehicleMap["engine type"]
        
        return int(engineType[1])/2