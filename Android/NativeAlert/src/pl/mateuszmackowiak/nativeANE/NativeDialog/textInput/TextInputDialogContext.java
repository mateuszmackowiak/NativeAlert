package pl.mateuszmackowiak.nativeANE.NativeDialog.textInput;

import java.util.HashMap;
import java.util.Map;

import pl.mateuszmackowiak.nativeANE.NativeDialog.NativeExtension;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class TextInputDialogContext extends FREContext {

	public static final String KEY = "TextInputDialogContext";
	private Map<String, FREFunction> map = null;
	@Override
	public void dispose() {
		if(map!=null){
			FREObject args[] = new FREObject [1];
	    	try {
				args[0] = FREObject.newObject("hide");
				
					map.get(showTextInputDialog.KEY).call(this,args);
	    	} catch (Exception e) {
	    		dispatchStatusEventAsync(NativeExtension.ERROR_EVENT,"while disposeing   "+e.toString());
				e.printStackTrace();
			}
		}
	}

	@Override
	public Map<String, FREFunction> getFunctions() {
		map = new HashMap<String, FREFunction>();
      //  map.put(isSupportedFunction.KEY, new isSupportedFunction());
        map.put(showTextInputDialog.KEY, new showTextInputDialog());
        return map;
	}

}
