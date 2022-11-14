from NVH.analyzer.analyze_options import AnalyzeOptions
from NVH.analyzer.data_models.data_model_3d import DataModel3D
from NVH.channel_data_model import ChannelDataModel

import matplotlib.pyplot as plt

import numpy as np
import scipy.fft

class FourierSignalProcess():

    def timeFFT(self, signal, options):

        data = signal.data
        frequency = signal.frequency
        freqRes = options.frequencyResolution
        overlap = options.overlap
        windowSize = int(frequency / freqRes)

        ret = DataModel3D("dB", "Hz", freqRes, "s", (1-overlap)/freqRes)

        offset = 0
        while True:
            if (offset + windowSize) > len(data) :
                break

            window = [datum/frequency for datum in data[offset:offset+windowSize]]
            fft_abs = 20 * np.log10(
            (np.abs(scipy.fft.fft(window * options.getWindow(windowSize)))
             * options.energyCorrectionFactor) / options.referenceValue)

            offset = offset + int(windowSize * (1-overlap))

            ret.data.append(fft_abs[0:int(frequency/2)])

        self._showColormap(ret.data)
        
        return ret.data

    def orderFFT():
        return


    def _showColormap(self, data):
        # DEBUG FLAG to show colormap
        if False:
            plt.imshow(data, origin='lower', aspect='auto', vmin=30, vmax=80, cmap="jet")
            plt.colorbar() 
            plt.show()


