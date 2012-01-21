package pl.mateuszmackowiak.nativeANE.NativeAlert;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;


public class showProgressPopup implements FREFunction {

	public static final String KEY = "NativeProgress";
	
	private int MAX_PROGRESS = 100;
	
	private ProgressDialog mProgressDialog=null;

	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		
		String function="",title="", message="";
		int progress=0 ,max=0,  style=ProgressDialog.STYLE_HORIZONTAL , _theme = AlertDialog.THEME_HOLO_DARK;
		boolean cancleble = false;
		
		try{
		 	function = args[0].getAsString();
        }catch (IllegalStateException e){
            e.printStackTrace();
        }catch (FRETypeMismatchException e){
            e.printStackTrace();
        }catch (FREInvalidObjectException e){
            e.printStackTrace();
        }catch (FREWrongThreadException e){
            e.printStackTrace();
        }
		
			
		if(function.equals("showPopup")){
			try{
				progress= args[1].getAsInt();
	        }catch (IllegalStateException e){
	            e.printStackTrace();
	        }catch (FRETypeMismatchException e){
	            e.printStackTrace();
	        }catch (FREInvalidObjectException e){
	            e.printStackTrace();
	        }catch (FREWrongThreadException e){
	            e.printStackTrace();
	        }
			try{
	        	style = args[2].getAsInt();
	        }catch (IllegalStateException e){
	            e.printStackTrace();
	        }catch (FRETypeMismatchException e){
	            e.printStackTrace();
	        }catch (FREInvalidObjectException e){
	            e.printStackTrace();
	        }catch (FREWrongThreadException e){
	            e.printStackTrace();
	        }
	        try{
	            title = args[3].getAsString();
	        }catch (IllegalStateException e){
	            e.printStackTrace();
	        }catch (FRETypeMismatchException e){
	            e.printStackTrace();
	        }catch (FREInvalidObjectException e){
	            e.printStackTrace();
	        }catch (FREWrongThreadException e){
	            e.printStackTrace();
	        }
	        try{
	        	message = args[4].getAsString();
	        }catch (IllegalStateException e){
	            e.printStackTrace();
	        }catch (FRETypeMismatchException e){
	            e.printStackTrace();
	        }catch (FREInvalidObjectException e){
	            e.printStackTrace();
	        }catch (FREWrongThreadException e){
	            e.printStackTrace();
	        }
	        
	        try{
	        	cancleble = args[5].getAsBool();
	        }catch (IllegalStateException e){
	            e.printStackTrace();
	        }catch (FRETypeMismatchException e){
	            e.printStackTrace();
	        }catch (FREInvalidObjectException e){
	            e.printStackTrace();
	        }catch (FREWrongThreadException e){
	            e.printStackTrace();
	        }	        
	        try{
	            _theme = args[6].getAsInt();
	        }catch (IllegalStateException e){
	            e.printStackTrace();
	        }catch (FRETypeMismatchException e){
	            e.printStackTrace();
	        }catch (FREInvalidObjectException e){
	            e.printStackTrace();
	        }catch (FREWrongThreadException e){
	            e.printStackTrace();
	        }
			if(mProgressDialog==null)
				createPopup(context,style,progress,title,message,_theme,cancleble);
			else{
				if(title!=null && !title.isEmpty())
					mProgressDialog.setTitle(title);
				if(message!=null && !message.isEmpty())
					mProgressDialog.setTitle(message);
			}
			mProgressDialog.show();
			context.dispatchStatusEventAsync("nativeProgress_opened",String.valueOf(-2));
			
		}else if(function.equals("setTitle")){
			 	try{
		            title = args[1].getAsString();
		        }catch (IllegalStateException e){
		            e.printStackTrace();
		        }catch (FRETypeMismatchException e){
		            e.printStackTrace();
		        }catch (FREInvalidObjectException e){
		            e.printStackTrace();
		        }catch (FREWrongThreadException e){
		            e.printStackTrace();
		        }
			if(mProgressDialog!=null)
				mProgressDialog.setMessage(title);
		}else if(function.equals("setMessage")){
			 	try{
		            message = args[1].getAsString();
		        }catch (IllegalStateException e){
		            e.printStackTrace();
		        }catch (FRETypeMismatchException e){
		            e.printStackTrace();
		        }catch (FREInvalidObjectException e){
		            e.printStackTrace();
		        }catch (FREWrongThreadException e){
		            e.printStackTrace();
		        }
			if(mProgressDialog!=null)
				mProgressDialog.setMessage(message);
		}else if(function.equals("update")){
			try{
				progress= args[1].getAsInt();
	        }catch (IllegalStateException e){
	            e.printStackTrace();
	        }catch (FRETypeMismatchException e){
	            e.printStackTrace();
	        }catch (FREInvalidObjectException e){
	            e.printStackTrace();
	        }catch (FREWrongThreadException e){
	            e.printStackTrace();
	        }
			if(mProgressDialog!=null)
				mProgressDialog.setProgress(progress);
		}else if(function.equals("max")){
			try{
				max= args[1].getAsInt();
	        }catch (IllegalStateException e){
	            e.printStackTrace();
	        }catch (FRETypeMismatchException e){
	            e.printStackTrace();
	        }catch (FREInvalidObjectException e){
	            e.printStackTrace();
	        }catch (FREWrongThreadException e){
	            e.printStackTrace();
	        }
			if(max>=1)
				MAX_PROGRESS = max;
			if(mProgressDialog!=null)
				mProgressDialog.setMax(max);

		}else if(function.equals("hide")){
			if(mProgressDialog!=null && mProgressDialog.isShowing())
				mProgressDialog.hide();
			context.dispatchStatusEventAsync("nativeProgress_closed",String.valueOf(-2));
		}else if(function.equals("isShowing")){
			FREObject b = null;
	        try{
	            b = FREObject.newObject(true);
	        }catch (FREWrongThreadException e){
	            e.printStackTrace();
	        }
	        return b;
		}else{
			context.dispatchStatusEventAsync("nativeAlertError","No souch function "+function);
		}
			
		
		return null;
	}
	
	public void createPopup(FREContext context,int style,int progress,String title,String message,int theme,boolean cancleble) {
		mProgressDialog = new ProgressDialog(context.getActivity(),theme);

		if(title!=null && !title.trim().isEmpty())
			mProgressDialog.setTitle(title);
		
		if(message!=null && !message.trim().isEmpty())
			mProgressDialog.setMessage(message);
		
        mProgressDialog.setProgressStyle(style);
        mProgressDialog.setMax(MAX_PROGRESS);
        
       	mProgressDialog.setCancelable(cancleble);
        	
       	mProgressDialog.setOnCancelListener(new CancelListener(context));
       	mProgressDialog.setProgress(progress);

	}
	
	private class CancelListener implements DialogInterface.OnCancelListener{
    	private FREContext context; 
    	CancelListener(FREContext context)
    	{
    		this.context=context;
    	}
 
        public void onCancel(DialogInterface dialog) 
        {
     	    context.dispatchStatusEventAsync("nativeProgress_cancled",String.valueOf(-1));        
            dialog.cancel();
        }
    }

}
