#define USE_ARDUINO_INTERRUPTS true // Set-up low-level interrupts for most acurate BPM math.
#include <PulseSensorPlayground.h> // Includes the PulseSensorPlayground Library.
 
// Variables
int val;         //for storing temperature value
int tempPin = 1; //temperature will be recorded from pin 1
const int PulseWire = 0; // PulseSensor PURPLE WIRE connected to ANALOG PIN 0
int Threshold = 550; // Determine which Signal to "count as a beat" and which to ignore.
// Use the "Getting Started Project" to fine-tune Threshold Value beyond default setting.
// Otherwise leave the default "550" value.
 
PulseSensorPlayground pulseSensor; // Creates an instance of the PulseSensorPlayground object called "pulseSensor"
void setup() {
 
  Serial.begin(9600); // For Serial Monitor
 
  // Configure the PulseSensor object, by assigning our variables to it.
  pulseSensor.analogInput(PulseWire);
  //pulseSensor.blinkOnPulse(LED13); //auto-magically blink Arduino's LED with heartbeat.
  pulseSensor.setThreshold(Threshold);
 
  // Double-check the "pulseSensor" object was created and "began" seeing a signal.
  if (pulseSensor.begin()) {
  
  }
}
 
void loop() {

  if (pulseSensor.sawStartOfBeat()) { // Constantly test to see if "a beat happened".
    // "myBPM" hold this BPM value now.
    int myBPM = pulseSensor.getBeatsPerMinute(); // Calls function on our pulseSensor object that returns BPM as an "int".
    Serial.print(myBPM); // Print the value inside of myBPM.
    Serial.print(",");
    val = analogRead(tempPin);
    float mv = ( val/1024.0)*5000;
    float cel = mv/10;
    float farh = (cel*9)/5 + 32;
    Serial.print(cel);
    Serial.print(",");

  }

  delay(20); // considered best practice in a simple sketch.
}
