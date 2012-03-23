package pl.mateuszmackowiak.nativeANE.NativeDialog;

import pl.mateuszmackowiak.nativeANE.NativeDialog.alert.AlertContext;
import pl.mateuszmackowiak.nativeANE.NativeDialog.listDialog.ListDialogContext;
import pl.mateuszmackowiak.nativeANE.NativeDialog.progressDialog.ProgressContext;
import pl.mateuszmackowiak.nativeANE.NativeDialog.textInput.TextInputDialogContext;
import pl.mateuszmackowiak.nativeANE.NativeDialog.toast.ToastContext;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

/**
 *
 * @author Mateusz Maçkowiak
 */
public class NativeExtension implements FREExtension{
    
	public static final String ERROR_EVENT = "nativeError";
	
	public static final String LOG_EVENT ="logEvent";
	
	public static final String CLOSED="nativeDialog_closed";
	public static final String OPENED="nativeDialog_opened";
	public static final String CANCELED="nativeDialog_cancled";
	
	public static final String LIST_CHANGE = "nativeListDialog_change";
	
    @Override
    public FREContext createContext(String arg0)
    {
		Log.i("NativeAlert", "createContext");
		if(arg0.equals(ProgressContext.KEY))
			return new ProgressContext();
		else if(arg0.equals(ListDialogContext.KEY))
			return new ListDialogContext();
		else if(arg0.equals(ToastContext.KEY))
			return new ToastContext();
		else if(arg0.equals(systemProperties.KEY))
			return new systemProperties();
		else if(arg0.equals(TextInputDialogContext.KEY))
			return new TextInputDialogContext();
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
