void measureImpedance() {
 
   // 1. place AD5933 in standby mode
  setControlRegister(STANDBY);
  
  // 2. initialize with start frequency
  setControlRegister(INITIALIZE);
 
  // 3. start frequency sweep
  setControlRegister(START_SWEEP);
  
  // start array:
  Serial.println("data = [ ... ");
  
  while (checkStatus() < frequencySweepComplete) { // if status is 4 or higher, the sweep is complete
 
  // 4. poll status register until complete
   //while (checkStatus() < validImpedanceData) {
   //}
   delay(100); // delay seems to determine the minimum frequency that can be used for an accurate measurement
           // examples (for settling times = 1000)
           // 1 ms:
           // 2 ms:
           // 5 ms:
           // 10 ms:
           // 100 ms:
           // 200 ms:
           // 500 ms: 2000 Hz
           // 1000 ms: 2000 Hz
 
  // 5. read values
   int real = getByte(REAL_DATA_REGISTER[0]) << 8;
   real |= getByte(REAL_DATA_REGISTER[1]);
   
   if (real > 0x7FFF) { // negative value
     real &= 0x7FFF;
     real -= 0x10000;
   }
   
   int imag = getByte(IMAG_DATA_REGISTER[0]) << 8;
   imag |= getByte(IMAG_DATA_REGISTER[1]); 
   
   if (imag > 0x7FFF) { // negative value
     imag &= 0x7FFF;
     imag -= 0x10000;
   }
   
   double magnitude = sqrt(pow(double(real),2) + pow(double(imag),2));
   double gain = 2.3 * pow(10, -10); //calibrated with 220kOhm resistor on 1/3/12
   
   double impedance = 1/(gain*magnitude);
   
   double phase = atan(double(imag)/double(real));
   
   //Serial.print("Real: ");
   Serial.print(real);
   Serial.print(" ");
   
   //Serial.print("Imaginary: ");
   Serial.print(imag);
   Serial.print(" ");
   
   //Serial.print("Magnitude: ");
   Serial.print(magnitude);
   Serial.print(" ");
   
   //Serial.print("Impedance: ");
   Serial.print(impedance);
   Serial.print(" ");
   
   //Serial.print("Phase: ");
   Serial.print(phase);
   Serial.println("; ... ");
 
  // 7. increment frequency
  if (checkStatus() < frequencySweepComplete)
    setControlRegister(INCREMENT);
  
  }
  
  Serial.println(" ");
 
  // 8. power-down mode 
  setControlRegister(POWER_DOWN);
  
  
}


void configureAD5933(int settlingTimes, float startFreq, float freqIncr, int numIncr) 
{
  setNumberOfSettlingTimes(settlingTimes);
  setStartFrequency(startFreq);
  setFrequencyIncrement(freqIncr);
  setNumberOfIncrements(numIncr);

}
