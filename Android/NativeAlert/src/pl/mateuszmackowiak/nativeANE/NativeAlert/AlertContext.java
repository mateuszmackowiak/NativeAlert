package pl.mateuszmackowiak.nativeANE.NativeAlert;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

import java.util.HashMap;
import java.util.Map;

/**
*
* @author Mateusz Maækowiak
*/
public class AlertContext extends FREContext{
	
	public static final String KEY = "NativeAlert";
	
    @Override
    public void dispose(){
    	
    }
    
    @Override
    public Map<String, FREFunction> getFunctions()
    {
		Log.i(KEY, "getFunctions");
       
        Map<String, FREFunction> map = new HashMap<String, FREFunction>();
        map.put(showAlertFunction.KEY, new showAlertFunction());
        map.put(isSupportedFunction.KEY, new isSupportedFunction());
        return map;
        
    }

}
