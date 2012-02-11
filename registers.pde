//// register map
//
//
//
//// message sequence:
//// to set the memory address:
//// 1. slave address
//// 2. pointer command
//// 3. register address to point to
//
//// to write data (address already set):
//// 1. slave address
//// 2. block write
//// 3. number bytes write
//// 4. byte 0, byte 1, byte 2, etc.
//
//// to read data (address is already set):
//// 1. slave address with read bit high
//// 2. register data is returned
//
//// to read a block of data (address is already set):
//// 1. slave address
//// 2. block read
//// 3. number of bytes
//// 4. slave address (read bit high)
//// 5. byte 0, byte 1, byte 2, etc.
//
//
//// control register map (D10 to D9)
//// ranges = {2.0 V p-p, 200 mV p-p, 400 mV p-p, 1.0 V p-p}
////const int OUTPUT_VOLTAGE[4] = {B00, B01, B10, B11};
//
//// control register map (D11, D8 to D0)
//// D11 = no operation
//// D8 = PGA gain (0 = x5, 1 = x1) // amplifies the response signal into the ADC
//// D7 = reserved, set to 0
//// D6 = reserved, set to 0
//// D5 = reserved, set to 0
//// D4 = reset // interrupts a frequency sweep
//// D3 = external system clock, set to 1; internal system clock, set to 0
//// D2 = reserved, set to 0
//// D1 = reserved, set to 0
//// D0 = reserved, set to 0
//
//// number of increments register
//// 0x88: D15 to D9 -- don't care
//// 0x89: D8 -- number of increments bit 1
//// 0x89: D7 to D0 -- number of increments bits 2 through 9; 9-bit integer number stored in binary format
//
//// number of settling times
//// 0x8A: D15 to D11 -- don't care
//// 0x8A: D10 to D9 -- 2-bit decode
////        0 0 = default
////        0 1 = # of cycles x 2
////        1 0 = reserved
////        1 1 = # of cycles x 4
//// 0x8A: D8 -- MSB number of settling times
//// 0x8B: D7 to D0 -- number of settling times; 9-bit integer number stored in binary format
//
//// status register
////const int validTemperatureMeasurement =  1;
////const int validImpedanceData =           2;
////const int frequencySweepComplete =       4;
//
////byte[2] controlCode()
////{
////  
////	
////	int code[2];
////
////	code[0] = DEFAULT << 4 + OUTPUT_VOLTAGE[0] << 1 + 0;
////	code[1] = 0x00;
////
////}
//
//
//// start frequency and frequency increment formula:
//byte frequencyCode(float freqInHz, int byteNum) 
//{
//   long value = long((freqInHz / (CLOCK_SPEED / 4)) * pow(2,27));
//   
//   //Serial.println(value);
//   
//   byte code[3];
//   
//   code[0] = (value & 0xFF0000) >> 0x10;
//   code[1] = (value & 0x00FF00) >> 0x08;
//   code[2] = (value & 0x0000FF);
//   
//   return code[byteNum];
//}
//
//boolean setStartFrequency(float freqInHz) 
//{
//  
//    Serial.print("Setting start frequency of AD5233 to ");
//    Serial.print(freqInHz);
//    Serial.println(" Hz.");
//   
//    int i2cStatus;
//   
//   for (int n = 0; n < 3; n++) {
// 
//    Wire.beginTransmission(AD5933_ADDR); // master sends a 7-bit slave address
//    Wire.send(START_FREQUENCY_REGISTER[n]); // 
//    Wire.send(frequencyCode(freqInHz,n));
//    i2cStatus = Wire.endTransmission();
//    
//    //Serial.println(i2cStatus);
//    
//   }
//    
//   if (i2cStatus)
//      return false;
//   else
//      return true;
//    
//}
//
//
//boolean setFrequencyIncrement(float freqInHz) 
//{
//  
//    Serial.print("Setting frequency increment of AD5233 to ");
//    Serial.print(freqInHz);
//    Serial.println(" Hz.");
//   
//    int i2cStatus;
//   
//   for (int n = 0; n < 3; n++) {
// 
//    Wire.beginTransmission(AD5933_ADDR); // master sends a 7-bit slave address
//    Wire.send(FREQ_INCREMENT_REGISTER[n]); // 
//    Wire.send(frequencyCode(freqInHz,n));
//    i2cStatus = Wire.endTransmission();
//    
//    //Serial.println(i2cStatus);
//    
//   }
//    
//     if (i2cStatus)
//       return false;
//     else
//       return true;
//    
//}
//
//
//boolean setNumberOfIncrements(int n) 
//{
//  
//    Serial.print("Setting number of increments of AD5233 to ");
//    Serial.print(n);
//    Serial.println(".");
//    
//   int i2cStatus; 
//  
//   int numIncrements = min(n,511);
//  
//   Wire.beginTransmission(AD5933_ADDR);
//   Wire.send(NUM_INCREMENTS_REGISTER[0]);
//   Wire.send(numIncrements >> 8);
//   i2cStatus = Wire.endTransmission();
//   
//   Wire.beginTransmission(AD5933_ADDR);
//   Wire.send(NUM_INCREMENTS_REGISTER[1]);
//   Wire.send(numIncrements & 255);
//   i2cStatus = Wire.endTransmission();
//
//    if (i2cStatus)
//       return false;
//     else
//       return true;
//     
//}
//
//
//boolean setNumberOfSettlingTimes(int n) 
//{
//  
//    Serial.print("Setting number of settling times of AD5233 to ");
//    Serial.print(n);
//    Serial.println(".");
//    
//    int decode;
//    int numSettlingTimes = min(n, 2047);
//    
//    if (n > 1023) {
//      decode = 3;
//      numSettlingTimes /= 4;
//    } else if (n > 511) {
//      decode = 1;
//      numSettlingTimes /= 2;
//    } else {
//      decode = 0;
//      numSettlingTimes = n;
//    } 
//    
//   int i2cStatus; 
//  
//   Wire.beginTransmission(AD5933_ADDR);
//   Wire.send(NUM_SETTLING_CYCLES_REGISTER[0]);
//   Wire.send((numSettlingTimes >> 8) + (decode << 1));
//   i2cStatus = Wire.endTransmission();
//   
//   Wire.beginTransmission(AD5933_ADDR);
//   Wire.send(NUM_INCREMENTS_REGISTER[1]);
//   Wire.send(numSettlingTimes & 255);
//   i2cStatus = Wire.endTransmission();
//
//    if (i2cStatus)
//       return false;
//     else
//       return true;
//     
//}
