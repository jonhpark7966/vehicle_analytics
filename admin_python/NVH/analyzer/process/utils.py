import math

class UtilsProcessor:

    def getRMSFreq(self, dataModel2D, startFreq, endFreq, referenceValue):

        endIndex = len(dataModel2D.data)
        if endFreq != 0.0:
            endIndex = (endFreq - dataModel2D.xAxisStart)/dataModel2D.xAxisDelta
        assert (len(dataModel2D.data) > (endIndex-1))

        startIndex = (startFreq - dataModel2D.xAxisStart)/dataModel2D.xAxisDelta
        assert (startIndex +1 < endIndex)

        dataToRMS = dataModel2D.data[round(startIndex):round(endIndex)]
        linear = [10**(datum/20) * referenceValue for datum in dataToRMS]

        rms = 0.0
        for i in range(1, len(linear) -1):
            rms = rms + linear[i] * linear[i]

        ratio = 0.5 + round(startIndex) - startIndex
        rms =  rms + linear[0] * linear[0] * ratio

        ratio = 0.5 + endIndex - round(endIndex)
        rms =  rms + linear[-1] * linear[-1] * ratio
        
        rms = math.sqrt(rms)
        rms = 20 * math.log10(rms / referenceValue)

        return rms

    def getRMS(self, data, referenceValue, divideByLength=True):
        ret = 0.0
        for datum in data:
            # log to linear
            linear = 10**(datum/20) * referenceValue
            ret = ret + linear * linear

        if divideByLength:
            ret = ret / len(data) 

        ret = math.sqrt(ret)
        ret = 20 * math.log10(ret / referenceValue)

        return ret



