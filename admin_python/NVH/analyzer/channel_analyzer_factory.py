from NVH.analyzer.nvh_test_type import NVHTestType
from NVH.analyzer.accel_channel_analyzer import *
from NVH.analyzer.idle_channel_analyzer import *
from NVH.channel_data_model import SignalType



# Factory Method
def createChannelAnalyzer(channelDataModel, testType, tachoChannels, vehicleMap):
        
    if testType == NVHTestType.Idle:
        if channelDataModel.getType() == SignalType.Noise:
            return IdleNoiseAnalyzer(channelDataModel, tachoChannels, vehicleMap)
        elif channelDataModel.getType() == SignalType.Vibration:
            return IdleVibrationAnalyzer(channelDataModel, tachoChannels, vehicleMap)

    elif testType == NVHTestType.Accel:
        if channelDataModel.getType() == SignalType.Noise:
            return AccelNoiseAnalyzer(channelDataModel, tachoChannels, vehicleMap)
        elif channelDataModel.getType() == SignalType.Vibration:
            return AccelVibrationAnalyzer(channelDataModel, tachoChannels, vehicleMap)


    #assert False # TODO handle for not nvh channel.

    return None

