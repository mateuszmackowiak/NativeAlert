package pl.mateuszmackowiak.nativeANE.NativeDialog.listDialog;

import pl.mateuszmackowiak.nativeANE.NativeDialog.FREUtilities;
import pl.mateuszmackowiak.nativeANE.NativeDialog.NativeExtension;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.text.Html;
import android.util.Log;

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
			if(function.equals("create")){
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

				context.dispatchStatusEventAsync(NativeExtension.OPENED,"");
				
			}else if(function.equals("show") && mDialog!=null){
				mDialog.show();
				
			}else if(function.equals("hide")){
				if(mDialog!=null && mDialog.isShowing()){
					context.dispatchStatusEventAsync(NativeExtension.CANCELED,String.valueOf(-1));
					mDialog.dismiss();
				}
				
			}else if(function.equals("setTitle") && mDialog!=null && mDialog.isShowing()){
				mDialog.setTitle(Html.fromHtml(title));
				
				
			}else if(function.equals("setCancelable") && mDialog!=null){
				cancelable = args[1].getAsBool();
				mDialog.setCancelable(cancelable);
				 if(cancelable==true)
					 mDialog.setOnCancelListener(new CancelListener(context));
				
				
			}else if(function.equals("dismiss") && mDialog!=null){
					mDialog.dismiss();
			}
			/*else if(function.equals("kill")){
				if(mDialog!=null){
					context.dispatchStatusEventAsync(NativeExtension.CANCELED,String.valueOf(-1));
					mDialog.dismiss();
				}
			}*/else if(function.equals("isShowing")){
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
		AlertDialog.Builder builder = (Integer.parseInt(android.os.Build.VERSION.SDK)<11)?new AlertDialog.Builder(context.getActivity()):new AlertDialog.Builder(context.getActivity(),theme);
		try{
			if(title!=null && !title.isEmpty())
				builder.setTitle(Html.fromHtml(title));
			
			builder.setCancelable(cancelable);
			if(cancelable==true)
				builder.setOnCancelListener(new CancelListener(context));
			
			if(choices!=null && checkedItem!=null){
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
 
        @Override
		public void onCancel(DialogInterface dialog) 
        {
        	Log.e("List Dialog","onCancle");
     	    context.dispatchStatusEventAsync(NativeExtension.CANCELED,String.valueOf(-1));        
        }
    }
	private class ConfitmListener implements DialogInterface.OnClickListener{
    	private FREContext context; 
    	ConfitmListener(FREContext context)
    	{
    		this.context=context;
    	}
 
        @Override
		public void onClick(DialogInterface dialog,int id) 
        {
        	Log.e("List Dialog","onClicked");
     	    context.dispatchStatusEventAsync(NativeExtension.CLOSED,String.valueOf(Math.abs(id)));     
        }
    }
	
	private class SingleChoiceClickListener implements DialogInterface.OnClickListener{
    	private FREContext context; 
    	SingleChoiceClickListener(FREContext context)
    	{
    		super();
    		this.context=context;
    	}
 
        @Override
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
 
        @Override
		public void onClick(DialogInterface dialog,int id , boolean checked) 
        {
     	    context.dispatchStatusEventAsync(NativeExtension.LIST_CHANGE,String.valueOf(id)+"_"+String.valueOf(checked));        
        }
    }
//
}
