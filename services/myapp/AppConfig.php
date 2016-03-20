<?php
namespace myapp\server;

use emilkm\efxphp\ServerConfig;

/**
 * List properties for intellisense in some IDEs
 *
 * @property array $databases
 */
class AppConfig extends ServerConfig
{
    /**
     * Array of database connection settings
     *
     * @var array
     */
    protected $databases;
    
    /**
     * Intialize inherited properties if necessary.
     */
    public function __construct()
    {
        $this->servicesRootNamespace = '';
        $this->crossOriginResourceSharing = true;
        $this->contentEncodingEnabled = true;
    }   
}
