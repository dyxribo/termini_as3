package net.blaxstar.log4air.policies
{
  public class TimeBasedRollingPolicy extends Policy {
        private var _target_time:RegExp;

        public function TimeBasedRollingPolicy(time_date_pattern:String) {
            super();
        }

        override public function shouldProcess(loggerName:String, level:int, message:String):Boolean {
            // Check if the log level is in the allowedLevels array
            return false;
        }
  }
}