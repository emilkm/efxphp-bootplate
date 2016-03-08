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
    public function __construct()
    {
        $this->productionMode = false;
    }
    
    /**
     * Array of database connection settings
     * 
     * @var array
     */
    protected $databases;
}
