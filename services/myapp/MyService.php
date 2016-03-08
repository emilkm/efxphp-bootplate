<?php
namespace myapp\server;

use Exception;

/**
 * @access public
 */
class MyService
{
    /**
     * @return bool
     */
    public function publicMethodNoParams()
    {
        return true;
    }

    /**
     * @param int $p1
     *
     * @return bool
     */
    public function publicMethodOptionalParam($p1 = null)
    {
        return true;
    }

    /**
     * @param int $p1
     *
     * @return bool
     */
    public function publicMethodMandatoryParam($p1)
    {
        return true;
    }
}
