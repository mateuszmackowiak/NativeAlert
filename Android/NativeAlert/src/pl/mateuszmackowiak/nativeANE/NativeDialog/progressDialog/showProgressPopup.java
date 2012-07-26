package pl.mateuszmackowiak.nativeANE.NativeDialog.progressDialog;

import pl.mateuszmackowiak.nativeANE.NativeDialog.NativeExtension;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.text.Html;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;


public class showProgressPopup implements FREFunction {

	public static final String KEY = "showProgressPopup";
	
	private int MAX_PROGRESS = 100;
	
	private ProgressDialog mProgressDialog=null;

	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		
		try{
			String function="";
		 	function = args[0].getAsString();
        
			if("showPopup".equals(function)){
				
				String title="", message="";
				int style = ProgressDialog.STYLE_HORIZONTAL , theme = 0;
				Integer secondaryProgress = null,progress=null;
				boolean cancleble = false,indeterminate =false;
				
				progress= args[1].getAsInt();
				secondaryProgress = args[2].getAsInt();
				style = args[3].getAsInt();
				title = args[4].getAsString();
				message = args[5].getAsString();
				cancleble = args[6].getAsBool();
				indeterminate = args[7].getAsBool();
				theme = args[8].getAsInt();
				if(mProgressDialog==null)
					mProgressDialog = createProgressDialog(context,style,progress,secondaryProgress,title,message,theme,cancleble,indeterminate);
				else{
					if(title!=null && !title.isEmpty())
						mProgressDialog.setTitle(Html.fromHtml(title));
					if(message!=null && !message.isEmpty())
						mProgressDialog.setTitle(Html.fromHtml(message));
					mProgressDialog.setProgress(progress);
					mProgressDialog.setCancelable(cancleble);
					if(cancleble==true)
						mProgressDialog.setOnCancelListener(new CancelListener(context));
					
					mProgressDialog.setIndeterminate(indeterminate);
					
				}
				mProgressDialog.show();
				context.dispatchStatusEventAsync(NativeExtension.OPENED,String.valueOf(-2));
				
			}else if("setTitle".equals(function)){
				String title="";
			    title = args[1].getAsString();
				if(mProgressDialog!=null)
					mProgressDialog.setMessage(Html.fromHtml(title));
				
			}else if("setIndeterminate".equals(function)){
				boolean indeterminate =false;
				indeterminate = args[1].getAsBool();
				if(mProgressDialog!=null)
					mProgressDialog.setIndeterminate(indeterminate);
				
			}else if("setMessage".equals(function)){
				String message="";
			    message = args[1].getAsString();
				if(mProgressDialog!=null)
					mProgressDialog.setMessage(Html.fromHtml(message));
				
			}else if("update".equals(function)){
				Integer progress = null;
				progress= args[1].getAsInt();
				if(mProgressDialog!=null && mProgressDialog.isIndeterminate()==false)
					mProgressDialog.setProgress(progress.intValue());
				
			}else if("setSecondary".equals(function)){
				Integer secondaryProgress = null;
				secondaryProgress= args[1].getAsInt();
				if(mProgressDialog!=null)
					mProgressDialog.setSecondaryProgress(secondaryProgress);
				
			}else if("max".equals(function)){
				int max=0;
				max= args[1].getAsInt();
				if(max>=1)
					MAX_PROGRESS = max;
				if(mProgressDialog!=null && mProgressDialog.isIndeterminate()==false)
					mProgressDialog.setMax(max);
	
			}else if("hide".equals(function)){
				if(mProgressDialog!=null && mProgressDialog.isShowing()){
					mProgressDialog.hide();
					context.dispatchStatusEventAsync(NativeExtension.CLOSED,String.valueOf(-2));
				}
			}else if("isShowing".equals(function)){
				FREObject b = null;
				if(mProgressDialog!=null && mProgressDialog.isShowing()==true){
		            b = FREObject.newObject(true);
				}else{
		            b = FREObject.newObject(false);
				}
		        return b;
			}else if("kill".equals(function)){
				if(mProgressDialog!=null){
					mProgressDialog.dismiss();
					context.dispatchStatusEventAsync(NativeExtension.CLOSED,String.valueOf(-2));
				}
			}else{
				context.dispatchStatusEventAsync(NativeExtension.ERROR_EVENT,"No souch function "+function);
			}
			
		}catch (Exception e){
        	context.dispatchStatusEventAsync(NativeExtension.ERROR_EVENT,KEY+"   "+e.toString());
            e.printStackTrace();
        }
		return null;
	}
	
	public ProgressDialog createProgressDialog(FREContext context,int style,Integer progress,Integer secondaryProgress,String title,String message,int theme,boolean cancleble,boolean indeterminate) {
		
		ProgressDialog mDialog = (android.os.Build.VERSION.SDK_INT<11)?new ProgressDialog(context.getActivity()):new ProgressDialog(context.getActivity(),theme);
		try{
			if(title!=null && !title.isEmpty())
				mDialog.setTitle(Html.fromHtml(title));
			if(message!=null && !message.isEmpty())
				mDialog.setMessage(Html.fromHtml(message));
			
	        mDialog.setProgressStyle(style);
	        if(style==ProgressDialog.STYLE_HORIZONTAL){
		        if(indeterminate==true){
		        	mDialog.setIndeterminate(indeterminate);
		        }else{
		        	mDialog.setMax(MAX_PROGRESS);
		        	if(progress!=null)
		        		mDialog.setProgress(progress.intValue());
		        	if(secondaryProgress!=null)
			       		mDialog.setSecondaryProgress(secondaryProgress);
		        }
	        }
	       	mDialog.setCancelable(cancleble);
	       	
	       	mDialog.setOnCancelListener(new CancelListener(context));
		}catch (Exception e){
        	context.dispatchStatusEventAsync(NativeExtension.ERROR_EVENT,KEY+"   "+e.toString());
            e.printStackTrace();
        }
       	return mDialog;
	}
	
	private class CancelListener implements DialogInterface.OnCancelListener{
    	private FREContext context; 
    	CancelListener(FREContext context)
    	{
    		this.context=context;
    	}
 
        @Override
		public void onCancel(DialogInterface dialog) 
        {
        	if(context!=null)
        		context.dispatchStatusEventAsync(NativeExtension.CANCELED,String.valueOf(-1));
            dialog.dismiss();
        }
    }

}
