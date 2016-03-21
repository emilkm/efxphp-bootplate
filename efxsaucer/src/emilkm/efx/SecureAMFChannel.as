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

/**
 *  The SecureAMFChannel class is identical to the AMFChannel class except that it uses a
 *  secure protocol, HTTPS, to send messages to an AMF endpoint.
 */
public class SecureAMFChannel extends AMFChannel
{
    //--------------------------------------------------------------------------
    //
    // Constructor
    // 
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor.
     *
     *  @param id The id of this Channel.
     *  
     *  @param uri The uri for this Channel.
     */
    public function SecureAMFChannel(id:String = null, uri:String = null)
    {
        super(id, uri);
    }

    //--------------------------------------------------------------------------
    //
    // Properties
    // 
    //--------------------------------------------------------------------------

    /**
     *  Returns the protocol for this channel (https).
     */
    override public function get protocol():String
    {
        return "https";
    }
}

}
