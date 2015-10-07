
class Blacklist
{
  private final String mFileName = dataPath("") + "/blacklist.txt"; // sketchPath + "/data/blacklist.txt";
  private ArrayList mBlackList;
  private Console mConsole;

  Blacklist( Console pConsole)
  {
    BufferedReader vReader;
    String vEntry = "";
    this.mConsole = pConsole;
    this.mBlackList = new ArrayList(); 
    vReader = createReader( this.mFileName );


    try
    {
      vEntry = vReader.readLine();
    } 
    catch( Exception e ) 
    {
      e.printStackTrace();
      vEntry = null;
    } 

    while ( vEntry != null )
    {
      this.mBlackList.add( vEntry );

      try
      {
        vEntry = vReader.readLine();
      } 
      catch( IOException e ) 
      {
        e.printStackTrace();
        vEntry = null;
      }
    }
  }

  public boolean isBlocked( String pFile )
  {
    String vBlockedFile = "";
    for ( int i=0; i< this.mBlackList.size(); i++ )
    {
      vBlockedFile = (String) this.mBlackList.get( i );
      if ( pFile.equals( vBlockedFile ) )
      {
        mConsole.write( pFile + " is blocked" );
        return true;
      }
    }
    return false;
  }

  public void block( String pFile )
  {
    BufferedWriter vWriter = null;
    try
    {
      vWriter = new BufferedWriter( new FileWriter( this.mFileName, true ) ); // true means: "append"
      //vWriter = new PrintWriter( this.mFileName ); 

      vWriter.write( pFile + System.getProperty( "line.separator" ) );
      vWriter.flush();
      vWriter.close();
    }
    catch( IOException e ) 
    {
      e.printStackTrace();
    }    
    mBlackList.add( pFile );
    println( "block: " + pFile );
  }
}