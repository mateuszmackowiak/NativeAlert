package pl.mateuszmackowiak.nativeANE.NativeDialog.listDialog;

import pl.mateuszmackowiak.nativeANE.NativeDialog.FREUtilities;
import pl.mateuszmackowiak.nativeANE.NativeDialog.NativeExtension;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.text.Html;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class showListDialog implements FREFunction {

	public static final String KEY = "showListDialog";
	
	private AlertDialog mDialog = null;
	
	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		String function="",title="";
		String buttons[] = null, choices[] = null;
		boolean checkedItems[] = null,cancelable = false;
		Integer checkedItem = null;
		int theme = AlertDialog.THEME_HOLO_DARK;
	
		try{
		 	function = args[0].getAsString();
			if(function.equals("show")){
		        title = args[1].getAsString();
		        
				if(args[2] instanceof FREArray)
		        	buttons = FREUtilities.convertFREArrayToStringArray((FREArray)args[2]);
				
		        if(args[3] instanceof FREArray)
		        	choices = FREUtilities.convertFREArrayToStringArray((FREArray)args[3]);
		        else
		        	context.dispatchStatusEventAsync(NativeExtension.ERROR_EVENT, "args[3] is not an array");
		        
		        
		        if(args[4]!=null && args[4] instanceof FREArray)
					checkedItems = FREUtilities.convertFREArrayToBooleadArray((FREArray)args[4]);
				else if(args[4]!=null)
		        	checkedItem = args[4].getAsInt();
		        else
					context.dispatchStatusEventAsync(NativeExtension.ERROR_EVENT, "args[4] is not an array");
		        
		        cancelable = args[5].getAsBool();
		        theme = args[6].getAsInt();
	        	mDialog = createPopup(context,title,buttons,choices,checkedItems,checkedItem,cancelable,theme);
	        	
	        	
	        	
		        mDialog.show();
				context.dispatchStatusEventAsync(NativeExtension.OPENED,String.valueOf(-2));
		        
		        
			}else if(function.equals("hide")){
				if(mDialog!=null && mDialog.isShowing()){
					mDialog.hide();
					context.dispatchStatusEventAsync(NativeExtension.CLOSED,String.valueOf(-2));
				}
			}else if(function.equals("kill")){
				if(mDialog!=null){
					mDialog.dismiss();
					context.dispatchStatusEventAsync(NativeExtension.CLOSED,String.valueOf(-2));
				}
			}else if(function.equals("isShowing")){
				FREObject b = null;
				if(mDialog!=null && mDialog.isShowing()==true)
					b = FREObject.newObject(true);
				else{
					b = FREObject.newObject(false);
				}
		        return b;
			}else{
				context.dispatchStatusEventAsync(NativeExtension.ERROR_EVENT,KEY+" No souch function "+function);
			}
		}catch (Exception e){
			context.dispatchStatusEventAsync(NativeExtension.ERROR_EVENT, KEY+"   "+e.toString());
	        e.printStackTrace();
	    }
		return null;
	}


	public AlertDialog createPopup(FREContext context, String title, String buttons[], CharSequence choices[],boolean checkedItems[],Integer checkedItem, boolean cancelable, int theme) {
		AlertDialog.Builder builder = new AlertDialog.Builder(context.getActivity(),theme);
		try{
			if(title!=null && !title.isEmpty())
				builder.setTitle(Html.fromHtml(title));
			
			builder.setCancelable(cancelable);
			if(cancelable==true)
				builder.setOnCancelListener(new CancelListener(context));
			
			if(choices!=null && checkedItem!=null){
				context.dispatchStatusEventAsync(NativeExtension.LOG_EVENT, KEY+"   jest jeden element "+String.valueOf(checkedItem.intValue()));
				builder.setSingleChoiceItems(choices, checkedItem.intValue(), new SingleChoiceClickListener(context));
			}else if(choices!=null && (checkedItems==null || checkedItems.length == choices.length)){
				builder.setMultiChoiceItems(choices, checkedItems, new IndexChange(context));
			}else
				context.dispatchStatusEventAsync(NativeExtension.ERROR_EVENT, KEY+"  labels are empty or the list of labels is not equal to list of selected labels ");
			
			if(buttons!=null && buttons.length>0){
				builder.setPositiveButton(buttons[0], new ConfitmListener(context));
				if(buttons.length>1)
					builder.setNeutralButton(buttons[1], new ConfitmListener(context));
				if(buttons.length>2)
					builder.setNegativeButton(buttons[2], new ConfitmListener(context));
			}else
				builder.setPositiveButton("OK",new ConfitmListener(context));
			
		}catch(Exception e){
			context.dispatchStatusEventAsync(NativeExtension.ERROR_EVENT,KEY+"   "+e.toString());
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
     	    context.dispatchStatusEventAsync(NativeExtension.CANCLED,String.valueOf(-1));        
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
     	    context.dispatchStatusEventAsync(NativeExtension.CLOSED,String.valueOf(id));     
            dialog.dismiss();
        }
    }
	
	private class SingleChoiceClickListener implements DialogInterface.OnClickListener{
    	private FREContext context; 
    	SingleChoiceClickListener(FREContext context)
    	{
    		super();
    		this.context=context;
    	}
 
        public void onClick(DialogInterface dialog,int id) 
        {
     	    context.dispatchStatusEventAsync(NativeExtension.LIST_CHANGE,String.valueOf(id));     
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
     	    context.dispatchStatusEventAsync(NativeExtension.LIST_CHANGE,String.valueOf(id)+"_"+String.valueOf(checked));        
        }
    }
//
}
