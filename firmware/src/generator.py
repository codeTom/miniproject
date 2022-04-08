import numpy as np
import scipy
from typing import List

class Action:
    time = 0
    channel = 0
    intensity = 0
    
    def __init__(self, time, channel, intensity):
        self.time = time
        self.channel = channel
        self.intensity = intensity

    def __str__(self):
        return f"{{{int(self.time)}, {self.channel}, {self.intensity}}}"

class Channel:
    def __init__(self, channel_n):
        self.current_time = 0
        self.current_intensity = 0
        self.actions: List[Action] = []
        self.channel_n = channel_n
          
    def on_for(self, intensity, duration):
        self.actions.append(Action(self.current_time, self.channel_n, intensity))
        self.current_time += duration
        self.actions.append(Action(self.current_time, self.channel_n, self.current_intensity))

    def delay(self, duration):
        self.current_time += duration
    
    def on(self, intensity=100):
        self.actions.append(Action(self.current_time, self.channel_n, intensity))

    def off(self):
        self.on(0)

def intensity_current_measurement(channels: List[Channel]):
    done = 0
    for channel in channels:
        channel.delay(done * 5)
        done += 1
        for intensity in range(0, 100):
            channel.on(intensity)
        channel.off()

def one_hour_simple(channels: List[Channel], intensities = [0, 1, 5, 10, 20, 35, 0]):
    for i in range(0,7):
        channels[i].on_for(intensities[i], 3600)

def spectro_cycle(channels: List[Channel], intensities = [0, 1, 5, 10, 20, 35, 0], break_every = 300, break_for = 60, total_on_time = 1200):
    while total_on_time > 0:
        time_on = min(break_every, total_on_time)
        for i in range(7):
            channels[i].on_for(intensities[i], min(break_every, time_on))
            channels[i].delay(break_for)
        total_on_time -= time_on

def temp_scan(channels: List[Channel], intensity = 70, max_heat = 30, heat_increase_time = 30):
    channels[0].on(intensity)
    channels[6].delay(2*heat_increase_time) #wait 
    for i in range(max_heat):
        channels[6].on_for(i, heat_increase_time)
    channels[6].delay(30)
    channels[6].off()

def intensity_analysis(channel: Channel, seconds_per_intensity = 2, max_intensity = 40, step=2):
    for intensity in range(0,max_intensity+1,step):
        channel.on_for(intensity, seconds_per_intensity)

channels: List[Channel] = []
for i in range(7):
    channels.append(Channel(i))

#for channel in channels:
#    channel.delay(30)

#temp_scan(channels, 70, 35, 30)

intensity_analysis(channels[0], 6, 40, 2)

#spectro_cycle(channels, [0, 0, 40, 25, 15, 5, 4])

#one_hour_simple(channels, [0, 1, 5, 10, 20, 35, 1]) #IR

#one_hour_simple(channels, [0, 1, 5, 10, 40, 70, 1]) #RED


#intensity_current_measurement(channels)

#intensities = [0, 100, 50, 20, 10, 5]
#for i in range(1,6):
#    channels[i].on_for(intensities[i], 3600)

#thermal
#channels[6].on_for(20, 3600)



#printing
all_actions = []
for channel in channels:
    all_actions += channel.actions

all_actions.sort(key=lambda x: x.time)

print("{")
for action in all_actions:
    print(f"    {action},")

print("{UINT32_MAX, 0, 0} //END of programme")
print("}")