using System;
using System.IO;
using System.Xml;
using System.Xml.Xsl;
using System.Text;
using System.Text.RegularExpressions;
using System.Diagnostics.Contracts;

namespace VectorConvertor
{
    public static class VectorConvertor
    {
        public static String VmlToSvg(String vmlXmlString)
        {
            vmlXmlString = Regex.Replace(vmlXmlString,@"/(<meta[^>]*[^\/]?)>/i", @"$1/>");
            vmlXmlString = Regex.Replace(vmlXmlString, @"/\/(\/>)/i", "$1");
            var xslTrans = new XslCompiledTransform();
            xslTrans.Load("vml2svg.xsl");
            MemoryStream writer = new MemoryStream();
            xslTrans.Transform(
                new XmlTextReader(
                    new MemoryStream(Encoding.Unicode.GetBytes(vmlXmlString))
                ),
                null,
                new XmlTextWriter(writer, Encoding.Unicode));
            return Encoding.Unicode.GetString(writer.ToArray()).Replace("d=\"Mc","d=\"M");
        }

        public static String Svg2Vml(String svgString)
        {
            svgString = Regex.Replace(svgString, @"/(<meta[^>]*[^\/]?)>/i", @"$1/>");
            svgString = Regex.Replace(svgString, @"/\/(\/>)/i", "$1");
            svgString = Regex.Replace(svgString, @"/<\!DOCTYPE[^>]+\>/i", "");
            svgString = Regex.Replace(svgString, @"/<\?xml-stylesheet[^>]+\>/i", "$1");
            var xslTrans = new XslCompiledTransform();
            xslTrans.Load("svg2vml.xsl");
            MemoryStream writer = new MemoryStream();
            xslTrans.Transform(
                new XmlTextReader(
                    new MemoryStream(Encoding.Unicode.GetBytes(svgString))
                ),
                null,
                new XmlTextWriter(writer, Encoding.Unicode));
            return Encoding.Unicode.GetString(writer.ToArray());
        }
    }
}
