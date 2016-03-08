<?php
namespace myapp\client;

use emilkm\efxphp\Client;
use emilkm\efxphp\Response;
use emilkm\efxphp\Amf\Constants;
use emilkm\efxphp\Amf\Deserializer;
use emilkm\efxphp\Amf\Serializer;
use emilkm\efxphp\Amf\Input;
use emilkm\efxphp\Amf\InputExt;
use emilkm\efxphp\Amf\Output;
use emilkm\efxphp\Amf\OutputExt;
use emilkm\efxphp\Amf\ActionMessage;
use emilkm\efxphp\Amf\MessageBody;
use emilkm\efxphp\Amf\Messages\AcknowledgeMessage;
use emilkm\efxphp\Amf\Messages\CommandMessage;
use emilkm\efxphp\Amf\Messages\RemotingMessage;

class SimpleClient
{
    protected $serializer;
    protected $deserializer;
    protected $amfClient;

    /**
     * Creates the serializer and desirializer using the extension if available.
     * Intializes the AMF Client and sends a ping command to the server.
     *
     * @param string $endpoint
     * @param string $debugproxy
     */
    public function __construct($endpoint, $debugproxy = '')
    {
        $output = (function_exists('amf_encode')) ? new OutputExt() : new Output();
        $this->serializer = new Serializer($output);

        $input = (function_exists('amf_decode')) ? new InputExt() : new Input();
        $this->deserializer = new Deserializer($input);

        $this->amfClient = new Client(
            $this->deserializer,
            $this->serializer,
            'efxphp',
            $endpoint
        );

        if ($debugproxy != '') {
            $this->amfClient->setProxy($debugproxy);
        }
        $response;
        $this->amfClient->ping(
            function ($result) use (&$response) {
                $response = $result;
            },
            function ($error) use (&$response) {
                $response = $error;
            }
        );
    }

    /**
     * @returns emilkm\efxphp\Response
     */
    public function testpublicServicePublicMethodNoParams()
    {
        $response;
        $this->amfClient->invoke(
            'myapp.server.MyService',
            'publicMethodNoParams',
            null,
            function ($result) use (&$response) {
                $response = $result;
            },
            function ($error) use (&$response) {
                $response = $error;
            }
        );
        return $response;
    }

    /**
     * @param int $p1
     *
     * @returns emilkm\efxphp\Response
     */
    public function testpublicServicePublicMethodOptionalParam($p1 = null)
    {
        $response;
        $this->amfClient->invoke(
            'myapp.server.MyService',
            'publicMethodOptionalParam',
            null,
            function ($result) use (&$response) {
                $response = $result;
            },
            function ($error) use (&$response) {
                $response = $error;
            }
        );
        return $response;
    }

    /**
     * @param int $p1
     *
     * @returns emilkm\efxphp\Response
     */
    public function testpublicServicePublicMethodMandatoryParam($p1)
    {
        $response;
        $this->amfClient->invoke(
            'myapp.server.MyService',
            'publicMethodMandatoryParam',
            [],
            function ($result) use (&$response) {
                $response = $result;
            },
            function ($error) use (&$response) {
                $response = $error;
            }
        );
        return $response;
    }
}
