package pl.mateuszmackowiak.nativeANE.NativeDialog.toast;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

public class ToastContext extends FREContext {

	public static final String KEY = "ToastContext";

	@Override
	public void dispose() {
	}

	@Override
	public Map<String, FREFunction> getFunctions() {
		Map<String, FREFunction> map = new HashMap<String, FREFunction>();
       // map.put(isSupportedFunction.KEY, new isSupportedFunction());
        map.put(showToast.KEY, new showToast());
        return map;
	}

}
