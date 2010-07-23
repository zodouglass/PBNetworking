package flash.events {

import avmplus.StringBuilder;

public class Event
{
public static const ACTIVATE:String = "activate";
        public static const ADDED:String = "added";
        public static const ADDED_TO_STAGE:String = "addedToStage";
        public static const CANCEL:String = "cancel";
        public static const CHANGE:String = "change";
        public static const CLEAR:String = "clear";
        public static const CLOSE:String = "close";
        public static const CLOSING:String = "closing"; //AIR
        public static const COMPLETE:String = "complete";
        public static const CONNECT:String = "connect";
        public static const COPY:String = "copy";
        public static const CUT:String = "cut";
        public static const DEACTIVATE:String = "deactivate";
        public static const DISPLAYING:String = "displaying";
        public static const ENTER_FRAME:String = "enterFrame";
        public static const EXIT_FRAME:String = "exitFrame";
        public static const EXITING:String = "exiting"; //AIR
        public static const FRAME_CONSTRUCTED:String = "frameConstructed";
        public static const FULLSCREEN:String = "fullScreen";
        public static const HTML_BOUNDS_CHANGE:String = "htmlBoundsChange"; //AIR
        public static const HTML_DOM_INITIALIZE:String = "htmlDOMInitialize"; //AIR
        public static const HTML_RENDER:String = "htmlRender"; //AIR
        public static const ID3:String = "id3";
        public static const INIT:String = "init";
        public static const LOCATION_CHANGE:String = "locationChange"; //AIR
        public static const MOUSE_LEAVE:String = "mouseLeave";
        public static const NETWORK_CHANGE:String = "networkChange"; //AIR
        public static const OPEN:String = "open";
        public static const PASTE:String = "paste";
        public static const REMOVED:String = "removed";
        public static const REMOVED_FROM_STAGE:String = "removedFromStage";
        public static const RENDER:String = "render";
        public static const RESIZE:String = "resize";
        public static const SAMPLE_DATA:String = "sampleData";
        public static const SCROLL:String = "scroll";
        public static const SELECT:String = "select";
        public static const SELECT_ALL:String = "selectAll";
        public static const SOUND_COMPLETE:String = "soundComplete";
        public static const TAB_CHILDREN_CHANGE:String = "tabChildrenChange";
        public static const TAB_ENABLED_CHANGE:String = "tabEnabledChange";
        public static const TAB_INDEX_CHANGE:String = "tabIndexChange";
        public static const UNLOAD:String = "unload";
        public static const USER_IDLE:String = "userIdle"; //AIR
        public static const USER_PRESENT:String = "userPresent"; //AIR
        
    public function Event (type :String, bubbles :Boolean = false, cancelable :Boolean = false)
    {
        _type = type;
        if (bubbles) {
            _flags |= BUBBLES;
        }
        if (cancelable) {
            _flags |= CANCELABLE;
        }
    }

    public function get type () :String
    {
        return _type;
    }

    /**
     * @todo Do something smarter here?
     */
    public var target:Object = null;

    public function get bubbles () :Boolean
    {
        return (_flags & BUBBLES) != 0;
    }

    public function get cancelable () :Boolean
    {
        return (_flags & CANCELABLE) != 0;
    }

    public function clone () :Event
    {
        return new Event(_type);
    }

    public function preventDefault () :void
    {
        if ((_flags & CANCELABLE) != 0) {
            _flags |= DEFAULT_PREVENTED;
        }
    }

    public function isDefaultPrevented () :Boolean
    {
        return (_flags & DEFAULT_PREVENTED) != 0
    }

    public function stopImmediatePropagation () :void
    {
        _flags |= STOP_IMMEDIATE_PROPAGATION;
        _flags |= STOP_PROPAGATION;
    }

    public function formatToString (className :String, ... arguments) :String
    {
        var s :StringBuilder = new StringBuilder();
        s.append("[");
        s.append(className);
        var self :Object = this;
        arguments.forEach (function (name :String, ... unused) {
            s.append(" ");
            s.append(name);
            s.append("=");
            s.append(self[name]);
        });
        s.append("]");
        return s.toString();
    }

    public function toString():String
    {
        //return formatToString("Event", "type", "bubbles", "cancelable");
        return "[Event type='" + type + "']";
    }

    internal function isPropagationStopped (immediate :Boolean) :Boolean
    {
        if (immediate) {
            return (_flags & STOP_IMMEDIATE_PROPAGATION) != 0;
        }
        return (_flags & STOP_PROPAGATION) != 0;
    }

    private var _type :String;
    private var _flags :int;

    private static const BUBBLES :int = 1 << 0;
    private static const CANCELABLE :int = 1 << 1;
    private static const DEFAULT_PREVENTED :int = 1 << 2;
    private static const STOP_IMMEDIATE_PROPAGATION :int = 1 << 3;
    private static const STOP_PROPAGATION :int = 1 << 4;
}

}
