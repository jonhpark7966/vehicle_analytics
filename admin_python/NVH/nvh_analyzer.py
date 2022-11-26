from NVH.analyzer.channel_analyzer_factory import createChannelAnalyzer

import json

class NVHAnalyzer:
    tachoChannels = [] # RPMs & speed
    channelAnalyzers = [] 
    outputPath = ""

    def __init__(self, channelsDataModel, testType, outputPath, vehicleJsonPath):
        # extract tacho channels
        self.tachoChannels = [channel for channel in channelsDataModel if channel.unit == "km/h" or channel.unit == "rpm"]
        self.outputPath = outputPath

        # vehicle Infos
        with open(vehicleJsonPath, 'r') as file:
            self.vehicleMap = json.load(file)

        # setup channel analyzers
        for channel in channelsDataModel:
            channelAnalyzer = createChannelAnalyzer(channel, testType, self.tachoChannels, self.vehicleMap)
            if channelAnalyzer is not None:
                self.channelAnalyzers.append(channelAnalyzer)
        

    def analyze(self):
        for channelAnalyzer in self.channelAnalyzers:
            channelAnalyzer.analyzeSignalTo3()
            channelAnalyzer.analyze3to2()
            channelAnalyzer.analyze2to1()
            channelAnalyzer.export(self.outputPath)

