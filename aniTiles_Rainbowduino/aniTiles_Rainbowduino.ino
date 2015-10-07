
/*
 *  aniTiles_Rainbowduino
 *
 *  animatet tiles, Rainbowduino arduino scatch
 *
 *  Copyright (C) 2015 Tom Hlina <tom.hlina@blinkingnoise.org.org>
 *
 *  This file is part of aniTiles.
 *
 *  aniTiles is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  any later version.
 *
 *  aniTiles is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with aniTiles. If not, see <http://www.gnu.org/licenses/>.
 */

#include <Rainbowduino.h>

#define BAUD 19200

int redBuffer[8][8];
int greenBuffer[8][8];
int blueBuffer[8][8];

char inBuffer[192];


void setup( void )
{

for( int x=0; x<8; x++ )
  for( int y=0; y<8; y++ )
  {
  	redBuffer[x][y] = 0xFF;
    greenBuffer[x][y] = 0xFF;
    blueBuffer[x][y] = 0xFF;
  }

for( int i=0; i<192; i++ )
	inBuffer[i] = 0;


  Rb.init();
  Serial.begin( BAUD ); 
  Serial.setTimeout( 2000 );
  Rb.blankDisplay();	
   drawTile();
 }


 void loop()
 {

 	int bytes = Serial.readBytesUntil( 0xFF, inBuffer, 192 );
  int x = 0;
  int y = 0;
  int c = 0;

  if( bytes != 0)
  {
    for( int i=0; i<192; i++ )
    {
    
      // color
      c = i % 3;

      x = 7 - floor( (i/3)/8 ); 
      y = 7 - int(floor( i/3 ) )% 8;

      switch (c)
      {
          case 0:
            redBuffer[x][y] = inBuffer[i];
            break;
          case 1:
            greenBuffer[x][y] = inBuffer[i];
            break;
          case 2:
            blueBuffer[x][y] = inBuffer[i];
            break;
          default:
            Serial.write( 0x0D );
      }

    }

      //Rb.setPixelXY( floor( i/8 ) , i%8, 0, 0, inBuffer[i] );
    drawTile();
    Serial.write( 0x00 );
   //Rb.setPixelXY( 0, 0, 0x00FFFFFF);
  }
  else
    Serial.write( 0x0F);

 }


 void drawTile()
 {
 	for( int x=0; x<8; x++)
  	  for( int y=0; y<8; y++)
  	Rb.setPixelXY(x , y, redBuffer[x][y], greenBuffer[x][y], blueBuffer[x][y] );
 }




