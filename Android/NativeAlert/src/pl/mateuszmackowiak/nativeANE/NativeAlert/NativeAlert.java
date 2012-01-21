package pl.mateuszmackowiak.nativeANE.NativeAlert;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

/**
 *
 * @author Mateusz Maćkowiak
 */
public class NativeAlert implements FREExtension{
    
	public static final String ERROR_EVENT = "nativeError";
	
	public static final String LOG_EVENT ="logEvent";
	
	public static final String CLOSED="nativeDialog_closed";
	public static final String OPENED="nativeDialog_opened";
	public static final String CANCLED="nativeDialog_cancled";
	
	public static final String LIST_CHANGE = "nativeExtensionList_change";
	
    @Override
    public FREContext createContext(String arg0)
    {
		Log.i("NativeAlert", "createContext");
		if(arg0.equals(ProgressContext.KEY))
			return new ProgressContext();
		else if(arg0.equals(MultiChoiceDialogContext.KEY))
			return new MultiChoiceDialogContext();
		else
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
