// AD5245 instruction byte:
//  D7: don't care
//  D6: midscale reset
//  D5: shutdown bit
//  D4-D0: don't care

boolean configureAD5245(float R) 
{  
  
    Serial.print("Setting resistance of AD5245 to ");
    Serial.print(R);
    Serial.println(" Ohms.");
  
   int i2cStatus;
  
   int Rw = 50; // wiper resistance
   float Rab = 100*pow(10,3); // max resistance
   
   if (R > Rab) {
     return false;
   } else {
  
     int D = int(( 256 * (R + 2*Rw) ) / Rab);
     
     Wire.beginTransmission(AD5245_ADDR); // master sends a 7-bit slave address
     Wire.send(0x00); // instruction byte
     Wire.send(D);    // data byte
     i2cStatus = Wire.endTransmission();
     
     if (i2cStatus)
       return false;
     else
       return true;
   }  
    
}
