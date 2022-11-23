from NVH.analyzer.analyze_options import AnalyzeOptions
from NVH.analyzer.data_models.data_model_3d import DataModel3D
from NVH.channel_data_model import ChannelDataModel

import matplotlib.pyplot as plt

import numpy as np
import scipy.fft

class FourierSignalProcess():

    def timeFFT(self, signal, referenceValue, freqRes):

        data = signal.data
        frequency = signal.frequency
        overlap =  AnalyzeOptions.overlap
        windowSize = int(frequency / freqRes)

        ret = DataModel3D("dB", "Hz", freqRes, "s", (1-overlap)/freqRes)

        offset = 0
        while True:
            if (offset + windowSize) > len(data) :
                break

            window = [datum/windowSize for datum in data[offset:offset+windowSize]]
            fft_abs = 20 * np.log10(
            (np.abs(scipy.fft.fft(window * AnalyzeOptions().getWindow(windowSize)))
             * AnalyzeOptions.amplitudeCorrectionFactor * AnalyzeOptions.peakRmsCorrectionFactor) / referenceValue).astype("float32")

            offset = offset + int(windowSize * (1-overlap))

            ret.data.append(fft_abs[0:int(frequency/2)])

        ret.showColormap()
        
        return ret

    def orderFFT():
        return




