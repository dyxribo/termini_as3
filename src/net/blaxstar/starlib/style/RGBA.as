package net.blaxstar.starlib.style {

    /**
     * ...
     * @author Deron D.
     * decamp.deron@gmail.com
     */
    public class RGBA {

        private var _red:uint;
        private var _green:uint;
        private var _blue:uint;
        private var _alpha:uint;
        private var _combined_value:uint;

        public function RGBA(red:uint = 0, green:uint = 0, blue:uint = 0, alpha:uint = 255) {
            _red = red;
            _green = green;
            _blue = blue;
            _alpha = alpha;
            _combined_value = combine_rgba();
        }

        /**
         * lightens the current RGBA color by 50% and returns the result.
         * @return RGBA result of the lightened RGBA color.
         */
        public function tint(percent:Number=0.5):RGBA {
            percent = (percent >= 1) ? (1 - 0.99) : (1 - percent);
            var tinted:RGBA = new RGBA(((_red - 255)*percent) + 255, ((_green - 255)*percent) + 255, ((_blue - 255)*percent) + 255);

            return tinted;
        }

        /**
         * darkens the current RGBA color by 50% and returns the result.
         * @return RGBA result of the darkened RGBA color.
         */
        public function shade(percent:Number=0.1):RGBA {
            percent = (percent >= 1) ? (1 - 0.99) : (1 - percent);
            var shaded:RGBA = new RGBA(_red * percent, _green * percent, _blue * percent);

            return shaded;
        }

        public function clone():RGBA {
          return new RGBA(_red, _green, _blue, _alpha);
        }

        /**
         * sets the color value of this RGBA instance.
         * @param hex_color color represented as hex e.g `0x0099FF`. 
         * @return this instance of the RGBA object.
         */
        public function from_hex(hex_color:uint):RGBA {
            var rgba:RGBA = new RGBA(_red, _green, _blue, _alpha);

            return rgba;
        }

        /**
         * converts this color to a string in hex format.
         * @param use_alpha a boolean denoting if the hex should be in 8-character hex format or not (ARGB vs RGB).
         * @return a string containing the hex formatted number.
         */
        public function to_hex_string(use_alpha:Boolean=false):String {
            _red = _red > 255 ? 255 : _red;
            _green = _green > 255 ? 255 : _green;
            _blue = _blue > 255 ? 255 : _blue;
            _alpha = _alpha > 255 ? 255 : _alpha;

            var hex_string:String = (use_alpha ? get_channel_hex('a') : "") + get_channel_hex('r') + get_channel_hex('g') + get_channel_hex('b');

            return hex_string.toUpperCase();
        }

        /**
         *
         * @param color_channel channel id which can be either `r`, `g`, `b`, or `a`.
         */
        private function get_channel_hex(color_channel:String):String {
            var channel_string:String = "";

            if (color_channel == 'r') {
                var r:uint = _red > 255 ? 255 : _red;
                channel_string = r.toString(16);
            } else if (color_channel == 'g') {
                var g:uint = _green > 255 ? 255 : _green;
                channel_string = g.toString(16);
            } else if (color_channel == 'b') {
                var b:uint = _blue > 255 ? 255 : _blue;
                channel_string = b.toString(16);
            } else if (color_channel == 'a') {
                var a:uint = _alpha > 255 ? 255 : _alpha;
                channel_string = a.toString(16);
            }

            channel_string = pad_channel_hex_zeroes(channel_string);
            return channel_string;
        }

        private function pad_channel_hex_zeroes(hex_string:String):String {
            while (hex_string.length < 2) {
              hex_string = "0" + hex_string;
            }

            return hex_string;
        }

          /**
           * checks if this color is bright or not (important for text and general visual accessibility).
           * @return 
           */
          public function color_is_bright():Boolean {
            // counting the perceptive luminance - human eye favors green color
            var a:Number = 1 - (0.299 * _red + 0.587 * _green + 0.114 * _blue) / 255;

            return (a < 0.5);
        }

          /**
           * darkens this color by `percent` and returns this RGBA instance.
           * @param percent 
           * @return 
           */
          public function darken_color(percent:Number = 0.10):RGBA {
            var shaded_color:RGBA = new RGBA(_red - (_red * percent), _green - (_green * percent), _blue - (_blue * percent), _alpha);

            return shaded_color;
        }

          /**
           * lightens this color by `percent` and returns this RGBA instance.
           * @param percent 
           * @return 
           */
          private function lighten_color(percent:Number = 0.10):RGBA {
            var lightened_color:RGBA = new RGBA(_red + (_red * percent), _green + (_green * percent), _blue + (_blue * percent), _alpha);
            
            return lightened_color;
        }

        private function combine_rgba():uint {
            return (_alpha << 24) | (_red << 16) | (_green << 8) | _blue;
        }

        private function extract_red():uint {
            return _combined_value >>> 16 & 0xFF;
        }

        private function extract_green():uint {
            return _combined_value >>> 8 & 0xFF;
        }

        private function extract_blue():uint {
            return _combined_value & 0xFF;
        }

        private function extract_alpha():uint {
            return _combined_value >>> 24;
        }

        /**
         * adds an alpha channel to an rgb color.
         * @param	alpha the alpha value to be applied. must be between 0 and 255.
         * @return
         */
        private function add_alpha_channel(alpha:uint):uint {
            return _combined_value + (alpha << 24);
        }

        /**
         * the red value extracted from this color.
         * @return 
         */
        public function get red():uint {
            return _red;
        }

         /**
         * the green value extracted from this color.
         * @return 
         */
        public function get green():uint {
            return _green;
        }

         /**
         * the blue value extracted from this color.
         * @return 
         */
        public function get blue():uint {
            return _blue;
        }

         /**
         * the alpha value extracted from this color.
         * @return 
         */
        public function get alpha():uint {
            return _alpha;
        }

        public function set alpha(val:uint):void {
            _alpha = val;
            _combined_value = combine_rgba();
        }

        public function get is_black_text_compatible():Boolean {
            return color_is_bright();
        }

        public function is_white_text_compatible():Boolean {
            return !color_is_bright();
        }

        public function get value():uint {
            return _combined_value;
        }
    }

}
