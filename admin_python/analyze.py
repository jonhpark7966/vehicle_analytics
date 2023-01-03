import argparse
from files_organizer import FileOrganizer
from vms_file_handler.vms_excel_converter import BrakingExcelConverter, PassingAccelExcelConverter, StartingAccelExcelConverter
from vms_file_handler.vms_html_converter import AccelHtmlConverter, BrakeHtmlConverter

from NVH.hdf_reader import *
from NVH.nvh_analyzer import *
from NVH.analyzer.nvh_test_type import NVHTestType

from pathlib import Path
import os

def nvhAnalyze(fileList, type, dst):
    for file in fileList:
        hdf = HdfReader(file)
        basename = os.path.basename(file)

        hdf.parseSync()
        path = args.path+"/outputs/" +  dst + "/" + basename
        Path(path).mkdir(parents=True, exist_ok=True)
        for ch in hdf.channels:
            if ch.frequency > 10000: # only for NVH channel.
                ch.toMP3File(path)
    
        analyzer = NVHAnalyzer(hdf.channels,type, path, organizer.vehicleJsonPath)
        analyzer.analyze()




# Shell Caller
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Analyze')
    parser.add_argument('--path', type=str, default=".")
    parser.add_argument('--test', type=str, default="performance")

    args = parser.parse_args()


    organizer = FileOrganizer(args.path)
    errormsg = organizer.checkFiles()

    if args.test == "performance":
        startingAccelConverter = StartingAccelExcelConverter(organizer.performanceStartingAccelRawList, "/Users/jonhpark/Desktop/auto_stat_example/outputs")
        startingAccelConverter.convert()
        
        passingAccelConverter = PassingAccelExcelConverter(organizer.performancePassingAccelRawList, "/Users/jonhpark/Desktop/auto_stat_example/outputs")
        passingAccelConverter.convert()
        
        brakingConverter = BrakingExcelConverter(organizer.brakingRawList, "/Users/jonhpark/Desktop/auto_stat_example/outputs")
        brakingConverter.convert()
        
        accelHtmlConverter = AccelHtmlConverter([organizer.performanceHtmlPath], "/Users/jonhpark/Desktop/auto_stat_example/outputs")
        accelHtmlConverter.convert()
        
        brakeHtmlConverter = BrakeHtmlConverter([organizer.brakingHtmlPath], "/Users/jonhpark/Desktop/auto_stat_example/outputs")
        brakeHtmlConverter.convert()

    elif args.test == "nvh":
        nvhAnalyze(organizer.idleHdfPathList, NVHTestType.Idle, "Idle")
        nvhAnalyze(organizer.cruiseHdfPathList, NVHTestType.Cruise , "Cruise")
        nvhAnalyze(organizer.wotHdfPathList, NVHTestType.WOT, "WOT")
        nvhAnalyze(organizer.accelHdfPathList, NVHTestType.Accel, "Accel")
        nvhAnalyze(organizer.decelHdfPathList, NVHTestType.Decel, "Decel")
        nvhAnalyze(organizer.mdpsHdfPathList, NVHTestType.MDPS, "MDPS")

        