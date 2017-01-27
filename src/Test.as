package
{
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObjectContainer;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindow;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class Test extends Sprite
	{
		private var myTextBox:TextField = new TextField();  
		private var placeholder_text:String = "Type Your Text";
		 
		
		public function Test()
		{
			var fileMenu:NativeMenuItem;
			
			if (NativeWindow.supportsMenu){ 
				stage.nativeWindow.menu = new NativeMenu();  
				fileMenu = stage.nativeWindow.menu.addItem(new NativeMenuItem("File")); 
				fileMenu.submenu = createFileMenu(); 
			} 
			
			if (NativeApplication.supportsMenu){  
				fileMenu = NativeApplication.nativeApplication.menu.addItem(new NativeMenuItem("File")); 
				fileMenu.submenu = createFileMenu(); 
			}
			
			init();
			
		}
		
		
		public function createFileMenu():NativeMenu { 
			var fileMenu:NativeMenu = new NativeMenu(); 
			var newCommand:NativeMenuItem = fileMenu.addItem(new NativeMenuItem("Save")); 
			newCommand.addEventListener(Event.SELECT, selectCommand); 
			
			return fileMenu; 
		} 
		
		public function init():void 
		{ 
			myTextBox.x = 10;
			myTextBox.y = 10;
			myTextBox.width = 480;
			myTextBox.type = TextFieldType.INPUT; 
			myTextBox.background = true; 
			myTextBox.multiline = true;
			myTextBox.wordWrap = true;
			myTextBox.border = true;
			myTextBox.antiAliasType = AntiAliasType.ADVANCED;
			myTextBox.sharpness = 1;
			myTextBox.thickness = 25;
			myTextBox.gridFitType = GridFitType.PIXEL;
			myTextBox.text = placeholder_text;
			myTextBox.addEventListener(FocusEvent.FOCUS_IN,  focusIn);
			myTextBox.addEventListener(FocusEvent.FOCUS_OUT, focusOut);
			
			addChild(myTextBox);  
			
			
		
			var textField:TextField = new TextField();
			
			var tf:TextFormat = new TextFormat();
			tf.color = 0xFFFFFF;
			tf.font = "Verdana";
			tf.size = 16;
			tf.align = "center";
			
			textField.text = "SAVE";
			textField.setTextFormat(tf);
			textField.mouseEnabled = false;
			
			var rectangleShape:Shape = new Shape();
			rectangleShape.graphics.beginFill(0x2196F3);
			rectangleShape.graphics.drawRect(0, 0, 100, 25);
			rectangleShape.graphics.endFill();
			
			var simpleButtonSprite:Sprite = new Sprite();
			simpleButtonSprite.name = "simpleButtonSprite";
			simpleButtonSprite.addChild(rectangleShape);
			simpleButtonSprite.addChild(textField);
			
			var simpleButton:SimpleButton = new SimpleButton();
			simpleButton.x = 10;
			simpleButton.y = 120;
			simpleButton.upState = simpleButtonSprite;
			simpleButton.overState = simpleButtonSprite;
			simpleButton.downState = simpleButtonSprite;
			simpleButton.hitTestState = simpleButtonSprite;
			simpleButton.addEventListener(MouseEvent.CLICK, saveButtonClicked);
			addChild(simpleButton);
			
		} 
		
		private function saveButtonClicked(event:Event):void { 
			saveToFile(myTextBox.text);
		} 
		
		public function focusIn(event:Event):void
		{
			if(myTextBox.text == placeholder_text)
			{
				myTextBox.text = ""; 
			}
		}
		
		public function focusOut(event:Event):void
		{
			
			if(myTextBox.text == "")
			{
				myTextBox.text = placeholder_text; 
			}
		}
		
		public function saveToFile(str:String):void 
		{ 
			str = "<xml><content>"+str+"</content></xml>";
			var file:File = File.documentsDirectory.resolvePath("*.xml");
			file.browseForSave("Save XML");
			file.addEventListener(Event.SELECT, select);
			function select(e:Event):void {
				var fileStream:FileStream = new FileStream();
				fileStream.open(file, FileMode.WRITE);
				fileStream.writeUTFBytes(str);
				fileStream.close();
			}
		} 
		
		private function selectCommand(event:Event):void { 
			var commandLabel:String = event.target.label; 
			
			if( commandLabel == "Save"){
				saveToFile(myTextBox.text);
			}
			
		} 
	}
}