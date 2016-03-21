/**
 * efx (http://emilmalinov.com/efx)
 *
 * @copyright Copyright (c) 2015 Emil Malinov
 * @license   http://www.apache.org/licenses/LICENSE-2.0 Apache License 2.0
 * @link      http://github.com/emilkm/efx
 * @package   efx
 */

package emilkm.efxphp
{
    
public class Response extends Object
{
    public var code:int;
    public var message:String;
    public var detail:String;
    public var data:Object;
    
    public function Response()
    {
        
    }
}

}
