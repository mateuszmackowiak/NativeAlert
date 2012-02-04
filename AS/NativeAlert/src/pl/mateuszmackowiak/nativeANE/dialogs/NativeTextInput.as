package pl.mateuszmackowiak.nativeANE.dialogs
{
	public class NativeTextInput
	{
		
		
		/**There is no content type. The text is not editable.*/
		public static const none:int =0x00000000;
		/**Just plain old text. Corresponds to TYPE_CLASS_TEXT | TYPE_TEXT_VARIATION_NORMAL*/
		public static const text:int =0x00000001;
		/**Can be combined with text and its variations to request capitalization of all characters. Corresponds to TYPE_TEXT_FLAG_CAP_CHARACTERS*/
		public static const textCapCharacters:int =0x00001001;
		/**Can be combined with text and its variations to request capitalization of the first character of every word. Corresponds to TYPE_TEXT_FLAG_CAP_WORDS*/
		public static const textCapWords:int =0x00002001;
		/**Can be combined with text and its variations to request capitalization of the first character of every sentence. Corresponds to TYPE_TEXT_FLAG_CAP_SENTENCES*/
		public static const textCapSentences:int =0x00004001;
		/**Can be combined with text and its variations to request auto-correction of text being input. Corresponds to TYPE_TEXT_FLAG_AUTO_CORRECT*/
		public static const textAutoCorrect:int =0x00008001;
		/**Can be combined with text and its variations to specify that this field will be doing its own auto-completion and talking with the input method appropriately. Corresponds to TYPE_TEXT_FLAG_AUTO_COMPLETE*/
		public static const textAutoComplete:int =0x00010001;
		/**Can be combined with text and its variations to allow multiple lines of text in the field. If this flag is not set, the text field will be constrained to a single line. Corresponds to TYPE_TEXT_FLAG_MULTI_LINE*/
		public static const textMultiLine:int =0x00020001;
		/**Can be combined with text and its variations to indicate that though the regular text view should not be multiple lines, the IME should provide multiple lines if it can. Corresponds to TYPE_TEXT_FLAG_IME_MULTI_LINE*/
		public static const textImeMultiLine:int =0x00040001;
		/**Can be combined with text and its variations to indicate that the IME should not show any dictionary-based word suggestions. Corresponds to TYPE_TEXT_FLAG_NO_SUGGESTIONS*/
		public static const textNoSuggestions:int =0x00080001;
		/**Text that will be used as a URI. Corresponds to TYPE_CLASS_TEXT | TYPE_TEXT_VARIATION_URI*/
		public static const textUri:int =0x00000011;
		/**Text that will be used as an e-mail address. Corresponds to TYPE_CLASS_TEXT | TYPE_TEXT_VARIATION_EMAIL_ADDRESS*/
		public static const textEmailAddress:int =0x00000021;
		/**Text that is being supplied as the subject of an e-mail. Corresponds to TYPE_CLASS_TEXT | TYPE_TEXT_VARIATION_EMAIL_SUBJECT*/
		public static const textEmailSubject:int =0x00000031;
		/**Text that is the content of a short message. Corresponds to TYPE_CLASS_TEXT | TYPE_TEXT_VARIATION_SHORT_MESSAGE*/
		public static const textShortMessage:int =0x00000041;
		/**Text that is the content of a long message. Corresponds to TYPE_CLASS_TEXT | TYPE_TEXT_VARIATION_LONG_MESSAGE*/
		public static const textLongMessage:int =0x00000051;
		/**Text that is the name of a person. Corresponds to TYPE_CLASS_TEXT | TYPE_TEXT_VARIATION_PERSON_NAME*/
		public static const textPersonName:int =0x00000061;
		/**Text that is being supplied as a postal mailing address. Corresponds to TYPE_CLASS_TEXT | TYPE_TEXT_VARIATION_POSTAL_ADDRESS*/
		public static const textPostalAddress:int =0x00000071;
		/**Text that is a password. Corresponds to TYPE_CLASS_TEXT | TYPE_TEXT_VARIATION_PASSWORD*/
		public static const textPassword:int =0x00000081;
		/**Text that is a password that should be visible. Corresponds to TYPE_CLASS_TEXT | TYPE_TEXT_VARIATION_VISIBLE_PASSWORD*/
		public static const textVisiblePassword:int =0x00000091;
		/**Text that is being supplied as text in a web form. Corresponds to TYPE_CLASS_TEXT | TYPE_TEXT_VARIATION_WEB_EDIT_TEXT*/
		public static const textWebEditText:int =0x000000a1;
		/**Text that is filtering some other data. Corresponds to TYPE_CLASS_TEXT | TYPE_TEXT_VARIATION_FILTER*/
		public static const textFilter:int =0x000000b1;
		/**Text that is for phonetic pronunciation, such as a phonetic name field in a contact entry. Corresponds to TYPE_CLASS_TEXT | TYPE_TEXT_VARIATION_PHONETIC*/
		public static const textPhonetic:int =0x000000c1;
		/**Text that will be used as an e-mail address on a web form. Corresponds to TYPE_CLASS_TEXT | TYPE_TEXT_VARIATION_WEB_EMAIL_ADDRESS*/
		public static const textWebEmailAddress:int =0x000000d1;
		/**Text that will be used as a password on a web form. Corresponds to TYPE_CLASS_TEXT | TYPE_TEXT_VARIATION_WEB_PASSWORD*/
		public static const textWebPassword:int =0x000000e1;
		/**A numeric only field. Corresponds to TYPE_CLASS_NUMBER | TYPE_NUMBER_VARIATION_NORMAL*/
		public static const number:int =0x00000002;
		/**Can be combined with number and its other options to allow a signed number. Corresponds to TYPE_CLASS_NUMBER | TYPE_NUMBER_FLAG_SIGNED*/
		public static const numberSigned:int =0x00001002;
		/**Can be combined with number and its other options to allow a decimal (fractional) number. Corresponds to TYPE_CLASS_NUMBER | TYPE_NUMBER_FLAG_DECIMAL*/
		public static const numberDecimal:int =0x00002002;
		/**A numeric password field. Corresponds to TYPE_CLASS_NUMBER | TYPE_NUMBER_VARIATION_PASSWORD*/
		public static const numberPassword:int =0x00000012;
		/**For entering a phone number. Corresponds to TYPE_CLASS_PHONE*/
		public static const phone:int =0x00000003;
		/**For entering a date and time. Corresponds to TYPE_CLASS_DATETIME | TYPE_DATETIME_VARIATION_NORMAL*/
		public static const datetime:int =0x00000004;
		/**For entering a date. Corresponds to TYPE_CLASS_DATETIME | TYPE_DATETIME_VARIATION_DATE*/
		public static const date:int =0x00000014;
		/**For entering a time. Corresponds to TYPE_CLASS_DATETIME | TYPE_DATETIME_VARIATION_TIME*/
		public static const time:int =0x00000024;
		
		
		
		
		public var inputType:int = 0;
		public var name:String;
		public var text:String;
		public var prompText:String;
		public var messageBefore:String;
		
		public function NativeTextInput(name:String)
		{
			this.name = name;
		}
	}
}