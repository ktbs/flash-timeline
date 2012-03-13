/*
 * Code from http://forums.adobe.com/message/3844410#3844410
 */
package com.ithaca.timeline.skins
{
    import spark.components.VGroup;

    public class ControlledScrollVGroup extends VGroup
    {
        private var _step_size: int = 0;

        public function get stepSize(): int
        {
            return _step_size;
        }

        public function set stepSize(value: int): void
        {
            _step_size = value;
        }

        override public function getVerticalScrollPositionDelta(navigationUnit: uint): Number
        {
            var megaValue: Number = super.getVerticalScrollPositionDelta(navigationUnit);

            if (megaValue == 0)
            {
                return 0;
            }

            var smallerValue: int =  _step_size;

            if (smallerValue == 0 || smallerValue > Math.abs(megaValue))
            {
                return megaValue;
            }

            if (megaValue < 0)
            {
                smallerValue = -1 * smallerValue;
            }

            return smallerValue;
        }

        public function ControlledScrollVGroup()
        {
            super();
        }
    }
}
