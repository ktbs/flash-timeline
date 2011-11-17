package com.ithaca.traces.model.vo
{

    public class AttributePairVO
    {
        [RemoteClass(alias="org.liris.ktbs.domain.interfaces.IAttributePair")]
        [Bindable]
        public var attributeType:AttributeTypeVO;
        public var value:Object;
    }
}