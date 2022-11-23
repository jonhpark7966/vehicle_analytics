
class TachoProcessor:
    def __init__(self, tachoChannels):
        self.tachoChannels = tachoChannels

    def getAvergeEngineRPM(self):
        # find Engine Speed
        engineSpeedChannel = self._findFromTachos("Engine Speed")
        return sum(engineSpeedChannel.data) / len(engineSpeedChannel.data)

    def _findFromTachos(self, key):
        matches = [channel for channel in self.tachoChannels if channel.name == "Engine Speed"]
        assert (len(matches) == 1)

        return matches[0]




