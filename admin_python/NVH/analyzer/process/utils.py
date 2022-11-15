import math

class UtilsProcessor:

    def getRMS(self, data, options):
        ret = 0.0
        for datum in data:
            # log to linear
            linear = 10**(datum/20) * options.referenceValue
            ret = ret + linear * linear
        
        ret = math.sqrt(ret / len(data))
        ret = 20 * math.log10(ret / options.referenceValue)

        return ret


