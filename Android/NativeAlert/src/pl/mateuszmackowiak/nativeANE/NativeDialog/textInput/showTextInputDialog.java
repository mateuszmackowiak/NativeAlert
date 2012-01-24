package pl.mateuszmackowiak.nativeANE.NativeDialog.textInput;

import pl.mateuszmackowiak.nativeANE.NativeDialog.FREUtilities;
import pl.mateuszmackowiak.nativeANE.NativeDialog.NativeExtension;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.text.Html;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;


import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;


public class showTextInputDialog implements FREFunction {

	public static final String KEY = "showTextInput";
	
	public AlertDialog mDialog=null;
	
	@Override
	public FREObject call(FREContext freContext, FREObject[] args) {
		String title="",message="",function="";
		boolean cancelable=true;
		int theme = AlertDialog.THEME_HOLO_DARK;
		try{
			function = args[0].getAsString();
			
			if(function!=null){
				if(function.equals("show")){
					
					String buttons[] = null;
					
					title = args[1].getAsString();
						freContext.dispatchStatusEventAsync(NativeExtension.LOG_EVENT, KEY+"   setting title   "+title.toString());
					message = args[2].getAsString();
						freContext.dispatchStatusEventAsync(NativeExtension.LOG_EVENT, KEY+"   setting message   "+message.toString());
					if(args.length>3){
						if(args[3]!=null && args[3] instanceof FREArray){
							buttons = FREUtilities.convertFREArrayToStringArray((FREArray)args[3]);
							freContext.dispatchStatusEventAsync(NativeExtension.LOG_EVENT, KEY+"   setting buttons   "+buttons.toString());
						}else if(args[3]!=null){
							theme = args[3].getAsInt();
							freContext.dispatchStatusEventAsync(NativeExtension.LOG_EVENT, KEY+"   setting theme  from 3 agrument "+String.valueOf(theme));
						}
						if(args.length>4 && args[4]!=null){
							theme = args[4].getAsInt();
							freContext.dispatchStatusEventAsync(NativeExtension.LOG_EVENT, KEY+"   setting theme  from 4 agrument "+String.valueOf(theme));
						}
					}
					
					AlertDialog.Builder alert = new AlertDialog.Builder(freContext.getActivity(),theme);
					if(title!=null)
						alert.setTitle(Html.fromHtml(title));
					if(message!=null)
						alert.setMessage(Html.fromHtml(message));
					
					EditText input = new EditText(freContext.getActivity());
					
					alert.setView(input);
					
				    alert.setCancelable(cancelable);
				    if(cancelable==true)
				    	alert.setOnCancelListener(new CancelListener(freContext,input));

				    if(buttons!=null && buttons.length>0){
				    	alert.setPositiveButton(buttons[0], new ClickListener(freContext,input));
						if(buttons.length>1)
							alert.setNeutralButton(buttons[1], new ClickListener(freContext,input));
						if(buttons.length>2)
							alert.setNegativeButton(buttons[2], new ClickListener(freContext,input));
					}else
						alert.setPositiveButton("OK",new ClickListener(freContext,input));
				    
				    mDialog = alert.create();
				    alert.show();
				    freContext.dispatchStatusEventAsync(NativeExtension.OPENED,String.valueOf(-2));
				    
				}else if(function.equals("setTitle") && mDialog!=null && mDialog.isShowing()){
						mDialog.setTitle(Html.fromHtml(title));
					
				}else if(function.equals("isShowing")){
					FREObject b = null;
					if(mDialog!=null && mDialog.isShowing()==true){
			            b = FREObject.newObject(true);
					}else{
				        b = FREObject.newObject(false);
					}
			        return b;
			        
			    }else if(function.equals("hide") && mDialog!=null && mDialog.isShowing()){
					mDialog.dismiss();
					freContext.dispatchStatusEventAsync(NativeExtension.CANCLED,String.valueOf(-1));
				}
			}
		}catch (Exception e){
        	freContext.dispatchStatusEventAsync(NativeExtension.ERROR_EVENT,e.toString());   
            e.printStackTrace();
        }
        return null;
	}
	

	private class CancelListener implements DialogInterface.OnCancelListener{
    	private FREContext context;
    	private EditText input;
    	CancelListener(FREContext context,EditText input)
    	{
    		this.input = input;
    		this.context=context;
    	}
 
        public void onCancel(DialogInterface dialog) 
        {
        	try{
		    	InputMethodManager imm = (InputMethodManager)context.getActivity().getSystemService(Context.INPUT_METHOD_SERVICE);
		    	if(imm!=null && imm.isActive())
		    		imm.hideSoftInputFromWindow(input.getWindowToken(), 0);
		    	context.dispatchStatusEventAsync(NativeExtension.CANCLED,String.valueOf(-1)+"#_#"+input.getText().toString());        
		   		dialog.dismiss();
	        }catch(Exception e){
	        	context.dispatchStatusEventAsync(NativeExtension.ERROR_EVENT,e.toString());   
	            e.printStackTrace();
	    	}
        }
    }
	
	private class ClickListener implements DialogInterface.OnClickListener{
    	private FREContext context;
    	private EditText input;
    	ClickListener(FREContext context,EditText input)
    	{
    		this.input = input;
    		this.context=context;
    	}
 
        public void onClick(DialogInterface dialog,int id) 
        {
        	try{
        		
        		Object obj  = context.getActivity().getSystemService(Context.INPUT_METHOD_SERVICE);
        		if(obj instanceof InputMethodManager){
		        	InputMethodManager imm = (InputMethodManager)obj;
		        	if(imm!=null && imm.isActive())
		        		imm.hideSoftInputFromWindow(input.getWindowToken(), 0);
		     	    context.dispatchStatusEventAsync(NativeExtension.CLOSED,String.valueOf(id)+"#_#"+input.getText().toString());        
		            dialog.cancel();
        		}
        	}catch(Exception e){
        		context.dispatchStatusEventAsync(NativeExtension.ERROR_EVENT,e.toString());   
                e.printStackTrace();
        	}
        }
    }
}
