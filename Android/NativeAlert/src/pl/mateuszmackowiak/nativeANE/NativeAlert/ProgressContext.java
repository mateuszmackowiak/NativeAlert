package pl.mateuszmackowiak.nativeANE.NativeAlert;

import java.util.HashMap;
import java.util.Map;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;

public class ProgressContext extends FREContext {

	public static final String KEY = "ProgressContext";

	@Override
	public void dispose() {
		FREObject args[] = new FREObject [1];
    	try {
			args[0] = FREObject.newObject("hide");
		} catch (FREWrongThreadException e) {
			e.printStackTrace();
		}
    	getFunctions().get(showProgressPopup.KEY).call(this,args);
	}

	@Override
	public Map<String, FREFunction> getFunctions() {
		
		Log.i(KEY, "getFunctions");
		
		Map<String, FREFunction> map = new HashMap<String, FREFunction>();
        map.put(isSupportedFunction.KEY, new isSupportedFunction());
        map.put(showProgressPopup.KEY, new showProgressPopup());
        return map;
	}

}
