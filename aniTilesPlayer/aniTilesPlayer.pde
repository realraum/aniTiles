/*
 *  aniTiles player (processing 3)
 *
 *
 *
 *  Copyright (C) 2015 Tom Hlina <tom.hlina@blinkingnoise.org>
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
import processing.serial.*;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.InputStream;
import java.util.Properties;
import themidibus.*; 


final static int     gMaxFrames = 127; 
final static String  gVersion = "3.0 beta ";
final static int     gGridX  = 60;
final static int     gGridY  = 60; 
final static int     gSize   = 60;


boolean gPlayMode = false;
boolean gFirstRun = true;
boolean gScreenOnly = true;
String  gCurrentAnimation = "";
String  gAnimationPath = "";

int     gCurrentFrame = -1;
boolean isNewFrame = false;

int     PPQNcnt;            //  Pulses Per Quarter Note (MIDI)
int     lastTick;
float   currentBPM;
float   currentFrameRate;
boolean MidiPlayFlag;



Grid            myGrid;
GridData[]      myAnimation;
FrameManager    myFrameManager;
AnimationLoader myLoader;
Blacklist       myBlackList;
UserControl     myUserControl;
Console         myConsole;
InfoScreen      myInfoScreen;
Config          myConfig;
Serial          myAniTlesPort;
AniTile         myAniTile;
MidiBus         myBus; // The MidiBus


void setup() 
{ 
  /* Config */
  myConfig = new Config();
  gScreenOnly = myConfig.isScreenOnlyMode(); 


  gAnimationPath = dataPath(""); //sketchPath + "/data/";

  background( 127 );
  size( 720, 780 ); 
  smooth();   
  frameRate( 25 );
  strokeWeight( 2 );
  stroke( 64 );
  rectMode( CORNER );

  /* MIDI */
  MidiBus.list();
  myBus = new MidiBus(this, 0, -1);  // only input
  lastTick = 0;
  currentBPM = 0;
  currentFrameRate = 0;
  PPQNcnt = 0;  



  myConsole = new Console( 60, 600 );
  myConsole.write( "aniTiles Player Version: " + gVersion );
  myConsole.write( "frameRate: " + myConfig.getAnimationFrameRate() );

  myBlackList = new Blacklist( myConsole );
  myAnimation = new GridData[ gMaxFrames ];
  for ( int i=0; i < gMaxFrames; i++ )
  {
    myAnimation[i] = new GridData( gGridX, gGridY, gSize );
  }
  myGrid = new Grid( gGridX, gGridY, gSize );     
  myFrameManager = new FrameManager();  
  myUserControl = new UserControl( 600, 60 );
  myUserControl.draw();

  if ( !gScreenOnly )
  { 
    myAniTlesPort = new Serial( this, Serial.list()[ myConfig.getAniTilesPort() ], myConfig.getAniTilesBaud() );

    print( "port: " + Serial.list()[ myConfig.getAniTilesPort() ] + ", @" + myConfig.getAniTilesBaud() + " baud" );

    myAniTile = new AniTile( myAniTlesPort );

    myConsole.write( "SerialPort: " + Serial.list()[ myConfig.getAniTilesPort() ] );
  } else
  {
    myConsole.write( "Screen only mode" );
  }

  if ( myConfig.isInfoScreenEnabeled() )
  {
    myInfoScreen = new InfoScreen( new Serial( this, Serial.list()[ myConfig.getInfoScreenPort() ], myConfig.getInfoScreenBaud() ) );
    myConsole.write( "InfoScreenPort" + Serial.list()[ myConfig.getInfoScreenPort() ]  );
  }

  if ( myConfig.isMidiEnabled() )
  {
    myConsole.write( "Midi enabled" );
  } else {
    myConsole.write( "Midi disabled" );
  }

  myConsole.draw();
  myGrid.draw( myAnimation[ myFrameManager.getCurrentFrame() ] );
} 

void draw()
{

  if ( gFirstRun )
  {
    delay( 5000 );
    gFirstRun = false;
  }
  if ( gPlayMode )
  {
    if ( gCurrentFrame != myFrameManager.getCurrentFrame() )
      drawTile( myAnimation[  myFrameManager.getCurrentFrame() ] );

    gCurrentFrame = myFrameManager.getCurrentFrame() ;   


    if ( myConfig.isMidiEnabled() ) {
      isNewFrame = myFrameManager.nextAnimationFrame( PPQNcnt );
      if ( isNewFrame )
        PPQNcnt = 0;
    } else {
      isNewFrame = myFrameManager.nextAnimationFrame();
    }

    /* Use midi clock
     if ( PPQNcnt >= 24 ) {
     myFrameManager.nextAnimationFrame();
     PPQNcnt = 0;
     }
     */
  } else
  {
    if ( myConfig.isInfoScreenEnabeled() )
      myInfoScreen.clear();
    loadRandom();
  }
  myConsole.draw();
  myUserControl.draw();
}

void drawTile( GridData pTile )
{
  myGrid.draw( pTile );
  if ( !gScreenOnly )
  {
    myAniTile.send( pTile );
  }
}

void mousePressed()
{
  switch( myUserControl.evaluateMousePress() )
  {
  case 'B':
    if ( gCurrentAnimation.length() > 0 )
      myBlackList.block( gCurrentAnimation );
    break;
  case 'S':
    //String vFileName = selectInput();
    selectInput("Select a file to process:", "fileSelected");     
    break;
  case 'P':
    selectFolder( "Select a folder to process:", "folderSelected" );
  default:
    break;
  }
}


void fileSelected( File selection )
{
  if ( selection != null )
  { 
    println( selection.getAbsoluteFile() );
    loadMyXML( selection.getAbsoluteFile().toString() );
  }
}

void folderSelected( File selection )
{
  if (selection != null)
  {
    gAnimationPath = selection.getAbsolutePath();
    loadRandom();
  }
}

void loadRandom()
{
  myConsole.clear();
  if ( myConfig.isInfoScreenEnabeled() )
    myInfoScreen.clear();

  File vDir = new File( gAnimationPath );

  if ( vDir.isDirectory() )
  {
    File vFiles[] = vDir.listFiles(xmlFilter );
    if ( vFiles.length > 0 )
    {
      int vIdx = int( random( vFiles.length ) );


      gCurrentAnimation = vFiles[ vIdx ].getName();
      if ( !myBlackList.isBlocked( gCurrentAnimation ) )
      {
        myConsole.write( "Load: " + gCurrentAnimation );
        loadMyXML( gAnimationPath + "/" + gCurrentAnimation );
      }
    } else
    {
      myConsole.write("Error: no files in data directory: " + vDir );
    }
  } else
  {
    myConsole.write("Error: no data directory ");
  }
}


public void loadMyXML( String pXml )
{
  for ( int i=0; i<gMaxFrames; i++)
    myGrid.clear( myAnimation[i] );
  myFrameManager.reset(); 
  try
  {
    myLoader = new AnimationLoader( pXml, myAnimation, false );
    myConsole.write( "Name: " + myLoader.getName() );
    myConsole.write( "Creator: " + myLoader.getCreator() );
    if ( myConfig.isInfoScreenEnabeled() )
    {
      myInfoScreen.info( myLoader.getName(), myLoader.getCreator() );
    }
  }
  catch( Exception e )
  {
    myConsole.write( "Error: loadXML -> " + e.getMessage() );
    println("Error: loadXML -> " + e.getMessage() );
  }

  myFrameManager.setMaxFrames( myLoader.getNumberOfPatterns() );
  gPlayMode = true;
}


void rawMidi(byte[] data) {
  //int currentTick =  millis();

  if ( data[0] == (byte)0xFA ) {
    MidiPlayFlag = true;
  } else if (data[0] == (byte)0xFB ) {
    MidiPlayFlag = true;
  } else if (data[0] == (byte)0xFC ) {
    MidiPlayFlag = false;
  }

  if (data[0] == (byte)0xF8 && MidiPlayFlag ) {
    PPQNcnt++;



    /*
    if ( PPQNcnt >= 24 ) {
     currentBPM = 60000.0 / ( float( (currentTick - lastTick) ) );
     currentFrameRate = currentBPM / 60;
     lastTick =  currentTick;
     PPQNcnt = 0;
     println( "BPM: " +  currentBPM + ", Framerate: " + currentFrameRate);
     }
     */
  }
}



java.io.FilenameFilter xmlFilter = new java.io.FilenameFilter() 
{
  boolean accept(File dir, String name) {
    return name.toLowerCase().endsWith(".xml");
  }
};