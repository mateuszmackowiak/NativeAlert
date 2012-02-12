package pl.mateuszmackowiak.nativeANE.NativeDialog.textInput;

import pl.mateuszmackowiak.nativeANE.NativeDialog.FREUtilities;
import pl.mateuszmackowiak.nativeANE.NativeDialog.NativeExtension;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.text.Html;

import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;


import com.adobe.fre.FREASErrorException;
import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FRENoSuchNameException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;


public class showTextInputDialog implements FREFunction {

	public static final String KEY = "showTextInput";
	
	public AlertDialog mDialog=null;
	
	
	@Override
	public FREObject call(FREContext freContext, FREObject[] args) {
		String title="",function="";
		boolean cancelable=true;
		int theme = 1;
		try{
			function = args[0].getAsString();
			
			if(function!=null){
				if(function.equals("show")){
					
					String buttons[] = null;
					FREArray textInputs = null;
					
					title = args[1].getAsString();
					if(args[2] instanceof FREArray)
						textInputs = (FREArray) args[2];
					if(args.length>3){
						if(args[3]!=null && args[3] instanceof FREArray){
							buttons = FREUtilities.convertFREArrayToStringArray((FREArray)args[3]);
						}else if(args[3]!=null){
							theme = args[3].getAsInt();
						}
						if(args.length>4 && args[4]!=null){
							theme = args[4].getAsInt();
						}
					}
					
					AlertDialog.Builder textInputDialog = (Integer.parseInt(android.os.Build.VERSION.SDK)<11)?new TextInputDialogWithoutTheme(freContext.getActivity(),textInputs):new TextInputDialog(freContext.getActivity(),theme,textInputs);
					if(title!=null)
						textInputDialog.setTitle(Html.fromHtml(title));
					
				    textInputDialog.setCancelable(cancelable);
				    if(cancelable==true)
				    	textInputDialog.setOnCancelListener(new CancelListener(freContext));

				    if(buttons!=null && buttons.length>0){
				    	textInputDialog.setPositiveButton(buttons[0], new ClickListener(freContext,(ITextInput)textInputDialog));
						if(buttons.length>1)
							textInputDialog.setNeutralButton(buttons[1], new ClickListener(freContext,(ITextInput)textInputDialog));
						if(buttons.length>2)
							textInputDialog.setNeutralButton(buttons[2], new ClickListener(freContext,(ITextInput)textInputDialog));
					}else
						textInputDialog.setPositiveButton("OK",new ClickListener(freContext,(ITextInput)textInputDialog));
				    
				    mDialog = textInputDialog.create();
				    textInputDialog.show();
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
    	
    	CancelListener(FREContext context)
    	{
    		this.context=context;
    	}
 
        public void onCancel(DialogInterface dialog) 
        {
        	try{
	     	    context.dispatchStatusEventAsync(NativeExtension.CLOSED,String.valueOf(-1));        
	            dialog.cancel();
        	}catch(Exception e){
        		context.dispatchStatusEventAsync(NativeExtension.ERROR_EVENT,e.toString());   
                e.printStackTrace();
        	}
        }
    }
	
	

/////////////////////////////////////////
	private interface ITextInput{
		TextInput textInputs[] = new TextInput[0];
	}
	private class TextInputDialog extends AlertDialog.Builder implements ITextInput
	{

		TextInput textInputs[];
		public TextInputDialog(Context context, int theme, FREArray fretextInputs) throws IllegalArgumentException, FREInvalidObjectException, FREWrongThreadException, IllegalStateException, FRETypeMismatchException, FREASErrorException, FRENoSuchNameException 
		{
			super(context,theme);
			/*input = new EditText(arg0);
			setView(input);*/
			int length = (int)fretextInputs.getLength();
			textInputs = new TextInput[length];
			TextInput textInput = null;
			String name ="";
			ScrollView sv = new ScrollView(context);
			LinearLayout ll = new LinearLayout(context);
			ll.setOrientation(LinearLayout.VERTICAL);
			sv.addView(ll);
			int type=0;
			for (int i = 0; i < length; i++) {
				FREObject fretextInput = fretextInputs.getObjectAt(i);
				name = (fretextInput.getProperty("name")!=null)?fretextInput.getProperty("name").getAsString():"";
				if(name!=null && name.length()>0){
					if(fretextInput.getProperty("messageBefore")!=null){
						TextView tv = new TextView(context);
						tv.setText(fretextInput.getProperty("messageBefore").getAsString());
						ll.addView(tv);
					}
					textInput = new TextInput(context,name);
					
					if(fretextInput.getProperty("text")!=null)
						textInput.setText(fretextInput.getProperty("text").getAsString());
					if(fretextInput.getProperty("inputType")!=null){
						type = fretextInput.getProperty("inputType").getAsInt();
						textInput.setInputType(type);
					}
					ll.addView(textInput);
					
					textInputs[i] = textInput;
				}
			}
			setView(sv);
			
		}		
	}
	

	private class TextInputDialogWithoutTheme extends AlertDialog.Builder implements ITextInput
	{

		TextInput textInputs[];
		public TextInputDialogWithoutTheme(Context context, FREArray fretextInputs) throws IllegalArgumentException, FREInvalidObjectException, FREWrongThreadException, IllegalStateException, FRETypeMismatchException, FREASErrorException, FRENoSuchNameException 
		{
			super(context);
			
			int length = (int)fretextInputs.getLength();
			textInputs = new TextInput[length];
			TextInput textInput = null;
			String name ="";
			ScrollView sv = new ScrollView(context);
			LinearLayout ll = new LinearLayout(context);
			ll.setOrientation(LinearLayout.VERTICAL);
			sv.addView(ll);
			int type=0;
			for (int i = 0; i < length; i++) {
				FREObject fretextInput = fretextInputs.getObjectAt(i);
				name = (fretextInput.getProperty("name")!=null)?fretextInput.getProperty("name").getAsString():"";
				if(name!=null && name.length()>0){
					if(fretextInput.getProperty("messageBefore")!=null){
						TextView tv = new TextView(context);
						tv.setText(fretextInput.getProperty("messageBefore").getAsString());
						ll.addView(tv);
					}
					textInput = new TextInput(context,name);
					
					if(fretextInput.getProperty("text")!=null)
						textInput.setText(fretextInput.getProperty("text").getAsString());
					if(fretextInput.getProperty("inputType")!=null){
						type = fretextInput.getProperty("inputType").getAsInt();
						textInput.setInputType(type);
					}
					ll.addView(textInput);
					
					textInputs[i] = textInput;
				}
			}
			setView(sv);
			
		}		
	}
	
	
	
	
	
	
	
	
	
	
	private class TextInput extends EditText{
		
		String name="";
		TextInput(Context activity,String _name)
		{
			super(activity);
			name = _name; 
		}
	}
	
	private class ClickListener implements DialogInterface.OnClickListener
	{
    	private FREContext context;
    	private ITextInput dlg;
    	
    	ClickListener(FREContext context,ITextInput dlg)
    	{
    		this.dlg = dlg;
    		this.context=context;
    	}
 
        public void onClick(DialogInterface dialog,int id) 
        {
        	try{
        		Object obj  = context.getActivity().getSystemService(Context.INPUT_METHOD_SERVICE);
        		if(obj!=null && obj instanceof InputMethodManager){
		        	InputMethodManager imm = (InputMethodManager)obj;
		        	if(imm.isActive()){
		        		for (TextInput textinput : dlg.textInputs) {
		        			imm.hideSoftInputFromWindow(textinput.getWindowToken(), 0);
						}
		        	}
		        	
		        	String returnString="";
		        	for (TextInput textinput : dlg.textInputs) {
	        			returnString+="#_#"+textinput.name+"#_#"+textinput.getText().toString();
					}
		        	String ret=String.valueOf(id)+returnString;
		     	    context.dispatchStatusEventAsync(NativeExtension.CLOSED,ret);        
		            dialog.cancel();
        		}
        	}catch(Exception e){
        		context.dispatchStatusEventAsync(NativeExtension.ERROR_EVENT,e.toString());   
                e.printStackTrace();
        	}
        }
    }
}
