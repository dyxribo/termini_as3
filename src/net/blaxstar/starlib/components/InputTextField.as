package net.blaxstar.starlib.components {

    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Shape;
    import flash.events.Event;
    import flash.events.FocusEvent;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.events.TextEvent;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFieldType;
    import flash.text.TextFormat;

    import net.blaxstar.starlib.input.InputEngine;
    import net.blaxstar.starlib.math.Arithmetic;
    import net.blaxstar.starlib.style.Font;
    import net.blaxstar.starlib.style.Style;
    import net.blaxstar.starlib.utils.Strings;

    import org.osflash.signals.natives.NativeSignal;

    /**
     * ...
     * @author Deron D. (decamp.deron@gmail.com)
     */
    public class InputTextField extends Component {
        // textfield
        private var _text_field:TextField;
        private var _textfield_underline:Shape;
        private var _textfield_background:Shape;
        private var _textfield_underline_strength:uint;
        private var _textfield_string:String;
        private var _text_format:TextFormat;
        private var _hint_text:String;
        //private var _leading_icon:Icon;
        private var _is_hinting:Boolean;
        private var _showing_underline:Boolean;
        private var _has_leading_icon:Boolean;
        private var _is_password_field:Boolean;
        private var _is_focused:Boolean;
        // suggestions
        private var _input_engine:InputEngine;
        private var _suggestion_iterator_index:uint;
        private var _input_cache:Array;
        private var _showing_suggestions:Boolean;
        private var _initial_selection_made:Boolean;
        // signals
        private var _on_focus:NativeSignal;
        private var _on_defocus:NativeSignal;

        public function InputTextField(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, hint_text:String = "type something") {
            _hint_text = _textfield_string = hint_text;
            _is_hinting = true;
            super(parent, xpos, ypos);
        }

        // ! PUBLIC FUNCTIONS ! //

        override public function init():void {
            _text_format = Font.BODY_2;
            _text_format.color = Style.TEXT.value;
            _showing_underline = true;
            super.init();
        }

        override public function add_children():void {
            _text_field = new TextField();
            _text_field.type = TextFieldType.INPUT;
            _text_field.autoSize = TextFieldAutoSize.NONE;
            _text_field.defaultTextFormat = _text_format;
            _text_field.embedFonts = true;
            _text_field.selectable = true;
            _text_field.border = false;
            _text_field.background = false;
            _text_field.height = 30;
            _text_field.width = 200;
            _text_field.text = _textfield_string;
            _text_field.setTextFormat(_text_format);
            addChild(_text_field);
            _textfield_background = new Shape();
            _textfield_underline = new Shape();
            _textfield_underline_strength = 1;
            addChild(_textfield_background);
            addChild(_textfield_underline);
            update_underline();
            update_background();
            setChildIndex(_textfield_background, 0);

            _on_focus = new NativeSignal(_text_field, FocusEvent.FOCUS_IN, FocusEvent);
            _on_defocus = new NativeSignal(_text_field, FocusEvent.FOCUS_OUT, FocusEvent);

            _on_focus.add(on_focus);

            super.add_children();

        }

        override public function draw(e:Event = null):void {
            // determine text color based on current field status
            if (_is_hinting) {
                if (Style.CURRENT_THEME == Style.DARK) {
                    _text_field.textColor = Style.TEXT.shade().value;
                } else {
                    _text_field.textColor = Style.TEXT.tint().value;
                }
                _text_field.text = _hint_text;
            } else {
                _text_field.textColor = Style.TEXT.value;
                if (_is_password_field) {
                    _text_field.displayAsPassword = true;
                } else {
                    _text_field.displayAsPassword = _is_password_field;
                }
                // set the text
                _text_field.text = _textfield_string;
            }

            // set height, width is adjustable manually only
            _text_field.height = _text_field.textHeight + 4;
            // update the underline if applicable, just in case width changes
            if (_showing_underline) {
                update_underline();
            } else {
                _text_field.width = _width_;
                _text_field.height = _height_;
            }
            update_background();

            dispatchEvent(_resize_event_);
        }

        public function format(fmt:TextFormat = null):void {
            if (fmt == null) {
                _text_field.setTextFormat(Font.BODY_2);
                _text_format = Font.BODY_2;
            } else {
                _text_field.defaultTextFormat = fmt;
                _text_format = fmt;
            }
            commit();
        }

        private function update_background():void {
            _textfield_background.graphics.clear();
            _textfield_background.graphics.beginFill(Style.BACKGROUND.value);
            _textfield_background.graphics.drawRoundRect(0, 0, _width_, _height_, 7, 7);
            _textfield_background.graphics.endFill();
        }

        private function update_underline():void {
            _textfield_underline.graphics.clear();
            _textfield_underline.graphics.lineStyle(_textfield_underline_strength, Style.SECONDARY.value);

                _textfield_underline.graphics.lineTo(_text_field.width, 0);
            

            _textfield_underline.y = _text_field.height + 4;
            _width_ = _textfield_underline.width;
            _height_ = _textfield_underline.y + _textfield_underline.height;
        }
        
        // ! DELEGATE FUNCTIONS !//

        private function on_key_down(e:KeyboardEvent):void {
            if (e.keyCode == _input_engine.keys.TAB) {
                e.preventDefault();
            } 
        }

        private function on_focus(e:FocusEvent):void {
            _on_focus.remove(on_focus);
            _is_focused = true;
            if (_is_hinting) {
                _is_hinting = false;
                _textfield_string = "";
                _text_field.text = "";
            } else {
                _text_field.setSelection(0, _text_field.text.length);
            }

            if (_showing_underline) {
                _textfield_underline_strength = 2;
                update_underline();
            }
            update_background();

            _on_defocus.add(on_defocus);
        }

        private function on_defocus(e:FocusEvent):void {
            _on_defocus.remove(on_defocus);
            _is_focused = false;

            if (_text_field.text == "") {
                show_hint_text();
            } else {
                _textfield_string = _text_field.text;
            }

            if (_showing_underline) {
                _textfield_underline_strength = 1;
                update_underline();
            }
            update_background();

            _on_focus.add(on_focus);
        }

        private function show_hint_text():void {
            if (_is_password_field) {
                _text_field.displayAsPassword = false;
            }
            _text_field.text = _hint_text;
            _is_hinting = true;
            commit();
        }

        // ! GETTERS & SETTERS ! //

        public function get input_target():TextField {
            return _text_field;
        }

        public function get text():String {
            _textfield_string = _text_field.text;
            return _textfield_string;
        }

        public function set text(val:String):void {
            if (val != "") {
                _is_hinting = false;
            }
            _textfield_string = val;
            draw();
        }

        public function get hint_text():String {
            return _hint_text;
        }

        public function set hint_text(val:String):void {
            if (Strings.is_empty_or_null(val)) {
                _hint_text = "enter text...";
            } else {
                _hint_text = val;
            }

            show_hint_text();
        }

        public function get color():uint {
            return _text_field.textColor;
        }

        public function set color(val:uint):void {
            _text_field.textColor = val;
        }

        public function get showing_underline():Boolean {
            return _showing_underline;
        }

        public function set showing_underline(val:Boolean):void {
            if (!val) {
                _textfield_underline.graphics.clear();
                if (_textfield_underline.parent) {
                    removeChild(_textfield_underline);
                }
            }
            _showing_underline = val;
            draw();
        }

        public function get display_as_password():Boolean {
            return _is_password_field;
        }

        public function set display_as_password(val:Boolean):void {
            _is_password_field = val;
            commit();
        }

        public function set restrict(value:String):void {
            _text_field.restrict = value;
        }

        // ! GARBAGE COLLECTION ! //
        override public function destroy():void {
            _on_focus.removeAll();
            _on_defocus.removeAll();
        }
    }

}
