package pl.mateuszmackowiak.nativeANE.NativeAlert;

import android.app.AlertDialog;
import android.content.DialogInterface;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;

public class showMultiChoiceDialog implements FREFunction {

	public static final String KEY = "showMultiChoiceDialog";
	
	private AlertDialog mDialog = null;
	
	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		String function="",title="";

		String buttons[] = null;
		String choices[] = null;
		boolean checkedItems[] = null;
		
		int _theme = AlertDialog.THEME_HOLO_DARK;
		boolean cancelable = false;
		
		try{
		 	function = args[0].getAsString();
        }catch (IllegalStateException e){
        	context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+" args[0]"+e.toString());
            e.printStackTrace();
        }catch (FRETypeMismatchException e){
        	context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+" args[0]"+e.toString());
            e.printStackTrace();
        }catch (FREInvalidObjectException e){
        	context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+" args[0]"+e.toString());
            e.printStackTrace();
        }catch (FREWrongThreadException e){
        	context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+" args[0]"+e.toString());
            e.printStackTrace();
        }
		
			
		if(function.equals("showPopup")){
			try{
	            title = args[1].getAsString();
	        }catch (IllegalStateException e){
	        	context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+"  "+function+" args[1]"+e.toString());
	            e.printStackTrace();
	        }catch (FRETypeMismatchException e){
	        	context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+"  "+function+" args[1]"+e.toString());
	            e.printStackTrace();
	        }catch (FREInvalidObjectException e){
	        	context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+"  "+function+" args[1]"+e.toString());
	            e.printStackTrace();
	        }catch (FREWrongThreadException e){
	        	context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+"  "+function+" args[1]"+e.toString());
	            e.printStackTrace();
	        }
			if(args[2] instanceof FREArray){
		        try{
		        	buttons = FREUtilities.convertFREArrayToStringArray((FREArray)args[2]);//args[2].getAsString();
		        } catch (IllegalArgumentException e1) {
					context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+"  "+function+" args[2]"+e1.toString());
				} catch (IllegalStateException e1) {
					context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+"  "+function+" args[2]"+e1.toString());
					e1.printStackTrace();
				} catch (FREInvalidObjectException e1) {
					context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+"  "+function+" args[2]"+e1.toString());
					e1.printStackTrace();
				} catch (FREWrongThreadException e1) {
					context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+"  "+function+" args[2]"+e1.toString());
					e1.printStackTrace();
				} catch (FRETypeMismatchException e1) {
					context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+"  "+function+" args[2]"+e1.toString());
					e1.printStackTrace();
				}
			}
	        if(args[3] instanceof FREArray){
	        	try {
					//choices = FREUtilities.convertFREArrayToCharSequenceArray((FREArray)args[3]);
	        		choices = FREUtilities.convertFREArrayToStringArray((FREArray)args[3]);
	        	} catch (IllegalArgumentException e1) {
					context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+"  "+function+" args[3]"+e1.toString());
				} catch (IllegalStateException e1) {
					context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+"  "+function+" args[3]"+e1.toString());
					e1.printStackTrace();
				} catch (FREInvalidObjectException e1) {
					context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+"  "+function+" args[3]"+e1.toString());
					e1.printStackTrace();
				} catch (FREWrongThreadException e1) {
					context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+"  "+function+" args[3]"+e1.toString());
					e1.printStackTrace();
				} catch (FRETypeMismatchException e1) {
					context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+"  "+function+" args[3]"+e1.toString());
					e1.printStackTrace();
				}
	        }else
	        	context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, "args[3] is not an array");
	        
	        
	        if(args[4] instanceof FREArray){
	        	try {
					checkedItems = FREUtilities.convertFREArrayToBooleadArray((FREArray)args[4]);
				} catch (IllegalArgumentException e1) {
					context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+"  "+function+" args[4]"+e1.toString());
					e1.printStackTrace();
				} catch (IllegalStateException e1) {
					context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+"  "+function+" args[4]"+e1.toString());
					e1.printStackTrace();
				} catch (FREInvalidObjectException e1) {
					context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+"  "+function+" args[4]"+e1.toString());
					e1.printStackTrace();
				} catch (FREWrongThreadException e1) {
					context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+"  "+function+" args[4]"+e1.toString());
					e1.printStackTrace();
				} catch (FRETypeMismatchException e1) {
					context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+"  "+function+" args[4]"+e1.toString());
					e1.printStackTrace();
				}
	        }else
				context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, "args[4] is not an array");
	        
	        
	        
	        try{
	        	cancelable = args[5].getAsBool();
	        }catch (IllegalStateException e){
	        	context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+"  "+function+" args[1]"+e.toString());
	            e.printStackTrace();
	        }catch (FRETypeMismatchException e){
	        	context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+"  "+function+" args[1]"+e.toString());
	            e.printStackTrace();
	        }catch (FREInvalidObjectException e){
	        	context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+"  "+function+" args[1]"+e.toString());
	            e.printStackTrace();
	        }catch (FREWrongThreadException e){
	        	context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+"  "+function+" args[1]"+e.toString());
	            e.printStackTrace();
	        }	        
	        try{
	            _theme = args[6].getAsInt();
	        }catch (IllegalStateException e){
	        	context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+"  "+function+" args[1]"+e.toString());
	            e.printStackTrace();
	        }catch (FRETypeMismatchException e){
	        	context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+"  "+function+" args[1]"+e.toString());
	            e.printStackTrace();
	        }catch (FREInvalidObjectException e){
	        	context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+"  "+function+" args[1]"+e.toString());
	            e.printStackTrace();
	        }catch (FREWrongThreadException e){
	        	context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+"  "+function+" args[1]"+e.toString());
	            e.printStackTrace();
	        }
	        
        	mDialog = createPopup(context,title,buttons,choices,checkedItems,cancelable,_theme);
        	setButtons(context,buttons);
	        mDialog.show();
			context.dispatchStatusEventAsync(NativeAlert.OPENED,String.valueOf(-2));
	        
	        
		}else if(function.equals("hide")){
			if(mDialog!=null && mDialog.isShowing())
				mDialog.hide();
			context.dispatchStatusEventAsync(NativeAlert.CLOSED,String.valueOf(-2));
		}else if(function.equals("isShowing")){
			FREObject b = null;
			if(mDialog!=null && mDialog.isShowing()==true){
		        try{
		            b = FREObject.newObject(true);
		        }catch (FREWrongThreadException e){
		        	context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+"  "+function+" "+e.toString());
		            e.printStackTrace();
		        }
			}else{
				try{
		            b = FREObject.newObject(false);
		        }catch (FREWrongThreadException e){
		        	context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+"  "+function+" "+e.toString());
		            e.printStackTrace();
		        }
			}
	        return b;
		}else{
			context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT,KEY+" No souch function "+function);
		}
		
		return null;
	}

	private void setButtons(FREContext context,String[] buttons) {
		if(buttons!=null && buttons.length>0){
			mDialog.setButton(buttons[0], new ConfitmListener(context));
			if(buttons.length>1)
				mDialog.setButton2(buttons[1], new ConfitmListener(context));
			if(buttons.length>2)
				mDialog.setButton3(buttons[2], new ConfitmListener(context));
		}else
			mDialog.setButton("OK",new ConfitmListener(context));
	}

	public AlertDialog createPopup(FREContext context, String title, String buttons[], String choices[],boolean checkedItems[], boolean cancelable, int _theme) {
		AlertDialog.Builder builder = new AlertDialog.Builder(context.getActivity(),_theme);
		try{
			if(title!=null && !title.isEmpty())
				builder.setTitle(title);
			builder.setCancelable(cancelable);
			if(cancelable==true)
				builder.setOnCancelListener(new CancelListener(context));
			if(choices!=null && (checkedItems==null || checkedItems.length == choices.length)){
				builder.setMultiChoiceItems(choices, checkedItems, new IndexChange(context));
			}else
				context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, KEY+"  labels are empty or the list of labels is not equal to list of selected labels ");
		}catch(Exception e){
			context.dispatchStatusEventAsync(NativeAlert.ERROR_EVENT, e.toString());
		}
		return builder.create();
	}
	
	
	
	private class CancelListener implements DialogInterface.OnCancelListener{
    	private FREContext context; 
    	CancelListener(FREContext context)
    	{
    		this.context=context;
    	}
 
        public void onCancel(DialogInterface dialog) 
        {
     	    context.dispatchStatusEventAsync(NativeAlert.CANCLED,String.valueOf(-1));        
            dialog.cancel();
        }
    }
	private class ConfitmListener implements DialogInterface.OnClickListener{
    	private FREContext context; 
    	ConfitmListener(FREContext context)
    	{
    		this.context=context;
    	}
 
        public void onClick(DialogInterface dialog,int id) 
        {
     	    context.dispatchStatusEventAsync(NativeAlert.CLOSED,String.valueOf(id));     
     	    
            dialog.dismiss();
        }
    }
	private class IndexChange implements DialogInterface.OnMultiChoiceClickListener{
    	private FREContext context; 
    	IndexChange(FREContext context)
    	{
    		this.context=context;
    	}
 
        public void onClick(DialogInterface dialog,int id , boolean checked) 
        {
     	    context.dispatchStatusEventAsync(NativeAlert.LIST_CHANGE,String.valueOf(id)+"_"+String.valueOf(checked));        
        }
    }
//
}
