#-*- coding: utf-8 -*-

from tkinter import *
from tkinter import filedialog as fd

from files_organizer import FileOrganizer
from file_handler.vms_excel_converter import *


root= Tk()
root.geometry("300x300")

organizer = None

def checkFilesCallback():
    rootDirectory = fd.askdirectory() 
    print(rootDirectory)

    # files
    organizer = FileOrganizer(rootDirectory)
    errormsg = organizer.checkFiles()

    print(errormsg)

def parsingFilesCallback():

    startingAccelConverter = StartingAccelExcelConverter(organizer.performanceStartingAccelRawList)
    startingAccelConverter.convert()

    print("parsing!")

openFolderButton = Button(root, text='Click to Open Folder', 
       command=checkFilesCallback)

parseButton = Button(root, text='Parsing files', 
       command=parsingFilesCallback)

openFolderButton.pack()
parseButton.pack()

root.mainloop()