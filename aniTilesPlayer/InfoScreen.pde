
class InfoScreen
{
  private Serial mPort;
  private boolean mSplashWrite;

  InfoScreen( Serial pPort )
  {
    this.mPort = pPort;
    this.mSplashWrite = true;
  }


  public void clear()
  {
    mPort.write( 0x00 );
    this.mSplashWrite = true;
  }

  public void splashScreen()
  {
    if ( this.mSplashWrite )
    {
      mPort.write( 0x01 );
      this.mSplashWrite = false;
    }
  }


  public void info( String pName, String pCreator )
  {
    mPort.write( 0x02 );
    mPort.write( pName );
    mPort.write( 0x03 );
    mPort.write( pCreator );
    this.mSplashWrite = true;
  }
}