from scipy.io.wavfile import write
import numpy as np

class ChannelDataModel:

  data = []
  name = ""
  unit = ""
  frequency = 0

  # Constructor.
  def __init__(self, name, unit, frequency):
      self.name = name
      self.unit = unit
      self.frequency = frequency
      self.data = []


  def addData(self, datum):
      self.data.append(datum)
  

  def toWavFile(self):
    if len(self.data) == 0:
        print("channel data is empty!")
        return

    normalized = [elem/self._maxToNormalize() for elem in self.data]
    write("example.wav", self.frequency, np.array(normalized).astype(np.float32))

  def _maxToNormalize(self):
    if "MIC" in self.name:
        return 10.0 # pascal
    elif "Floor" in self.name:
        return 10.0 # m/s^2
    elif "Engine" in self.name:
        return 100.0 # m/s^2