from scipy.io.wavfile import write
import numpy as np
import pydub
import os

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
    sound.export(os.path.join(outputPath, self.name + ".mp3"), format="mp3")

  def _maxToNormalize(self):
    if "MIC" in self.name:
        return 10.0 # pascal
    elif "Floor" in self.name:
        return 10.0 # m/s^2
    elif "Engine" in self.name:
        return 100.0 # m/s^2

    