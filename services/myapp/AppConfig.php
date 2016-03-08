<?php
namespace myapp\server;

use emilkm\efxphp\ServerConfig;

class AppConfig extends ServerConfig
{
    public function __construct()
    {
        $this->productionMode = false;
    }
}
