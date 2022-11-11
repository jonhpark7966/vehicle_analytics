from files_organizer import FileOrganizer

from vms_file_handler.vms_excel_converter import *
from vms_file_handler.vms_html_converter import *

from NVH.hdf_reader import *



root = "/Users/jonhpark/Desktop/auto_stat_example"

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

# TEMP TEST
hdf = HdfReader(organizer.wotHdfPathList[0])
hdf.parseSync()
hdf.channels[0].toWavFile()