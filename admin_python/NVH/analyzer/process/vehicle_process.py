import math

class VehicleProcessor:
    def __init__(self, vehicleMap):
        self.vehicleMap = vehicleMap 

    def getMainOrder(self):
        engineType = self.vehicleMap["engine type"]
        
        return int(engineType[1])/2

    def getSpeedToTireRatio(self):
        tireWidth = float(self.vehicleMap["front tire width"])/1000
        aspectRatio = float(self.vehicleMap["front tire aspect ratio"])/100
        tireRim = float(self.vehicleMap["front tire rim"])*0.0254

        circumference = math.pi(2*tireWidth*aspectRatio + tireRim)
        return (1000/60) / circumference
    
    def getSpeedToTireRatio(self):
        tireWidth = float(self.vehicleMap["front tire width"])/1000
        aspectRatio = float(self.vehicleMap["front tire aspect ratio"])/100
        tireRim = float(self.vehicleMap["front tire rim"])*0.0254

        circumference = math.pi(2*tireWidth*aspectRatio + tireRim)
        return (1000/60) / circumference
    
    def getSpeedToPropellerShaftRatio(self):
        if not self.isPropellerExist():
            return 0.0 # no propeller

        fgr = float(self.vehicleMap["FGR"])
        return self.getSpeedToTireRatio()*fgr
    
    def isPropellerExist(self):
        # EV -> no propeller 
        if self.vehicleMap["fuel type"] == "EV":
            return False
        # FR -> propeller exists
        if self.vehicleMap["car layout"] == "FR":
            return True
        # FF & 2Wd -> no propeller
        if self.vehicleMap["wheel drive"] == "2WD":
            return False
        return True
    

