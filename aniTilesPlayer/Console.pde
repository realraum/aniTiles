
class Console
{

  private int mX, mY, mSizeX, mSizeY, mLineLength, mLines;
  private String mText;
  private PFont mFont;
  private final static int mFontSize = 12;
  private final static String mFontName = "Consolas-12.vlw";

  Console( int pX, int pY )
  {    
    this.mX = pX;
    this.mY = pY;
    this.mSizeX = 600;
    this.mSizeY = 120;
    this.mLineLength = 137;
    this.mLines = 4;

    this.mText = "";    
    mFont = loadFont( mFontName );
  }


  public void write( String pString )
  {
    if ( this.mText.length() < 1  )
    {
      this.mText = pString;
    } else
      this.mText += "\n" + pString;
  }

  public void clear()
  {
    this.mText = "";
  }

  public void draw()
  {
    pushMatrix();
    textAlign( LEFT );
    textFont( mFont, mFontSize );
    fill( 0 );
    translate( this.mX, this.mY );
    rect( 0, 0, this.mSizeX, this.mSizeY );
    fill( 128 );
    text( mText, 10, 10, ( this.mSizeX - 10 ), ( this.mSizeY - 10 ) );    
    popMatrix();
  }
}