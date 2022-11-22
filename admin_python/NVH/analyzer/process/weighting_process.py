import math

class WeightingProcessor:
    def __init__(self, endFreq, stepFreq):
        self.aWeights = self._getAWeighting(endFreq, stepFreq)
        self.cWeights = self._getCWeighting(endFreq, stepFreq)

    def _getAWeighting(self, endFreq, stepFreq):
        weights = []
        steps = math.ceil((endFreq/stepFreq+1))
        iFreq = 0
        for iStep in range(0, steps):
            weights.append((12200 * 12200 * iFreq * iFreq * iFreq * iFreq) / ((iFreq * iFreq + 20.6 * 20.6) * math.sqrt((iFreq * iFreq + 107.7 * 107.7) * (iFreq * iFreq + 737.9 * 737.9)) * (iFreq * iFreq + 12200 * 12200)))
            iFreq = iFreq + stepFreq

        return weights

    def _getCWeighting(self, endFreq, stepFreq):
        weights = []
        steps = math.ceil((endFreq/stepFreq+1))
        iFreq = 0
        for iStep in range(0, steps):
            weights.append((12200 * 12200 * iFreq * iFreq) / ((iFreq * iFreq + 20.6 * 20.6) * (iFreq * iFreq + 12200 * 12200)))
            iFreq = iFreq + stepFreq

        return weights
     
    def processAweighting(self, data):
        ret = []
        for i in range(len(data)):
            if not self.aWeights[i] == 0.0:
                ret.append(data[i] + 2.0 + 20 * math.log10(self.aWeights[i]))
            else:
                ret.append(data[i])
        return ret
        

    def processCweighting(self, data):
        ret = []
        for i in range(len(data)):
            if not self.cWeights[i] == 0.0:
                ret.append(data[i] + 2.0 + 20 * math.log10(self.cWeights[i]))
            else:
                ret.append(data[i])
        return ret
        






    