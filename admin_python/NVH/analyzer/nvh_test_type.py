from enum import Enum

class NVHTestType(Enum):
    Idle = 0
    Cruise = 1
    WOT = 2
    Accel = 3
    Decel = 4
    MDPS = 5

