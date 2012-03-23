package pl.mateuszmackowiak.nativeANE.NativeDialog.textInput;

import pl.mateuszmackowiak.nativeANE.NativeDialog.FREUtilities;
import pl.mateuszmackowiak.nativeANE.NativeDialog.NativeExtension;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.text.Html;
import android.text.InputType;

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
					
					TextInputDialog textInputDialog = (Integer.parseInt(android.os.Build.VERSION.SDK)<11)?new TextInputDialog(freContext.getActivity(),textInputs):new TextInputDialog(freContext.getActivity(),textInputs,theme);

					if(title!=null)
						textInputDialog.setTitle(Html.fromHtml(title));
					
				    textInputDialog.setCancelable(cancelable);
				    if(cancelable==true)
				    	textInputDialog.setOnCancelListener(new CancelListener(freContext));

				    if(buttons!=null && buttons.length>0){
				    	textInputDialog.setPositiveButton(buttons[0], new ClickListener(freContext,textInputDialog));
						if(buttons.length>1)
							textInputDialog.setNeutralButton(buttons[1], new ClickListener(freContext,textInputDialog));
						if(buttons.length>2)
							textInputDialog.setNeutralButton(buttons[2], new ClickListener(freContext,textInputDialog));
					}else
						textInputDialog.setPositiveButton("OK",new ClickListener(freContext,textInputDialog));
				    
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
					freContext.dispatchStatusEventAsync(NativeExtension.CANCELED,String.valueOf(-1));
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
	     	 context.dispatchStatusEventAsync(NativeExtension.CLOSED,String.valueOf(-1));        
	         dialog.dismiss();
        }
    }
	
	

/////////////////////////////////////////
	
	private class TextInputDialog extends AlertDialog.Builder{

		private TextInput textInputs[];

		
		public TextInputDialog(Context context,FREArray fretextFields) throws IllegalArgumentException, FREInvalidObjectException, FREWrongThreadException, IllegalStateException, FRETypeMismatchException, FREASErrorException, FRENoSuchNameException 
		{
			super(context);
			createContent(context,fretextFields);
		}
		public TextInputDialog(Context context,FREArray fretextFields, int theme) throws IllegalArgumentException, FREInvalidObjectException, FREWrongThreadException, IllegalStateException, FRETypeMismatchException, FREASErrorException, FRENoSuchNameException 
		{
			super(context,theme);
			createContent(context,fretextFields);
		}

		
		public void createContent(Context context,FREArray fretextFields) throws IllegalArgumentException, FREInvalidObjectException, FREWrongThreadException, IllegalStateException, FRETypeMismatchException, FREASErrorException, FRENoSuchNameException 
		{
			if(fretextFields==null)
				return;
			
			ScrollView sv = new ScrollView(context);
			LinearLayout ll = new LinearLayout(context);
			ll.setOrientation(LinearLayout.VERTICAL);
			sv.addView(ll);
			
			
			TextInput textInput = null;
			String name ="";
			boolean editable = false;
			
			int length = (int)fretextFields.getLength();
			
			textInputs = new TextInput[length];
			
			
			for (int i = 0; i < length; i++) {
				FREObject fretextField = fretextFields.getObjectAt(i);

				if(fretextField.getProperty("editable")!=null)
					editable = fretextField.getProperty("editable").getAsBool();
				
				if(editable){
					name = (fretextField.getProperty("name")!=null)?fretextField.getProperty("name").getAsString():"";
					if(name.length()>0){
						
						textInput =  new TextInput(context,name);
						
						if(fretextField.getProperty("text")!=null)
							textInput.setText(fretextField.getProperty("text").getAsString());
						
						if(fretextField.getProperty("prompText")!=null)
							textInput.setHint(fretextField.getProperty("prompText").getAsString());	
						
						textInput.setInputType(getInputType(fretextField));
						
						ll.addView(textInput);
						
						textInputs[i] = textInput;
					}
				}else if(fretextField.getProperty("text")!=null){
					TextView tv = new TextView(context);
					tv.setText(fretextField.getProperty("text").getAsString());
					ll.addView(tv);
				}
			}
			setView(sv);
		}
		/**
		 * @return the textInputs
		 */
		public TextInput[] getTextInputs() {
			return textInputs;
		}
	
		
		
		public int  getInputType(FREObject textField) throws IllegalStateException, FRETypeMismatchException, FREInvalidObjectException, FREASErrorException, FRENoSuchNameException, FREWrongThreadException{
			int type = 0x00000001;
			String softKeyboardType="default",autoCapitalize="none";
			boolean displayAsPassword=false,autoCorrect=false;
			
			if(textField.getProperty("softKeyboardType")!=null){
				softKeyboardType = textField.getProperty("softKeyboardType").getAsString();
				if(textField.getProperty("autoCapitalize")!=null)
					autoCapitalize = textField.getProperty("autoCapitalize").getAsString();
				if(textField.getProperty("displayAsPassword")!=null)
					displayAsPassword = textField.getProperty("displayAsPassword").getAsBool();
				if(textField.getProperty("autoCorrect")!=null)
					autoCorrect = textField.getProperty("autoCorrect").getAsBool();
				
				if("url".equals(softKeyboardType)){
					type = InputType.TYPE_TEXT_VARIATION_WEB_EDIT_TEXT;
					if(displayAsPassword)
						type = type | InputType.TYPE_TEXT_VARIATION_PASSWORD;
					if(autoCorrect)
						type = type | InputType.TYPE_TEXT_FLAG_AUTO_CORRECT;
					
					if("word".equals(autoCapitalize))
						type = type | InputType.TYPE_TEXT_FLAG_CAP_WORDS;
					else if("sentence".equals(autoCapitalize))
						type = type | InputType.TYPE_TEXT_FLAG_CAP_SENTENCES;
					else if("all".equals(autoCapitalize))
						type = type | InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS;
					
				}else if("number".equals(softKeyboardType)){
					type = InputType.TYPE_CLASS_NUMBER;
					if(displayAsPassword)
						type = type | InputType.TYPE_NUMBER_VARIATION_PASSWORD;
				}else if("contact".equals(softKeyboardType)){
					type = InputType.TYPE_CLASS_PHONE;
					if(displayAsPassword)
						type = type | InputType.TYPE_NUMBER_VARIATION_PASSWORD;
					
				}else if("email".equals(softKeyboardType)){
					type = InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS;
					if(displayAsPassword)
						type = type | InputType.TYPE_TEXT_VARIATION_PASSWORD;
					if(autoCorrect)
						type = type | InputType.TYPE_TEXT_FLAG_AUTO_CORRECT;
					
					if("word".equals(autoCapitalize))
						type = type | InputType.TYPE_TEXT_FLAG_CAP_WORDS;
					else if("sentence".equals(autoCapitalize))
						type = type | InputType.TYPE_TEXT_FLAG_CAP_SENTENCES;
					else if("all".equals(autoCapitalize))
						type = type | InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS;
				}else{
					type = InputType.TYPE_CLASS_TEXT;
					if(displayAsPassword)
						type = type | InputType.TYPE_TEXT_VARIATION_PASSWORD;
					if(autoCorrect)
						type = type | InputType.TYPE_TEXT_FLAG_AUTO_CORRECT;
					
					
					if("word".equals(autoCapitalize))
						type = type | InputType.TYPE_TEXT_FLAG_CAP_WORDS;
					else if("sentence".equals(autoCapitalize))
						type = type | InputType.TYPE_TEXT_FLAG_CAP_SENTENCES;
					else if("all".equals(autoCapitalize))
						type = type | InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS;
				}
			}
			return type;
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
    	private TextInputDialog dlg;
    	
    	ClickListener(FREContext context,TextInputDialog dlg)
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
		        		for (TextInput textinput : dlg.getTextInputs()) {
		        			if(textinput!=null)
		        				imm.hideSoftInputFromWindow(textinput.getWindowToken(), 0);
						}
		        	}
		        	
		        	String returnString="";
		        	for (TextInput textinput : dlg.getTextInputs()) {
		        		if(textinput!=null)
		        			returnString+="#_#"+textinput.name+"#_#"+textinput.getText().toString();
					}
		        	String ret=String.valueOf(id)+returnString;
		     	    context.dispatchStatusEventAsync(NativeExtension.CLOSED,ret);        
		            dialog.dismiss();
        		}
        	}catch(Exception e){
        		context.dispatchStatusEventAsync(NativeExtension.ERROR_EVENT,e.toString());   
                e.printStackTrace();
        	}
        }
    }
}
