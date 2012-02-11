
// message sequence:
// to set the memory address:
// 1. slave address
// 2. pointer command
// 3. register address to point to

// to write data (address already set):
// 1. slave address
// 2. block write
// 3. number bytes write
// 4. byte 0, byte 1, byte 2, etc.

// to read data (address is already set):
// 1. slave address with read bit high
// 2. register data is returned

// to read a block of data (address is already set):
// 1. slave address
// 2. block read
// 3. number of bytes
// 4. slave address (read bit high)
// 5. byte 0, byte 1, byte 2, etc.


// control register map (D10 to D9)
// ranges = {2.0 V p-p, 200 mV p-p, 400 mV p-p, 1.0 V p-p}
const int OUTPUT_VOLTAGE[4] = {
  B00, B01, B10, B11};

// control register map (D11, D8 to D0)
// D11 = no operation
// D8 = PGA gain (0 = x5, 1 = x1) // amplifies the response signal into the ADC
// D7 = reserved, set to 0
// D6 = reserved, set to 0
// D5 = reserved, set to 0
// D4 = reset // interrupts a frequency sweep
// D3 = external system clock, set to 1; internal system clock, set to 0
// D2 = reserved, set to 0
// D1 = reserved, set to 0
// D0 = reserved, set to 0

// number of increments register
// 0x88: D15 to D9 -- don't care
// 0x89: D8 -- number of increments bit 1
// 0x89: D7 to D0 -- number of increments bits 2 through 9; 9-bit integer number stored in binary format

// number of settling times
// 0x8A: D15 to D11 -- don't care
// 0x8A: D10 to D9 -- 2-bit decode
//        0 0 = default
//        0 1 = # of cycles x 2
//        1 0 = reserved
//        1 1 = # of cycles x 4
// 0x8A: D8 -- MSB number of settling times
// 0x8B: D7 to D0 -- number of settling times; 9-bit integer number stored in binary format

// status register


int checkStatus() {
  return (getByte(STATUS_REGISTER[0]) & 7);
}

boolean measureTemperature() {
  
   setControlRegister(MEASURE_TEMP);

  delay(10); // wait for 10 ms

  if (checkStatus() &1 == validTemperatureMeasurement) {

    // temperature is available
    int temperatureData = getByte(TEMPERATURE_DATA_REGISTER[0]) << 8;
    temperatureData |= getByte(TEMPERATURE_DATA_REGISTER[1]);
    temperatureData &= 0x3FFF; // remove first two bits
    
    if (temperatureData & 0x2000 == 1) { // negative temperature
      
      temperatureData -= 0x4000;
    }
    
    temperatureData /= 32;
    
    Serial.print("Current temperature is ");
    Serial.print(temperatureData); 
    Serial.println(" degrees Celsius.");
    
    setControlRegister(POWER_DOWN);
    
    return true;

  } else {
    return false;
  }
}

// start frequency and frequency increment formula:
byte frequencyCode(float freqInHz, int byteNum) 
{
  long value = long((freqInHz / (CLOCK_SPEED / 4)) * pow(2,27));

  byte code[3];

  code[0] = (value & 0xFF0000) >> 0x10;
  code[1] = (value & 0x00FF00) >> 0x08;
  code[2] = (value & 0x0000FF);

  return code[byteNum];
}

boolean setStartFrequency(float freqInHz) 
{

  Serial.print("Setting start frequency of AD5233 to ");
  Serial.print(freqInHz);
  Serial.println(" Hz.");

  boolean statusValue;

  for (int n = 0; n < 3; n++) {
    statusValue = setByte(START_FREQUENCY_REGISTER[n], frequencyCode(freqInHz,n));
  }

  return statusValue;

}


boolean setFrequencyIncrement(float freqInHz) 
{

  Serial.print("Setting frequency increment of AD5233 to ");
  Serial.print(freqInHz);
  Serial.println(" Hz.");

  boolean statusValue;

  for (int n = 0; n < 3; n++) {
    statusValue = setByte(FREQ_INCREMENT_REGISTER[n], frequencyCode(freqInHz,n));
  }

  return statusValue;

}


boolean setNumberOfIncrements(int n) 
{

  Serial.print("Setting number of increments of AD5233 to ");
  Serial.print(n);
  Serial.println(".");

  boolean i2cStatus; 

  int numIncrements = min(n,511);
  
  i2cStatus = setByte(NUM_INCREMENTS_REGISTER[0], numIncrements >> 8);
  i2cStatus = setByte(NUM_INCREMENTS_REGISTER[1], numIncrements & 255);

  return i2cStatus;
}


boolean setNumberOfSettlingTimes(int n) 
{

  Serial.print("Setting number of settling times of AD5233 to ");
  Serial.print(n);
  Serial.println(".");

  int decode;
  int numSettlingTimes = min(n, 2047);

  if (n > 1023) {
    decode = 3;
    numSettlingTimes /= 4;
  } 
  else if (n > 511) {
    decode = 1;
    numSettlingTimes /= 2;
  } 
  else {
    decode = 0;
    numSettlingTimes = n;
  } 

  boolean i2cStatus; 
  
  i2cStatus = setByte(NUM_SETTLING_CYCLES_REGISTER[0], (numSettlingTimes >> 8) + (decode << 1));
  i2cStatus = setByte(NUM_SETTLING_CYCLES_REGISTER[0], numSettlingTimes & 255);
  
  return i2cStatus;

}

