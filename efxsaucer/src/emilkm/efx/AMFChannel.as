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
    import flash.utils.Dictionary;
    
    import mx.messaging.FlexClient;
    import mx.messaging.MessageAgent;
    import mx.messaging.channels.AMFChannel;
    import mx.messaging.messages.IMessage;

    public class AMFChannel extends mx.messaging.channels.AMFChannel
    {
        public var headers:Dictionary = new Dictionary();
        
        public function AMFChannel(id:String = null, uri:String = null)
        {
            super(id, uri);
        }
        
        override public function send(agent:MessageAgent, message:IMessage):void
        {
            message.clientId = FlexClient.getInstance().id;
            
            var field:Object = null;
            for (field in headers)
                message.headers[field] = headers[field];
            
            super.send(agent, message);
        }
    }
}
