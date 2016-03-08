<?php
namespace myapp\server;

use emilkm\efxphp\IdentificationInterface;
use emilkm\efxphp\AuthorizationInterface;

use Exception;

/**
 * @author     Emil Malinov
 * @package    efxphp
 * @subpackage bootplate
 */
class AccessManager implements IdentificationInterface, AuthorizationInterface
{
    /**
     * @param string $clientId
     * @param string $sessionId
     *
     */
    public function identify($clientId, $sessionId)
    {

    }

    /**
     * @returns bool
     */
    public function isAuthenticated()
    {
        return true;
    }

    /**
     * @param mixed $serviceName
     * @param mixed $methodName
     * @param mixed $access
     */
    public function authorize($serviceName, $methodName, $access)
    {
        if ($access == 'authenticated') {
            throw new Exception('Not authenticated');
        }
    }
}
