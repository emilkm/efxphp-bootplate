/**
 * efx (http://emilmalinov.com/efx)
 *
 * @copyright Copyright (c) 2015 Emil Malinov
 * @license   http://www.apache.org/licenses/LICENSE-2.0 Apache License 2.0
 * @link      http://github.com/emilkm/efx
 * @package   efx
 */

package emilkm.efx
{

import emilkm.efxphp.Response;

import flash.events.Event;

import mx.core.FlexGlobals;
import mx.core.mx_internal;
import mx.managers.CursorManager;
import mx.messaging.ChannelSet;
import mx.rpc.AbstractOperation;
import mx.rpc.AsyncResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.mxml.Concurrency;
import mx.rpc.remoting.RemoteObject;

public class AMFService extends RemoteObject
{   
    private var _busy:Boolean = false;
    protected var _calls:Array = [];
    protected var _operation:AbstractOperation;
    
    
    public function AMFService(
        source:String, 
        destination:String = ChannelConfig.DEFAULT_DESTINATION_ID, 
        channelSet:ChannelSet = null
    ) {
        super(destination);
        this.concurrency = Concurrency.SINGLE;
        this.source = source;
        if (channelSet != null)
            this.channelSet = channelSet;
    }
    
    public function send(method:String, params:Array = null, responder:AsyncResponder = null):void
    {
        if (_busy) 
        {
            _calls.push({'method': method, 'params': params, 'responder': responder});
            return; 
        }
        
        if (CursorManager) 
            CursorManager.setBusyCursor();
        _busy = true;
        
        _operation = this.getOperation(method);
        _operation.arguments = params;
        _operation.send().addResponder(new AsyncResponder(resultEvent, faultEvent, responder));
    }
    
    private function faultEvent(event:FaultEvent, token:Object = null):void
    {
        CursorManager.removeBusyCursor();
        _busy = false;
        
        if (token is AsyncResponder)
        {
            var response:Response = new Response();
            response.code = -1;
            response.message = event.fault.faultString;
            response.data = event.fault.message;
            response.detail = event.fault.faultDetail;
            
            (token as AsyncResponder).fault(response);
        }
        
        if (_calls.length > 0)
        {
            var call:Object = _calls.shift();
            send(call.method, call.params, call.responder);
        }
    }
    
    private function resultEvent(event:ResultEvent, token:Object = null):void
    {
        CursorManager.removeBusyCursor();
        _busy = false;
        
        if (token is AsyncResponder)
        {
            var response:Response = event.result as Response;
            (token as AsyncResponder).result(response);
        }
        
        if (_calls.length > 0)
        {
            var call:Object = _calls.shift();
            send(call.method, call.params, call.responder);
        }
    }
}

}
