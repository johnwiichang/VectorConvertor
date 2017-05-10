#Welcome to VectorConvertor
This library is the .NET implementation of the VML and SVG parts of the VectorConverter project. Support SVG and VML two graphics file format of the exchange via System.Xml.Xsl.

##Warning 
This library cannot work with Microsoft .NET Core currently.

##How to use
You need to copy the library files, XSL folder, XSL2 folder to the same folder.

Convert VML files to SVG:
```
using VectorConvertor;
public class MyClass
{
    public static void Main()
    {
        System.Console.WriteLine(VectorConvertor.VmlToSvg(System.IO.File.ReadAllText("TestVml.vml")));
    }
}
```

##About VectorConverter

> [VectorConverter][1] is a server-side application that performs automatic conversion between SVG, VML and GIF. The application is composed of a few XSLT files to manage the conversion between vector formats, and some PHP scripts that work on raster images.


  [1]: http://vectorconverter.sourceforge.net
