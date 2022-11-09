from files_organizer import FileOrganizer
from file_handler.vms_excel_converter import *



root = "/Users/jonhpark/Desktop/auto_stat_example"

organizer = FileOrganizer(root)
errormsg = organizer.checkFiles()

startingAccelConverter = StartingAccelExcelConverter(organizer.performanceStartingAccelRawList, "/Users/jonhpark/Desktop/auto_stat_example/outputs")
startingAccelConverter.convert()

passingAccelConverter = PassingAccelExcelConverter(organizer.performancePassingAccelRawList, "/Users/jonhpark/Desktop/auto_stat_example/outputs")
passingAccelConverter.convert()