
void setup() {
  PImage img = loadImage("image2.jpg");
  size(img.width, img.height);
  image(img, 0, 0);
  JSONObject json = loadJSONObject("data2.json");
  rectMode( CORNERS );
  JSONArray results = json.getJSONArray( "responses" );
  JSONObject result = results.getJSONObject(0);
  result = result.getJSONObject("fullTextAnnotation");
  //println( result );
  String allStrings = result.getString("text");
  //println ( allStrings );
  JSONArray pages = result.getJSONArray("pages");
  JSONObject page = pages.getJSONObject(0);
  JSONArray blocks = page.getJSONArray("blocks");

  for ( int i=0; i<blocks.size (); i++ ) {
    String blockStrings = "";
    JSONObject block = blocks.getJSONObject(i);
    //println("============== " +   i + " ================");
    //println( block );
    JSONObject boundingBox = block.getJSONObject("boundingBox");
    JSONArray vertices = boundingBox.getJSONArray("vertices");
    //println( vertices );
    JSONObject leftTop = vertices.getJSONObject(0);
    JSONObject rightTop = vertices.getJSONObject(1);
    JSONObject rightBottom = vertices.getJSONObject(2);
    JSONObject leftBottom = vertices.getJSONObject(3);
    fill( 255, 0, 0, 10 );
    rect( leftTop.getInt("x"), leftTop.getInt("y"), rightBottom.getInt("x"), rightBottom.getInt("y") );

    JSONArray paragraphs = block.getJSONArray("paragraphs");
    for ( int p=0; p<paragraphs.size (); p++ ) {

      JSONObject paragraph = paragraphs.getJSONObject(p);
      JSONArray words = paragraph.getJSONArray("words");
      //println(words);
      for ( int w=0; w<words.size (); w++ ) {

        //println("■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ " + w + " ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■");
        JSONObject word = words.getJSONObject(w);
        //println( word );
        JSONArray symbols = word.getJSONArray("symbols");
        for ( int s=0; s<symbols.size (); s++ ) {
          img = loadImage("image2.jpg");

          JSONObject symbol = symbols.getJSONObject(s);
          String text = symbol.getString("text");
          blockStrings += text;

          JSONObject childBoundingBox = symbol.getJSONObject("boundingBox");
          JSONArray childVertices = childBoundingBox.getJSONArray("vertices");
          JSONObject c_leftTop = childVertices.getJSONObject(0);
          JSONObject c_rightTop = childVertices.getJSONObject(1);
          JSONObject c_rightBottom = childVertices.getJSONObject(2);
          JSONObject c_leftBottom = childVertices.getJSONObject(3);
          
          if (  c_rightBottom.getInt("x") - c_leftTop.getInt("x") + 10 > 0 && c_rightBottom.getInt("y")- c_leftTop.getInt("y") + 10 > 0 ) {
          fill( 0, 0, 255, 10 );
          rect( c_leftTop.getInt("x"), c_leftTop.getInt("y"), c_rightBottom.getInt("x"), c_rightBottom.getInt("y") );
          println(text);

          

            println(  c_leftTop.getInt("x")-5, c_leftTop.getInt("y")-5, c_rightBottom.getInt("x") - c_leftTop.getInt("x") + 10, c_rightBottom.getInt("y")- c_leftTop.getInt("y") + 10 );

            img = img.get( c_leftTop.getInt("x")-5, c_leftTop.getInt("y")-5, c_rightBottom.getInt("x") - c_leftTop.getInt("x") + 10, c_rightBottom.getInt("y")- c_leftTop.getInt("y") + 10 );

            println(sketchPath("") +"save3/" + text + ".png");
            int num = 0;
            File saveFile = new File( sketchPath("") + "save3/" + text + "_" + num + ".png"  );
            while ( saveFile.exists () ) {
              num++;
              saveFile = new File( sketchPath("") + "save3/" + text + "_" + num + ".png"  );
            }

            img.save( "save3/" + text +"_" + num + ".png");
          }
        }
      }
    }
    fill(0);
    text( blockStrings, leftTop.getInt("x"), leftTop.getInt("y")-5 );
  }

  //JSONArray block
}

