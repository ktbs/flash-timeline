package com.ithaca.visu.events
{
    import com.ithaca.traces.Obsel;
    
    import flash.events.Event;
    
    public class SalonRetroEvent extends Event
    {
        static public const CLICK_BUTTON_PLAY : String = 'clickButtonPlaySalonRetro';
        static public const CLICK_BUTTON_PAUSE : String = 'clickButtonPauseSalonRetro';
        
        static public const ACTION_ON_VIDEO_PLAYER : String = 'actionOnVideoPlayer';
        static public const ACTION_ON_SLIDER_VIDEO_PLAYER : String = 'actionOnSliderVIdeoPlayer';
        static public const ACTION_ON_TIME_LINE : String = 'actionOnTimeLine';
        
        static public const ACTION_ON_EXPLORE_OBSEL : String = 'actionOnExploreObsel';
        static public const ACTION_ON_EXPAND_TRACE_LINE : String = 'actionOnExpandeTraceLine';
        
        static public const ACTION_ON_TRACE_LINE : String = 'actionOnTraceLine';
        static public const ACTION_ON_COMMENT_TRACE_LINE : String = 'actionOnCommentTraceLine';
        static public const ACTION_ON_OBSEL_COMMENT_START_EDIT_CANCEL_EDIT : String = 'actionOnObselCommentStartEditCancelEdit';
        static public const PRE_ACTION_ON_OBSEL_COMMENT_START_EDIT_CANCEL_EDIT : String = 'preActionOnObselCommentStartEditCancelEdit';
            
        // properties
        public var userId : int;
        public var nameUserTraceLine:String;
        public var avatarUser:String;
        public var isOpen:Boolean;
        public var isPlus:Boolean;
        public var userIdClient : String;
        public var typeAddedObsel:int;
        public var typeWidget:int;
        // action of the user const
        public var typeAction:String;
        public var timePlayer:Number;
        public var timeObselBegin:Number;
        public var timeObselEnd:Number;
        public var timeStamp:Number;
        public var text:String;
        public var editTypeCancel:String;
        public var obsel:Obsel;
        
        public function SalonRetroEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }
    }
}