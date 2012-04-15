#!/bin/sh
/Applications/Adobe\ Flash\ Builder\ 4.6/sdks/4.6.0_3.3/bin/adt -package -target ane NativeAlert.ane ./extension.xml -swc NativeAlert.swc -platform iPhone-ARM -C ./ios . -platform default library.swf -platform Android-ARM library.swf nativeAlert.jar -platform iPhone-x86 -C ./ios_simulator . -platform Windows-x86 library.swf NativeAlertCbDll.dll
