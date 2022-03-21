#include <ESP8266WiFi.h>   //Library for NodeMCU/ESP8266
#include <FirebaseArduino.h>//For connecting to firebase

#define FIREBASE_HOST "integrated-design-projec-1e9b8-default-rtdb.firebaseio.com" //give your firebase host id here
#define FIREBASE_AUTH "6UHbL2DgfZjzuHN22eMjRUZgg18KgkwuLcmzi9WU"           //give your firebase database secret here
#define WIFI_SSID "DR JAHANGIR"       //give the wifi ssid you are connected to
#define WIFI_PASSWORD "19671967"      //give the wifi password you are connected to

String values,sensor_data;

void setup() {
    //Initializes the serial connection at 9600 get sensor data from arduino.
    Serial.begin(9600);
   
    delay(1000);
  
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    while (WiFi.status() != WL_CONNECTED) {
      delay(500);  
    }
    
    Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH); 
  
}
void loop() {

  bool Sr =false;
 
  while(Serial.available()){
    
     //get sensor data from serial put in sensor_data
     sensor_data=Serial.readString(); 
     Sr=true;    
     
  }
  
  delay(1000);

  if(Sr==true){  
    
    values=sensor_data;
    
    //get comma indexes from values variable
    int firstCommaIndex = values.indexOf(',');
    int secondCommaIndex = values.indexOf(',', firstCommaIndex+1);
  
    //get sensors data from values variable by  spliting by commas and put in to variables  
    String pulse_value = values.substring(0, firstCommaIndex);
    String temp_value = values.substring(firstCommaIndex+1, secondCommaIndex);
  
    //storing sensor data as string in firebase 
    Firebase.setString("Sensor Data/Pulse Rate",pulse_value);
    delay(10);
    Firebase.setString("Sensor Data/Temperature",temp_value);
    delay(10);
    
    //store previous sensors data as string in firebase
    Firebase.pushString("Previous Sensor Data/Pulse Rate",pulse_value);
    delay(10);
    Firebase.pushString("Previous Sensor Data/Temperature",temp_value);
    delay(1000);
  
    if(Firebase.failed()) {  
      return;
    }
  }   
}
