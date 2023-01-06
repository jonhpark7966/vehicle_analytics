from NVH.analyzer.nvh_test_type import NVHTestType
from .test.accel_channel_analyzer import *
from .test.idle_channel_analyzer import *
from .test.cruise_channel_analyzer import *
from .test.wot_channel_analyzer import *


from NVH.channel_data_model import SignalType



# Factory Method
def createChannelAnalyzer(channelDataModel, testType, tachoChannels, vehicleMap):
        
    if testType == NVHTestType.Idle:
        if channelDataModel.getType() == SignalType.Noise:
            return IdleNoiseAnalyzer(channelDataModel, tachoChannels, vehicleMap)
        elif channelDataModel.getType() == SignalType.Vibration:
            return IdleVibrationAnalyzer(channelDataModel, tachoChannels, vehicleMap)

    
    elif testType == NVHTestType.Cruise:
        if channelDataModel.getType() == SignalType.Noise:
            return CruiseNoiseAnalyzer(channelDataModel, tachoChannels, vehicleMap)
        elif channelDataModel.getType() == SignalType.Vibration:
            return CruiseVibrationAnalyzer(channelDataModel, tachoChannels, vehicleMap)

    elif testType == NVHTestType.Accel:
        if channelDataModel.getType() == SignalType.Noise:
            return AccelNoiseAnalyzer(channelDataModel, tachoChannels, vehicleMap)
        elif channelDataModel.getType() == SignalType.Vibration:
            return AccelVibrationAnalyzer(channelDataModel, tachoChannels, vehicleMap)

    elif testType == NVHTestType.WOT:
        if channelDataModel.getType() == SignalType.Noise:
            return WOTNoiseAnalyzer(channelDataModel, tachoChannels, vehicleMap)
        elif channelDataModel.getType() == SignalType.Vibration:
            return WOTVibrationAnalyzer(channelDataModel, tachoChannels, vehicleMap)




    #assert False # TODO handle for not nvh channel.

    return None

