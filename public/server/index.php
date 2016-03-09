<?php
//define the application root
define('BASE', str_replace(array('\\', '\\\\'), '/', realpath('../../')) . '/');

$autoLoader = require_once BASE . 'vendor/autoload.php';

use myapp\server\AppConfig;
$appConfig = new AppConfig();
if ($appConfig->servicesRootDirectory === null) {
    $appConfig->servicesRootDirectory = BASE . 'services';
}
if ($appConfig->cacheDirectory === null) {
    $appConfig->cacheDirectory = BASE . 'services/cache';
}

use emilkm\efxphp\Dice;
$dice = new Dice();
$dice->addInstance('emilkm\\efxphp\\Dice', $dice);
$dice->addInstance('myapp\\server\\AppConfig', $appConfig);

//Identification, Authorization, Authentication, ...
$rule1 = [];
$rule1['shared'] = true;
$rule1['substitutions']['emilkm\\efxphp\\IdentificationInterface'] = ['instance' => 'myapp\\server\\AccessManager'];
$rule1['substitutions']['emilkm\\efxphp\\AuthorizationInterface'] = ['instance' => 'myapp\\server\\AccessManager'];
$rule1['substitutions']['emilkm\\efxphp\\ServerConfig'] = ['instance' => 'myapp\\server\\AppConfig'];
$rule1['shareInstances'] = ['emilkm\\efxphp\\Dice', 'myapp\\server\\AppConfig'];
$dice->addRule('*', $rule1);

//AMF Input & Output
$rule2 = [];
$rule2['substitutions']['emilkm\\efxphp\\Amf\\AbstractInput'] = ['instance' => (function () {
    if (function_exists('amf_decode')) {
        return new emilkm\efxphp\Amf\InputExt();
    } else {
        return new emilkm\efxphp\Amf\Input();
    }
})];
$dice->addRule('emilkm\\efxphp\\Amf\\Deserializer', $rule2);

$rule3 = [];
$rule3['substitutions']['emilkm\\efxphp\\Amf\\AbstractOutput'] = ['instance' => (function () {
    if (function_exists('amf_encode')) {
        return new emilkm\efxphp\Amf\OutputExt();
    } else {
        return new emilkm\efxphp\Amf\Output();
    }
})];
$dice->addRule('emilkm\\efxphp\\Amf\\Serializer', $rule3);

//MetadataCache
$rule4 = ['constructParams' => [$appConfig->cacheDirectory]];
$dice->addRule('emilkm\\efxphp\\MetadataCache', $rule4);

//Router rule
$rule5 = ['constructParams' => [$appConfig->servicesRootNamespace]];
$dice->addRule('emilkm\\efxphp\\Router', $rule5);

//##############################################################################

//Create the server and handle the request
use emilkm\efxphp\Server;
$server = $dice->create('emilkm\\efxphp\\Server');
$server->handle();
