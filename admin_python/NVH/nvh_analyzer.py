from NVH.analyzer.channel_analyzer_factory import createChannelAnalyzer

class NVHAnalyzer:
    tachoChannels = [] # RPMs & speed
    channelAnalyzers = [] 
    outputPath = ""

    def __init__(self, channelsDataModel, testType, outputPath):
        # extract tacho channels
        self.tachoChannels = [channel for channel in channelsDataModel if channel.unit == "kph" or channel.unit == "rpm"]
        self.outputPath = outputPath

        # setup channel analyzers
        for channel in channelsDataModel:
            channelAnalyzer = createChannelAnalyzer(channel, testType, self.tachoChannels)
            if channelAnalyzer is not None:
                self.channelAnalyzers.append(channelAnalyzer)

    def analyze(self):
        for channelAnalyzer in self.channelAnalyzers:
            channelAnalyzer.analyzeSignalTo3()
            channelAnalyzer.export(self.outputPath)
