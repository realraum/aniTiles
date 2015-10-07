class Grid
{

  private int mX;
  private int mY;
  private int mSize;

  Grid( int pX, int pY, int pSize )
  {
    this.mX = pX;
    this.mY = pY;
    this.mSize = pSize;
  }
 
  public void draw( GridData pGridData )
  {
    for ( int i=0; i<8; i++ )
      for ( int j=0; j<8; j++ )
      {
        pushMatrix();
        pGridData.getTile( i, j ).draw();
        popMatrix();
      }
  }
  
  public void setTile( GridData pGridData, int pX, int pY, color pColor )
  {
   int vX = constrain( floor( ( pX - this.mX) / this.mSize ), 0, 7 );
   int vY = constrain( floor( ( pY - this.mY) / this.mSize ), 0, 7 );
   
   pGridData.setColor( vX, vY, pColor );
   pGridData.getTile( vX, vY ).draw();    
  }
  
  public void clear( GridData pGridData )
  {
    for ( int i=0; i<8; i++ )
      for ( int j=0; j<8; j++ )
        pGridData.setColor( i, j, color( 0 ) );
  }
}