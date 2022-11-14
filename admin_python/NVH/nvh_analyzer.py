from NVH.analyzer.channel_analyzer_factory import createChannelAnalyzer



class NVHAnalyzer:
    tachoChannels = [] # RPMs & speed
    channelAnalyzers = [] 

    def __init__(self, channelsDataModel, testType):
        # extract tacho channels
        self.tachoChannels = [channel for channel in channelsDataModel if channel.unit == "kph" or channel.unit == "rpm"]

        # setup channel analyzers
        for channel in channelsDataModel:
            self.channelAnalyzers.append(createChannelAnalyzer(channel, testType, self.tachoChannels))

    def analyze(self):
        for channelAnalyzer in self.channelAnalyzers:
            channelAnalyzer.analyzeSignalTo3()
