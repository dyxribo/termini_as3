package net.blaxstar.starlib.input {
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import net.blaxstar.log4air.LoggerFactory;
    import net.blaxstar.log4air.Logger;
    import net.blaxstar.log4air.appenders.ConsoleAppender;
    import net.blaxstar.log4air.layouts.PatternLayout;
    ConsoleAppender;
    PatternLayout;

    /**
     * Enumerated type holding all the key code values and their names.
     * @author Deron Decamp	(decamp.deron@gmail.com)
     *
     */
    public class InputEngine {
        // const
        static public const KEYUP:uint = 0;
        static public const KEYDOWN:uint = 1;
        static private const _KEYS:KeyboardKeys = new KeyboardKeys();

        // static
        static private var _key_states:Vector.<uint> = new Vector.<uint>(250);
        static private var _init_names:Boolean;
        static private var _keyboard_initialized:Boolean;
        static private var _instantiating_internally:Boolean;
        static private var _stage:Stage;
        static private var _instance:InputEngine;
        static private const LOGGER:Logger = LoggerFactory.getLogger(InputEngine);

        // * CONSTRUCTOR * /////////////////////////////////////////////////////////
        /**
         * instantiates a logical engine for handling user input (keyboard, gamepad, mouse).
         * @param _stage a `_stage` object, which references the main _stage. this allows for input processing from anywhere in the current native window.
         * @param init_keyboard boolean value to initialize keyboard input listeners.
         * @param init_mouse boolean value to initialize mouse input listeners.
         * @param init_gamepad boolean value to initialize gamepad input listeners.
         */
        public function InputEngine() {
          LOGGER.error("initializing Termini instance of InputEngine");
            if (!_instantiating_internally) {
                throw new Error("input engine is a singleton, please use InputEngine.instance()!");
            }
            _instantiating_internally = false;
            _instance = this;
        }

        static public function get_instance():InputEngine {
            if (!_instance) {
                _instantiating_internally = true;
                _instance = new InputEngine();
            }
            return _instance;
        }

        // * PUBLIC * //////////////////////////////////////////////////////////////

        /**
         * initializes listeners on the _stage for input events.
         * NOTE: instantiating this class with the constructor and a non-null _stage
         * will result in an automatic call to this method. this method is mainly
         * for dependency injection.
         * @param _stage
         * @param init_keyboard boolean value to initialize keyboard input listeners.
         * @param init_mouse boolean value to initialize mouse input listeners.
         * @param init_gamepad boolean value to initialize gamepad input listeners.
         */
        public function init(stage:Stage, init_keyboard:Boolean = false):InputEngine {
            // the _stage is needed for these listeners, so if its null, throw errorSS
            if (!stage) {
              throw new Error("the referenced stage object is null, cannot initialize InputEngine!");
            } else if (!_stage) {
                _stage = stage;
            }
            // if none of the init flags are set, then there's no point
            if (init_keyboard == false) {
                return _instance;
            }

            // conditionally activate listeners based on the flags, we won't always want all of them simultaneously
            if (init_keyboard && !_keyboard_initialized) {
                this.init_keyboard();
            }

            return _instance;
        }

        /**
         * checks if a key is currently being pressed on the keyboard.
         * @param keyCode value of the key to check.
         * @return boolean value indicating if the key is being pressed.
         */
        public function key_is_down(keyCode:uint):Boolean {
            // dont bother checking if the keyboard listeners are not initialized, just initialize the keyboard, write a debug message, and return false
            if (!_keyboard_initialized) {
                init_keyboard();
                LOGGER.warn("the keyboard is not yet initialized! initializing keyboard.");
                return false;
            }
            // otherwise return the state of the key with the specified keycode
            return _key_states[keyCode] == 1;
        }
        
        /**
         * adds a delegate to the internal keyboard listener that fires based on `key_event_trigger`.
         * @param delegate the function to be called when `key_event_trigger`'s associated event is dispatched.
         * @param key_event_trigger the keyboard event type to use as a trigger for `delegate`.
         * @return void
         */
        public function add_keyboard_listener(delegate:Function, key_event_trigger:uint = 0):void {
            // if the _stage is not available then there's nothing we can do
            if (!_stage) {
                LOGGER.warn("the stage is not available, could not add keyboard listener!");
            } else {
                // otherwise lets add listeners based on the trigger
                if (key_event_trigger == KEYDOWN) {
                    _stage.addEventListener(KeyboardEvent.KEY_DOWN, delegate);
                } else if (key_event_trigger == KEYUP) {
                    _stage.addEventListener(KeyboardEvent.KEY_UP, delegate);
                }
            }
        }

        /**
         * remove previously set delegates from the _stage.
         * @param delegate the delegate to remove.
         */
        public function remove_keyboard_listeners(delegate:Function):void {
            if (_stage) {
                _stage.removeEventListener(KeyboardEvent.KEY_DOWN, delegate);
                _stage.removeEventListener(KeyboardEvent.KEY_UP, delegate);
            }
        }

        // * DELEGATE FUNCTIONS * //////////////////////////////////////////////////

        private function on_key_up(e:KeyboardEvent):void {
            _key_states[e.keyCode] = 0;
        }

        private function on_key_down(e:KeyboardEvent):void {
            _key_states[e.keyCode] = 1;
        }


        /**
         * initializes the keyboard listeners on the main _stage.
         * @param e event for listener
         */
        private function init_keyboard(e:Event = null):void {
            if (_stage) {
                _stage.addEventListener(KeyboardEvent.KEY_DOWN, on_key_down);
                _stage.addEventListener(KeyboardEvent.KEY_UP, on_key_up);
                _keyboard_initialized = true;
            } else {
                
            }
        }

        // * GETTERS, SETTERS * ////////////////////////////////////////////////////

        public function get keys():KeyboardKeys {
            return _KEYS;
        }
    }
}
