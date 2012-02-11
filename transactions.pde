// How to write or read a byte:
// 1. master device asserts a start condition on SDA
// 2. master sends the 7-bit slave address followed by the write bit (low)
// 3. addressed slave device asserts an acknowledge on SDA
// 4. The master send a register address or pointer command code (1011 0000)
// 5. the slave asserts an acknowledge on SDA
// 6. the master sends a data byte or register address to where the pointer is to point
// 7. the slave asserts an acknowledge on SDA
// 8. the master asserts a stop condition on SDA to end the transaction

int getByte(int address) {

  int rxByte;

  Wire.beginTransmission(AD5933_ADDR);
  Wire.send(ADDRESS_PTR);
  Wire.send(address);
  int i2cStatus = Wire.endTransmission();

  Wire.requestFrom(AD5933_ADDR, 1);

  if (1 <= Wire.available()) {
    rxByte = Wire.receive();
  } 
  else {
    rxByte = -1;
  }

  return rxByte;

}

boolean setByte(int address, int value) {

  Wire.beginTransmission(AD5933_ADDR);
  Wire.send(address);
  Wire.send(value);
  int i2cStatus = Wire.endTransmission();

  if (i2cStatus)
    return false;
  else
    return true; 

}

boolean setControlRegister(int code) {
 
  int rxByte = getByte(CONTROL_REGISTER[0]);

  rxByte &= 0x0F; // clear upper four bits
  rxByte |= code << 4; // set to 1011

  boolean s = setByte(CONTROL_REGISTER[0], rxByte);
  
  delay(10); 
  
  return s;
  
}
