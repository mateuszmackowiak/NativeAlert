package pl.mateuszmackowiak.nativeANE.NativeDialog.listDialog;

import java.util.HashMap;
import java.util.Map;

import pl.mateuszmackowiak.nativeANE.NativeDialog.NativeExtension;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class ListDialogContext extends FREContext {

	public static final String KEY = "ListDialogContext";
	private Map<String, FREFunction> map=null;
	
	@Override
	public void dispose() {
		if(map!=null){
			FREObject args[] = new FREObject [1];
	    	try {
				args[0] = FREObject.newObject("kill");
				map.get(showListDialog.KEY).call(this,args);
				
	    	} catch (Exception e) {
	    		dispatchStatusEventAsync(NativeExtension.ERROR_EVENT,"while disposeing   "+e.toString());
				e.printStackTrace();
			}
		}
	}

	@Override
	public Map<String, FREFunction> getFunctions() {
		Log.i(KEY, "getFunctions");
		
		map = new HashMap<String, FREFunction>();
        //map.put(isSupportedFunction.KEY, new isSupportedFunction());
        map.put(showListDialog.KEY, new showListDialog());
        return map;
	}

}
