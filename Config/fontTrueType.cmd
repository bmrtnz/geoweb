set ROOT=C:\bluewhale\tomcat5.0-19\webapps\GEOWEB\WEB-INF\lib
set CLASSPATH=%ROOT%\fop.jar;%ROOT%\avalon-framework.jar;%ROOT%\commons-logging.jar;%ROOT%\commons-io.jar
java -cp %CLASSPATH% org.apache.fop.fonts.apps.TTFReader C:\WINDOWS\Fonts\IDAutomationC128XL.ttf IDAutomationC128XL.xml
java -cp %CLASSPATH% org.apache.fop.fonts.apps.TTFReader C:\WINDOWS\Fonts\ARIAL.TTF Arial.xml
java -cp %CLASSPATH% org.apache.fop.fonts.apps.TTFReader C:\WINDOWS\Fonts\ARIALBD.TTF ArialBold.xml
java -cp %CLASSPATH% org.apache.fop.fonts.apps.TTFReader C:\WINDOWS\Fonts\TAHOMA.TTF Tahoma.xml
java -cp %CLASSPATH% org.apache.fop.fonts.apps.TTFReader C:\WINDOWS\Fonts\TAHOMABD.TTF TahomaBold.xml
java -cp %CLASSPATH% org.apache.fop.fonts.apps.TTFReader C:\WINDOWS\Fonts\lsans.ttf Lucida.xml
java -cp %CLASSPATH% org.apache.fop.fonts.apps.TTFReader C:\WINDOWS\Fonts\lsansd.ttf LucidaD.xml
java -cp %CLASSPATH% org.apache.fop.fonts.apps.TTFReader C:\WINDOWS\Fonts\lsansdi.ttf LucidaDI.xml
java -cp %CLASSPATH% org.apache.fop.fonts.apps.TTFReader C:\WINDOWS\Fonts\lsansi.ttf LucidaI.xml
java -cp %CLASSPATH% org.apache.fop.fonts.apps.TTFReader C:\WINDOWS\Fonts\MICROSS.ttf MSsansSerif.xml