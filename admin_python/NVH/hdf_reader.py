
import struct
from NVH.channel_data_model import ChannelDataModel


class HdfReader:
    baseBlockFrequency = 1000; # assume 1kHz, should be parsed from delta value
    
    # Constructor.
    def __init__(self, path):
        self.hdfFilePath = path
        self.dataLength = 0
        self.startPoint = 65536 # first candidate
        self.numberOfChannel = 0
        self.nbrBlock = 0
        self.channels = []


    def parseSync(self):
        self._parseHeader()

        #find data start point
        self.dataLength = self._getDataLength()

        # parse Raw data to Channel data model
        self._getChannelData()

        #return channels;

  
    def _parseHeader(self):
        f = open(self.hdfFilePath, 'rb')
        lines = f.readlines(self.startPoint)
        channelLines = []


        for i, lineBytes in enumerate(lines):
            line = str(lineBytes)
            if "start of data" in line :
                self.startPoint = int(line.split(":")[-1].strip().replace("\\r\\n'", ""))
                print("startPoint: ", self.startPoint)
            
            if "ch order" in line:
                chOrder = (line.split(":")[-1].strip().replace("\\r\\n'", ""))
                print("Channel Order: ",chOrder)

            if "scan mode" in line:
                mode = line.split(":")[-1].strip().replace("\\r\\n'", "")
                if mode != "synchronised multiple":
                    assert False

            if "nbr of scans" in line:
                self.nbrBlock = int(line.split(":")[-1].strip().replace("\\r\\n'", ""))
                print("Number of Block: ", self.nbrBlock)
            
            if "distribution func" in line:
                channelLines = lines[i:]
                break
        
        f.close()
        self._parseChannels(channelLines, chOrder)
    
    def _parseChannels(self, channelLinesBytes, chOrder):
        chOrders = chOrder.split(",")

        index = 0 
        for ch in chOrders:
            name = ""
            unit = ""
            frequency = 0
            while True:
                line = str(channelLinesBytes[index])
                index = index + 1
                if "name str" in line:
                    name = (line.split("name str:")[-1].strip().replace("\\r\\n'", ""))
                if "physical unit" in line:
                    unit = (line.split(":")[-1].strip().replace("\\r\\n'", ""))
                    break

            if "*" in ch:
                frequency = int(ch.split("*")[0])
            else:
                frequency = 1

            frequency *= self.baseBlockFrequency # assume block is based on 1kHz.

            self.channels.append(ChannelDataModel(name, unit, frequency))
            print("name:", name, "unit:", unit, "frequency:", frequency)

    def _getDataLength(self): 
        dataLength = 0
        f = open(self.hdfFilePath, 'rb')
        f.seek(self.startPoint -8192)
        dummy = f.read(8192)
        dummyString = str(dummy)
        if "data1" in dummyString: 
            dataLength = int(dummyString.split("data1")[-1].split(":")[0])
        print("dataLength:", dataLength)
        f.close()
        return dataLength

    def _getChannelData(self):
        blockSize = int(self.dataLength / self.nbrBlock)

        f = open(self.hdfFilePath, 'rb')
        f.seek(self.startPoint)
        while True:
            buf = f.read(blockSize)
            if len(buf) == 0:
                break
            self._parseBlock(buf)

        f.close()

    def _parseBlock(self, block):
        index = 0
        for channel in self.channels:
            numReads = int(channel.frequency / self.baseBlockFrequency)
            for i in range(numReads):
                datum = struct.unpack('<f', block[index:index+4])[0]
                channel.addData(datum)
                index = index + 4

