package com.ithaca.traces.model.vo
{
    public class TraceVO
    {
        [RemoteClass(alias="org.liris.ktbs.domain.interfaces.ITrace")]
        [Bindable]
        public var uri:String;
    }
}