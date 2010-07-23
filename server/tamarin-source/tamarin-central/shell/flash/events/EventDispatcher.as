package flash.events {

import flash.utils.Dictionary;

public class EventDispatcher implements IEventDispatcher
{
    private var _listenerMap:Dictionary = new Dictionary();
    
    public function addEventListener (
        type :String, listener :Function, useCapture :Boolean = false,
        priority :int = 0, useWeakReference :Boolean = false) :void
    {
    
        //if(!_listenerMap) _listenerMap = new Dictionary();
        
        if (useCapture || priority != 0) {
            throw new Error("Fancy addEventListener not implemented");            
        }

        if (useWeakReference) {
            // we can't do this properly with our current data structure, just ignore for now
        }
        
        var listeners:Array = _listenerMap[type] as Array;
        
        if (listeners == null) 
        {
            _listenerMap[type] = new Array();
            listeners = _listenerMap[type];

        }
        else if (-1 != listeners.indexOf(listener)) 
        {
            // Can't register twice.
            return;
        }
        
        listeners.push(listener); 
    }

    public function removeEventListener (
        type :String, listener :Function, useCapture :Boolean = false) :void
    {
        //if(!_listenerMap) _listenerMap = new Dictionary();
        
        if (useCapture) {
            throw new Error("Fancy removeListener not implemented");
        }
        var listeners :Array = _listenerMap[type] as Array;
        if (listeners != null) {
            var ix :int = listeners.indexOf(listener);
            if (ix >= 0) {
                listeners.splice(ix, 1);
            }
        }
    }

    public function dispatchEvent (event :Event) :Boolean
    {
        //if(!_listenerMap) _listenerMap = new Dictionary();
        
        event.target = this;
        
        var listeners :Array = _listenerMap[event.type] as Array;

        if (listeners == null) {
            return true;
        }

        for each (var listener :Function in listeners) {
            try {
                listener(event);
            } catch (err :Error) {
                var errStr :String = err.getStackTrace();
                if (errStr == null) {
                    errStr = err.message;
                }
                trace(errStr);
            }
            if (event.isPropagationStopped(true)) {
                break;
            }
        }
        return !event.isDefaultPrevented();
    }

    public function hasEventListener (type :String) :Boolean
    {
        //if(!_listenerMap) _listenerMap = new Dictionary();
        
        if (type in _listenerMap) {
            return _listenerMap[type].length > 0;
        }
        return false;
    }

    public function toString () :String
    {
        return "[EventDispatcher]";
    }

}

}
