from time import sleep
import time
import board
import busio
import serial
import random
import time
import pyrebase
import datetime
import serial
import pynmea2

config = {     
  "apiKey": "AIzaSyADBkvyxY_P0hynMwtw3vCEMjbCefOL88Y",
  "authDomain": "integrated-design-projec-1e9b8.firebaseapp.com",
  "databaseURL": "https://integrated-design-projec-1e9b8-default-rtdb.firebaseio.com",
  "storageBucket": "integrated-design-projec-1e9b8.appspot.com"
}

firebase = pyrebase.initialize_app(config)  
db=firebase.database()
prevdb=firebase.database()

i2c = busio.I2C(board.SCL, board.SDA)
import adafruit_ads1x15.ads1015 as ADS
from adafruit_ads1x15.analog_in import AnalogIn
ads = ADS.ADS1015(i2c)
chan = AnalogIn(ads, ADS.P0)

rate = [0]*10
amp = 100
GAIN = 2/3  
curState = 0
stateChanged = 0

ser = serial.Serial ("/dev/ttyS0", 9600)

def read_data():
    firstBeat = True
    secondBeat = False
    sampleCounter = 0
    lastBeatTime = 0
    lastTime = int(time.time()*1000)
    th = 525
    P = 512
    T = 512
    IBI = 600
    Pulse = False
    
    Signal = AnalogIn(ads, ADS.P1)
    curTime = int(time.time()*1000)
    sampleCounter += curTime - lastTime
    lastTime = curTime
    N = sampleCounter - lastBeatTime; 

    if Signal > th and  Signal > P:          
        P = Signal
  
    if Signal < th and N > (IBI/5.0)*3.0 :  
        if Signal < T :                      
          T = Signal                                                 
    
    if N > 250 :                              
        if  (Signal > th) and  (Pulse == False)  :       
          Pulse = 1;                       
          IBI = sampleCounter - lastBeatTime
          lastBeatTime = sampleCounter       

          if secondBeat :                     
            secondBeat = 0;               
            for i in range(0,10):             
              rate[i] = IBI                      

          if firstBeat :                        
            firstBeat = 0                  
            secondBeat = 1                                               

          runningTotal = 0;               
          for i in range(0,9):            
            rate[i] = rate[i+1]       
            runningTotal += rate[i]      

          rate[9] = IBI;                  
          runningTotal += rate[9]        
          runningTotal /= 10;             
          BPM = 60000/runningTotal       

    if Signal < th and Pulse == 1 :                    
        amp = P - T                   
        th = amp/2 + T
        T = th
        P = th
        Pulse = 0

    port="/dev/ttyAMAO"

    ser=serial.Serial(port,baudrate=9600,timeout=0.5)

    dataout =pynmea2.NMEAStreamReader()

    newdata=ser.readline()

    if newdata[0:6]=="$GPRMC":
      newmsg=pynmea2.parse(newdata)
      latitude=newmsg.latitude
      longitude=newmsg.longitude
    
    pulse=BPM
    temp=str((round((chan.voltage / 0.01),2)) +" C")
    e=datetime.datetime.now()
    timestamp=str(e.day)+'/'+str(e.month)+'/'+str(e.year)+' '+str(e.hour)+'-'+str(e.minute)+'-'+str(e.second)
    db.child("baby0").child("Sensor Data").child("Pulse Rate").set(pulse)
    db.child("baby0").child("Sensor Data").child("Temperature").set(temp)
    db.child("baby0").child("Sensor Data").child("Latitude").set(latitude)
    db.child("baby0").child("Sensor Data").child("Longitude").set(longitude)
    db.child("baby0").child("Sensor Data").child("Timestamp").set(timestamp)
    db.child("baby0").child("Previous Sensor Data").child("Pulse Rate").push(pulse)
    db.child("baby0").child("Previous Sensor Data").child("Temperature").push(temp)
    db.child("baby0").child("Previous Sensor Data").child("Latitude").push(latitude)
    db.child("baby0").child("Previous Sensor Data").child("Longitude").push(longitude)
    db.child("baby0").child("Previous Sensor Data").child("Timestamp").push(timestamp)
    time.sleep(5)

read_data()


   
   


