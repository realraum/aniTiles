class AnimationLoader
{
  private boolean mHaveAnimation = false;
  private boolean mHaveMeta = false;
  private boolean mHaveName = false;
  private boolean mHaveCreator = false;
  private boolean mHavePatterns = false;

  private int mPatternCnt = 0;

  private String mName = "";
  private String mCreator = "";

  private boolean mDebug = false;

  private int mX = 0;
  private int mY = 0;

  private GridData[] mPatterns;


  AnimationLoader( String pFileName, GridData[] pSaveTo ) throws Exception
  {
    this.mPatterns = pSaveTo;
    XML vXml = loadXML( pFileName );
    this.parse( vXml );

    if ( !this.mHavePatterns || this.mPatternCnt < 1 )
      throw new Exception( "No animation patterns" );
  }

  AnimationLoader( String pFileName, GridData[] pSaveTo, boolean pDebug ) throws Exception
  {
    this.mPatterns = pSaveTo;
    this.mDebug = pDebug;
    XML vXml = loadXML( pFileName );

    this.parse( vXml );

    if ( !this.mHavePatterns || this.mPatternCnt < 1 )
      throw new Exception( "No animation patterns" );
  }


  public String getName()
  {
    return this.mName;
  }

  public String getCreator()
  {
    return this.mCreator;
  }

  public int getNumberOfPatterns()
  {
    return this.mPatternCnt;
  }

  private void parse( XML pXml ) throws Exception
  {
    if ( pXml.getName().toLowerCase().equals("animation") )
    {
      this.parseAnimation( pXml );
    }
    else throw new Exception("animation not in xml");
  }


  private void parseAnimation( XML pXml )
  {
    this. mHaveAnimation = true;
    this.printDebug( "* Have Animation" );

    XML[] vChilds = pXml.getChildren();

    if ( vChilds.length == 2 )
    {
      this.printDebug( "  + Found two child´s, fine" );
    }
    else  
    {
      this.printDebug( "  - Found " + vChilds.length + " child´s, expeced two!" );
    }

    for ( int i=0; i < vChilds.length; i++ )
    {
      if ( vChilds[i].getName().toLowerCase().equals("meta") )
      {
        this.parseMeta( vChilds[i] );
      }

      if ( vChilds[i].getName().toLowerCase().equals("patterns") )
      {
        this.parsePatterns( vChilds[i] );
      }
    }
  }

  private void parseMeta( XML pXml )
  {
    String vName;
    String vCreator;
    XML[] vChilds = pXml.getChildren();

    if ( !this.mHaveMeta )
    {
      this.mHaveMeta = true;
      this.printDebug( "* Have Meta" );
      if ( vChilds.length == 2 )
      {
        this.printDebug( "  + Found two child´s, fine" );
      }
      else
      {
        this.printDebug( "  - Found " + vChilds.length + " child´s, expeced two!" );
      }

      for ( int i=0; i < vChilds.length; i++ )
      {
        if ( vChilds[i].getName().toLowerCase().equals("name") )
          this.parseName( vChilds[i] );
        if ( vChilds[i].getName().toLowerCase().equals("creator") )
          this.parseCreator( vChilds[i] );
      }
    }
    else
    {
      this.printDebug( "x Have meta already, ignored" );
    }
  }

  private void parseName( XML pXml )
  {
    if ( !this.mHaveName )
    {
      this.mHaveName = true;
      this.mName = pXml.getContent();
      this.printDebug( "  + Have name: " + this.mName );
    }
    else
    {
      this.printDebug( "x Have name already, ignored" );
    }
  }

  private void parseCreator( XML pXml )
  {
    if ( !this.mHaveCreator )
    {
      this.mHaveCreator = true;
      this.mCreator = pXml.getContent();
      this.printDebug( "  + Have creator: " + this.mCreator );
    }
    else
    {
      this.printDebug( "x Have creator already, ignored" );
    }
  }

  private void parsePatterns( XML pXml )
  {
    XML[] vChilds = pXml.getChildren();

    if ( !this.mHavePatterns )
    {
      this.mHavePatterns = true;

    //  this.mPatterns = new GridData[ vChilds.length ]; 

      this.printDebug( "* Have patterns (" + vChilds.length + ")" );
      for ( int i=0; i < vChilds.length; i++ )
        this.parsePattern( vChilds[i] );
    }
    else
    {
      this.printDebug( "x Have patterns already, ignored" );
    }
  }

  private void parsePattern( XML pXml )
  {
    XML[] vChilds = pXml.getChildren();
    this.printDebug( "  + Have pattern Nr:" + this.mPatternCnt );

    this.mX = 0;
    this.mY = 0;

    this.mPatterns[ this.mPatternCnt ] = new GridData( gGridX, gGridY, gSize  );

    if ( vChilds.length == 8 )
    {
      for ( int i=0; i < vChilds.length; i++ )
      {
        this.parseRow( vChilds[i] );
        this.mX++;
      }
    }
    else
    {
      this.printDebug( "  x expected 8 rows but found" + vChilds.length );
    }
    this.mPatternCnt++;
  }


  private void parseRow( XML pXml )
  {
    XML[] vChilds = pXml.getChildren();
    this.printDebug( "  + Have row");

    if ( vChilds.length == 8 )
    {
      this.mY = 0;
      for ( int i=0; i < vChilds.length; i++ )
      {
        this.parseCol( vChilds[i] );
        this.mY++;
      }
    }
    else
    {
      this.printDebug( "  x expected 8 col but found" + vChilds.length );
    }
  }

  private void parseCol( XML pXml )
  {
    color vColor;
    vColor = color( unhex( pXml.getContent() ) );
    this.printDebug( "  + Have col: " + hex( vColor ) );
    this.mPatterns[ this.mPatternCnt ].setColor( mY, mX, vColor );
  }


  private void printDebug( String pMsg )
  {
    if ( this.mDebug )
      println( pMsg );
  }
}