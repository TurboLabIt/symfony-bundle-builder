<?php
namespace MyVendorName\MyPackageNameBundle\Tests;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;
use PHPUnit\Framework\Attributes\DataProvider;
use PHPUnit\Framework\Attributes\Depends;


class BundleTest extends BaseT
{
    const TESTED_SERVICE_FQN = 'MyVendorName\MyPackageNameBundle\MyServiceName';

    public function testInstance() : MyServiceName { return $this->getInstance(); }


    #[Depends('testInstance')]
    public function testSendMessageToChannel(MyServiceName $myService)
    {
        // ...
    }


    public static function somethingProvider()
    {
        yield ['/aaa', '/bbb', '/ccc'];
    }


    #[DataProvider('somethingProvider')]
    public function testSomething(string $value)
    {
        $this->assertNotEmpty($value);
        return $value;
    }
}
