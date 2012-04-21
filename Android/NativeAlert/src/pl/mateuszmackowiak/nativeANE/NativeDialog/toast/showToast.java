package pl.mateuszmackowiak.nativeANE.NativeDialog.toast;

import pl.mateuszmackowiak.nativeANE.NativeDialog.NativeExtension;
import android.content.Context;
import android.text.Html;
import android.widget.Toast;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class showToast implements FREFunction {

	public static final String KEY = "Toast";
	
	@Override
	public FREObject call(FREContext freContext, FREObject[] args) {
		
		
		String text = "";
		int duration = Toast.LENGTH_SHORT;
		Integer gravity=null;
		int xOffset=0,yOffset=0;
		
		try{
			text = args[0].getAsString();
			if(args.length>1 && args[1]!=null)
				duration = args[1].getAsInt();
			if(args.length>2){
				gravity = args[2].getAsInt();
				xOffset = args[3].getAsInt();
				yOffset = args[4].getAsInt();
			}
			
			Context context = freContext.getActivity().getApplicationContext();

			Toast toast = Toast.makeText(context, Html.fromHtml(text), duration);
			if(gravity!=null)
				toast.setGravity(gravity.intValue(), xOffset, yOffset);
		
			toast.show();
        }catch (Exception e){
        	freContext.dispatchStatusEventAsync(NativeExtension.ERROR_EVENT,KEY+"  "+e.toString());
        }
		return null;
	}

}
