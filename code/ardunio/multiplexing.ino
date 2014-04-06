
void setChannel(int chan)
{
  if (chan < 64)
  {
    digitalWrite(mux4A,(chan >> 5) & 1);
    digitalWrite(mux4B,(chan >> 4) & 1);
    digitalWrite(mux16A,(chan >> 3) & 1);
    digitalWrite(mux16B,(chan >> 2) & 1);
    digitalWrite(mux16C,(chan >> 1) & 1);
    digitalWrite(mux16D,chan & 1);
  }
}

void setSignalPath(int path)
// 1 == current source, 0 == impedance test
{
  digitalWrite(mux2A,path);
  digitalWrite(mux2B,path);
}
