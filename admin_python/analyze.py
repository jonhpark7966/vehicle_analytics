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
            if ch.frequency >= 10000: # only for NVH channel.
                ch.toMP3File(path)
            else: # tacho channels.
                ch.toTachoJsonFile(path)
    
        analyzer = NVHAnalyzer(hdf.channels,type, path, organizer.vehicleJsonPath)
        analyzer.analyze()




# Shell Caller
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Analyze')
    parser.add_argument('--path', type=str, default=".")
    parser.add_argument('--test', type=str, default="performance")
    parser.add_argument('--type', type=str, default="idle")

    args = parser.parse_args()


    organizer = FileOrganizer(args.path)
    errormsg = organizer.checkFiles()

    # make output path
    outputPath = args.path + "/outputs"
    try:
        if not os.path.isdir(outputPath):
            os.mkdir(outputPath)
    except:
        print("Error!")
        pass

    if args.test == "performance":
        startingAccelConverter = StartingAccelExcelConverter(organizer.performanceStartingAccelRawList, outputPath)
        startingAccelConverter.convert()
        
        passingAccelConverter = PassingAccelExcelConverter(organizer.performancePassingAccelRawList, outputPath)
        passingAccelConverter.convert()
        
        brakingConverter = BrakingExcelConverter(organizer.brakingRawList, outputPath)
        brakingConverter.convert()
        
        accelHtmlConverter = AccelHtmlConverter([organizer.performanceHtmlPath], outputPath)
        accelHtmlConverter.convert()
        
        brakeHtmlConverter = BrakeHtmlConverter([organizer.brakingHtmlPath], outputPath)
        brakeHtmlConverter.convert()

    elif args.test == "nvh":
        if args.type == "idle":
            nvhAnalyze(organizer.idleHdfPathList, NVHTestType.Idle, "Idle")
        elif args.type == "cruise":
            nvhAnalyze(organizer.cruiseHdfPathList, NVHTestType.Cruise , "Cruise")
        elif args.type == "wot":
            nvhAnalyze(organizer.wotHdfPathList, NVHTestType.WOT, "WOT")
        elif args.type == "accel":
            nvhAnalyze(organizer.accelHdfPathList, NVHTestType.Accel, "Accel")
            print(organizer.accelHdfPathList)
        elif args.type == "decel":  
            nvhAnalyze(organizer.decelHdfPathList, NVHTestType.Decel, "Decel")
        elif args.type == "mdps":
            nvhAnalyze(organizer.mdpsHdfPathList, NVHTestType.MDPS, "MDPS")

        