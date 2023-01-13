class HelpResources{

  static String coastdownCalibration =  """
  θ0 : the zero yaw offset angle, in degrees
  ky : the yaw correction coefficient
  ka : the coefficient relating Vr_true to Vr_apparent
  kr : the minimum velocity at which the anemometer will respond, in kilometres per hour (km/h)
  ku : a unitless coefficient relating yaw angle to relative air speed""";


  static String performanceGraph = """
  The data is originally measured by 100Hz GPS.
  If you want to get 100Hz data, you need to download the raw data.""";
}
