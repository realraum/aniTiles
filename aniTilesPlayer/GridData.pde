class GridData
{
  private Tile[][] mGrid; 
  
  
  GridData( int pX, int pY, int pSize )
  {   
    mGrid = new Tile[8][8];
    for ( int i=0; i<8; i++ )
      for ( int j=0; j<8; j++ )
        mGrid[i][j] = new Tile( pX + i*pSize, pY + j*pSize, pSize );        
  }

  public void setColor( int pX, int pY, color pColor )
  {
    this.mGrid[ pX ][ pY ].setColor( pColor );
  }  

  public color getColor( int pX, int pY )
  {
    return this.mGrid[ pX ][ pY ].getColor();
  }
  
  public Tile getTile( int pX, int pY)
  {
    return this.mGrid[ pX ][ pY ]; 
  }
}