#include <ESP8266WiFi.h>      //Library for NodeMCU/ESP8266
#include <FirebaseArduino.h> //For connecting to firebase
#include <SoftwareSerial.h> //For creating software serial communication
#include <TinyGPS.h>        //For creating gps object 

#define FIREBASE_HOST "integrated-design-projec-1e9b8-default-rtdb.firebaseio.com" //give your firebase host id here
#define FIREBASE_AUTH "6UHbL2DgfZjzuHN22eMjRUZgg18KgkwuLcmzi9WU"                 //give your firebase database secret here
#define WIFI_SSID "DR JAHANGIR"       //give the wifi ssid you are connected to
#define WIFI_PASSWORD "19671967"      //give the wifi password you are connected to

//Variables
const int RXPin = 4, TXPin = 5;  //Serial Pins
SoftwareSerial gpsSerial(RXPin, TXPin); //Create serial communication
TinyGPS gps; //create gps object
long latitude,longitude; //for storing latitudes and longitudes

void setup()
{
   Serial.begin(9600); 
   gpsSerial.begin(9600);
  
   wifiConnect(); //Connect to wifi

   Serial.println("Connecting Firebase.....");
   Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH); //Connect to firebase
   Serial.println("Firebase OK.");

}

void loop() {
  
   //smartdelay_gps(1000); //wait till gps module is activated

   while(gpsSerial.available()){ // check for gps data
     
     if(gps.encode(gpsSerial.read())){ // encode gps data
       gps.get_position(&latitude,&longitude); // get latitude and longitude
       
       //Sending data to firebase
       Firebase.setInt("Latitude",latitude);
       delay(10);
       Firebase.setInt("Longitude",longitude);
       delay(10);

       //Saving previous data 
       Firebase.pushInt("Previous Latitude", latitude);
       delay(10);
       Firebase.pushInt("Previous Longitude",longitude);
       delay(10);
     }
   }
}

static void smartdelay_gps(unsigned long ms)
{
  unsigned long start = millis();
  do 
  {
    while (gpsSerial.available()){
      gps.encode(gpsSerial.read());
      Serial.println("available");
    }
      
  } while (millis() - start < ms);
}

void wifiConnect()
{
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();
}
