class Tile
{
 
  private int mSize;
 
  private int   mX;
  private int   mY;
  private color mColor;
 
  Tile( int pX, int pY, int pSize )
  {
    this.mColor = color( 0 );
 
    this.mX = pX;
    this.mY = pY;
    this.mSize = pSize;
  }
 
  public void setColor( color pColor )
  {
    this.mColor = pColor;
  }
  
  public color getColor()
  {
    return this.mColor;
  }

 
  public void draw()
  {
    pushMatrix();
    fill( this.mColor );
    translate( this.mX, this.mY );
    rect( 0, 0, this.mSize, this.mSize );
    popMatrix();
  }
 
}