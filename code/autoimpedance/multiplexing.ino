//const int mux16A = 2;
//const int mux16B = 3;
//const int mux16C = 4;
//const int mux16D = 5;
//
//const int mux4A = 6;
//const int mux4B = 7;
//
//const int mux2A = 8;
//const int mux2B = 9;
//
//int inByte1;
//int inByte2;
//
//int channelNumber = 0;
//
//void setup()
//{
// 
// pinMode(mux16A,OUTPUT);
// pinMode(mux16B,OUTPUT);
// pinMode(mux16C,OUTPUT);
// pinMode(mux16D,OUTPUT);
// pinMode(mux4A,OUTPUT);
// pinMode(mux4B,OUTPUT);
// pinMode(mux2A,OUTPUT);
// pinMode(mux2B,OUTPUT);
// 
// pinMode(ledPin,OUTPUT);
// 
// setSignalPath(0);
// 
// Serial.begin(9600);
// 
// setChannel(channelNumber);
// 
// Serial.println(channelNumber,DEC);
//  
//}
//
//void loop()
//{
//  
//  if (Serial.available() > 0) {
//    
//    int i = 1;
//    channelNumber = 0;
//    
//    while (Serial.peek() != -1)
//    {
//      inByte1 = Serial.read();
//       channelNumber += (inByte1-48)*pow(10,i);
//       i--;
//    }
//    
//    inByte2 = Serial.read();
//    
//    digitalWrite(ledPin,HIGH);
//    
//    setChannel(channelNumber);
//    
//    Serial.read();
//    
//    Serial.println(channelNumber,DEC);
//    
//    delay(500);
//    
//    digitalWrite(ledPin,LOW);
//    
//  }
//    
//      
////    int digit = 0;
////    
////    while (Serial.available())
////    {
////       inByte = Serial.read();
////       channelNumber = channelNumber + (inByte-48)*(pow(10,digit));//(channelNumber << 3 + inByte);
////       ++digit;
////    }
////    
////    Serial.println(channelNumber,DEC);
////      
////    digitalWrite(ledPin,HIGH);
////    
////    setChannel(channelNumber);
////    
////    delay(500);
////    
////    digitalWrite(ledPin,LOW);
////    
////    channelNumber = 0;
////    
////  }
//}
//
//void setChannel(int chan)
//{
//  if (chan < 64)
//  {
//    digitalWrite(mux4A,(chan >> 5) & 1);
//    digitalWrite(mux4B,(chan >> 4) & 1);
//    digitalWrite(mux16A,(chan >> 3) & 1);
//    digitalWrite(mux16B,(chan >> 2) & 1);
//    digitalWrite(mux16C,(chan >> 1) & 1);
//    digitalWrite(mux16D,chan & 1);
//  }
//}
//
//void setSignalPath(int path)
//// 1 == current source, 0 == impedance test
//{
//  digitalWrite(mux2A,path);
//  digitalWrite(mux2B,path);
//}
