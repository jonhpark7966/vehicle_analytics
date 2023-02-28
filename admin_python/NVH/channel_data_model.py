from scipy.io.wavfile import write
import numpy as np
import pydub
import os
import sys
import json

from enum import Enum

class SignalType(Enum):
    Noise = 0
    Vibration = 1
    Speed = 2
    RPM = 3
    ETC = 4

class ChannelDataModel:

  data = []
  name = ""
  unit = ""
  frequency = 0

  wavFilePath = ""

  # Constructor.
  def __init__(self, name, unit, frequency):
      self.name = name
      self.unit = unit
      self.frequency = frequency
      self.data = []


  def addData(self, datum):
      self.data.append(datum)
  
  def toWavFile(self, outputPath):
    if len(self.data) == 0:
        print("channel data is empty!")
        return

    normalized = [elem/self._maxToNormalize() for elem in self.data]
    self.wavFilePath = os.path.join(outputPath, self.name + ".wav")
    write(self.wavFilePath, self.frequency, np.array(normalized).astype(np.float32))

  def toMP3File(self, outputPath):
    if self.wavFilePath == "":
        self.toWavFile(outputPath)

    sound = pydub.AudioSegment.from_wav(self.wavFilePath)
    mp3path = os.path.join(outputPath, self.name + ".mp3")
    sound.export(mp3path, format="mp3")
    sys.stdout.write("Success! :"+mp3path+"\n")

  def toTachoJsonFile(self, outputPath):

    tachoPath = os.path.join(outputPath, self.name + "_tacho.json")

    with open(tachoPath, "w") as f:
        jsonDict = {"name":self.name, "unit":self.unit,
         "xAxisunit": "ms", "xAxisDelta":1,
        }
        for i, datum in enumerate(self.data):
            jsonDict[str(i)] = str(round(datum, 1))

        json.dump(jsonDict, f)
    sys.stdout.write("Success! :"+tachoPath+"\n")

  def getType(self):
    if self.unit == "Pa":
        return SignalType.Noise
    elif self.unit == "m/(s^2)":
        return SignalType.Vibration
    elif self.unit == "km/h":
        return SignalType.Speed
    elif self.unit == "rpm":
        return SignalType.RPM
    else:
        return SignalType.ETC

  def _maxToNormalize(self):
    if "MIC" in self.name:
        return 10.0 # pascal
    elif "Floor" in self.name:
        return 10.0 # m/s^2
    elif "Engine" in self.name:
        return 100.0 # m/s^2
