
class AnimationFetcher {

  private String remoteUrl, animationPath;


  AnimationFetcher( String url, String animationPath ) {
    this.remoteUrl = url  + "getList.php";
    this.animationPath = animationPath;
  }

/*
  public boolean isAvailable() {
  
    return true;
  }
*/

  public int updateLocalAnimationPath() {
    BufferedReader reader;
    PrintWriter    writer;

    String line;
    ArrayList<String> localAnimations  = new ArrayList<String>();
    ArrayList<String> remoteAnimations  = new ArrayList<String>();

    File dir = new File( this.animationPath );

    if ( dir.isDirectory() )
    {
      File files[] = dir.listFiles( xmlFilter );
      if ( files.length > 0 )
      {
        for ( int i=0; i < files.length; i++) {
          localAnimations.add( files[ i ].getName() );
          //println( vFiles[ i ].getName() );
        }
      } else
      {
        println("no files in data directory: " + dir );
      }
    } else
    {
      println("Error: no data directory ");
    }

    reader = createReader( this.remoteUrl );
    try {  
      line = reader.readLine();
      while ( line != null )
      {
        //println( line );

        remoteAnimations.add( line );
        line = reader.readLine();
      }
      reader.close();
    }
    catch (IOException e) {
      e.printStackTrace();
      line = null;
    }

    remoteAnimations.removeAll( localAnimations );
    println( remoteAnimations.size() - 1 + " new animations" );


    for ( String newAnimation : remoteAnimations )
    {
      if ( !newAnimation.equalsIgnoreCase("") )
      {
        println( "fetching " + baseUrl + "data/" + newAnimation );
        reader = createReader( baseUrl + "data/" + newAnimation.replace( " ", "%20" ) );
        writer = createWriter( gAnimationPath + "/" + newAnimation );
        try {  
          line = reader.readLine();
          while ( line != null )
          {
            writer.println( line );

            line = reader.readLine();
          }
          writer.flush();
          writer.close();
          reader.close();
        }
        catch (IOException e) {
          e.printStackTrace();
          line = null;

          writer.flush();
          writer.close();
        }
      }
    }
  return  remoteAnimations.size() - 1 ;
}
}




java.io.FilenameFilter xmlFilter = new java.io.FilenameFilter() 
{
  boolean accept(File dir, String name) {
    return name.toLowerCase().endsWith(".xml");
  }
};