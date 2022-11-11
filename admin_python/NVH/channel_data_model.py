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


  def addData(self, datum):
      self.data.append(datum);
  

  def toMp4(self):
      print("MP4 convert!")