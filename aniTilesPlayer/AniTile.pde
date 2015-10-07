
class AniTile
{

  private Serial  mPort;

  AniTile( Serial pPort )
  {
    this.mPort = pPort;

    this.mPort.clear();
  }

  void send( GridData pTile )
  {

    for ( int x = 7; x >= 0; x-- )
      for ( int y = 0; y < 8; y++ )
      { 
        int vRed   = constrain( round( red(  pTile.getColor( x, y ) )  ), 0, 0xFD );
        int vGreen = constrain( round( green( pTile.getColor( x, y ) ) / 2 ), 0, 0xFD );
        int vBlue  = constrain( round( blue( pTile.getColor( x, y ) )  / 4 ), 0, 0xFD );
        
        this.mPort.write( vRed );
        this.mPort.write( vGreen );
        this.mPort.write( vBlue );
      }

    while ( this.mPort.available () < 0 ) {
    }
  }
}