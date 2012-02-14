set signing_options=-storetype pkcs12 -keystore "C:\Users\mateusz\Adobe Flash Builder 4.5\CERTYFIKATY DLA IPODA\android.p12"
set dest_ANE=release\NativeAlert.ane
set extension_XML=extension.xml

set library_SWC=NativeAlert.swc
set dll_Library=NativeAlertCbDll.dll

unzip -o %library_SWC%
del catalog.xml
adt -package %signing_options% -target ane "%dest_ANE%" "%extension_XML%" -swc "%library_SWC%" -platform Windows-x86 library.swf %dll_Library% -platform iPhone-ARM library.swf libNativeAlert.a -platform Android-ARM library.swf nativealert.jar  -platform default library.swf
del %library_SWC%