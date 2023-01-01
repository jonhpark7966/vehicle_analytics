import argparse
from files_organizer import FileOrganizer
from vms_file_handler.vms_excel_converter import BrakingExcelConverter, PassingAccelExcelConverter, StartingAccelExcelConverter
from vms_file_handler.vms_html_converter import AccelHtmlConverter, BrakeHtmlConverter

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
        print("not implemented yet")
