
/**
 * simple convenience wrapper object for the standard
 * Properties class to return pre-typed numerals
 * http://wiki.processing.org/w/External_configuration_files
 */
class P5Properties extends Properties
{
 
  boolean getBooleanProperty( String pId, boolean pDefault )
  {
    return boolean( getProperty( pId, "" + pDefault ) );
  }
 
  int getIntProperty( String pId, int pDefault )
  {
    return int( getProperty( pId,"" + pDefault ) ); 
  }
 
  float getFloatProperty( String pId, float pDefault )
  {
    return float( getProperty( pId, "" + pDefault ) ); 
  }  
}