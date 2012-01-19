package pl.mateuszmackowiak.nativeANE.NativeAlert;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;
import android.content.DialogInterface;
import android.app.AlertDialog;
/**
*
* @author Mateusz Maækowiak
*/
public class showAlertFunction implements FREFunction{
    
    public static final String KEY = "showAlertWithTitleAndMessage";

    @Override
    public FREObject call(FREContext context, FREObject[] args)
    {
        String message="";
        String title="",closeLabel="",otherLabel="";
        int theme=AlertDialog.THEME_HOLO_DARK;  
        try{
            title = args[0].getAsString();
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
        try{
            closeLabel = args[2].getAsString();
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
            otherLabel= args[3].getAsString();
        }catch (IllegalStateException e){
            e.printStackTrace();
        }catch (FRETypeMismatchException e){
            e.printStackTrace();
        }catch (FREInvalidObjectException e){
            e.printStackTrace();
        }catch (FREWrongThreadException e){
            e.printStackTrace();
        }
        if (args.length>=5)
        {
	        try{
	            theme= args[4].getAsInt();
	        }catch (IllegalStateException e){
	            e.printStackTrace();
	        }catch (FRETypeMismatchException e){
	            e.printStackTrace();
	        }catch (FREInvalidObjectException e){
	            e.printStackTrace();
	        }catch (FREWrongThreadException e){
	            e.printStackTrace();
	        }
        }
        showAlertWithTitleAndMessage(context,message,title,closeLabel,otherLabel,theme);        
        return null;
    }
    
    private void showAlertWithTitleAndMessage(FREContext context,String message,String title,String closeLabel,String otherLabel,int theme)
    {  
    	AlertDialog.Builder builder = new AlertDialog.Builder(context.getActivity(),theme);
    	
    	if (otherLabel==null || otherLabel.isEmpty())
    	{
    		if(!title.isEmpty())
    			builder.setTitle(title);
    		if(!message.isEmpty())
    			builder.setMessage(message);
        	builder.setNeutralButton(closeLabel, new AlertListener(context));    		
    	}
    	else
    	{
	    	String[] als = otherLabel.split(",");
	        if (als.length==1)
	        {
	        	if(!title.isEmpty())
	        		builder.setTitle(title);
	        	if(!message.isEmpty())
	        		builder.setMessage(message);
	        	builder.setPositiveButton(otherLabel, new AlertListener(context))
	                   .setNegativeButton(closeLabel, new AlertListener(context))
	                   .setOnCancelListener(new CancelListener(context));
	        			
	        }
	        else
	        {
	        	if(!title.isEmpty())
	        		builder.setTitle(title);
	        	else if(!message.isEmpty())
	        		builder.setTitle(message);
	        	else
	        		builder.setTitle(title+": "+message);
	        	String[] als2 = new String[als.length+1];
	         	als2[0]=closeLabel;
	         	for (int i=0;i<als.length;i++)
	        		als2[i+1]=als[i];
	        	builder.setItems(als2, new AlertListener(context));
	        }
    	}
        AlertDialog alert = builder.create();
        alert.show();
    }
    
    private class CancelListener implements DialogInterface.OnCancelListener{
    	private FREContext context; 
    	CancelListener(FREContext context)
    	{
    		this.context=context;
    	}
 
        public void onCancel(DialogInterface dialog) 
        {
     	    context.dispatchStatusEventAsync("ALERT_CLOSED",String.valueOf(-1));        
            dialog.cancel();
        }
    }
    private class AlertListener implements DialogInterface.OnClickListener
    {
    	private FREContext context; 
    	AlertListener(FREContext context)
    	{
    		this.context=context;
    	}
 
        public void onClick(DialogInterface dialog, int id) 
        {
        	if(id==-1)
        		id=0;
        	else if(id==-2)
        		id=1;
        	else if(id==-3)
        		id=0;
     	    context.dispatchStatusEventAsync("ALERT_CLOSED",String.valueOf(id));        
            dialog.cancel();
        }
    	
    }
    
}
