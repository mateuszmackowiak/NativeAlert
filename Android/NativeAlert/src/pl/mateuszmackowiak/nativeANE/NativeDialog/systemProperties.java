package pl.mateuszmackowiak.nativeANE.NativeDialog;

import java.security.MessageDigest;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.view.ViewConfiguration;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
/**
*
* @author Mateusz Maçkowiak
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
    
    protected static String getImei(Context context) {
        TelephonyManager m = (TelephonyManager) context
                .getSystemService(Context.TELEPHONY_SERVICE);
        String imei = m != null ? m.getDeviceId() : null;
        return imei;
    }
    
    protected static String getDeviceId(Context context) throws Exception {
        String imei = getImei(context);
        if (imei != null) return imei;
        String tid = getWifiMacAddress(context);
        return tid;
    }
    
    protected static String md5(String s) throws Exception {
        MessageDigest md = MessageDigest.getInstance("MD5");

        md.update(s.getBytes());

        byte digest[] = md.digest();
        StringBuffer result = new StringBuffer();

        for (int i = 0; i < digest.length; i++) {
            result.append(Integer.toHexString(0xFF & digest[i]));
        }
        return (result.toString());
    }
    
    
    protected static String getWifiMacAddress(Context context) throws Exception {
        WifiManager manager = (WifiManager) context
                .getSystemService(Context.WIFI_SERVICE);
        WifiInfo wifiInfo = manager.getConnectionInfo();
        if (wifiInfo == null || wifiInfo.getMacAddress() == null)
            return md5(UUID.randomUUID().toString());
        else return wifiInfo.getMacAddress().replace(":", "").replace(".", "");
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

            	try{
		        	PackageInfo pInfo = activity.getPackageManager().getPackageInfo(activity.getPackageName(), 0);
		        	dictionary.setProperty("packageName",FREObject.newObject(pInfo.packageName));
		        	dictionary.setProperty("sourceDir",FREObject.newObject(pInfo.applicationInfo.sourceDir));
		        	dictionary.setProperty("AppUid",FREObject.newObject(String.valueOf(pInfo.applicationInfo.uid)));
		        	
		        	Boolean hasHardwareMenuButton = true;
		        	if((android.os.Build.VERSION.SDK_INT>14))
		        		hasHardwareMenuButton = ViewConfiguration.get(activity.getBaseContext()).hasPermanentMenuKey();
		        	dictionary.setProperty("hasHardwareMenuButton", FREObject.newObject(hasHardwareMenuButton));
		        	
		        	
		        	
		        	final TelephonyManager tm = (TelephonyManager) activity.getBaseContext().getSystemService(Context.TELEPHONY_SERVICE);
		
		    	    final String tmDevice, tmSerial, androidId;
		    	    tmDevice = "" + tm.getDeviceId();
		    	    tmSerial = "" + tm.getSimSerialNumber();
		    	    androidId = "" + android.provider.Settings.Secure.getString(activity.getContentResolver(), android.provider.Settings.Secure.ANDROID_ID);
		
		    	    UUID deviceUuid = new UUID(androidId.hashCode(), ((long)tmDevice.hashCode() << 32) | tmSerial.hashCode());
		    	    
		    	    dictionary.setProperty("UID",FREObject.newObject(deviceUuid.toString()));
		    	    
		        	dictionary.setProperty("UID2",FREObject.newObject(getDeviceId(activity.getBaseContext()).toString()));
		        	
		        	String MACAdress = getWifiMacAddress(activity.getBaseContext()).toString();
		        	dictionary.setProperty("MACAdress",FREObject.newObject(MACAdress));
		        	
		        	String IMEI = getImei(activity.getBaseContext()).toString();
		        	dictionary.setProperty("IMEI",FREObject.newObject(IMEI));
            	}catch(Exception e){
            		dictionary.setProperty("error",FREObject.newObject(e.toString()));
            	}
            }catch (Exception e){
                e.printStackTrace();
            }
            return dictionary;
    	}
    }
}
