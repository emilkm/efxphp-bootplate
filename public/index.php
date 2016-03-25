<?php
namespace myapp\client;

use emilkm\efxphp\Response;

require_once __DIR__ . '/../vendor/autoload.php';

$endpoint = 'http://' . $_SERVER['HTTP_HOST'] . $_SERVER['REQUEST_URI'] . 'server/index.php';

$client = new SimpleClient(
    $endpoint,
    '127.0.0.1:8888'
);

$init = $client->testinit();
$response1 = $client->testpublicServicePublicMethodNoParams();
$response2 = $client->testpublicServicePublicMethodOptionalParam();
$response3 = $client->testpublicServicePublicMethodMandatoryParam(1);

echo 'Run a small Flex app that makes the same service calls <a href="efxsaucer.html">efxsaucer</a>';
echo '<br> or a small JavaScript app that makes the same service calls <a href="amfjssaucer.html">amfjssaucer</a>';
