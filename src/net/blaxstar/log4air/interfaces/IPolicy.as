package net.blaxstar.log4air.interfaces {

    public interface IPolicy {
        function shouldProcess(logger_name:String, level:int, message:String):Boolean;
    }
}
