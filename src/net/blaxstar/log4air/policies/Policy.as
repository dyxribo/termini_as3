package net.blaxstar.log4air.policies {

    import net.blaxstar.log4air.interfaces.IPolicy;

    public class Policy implements IPolicy {
        public function shouldProcess(logger_name:String, level:int, message:String):Boolean {
            return true;
        }
    }
}
