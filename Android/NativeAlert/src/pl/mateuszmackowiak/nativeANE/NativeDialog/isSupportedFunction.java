package pl.mateuszmackowiak.nativeANE.NativeDialog;

//import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;

/**
*
* @author Mateusz Maækowiak
*/
public class isSupportedFunction implements FREFunction{
    
    public static final String KEY = "isSupported";

    @Override
    public FREObject call(FREContext context, FREObject[] args) {
        FREObject b = null;
        try{
            b = FREObject.newObject(true);
        }catch (FREWrongThreadException e){
//        	Log.e("in isSupported", e.getMessage());
            e.printStackTrace();
        }
        return b;
	}
}
