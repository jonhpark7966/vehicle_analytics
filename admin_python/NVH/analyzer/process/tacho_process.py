
class TachoProcessor:
    def __init__(self, tachoChannels):
        self.tachoChannels = tachoChannels

    def getOrderTrackedIndices(self, key, startTacho, endTacho, deltaTacho):
        channel = self._findFromTachos(key)
        startIndex, endIndex = self._getStartEndByTacho(channel.data)
        assert startIndex < endIndex

        minTacho = channel.data[startIndex]
        maxTacho = channel.data[endIndex]

        ret = []
        targetTacho = startTacho

        # fill in front of min
        while targetTacho < minTacho:
            ret.append(-1)
            targetTacho += deltaTacho

        # find indices
        for i in range(startIndex, endIndex):
            if targetTacho > endTacho: break
            tacho = channel.data[i] 

            if tacho > targetTacho:
                ret.append(i)
                targetTacho = targetTacho + deltaTacho

        # fill out of max
        while targetTacho <= endTacho:
           ret.append(-1)
           targetTacho = targetTacho + deltaTacho
        
        return ret

    def _getStartEndByTacho(self, channelData):
        startIndex = 0
        endIndex = 0
        min = 0
        max = 0

        # find in rising sequence.
        # 1. find max (=peak) index.
        for i in range(len(channelData)):
            tacho = channelData[i]
            # error check.
            if tacho == 0: continue
            # init
            if max == 0: max = tacho

            if tacho >= max:
                max = tacho
                endIndex = i
      
        # 2. find min (=start) index
        for i in range(endIndex):
            tacho = channelData[i]
            if tacho == 0: continue
            if min == 0: min = tacho

            if tacho <= min:
                min = tacho
                startIndex = i

        return startIndex, endIndex

    def getAvergeEngineRPM(self):
        # find Engine Speed
        engineSpeedChannel = self._findFromTachos("Engine Speed")
        return sum(engineSpeedChannel.data) / len(engineSpeedChannel.data)

    def _findFromTachos(self, key):
        matches = [channel for channel in self.tachoChannels if channel.name == "Engine Speed"]
        assert (len(matches) == 1)

        return matches[0]
