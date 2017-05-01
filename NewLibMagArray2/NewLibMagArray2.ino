//This is the updated copy as of 4/14/2017

// Libraries needed
#include <Wire.h>
#include <HMC5883L.h>

// I2C address of the multiplexers
// Defined by holding pins high -> A0 (Addr+1), A1 (Addr+2), A2 (Addr+4) 
#define TCAADDR0 0x70
#define TCAADDR1 0x71
#define TCAADDR2 0x72
#define TCAADDR3 0x73
#define TCAADDR4 0x74

// number of mags. MUST be placed IN ORDER from 0x70 up!
#define total 24

// Array of addresses
int mplxAddrs[] = {TCAADDR0, TCAADDR1, TCAADDR2, TCAADDR3, TCAADDR4};

//Sets Matlab call to !'R'
int mode = -1; 

// Array of Magnetometer structs
HMC5883L compass[total];

// Returns which multiplexer (8 ports) for the mag number
int magtoMultiplex(int magnum)
{
  return magnum/8;
}

// Returns which port on above multiplexer for the mag number
int magtoPort(int magnum)
{
  return magnum % 8; 
}

// This is how arduino sets the port and multiplexer
// Information found from Adafruit forum https://forums.adafruit.com/viewtopic.php?f=19&t=100184
// This fixed the problem of getting repeated values
void tcaselect(uint8_t magnum) 
{ 
  //turns all connected multiplexers off
  for (int i = 0; i < total / 8; i++) {
  Wire.beginTransmission(mplxAddrs[i]);
  Wire.write(0);
  Wire.endTransmission();
  }

  //only begin transmission to the mag we want
  Wire.beginTransmission(mplxAddrs[magtoMultiplex(magnum)]);
  Wire.write(1 << magtoPort(magnum));
  Wire.endTransmission(); 

  //wait for switch to switch (workwaround for garbage data)
  delay(1); 
}

// Checks if mag is connected
void initializemag(int magnum)
{
  tcaselect(magnum);
  if(!compass[magnum].begin())
  {
    /* There was a problem detecting the HMC5883 ... check your connections */
    Serial.print("Ooops, no HMC5883 detected ... Check your wiring on number ");
    Serial.println(magnum);
    while(1);
  }

  // The settings
  
  compass[magnum].setRange(HMC5883L_RANGE_1_3GA);
  // +/- 0.88 Ga: HMC5883L_RANGE_0_88GA
  // +/- 1.30 Ga: HMC5883L_RANGE_1_3GA (default)
  // +/- 1.90 Ga: HMC5883L_RANGE_1_9GA
  // +/- 2.50 Ga: HMC5883L_RANGE_2_5GA
  // +/- 4.00 Ga: HMC5883L_RANGE_4GA
  // +/- 4.70 Ga: HMC5883L_RANGE_4_7GA
  // +/- 5.60 Ga: HMC5883L_RANGE_5_6GA
  // +/- 8.10 Ga: HMC5883L_RANGE_8_1GA

  compass[magnum].setMeasurementMode(HMC5883L_CONTINOUS);
  // Idle mode:              HMC5883L_IDLE
  // Single-Measurement:     HMC5883L_SINGLE
  // Continuous-Measurement: HMC5883L_CONTINOUS (default)

  compass[magnum].setDataRate(HMC5883L_DATARATE_15HZ);
  //  0.75Hz: HMC5883L_DATARATE_0_75HZ
  //  1.50Hz: HMC5883L_DATARATE_1_5HZ
  //  3.00Hz: HMC5883L_DATARATE_3HZ
  //  7.50Hz: HMC5883L_DATARATE_7_50HZ
  // 15.00Hz: HMC5883L_DATARATE_15HZ (default)
  // 30.00Hz: HMC5883L_DATARATE_30HZ
  // 75.00Hz: HMC5883L_DATARATE_75HZ

  compass[magnum].setSamples(HMC5883L_SAMPLES_2);
  // Set number of samples averaged
  // 1 sample:  HMC5883L_SAMPLES_1 (default)
  // 2 samples: HMC5883L_SAMPLES_2
  // 4 samples: HMC5883L_SAMPLES_4
  // 8 samples: HMC5883L_SAMPLES_8

  // Sets the x and y offsets inside readRaw() to 0 and 0
  compass[magnum].setOffset(0,0);
}

void setup(void) 
{
  //setting baud rate
  Serial.begin(115200);

  //Needed to initialize Wire commands
  Wire.begin();
  Wire.setClock(400000L);
  
  //acknowledgment routine for Matlab
  Serial.println('a');
  char a = 'b';
  while(a != 'a')   //Matlab sends back an 'a'
    {
      //wait for PC to communicate
      a=Serial.read();
    }


  //looping initialization
  for (int i = 0; i<total; i++)
  {
    initializemag(i);
  }
}

 
void loop(void) 
{
  if (Serial.available() > 0)
  {
    mode = Serial.read();
    if (mode == 'R')  
    { 
      for(int i = 0; i< total; i++)
        {  
          tcaselect(i);
          Vector norm = compass[i].readNormalize();
          
          /* Display the results (magnetic vector values are in micro-Tesla (uT)) */
            //Serial.print("  Mag:");
            Serial.println(norm.XAxis);//Serial.print("  ");
            delay(1);
            Serial.println(norm.YAxis);//Serial.print("  ");
            delay(1);
            Serial.println(norm.ZAxis);
            delay(1);
      
        }
        //Serial.println("END");
        //Serial.println();
     }
  }
}
