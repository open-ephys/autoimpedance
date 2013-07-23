// Testing the AD5933

#include <Wire.h>

// The user must calibrate the AD5933 system for a known impedance range to determine the gain factor

#define AD5933_ADDR 0x0D
#define AD5245_ADDR 0x2D //B0101101; // << assumes AD0 tied to VCC

const float CLOCK_SPEED = 16.776*pow(10,6); // AD5933 has internal clock of 16.776 MHz

const int CONTROL_REGISTER[2] =                    { 0x80, 0x81       }; // see mapping below
const int START_FREQUENCY_REGISTER[3] =            { 0x82, 0x83, 0x84 }; // 24 bits for start frequency
const int FREQ_INCREMENT_REGISTER[3] =             { 0x85, 0x86, 0x87 }; // 24 bits for frequency increment
const int NUM_INCREMENTS_REGISTER[2] =             { 0x88, 0x89       }; //  9 bits for # of increments
const int NUM_SETTLING_CYCLES_REGISTER[2] =        { 0x8A, 0x8B       }; //  9 bits + 1 modifier for # of settling times
const int STATUS_REGISTER[1] =                     { 0x8F             }; // see mapping below
const int TEMPERATURE_DATA_REGISTER[2] =	   { 0x92, 0x93       }; // 16-bit, twos complement format
const int REAL_DATA_REGISTER[2] =                  { 0x94, 0x95       }; // 16-bit, twos complement format
const int IMAG_DATA_REGISTER[2] =                  { 0x96, 0x97       }; // 16-bit, twos complement format

// control register map (D15 to D12)
const int DEFAULT_VALUE =                 B0000; // initial setting
const int INITIALIZE =                    B0001; // excite the unknown impedance initially
const int START_SWEEP = 	          B0010; // begin the frequency sweep
const int INCREMENT =                     B0011; // step to the next frequency point
const int REPEAT =                        B0100; // repeat the current frequency point measurement
const int MEASURE_TEMP =                  B1001; // initiates a temperature reading
const int POWER_DOWN =                    B1010; // VOUT and VIN are connected internally to ground
const int STANDBY =                       B1011; // VOUT and VIN are connected internally to ground

const int BLOCK_WRITE = B1010000;
const int BLOCK_READ =  B1010001;
const int ADDRESS_PTR = 0xB0;// B1011000;

const int validTemperatureMeasurement =  1;
const int validImpedanceData =           2;
const int frequencySweepComplete =       4;

const int ledPin = 12;

int reading = 0;
byte rxByte;

// Arduino setup:
// D2 = MUX16A
// D3 = MUX16B
// D4 = MUX16C
// D5 = MUX16D
// D6 = MUX4A
// D7 = MUX4B
// D8 = MUX2A
// D9 = MUX2B
// D10 = LM234 enable
// D11 = buzzer
// D12 = green LED
// D13 = yellow LED

void setup() 
{
  Wire.begin();
  Serial.begin(9600);

  pinMode(ledPin, OUTPUT);

}

void loop() 
{  
  if (Serial.available()) {

    int incomingByte = Serial.read();

    digitalWrite(ledPin, HIGH);

    delay(50);
    
    configureAD5933(1000, // number of settling times
                    1*pow(10,3), // start frequency (Hz)
                    2*pow(10,2), // frequency increment (Hz)
                    21); // number of increments

    configureAD5245(40*pow(10,3));

    delay(50);
    
     measureTemperature();
     
     delay(50);
     
     measureImpedance();

    digitalWrite(ledPin, LOW);  

  }
}





