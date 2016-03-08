<?php
namespace myapp\client;

use emilkm\efxphp\Response;

require_once __DIR__ . '/../vendor/autoload.php';

//'http://127.0.0.1:9999/server/index.php'

$client = new SimpleClient(
    'http://127.0.0.1/5618/efxphp-bootplate/server/index.php',
    '127.0.0.1:8888'
);

$response1 = $client->testpublicServicePublicMethodNoParams();
$response2 = $client->testpublicServicePublicMethodOptionalParam();
$response3 = $client->testpublicServicePublicMethodMandatoryParam(1);

echo 'done';