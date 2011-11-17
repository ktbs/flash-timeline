package com.ithaca.traces.model.vo
{
    public class ObselVO
    {
        [RemoteClass(alias="org.liris.ktbs.domain.interfaces.IObsel")]
        [Bindable]
        
        public var begin:Number;
        public var beginDT:String;
        public var end:Number
        public var endDT:String;
        public var hasTrace:TraceVO;
        public var attributes:Array;
    }
}