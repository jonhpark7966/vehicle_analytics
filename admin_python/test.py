from NVH.nvh_analyzer import *
from NVH.analyzer.nvh_test_type import NVHTestType
from files_organizer import FileOrganizer

from vms_file_handler.vms_excel_converter import *
from vms_file_handler.vms_html_converter import *

from NVH.hdf_reader import *

from pathlib import Path



root = "/Users/jonhpark/Desktop/lincoln"

organizer = FileOrganizer(root)
errormsg = organizer.checkFiles()

#startingAccelConverter = StartingAccelExcelConverter(organizer.performanceStartingAccelRawList, "/Users/jonhpark/Desktop/auto_stat_example/outputs")
#startingAccelConverter.convert()

#passingAccelConverter = PassingAccelExcelConverter(organizer.performancePassingAccelRawList, "/Users/jonhpark/Desktop/auto_stat_example/outputs")
#passingAccelConverter.convert()

#brakingConverter = BrakingExcelConverter(organizer.brakingRawList, "/Users/jonhpark/Desktop/auto_stat_example/outputs")
#brakingConverter.convert()

#accelHtmlConverter = AccelHtmlConverter([organizer.performanceHtmlPath], "/Users/jonhpark/Desktop/auto_stat_example/outputs")
#accelHtmlConverter.convert()

#brakeHtmlConverter = BrakeHtmlConverter([organizer.brakingHtmlPath], "/Users/jonhpark/Desktop/auto_stat_example/outputs")
#brakeHtmlConverter.convert()

# TEMP TEST Idle
#hdf = HdfReader(organizer.idleHdfPathList[0])
#hdf.parseSync()
#path = "/Users/jonhpark/Desktop/lincoln/outputs/IDLE"
#Path(path).mkdir(parents=True, exist_ok=True)
##hdf.channels[0].toMP3File(path)
#
#analyzer = NVHAnalyzer(hdf.channels, NVHTestType.Idle, path, organizer.vehicleJsonPath)
#analyzer.analyze()

# TEMP TEST Accel 
hdf = HdfReader(organizer.accelHdfPathList[0])
hdf.parseSync()
path = "/Users/jonhpark/Desktop/lincoln/outputs/Accel"
Path(path).mkdir(parents=True, exist_ok=True)
hdf.channels[0].toMP3File(path)

analyzer = NVHAnalyzer(hdf.channels, NVHTestType.Accel, path, organizer.vehicleJsonPath)
analyzer.analyze()
