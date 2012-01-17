package pl.mateuszmackowiak.nativeANE.NativeAlert;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

/**
 *
 * @author Mateusz Maćkowiak
 */
public class NativeAlert implements FREExtension{
    
    @Override
    public FREContext createContext(String arg0)
    {
		Log.i("NativeAlert", "createContext");
        return new AlertContext();
    }

    @Override
    public void dispose()
    {
		Log.i("NativeAlert", "dispose");        
    }
     
    @Override
    public void initialize()
    {
		Log.i("NativeAlert", "initialize");        
    }
}
