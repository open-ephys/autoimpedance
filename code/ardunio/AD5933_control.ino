/*

    Autoimpedance driver for the electric imp
    
    USAGE:

*/

class ZSensor {

    // i2c object
    _i2c  = null;
	_clock = null;
    
    static ADDRESS = 0x0D;
    local numSteps = [null];
    local startHz = [null];
    local incHz = [null];

    // Construct the  Object
    constructor(i2c, clock) {
        _i2c  = i2c;
		_clock = clock;
    }
    
    function getZ() {
        return -1;
    }
    
    local function getFreqCode(fHz) {
        
        local value = (fHz / (clock.freqHz / 4)) * 2^27;
		local code = [null];
 
        code[0] = (value & 0xFF0000) >> 0x10;
        code[1] = (value & 0x00FF00) >> 0x08;
        code[2] = (value & 0x0000FF);
        
		return code;
    }
    
    //function setStartHz(fHz){
        //startHz = fHz;
    //}
    
    //function setIncHz(fHz){
        //incHz = fHz;
    //}
    
   // function setNumSteps(N){
        //numSteps = N;
    //}
}

class Pot {

    // i2c object
    _i2c  = null;
    
    // Shift 7-bit address to 8-bit address required by the imp
    static ADDRESS = 0x2D << 1;
    
    // Resistances of wiper switch and A --> B terminals
    static Rw   = 50;
    static Rab  = 100e3;

    // Construct the Object
    constructor(i2c) {
        _i2c  = i2c;
    }
    
    function setR(R) {
	    /*
		Sets the A --> W resistance
		
        Inputs:
            R: Resistance value, in ohms, less than 100k
        
        Returns:
            i2c.write result
        */
        
        if (R > Rab) {
            return -1;
        }
        else {
            
            // Get data register value
            local D = 256 + 256*(2*Rw - R)/Rab;
            
            // Configure the resistance from A -> W terminals
            local i2c_result = _i2c.write(ADDRESS, "\00" + D.tochar());
            imp.sleep(0.01); 
            
            // Return i2c result
            return i2c_result;   
            
        }
    }
}

class Clock {

    // i2c object
    _i2c  = null;
    
    // Shift 7-bit address to 8-bit address required by the imp
    static ADDRESS  = 0x17 << 1;
    
    // Current frequency setting
    freqHz = null;
    
    // Construct the Object
    constructor(i2c) {
        _i2c  = i2c;
    }
    
    function setHz(fHz) {
        /*
		Sets the clock frequency
		
        Inputs:
            fHz: String specifying oscillator frequency, e.g. "50kHz"
        
        Returns:
            i2c.write result
        */
        
         // Lookup table for setting the oscillator frequency
        local HZ_LOOKUP = 
        {
            f50MHz   =   ["\xFA\x36", 15, 653],   	//OCT=15, DAC = 653
            f10MHz   =   ["\xD4\xC6", 15, 653],     //OCT=13, DAC = 305
            f5MHz    =   ["\xC4\xC6", 15, 653],     //OCT=12, DAC = 305
            f1MHz    =   ["\x9E\xFE", 15, 653],     //OCT=09, DAC = 959
            f500kHz  =   ["\x8E\xFE", 15, 653],     //OCT=08, DAC = 959
            f100kHz  =   ["\x66\x86", 15, 653],     //OCT=06, DAC = 686
            f50kHz   =   ["\x56\x86", 15, 653],     //OCT=05, DAC = 686
            f10kHz   =   ["\x33\x46", 15, 653],     //OCT=03, DAC = 346
            f5kHz    =   ["\x23\x46", 15, 653],     //OCT=02, DAC = 346
            f1kHz    =   ["\x00\x00", 15, 653]      //OCT=00, DAC = 000
        }
        
        // Configure the clock frequency
        local i2c_result = _i2c.write(ADDRESS, HZ_LOOKUP["f" + fHz][1]); 
        imp.sleep(0.01); 
		
		// Note the true clock frequency
		

        // Return i2c result
        return i2c_result;   
        
    }
}

class Mux {
    
}


// Configure i2c bus
hardware.i2c89.configure(CLOCK_SPEED_100_KHZ);

// Assign globals
pot <- Pot(hardware.i2c89);
clock <- Clock(hardware.i2c89);
zsensor <- ZSensor(hardware.i2c89,clock);

// Test script
server.log("Autoimpedance is running...")


local result = wiggler.setHz("10kHz"); 
if (result == 0) {
    
    server.log("LTC6904 clock frequency set.");
}


local result = pot.setR(20e3); 
if (result == 0) {
    server.log("AD5245 resistance set.");
}
