
class UserControl
{

  private int mX, mY, mSizeX, mSizeY;
  private PFont mFont;   

  UserControl( int pX, int pY )
  {
    this.mX = pX;
    this.mY = pY;
    this.mSizeX = gSize;
    this.mSizeY = 480;    
    mFont = loadFont( "BitstreamVeraSansMono-Bold-48.vlw" );
  }


  public void draw()
  {
    pushMatrix();
    textFont( mFont, 48 );    
    textAlign( CENTER );
    fill( 0 );
    translate( this.mX, this.mY );

    for ( int i=0; i<8; i++)
    {
      rect( 0, ( i*gSize ), gSize, gSize );
    }
    this.drawButton( 0, "N", false );

    this.drawButton( 3, "P", false );
    this.drawButton( 4, "S", false );

    this.drawButton( 7, "B", false );
    popMatrix();
  }



  private void drawButton( int pId, String pText, boolean pHighlighted )
  {
    color vBackGroundColor = color( 0 );
    color vTextColor = color( 128 );

    if ( pHighlighted )
    {      
      vBackGroundColor = color( 255 );
      vTextColor = color( 192 );
    }

    pushMatrix();
    translate( 0, (gSize * pId ) );
    fill( vBackGroundColor );    
    rect( 0, 0, gSize, gSize );
    fill( color( vTextColor ) );
    text( pText, 0, 12, gSize, gSize );
    popMatrix();
  }



  public char evaluateMousePress()
  {
    char vReturnValue = '_';
    pushMatrix();
    translate( this.mX, this.mY );    
    textFont( mFont, 48 );    
    textAlign( CENTER );
    if (( mouseX >= this.mX ) && ( mouseX <= ( this.mX + gSize ) ) )
    {
      if ( ( mouseY >= this.mY ) && ( mouseY <= ( this.mY + gSize ) ) )
        vReturnValue = this.next();
      if ( (mouseY >= this.mY + gSize * 3 ) && (mouseY <= ( this.mY + 4 *gSize ) ) )
        vReturnValue = this.selectPath();
      if ( (mouseY >= this.mY + gSize * 4 ) && (mouseY <= ( this.mY + 5 *gSize ) ) )
        vReturnValue = this.selectFile();
      if ( (mouseY >= this.mY + gSize * 7 ) && (mouseY <= ( this.mY + 8 *gSize ) ) )
        vReturnValue = this.block();

    }
    popMatrix();
    return vReturnValue;
  }


  private char block()
  {
    gPlayMode = false;
    this.drawButton( 7, "B", true );
    return 'B';
  }

  private char selectFile()
  {
    gPlayMode = false;
    this.drawButton( 4, "S", true );
    return 'S';
  }

  private char selectPath()
  {
    gPlayMode = false;
    this.drawButton( 3, "P", true );
    return 'P';
  }

  private char next()
  {
    gPlayMode = false;
    this.drawButton( 0, "N", true );
    return 'N';
  }

}