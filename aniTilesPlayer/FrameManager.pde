class FrameManager
{

  private int mCurrentFrame;
  private int mMaxFrames;
  private int mFrameRate;
  private int mLastTime;


  FrameManager()
  {
    this.mCurrentFrame = 0;
    this.mMaxFrames = 0;
    this.mLastTime = millis();
    this.mFrameRate = round( 1000 / myConfig.getAnimationFrameRate() );
  }

  public void setMaxFrames( int pMaxFrames )
  {
    this.mMaxFrames = pMaxFrames;
    this.mLastTime = millis();
  }

  public void reset()
  {
    this.mCurrentFrame = 0;
    this.mMaxFrames = 0;
    this.mLastTime = millis();
  }

  public int getCurrentFrame()
  {
    return this.mCurrentFrame;
  }

  public int getMaxFrames()
  {
    return this.mMaxFrames;
  }


  public boolean nextAnimationFrame()
  {
    int vCurrentTime = millis();

    if ( vCurrentTime > this.mLastTime + this.mFrameRate )
    {
      if ( this.mCurrentFrame  < this.mMaxFrames - 1 )
      {
        this.mCurrentFrame++;
        this.mLastTime = vCurrentTime;
        return true;
      } else
      {
        if ( myConfig.isInfoScreenEnabeled() )
          myInfoScreen.splashScreen();
        if ( vCurrentTime > this.mLastTime + myConfig.getAnimationLastFrameMillis()  ) {          
          gPlayMode = false;
          this.mLastTime = vCurrentTime;
        }
      }
    }
    return false;
  }


  public boolean nextAnimationFrame( int PPQNcnt ) 
  {
    if ( PPQNcnt >= 24 ) 
    {
      if ( this.mCurrentFrame  < this.mMaxFrames - 1 )
      {
        this.mCurrentFrame++;
        return true;
      } else {
        gPlayMode = false;
      }
    }
    return false;
  }
}