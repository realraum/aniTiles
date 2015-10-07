

class Config
{
  P5Properties    mP5Prop;
  String          mConfigFile;

  Config()
  {
    //    private BufferedReader reader;
    this.mP5Prop = new P5Properties();
    this.mConfigFile = dataPath("") + "/conf.properties";


    try
    {
      File vConfFile = new File( this.mConfigFile  );
      if ( !vConfFile.exists() )
      {
        vConfFile.createNewFile();
      }
      mP5Prop = new P5Properties();
      mP5Prop.load( createInput( this.mConfigFile ) );
    }
    catch( IOException e )
    {
      e.printStackTrace();
    }
  }

  public boolean isScreenOnlyMode()
  {
    if ( mP5Prop.getIntProperty( "aniTiles.serialPort", - 1 ) < 0 )
    {
      return true;
    } else
    {
      return false;
    }
  }

  public int getAniTilesPort()
  {
    return mP5Prop.getIntProperty( "aniTiles.serialPort", 0 );
  }

  public int getAniTilesBaud()
  {
    return mP5Prop.getIntProperty( "aniTiles.baud", 19200 );
  }


  public boolean isInfoScreenEnabeled()
  {
    if ( mP5Prop.getIntProperty( "infoScreen.serialPort", - 1 ) < 0 )
    {
      return false;
    } else
    {
      return true;
    }
  }

  public int getInfoScreenPort()
  {
    return mP5Prop.getIntProperty( "infoScreen.serialPort", -1 );
  }


  public int getInfoScreenBaud()
  {
    return mP5Prop.getIntProperty( "infoScreen.boud", 19200 );
  }


  public int getAnimationFrameRate()
  {
    return mP5Prop.getIntProperty( "animation.frameRate", 2 );
  }

  public int getAnimationLastFrameMillis()
  {
    return mP5Prop.getIntProperty( "animation.lastFrameMillis", 5000 );
  }

  public boolean isMidiEnabled()
  {
    if ( mP5Prop.getIntProperty( "midi.inPort", - 1 ) < 0 )
    {
      return false;
    } else
    {
      return true;
    }
  }
}