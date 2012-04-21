package pl.mateuszmackowiak.nativeANE.NativeDialog;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.telephony.TelephonyManager;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
/**
*
* @author Mateusz Maækowiak
*/
public class systemProperties  extends FREContext{
public static final String KEY = "SystemProperites";
	
    @Override
    public void dispose(){
    	
    }
    
    @Override
    public Map<String, FREFunction> getFunctions()
    {
		Log.i(KEY, "getFunctions");
       
        Map<String, FREFunction> map = new HashMap<String, FREFunction>();
        map.put(getSystemProperty.KEY, new getSystemProperty());
        return map;
        
    }
    
    
    private class getSystemProperty implements FREFunction
    {
        
        public static final String KEY = "getSystemProperty";

        @Override
        public FREObject call(FREContext context, FREObject[] args) 
        {
            FREObject dictionary = null;
            try
            {
            	dictionary = FREObject.newObject("flash.utils.Dictionary",null);
            	dictionary.setProperty("java",FREObject.newObject(System.getProperty("java.version")));
            	dictionary.setProperty("os",FREObject.newObject(System.getProperty("os.name")) );
            	dictionary.setProperty("language",FREObject.newObject(System.getProperty("user.language") ));
            	dictionary.setProperty("arch",FREObject.newObject(System.getProperty("os.arch")) );
            	dictionary.setProperty("version",FREObject.newObject(System.getProperty("os.version") ));
            	
            	dictionary.setProperty("name",FREObject.newObject(android.os.Build.MODEL));

            	final Activity activity = context.getActivity();

            	PackageInfo pInfo = activity.getPackageManager().getPackageInfo(context.getActivity().getPackageName(), 0);
            	dictionary.setProperty("packageName",FREObject.newObject(pInfo.packageName));
            	dictionary.setProperty("sourceDir",FREObject.newObject(pInfo.applicationInfo.sourceDir));
            	dictionary.setProperty("AppUid",FREObject.newObject(pInfo.applicationInfo.uid));
            	
            	final TelephonyManager tm = (TelephonyManager) activity.getBaseContext().getSystemService(Context.TELEPHONY_SERVICE);

        	    final String tmDevice, tmSerial, androidId;
        	    tmDevice = "" + tm.getDeviceId();
        	    tmSerial = "" + tm.getSimSerialNumber();
        	    androidId = "" + android.provider.Settings.Secure.getString(activity.getContentResolver(), android.provider.Settings.Secure.ANDROID_ID);

        	    UUID deviceUuid = new UUID(androidId.hashCode(), ((long)tmDevice.hashCode() << 32) | tmSerial.hashCode());
        	    String deviceId = deviceUuid.toString();
        	    
        	    dictionary.setProperty("UID",FREObject.newObject(deviceId));
            }catch (Exception e){
                e.printStackTrace();
            }
            return dictionary;
    	}
    }
}
