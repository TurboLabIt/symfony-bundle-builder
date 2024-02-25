<?php
/**
 * 🪄 Based on https://github.com/TurboLabIt/symfony-bundle-builder/blob/main/template/tests/BundleTest.php
 *
 * 📚 Usage example (customize with your own):
 *
 * - MyVendorName   ➡ TurboLabIt
 * - MyPackageName  ➡ BaseCommand
 *
 * 💡 "Replace all" the above and you're ready to go
 */
namespace MyVendorName\MyPackageNameBundle\tests;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;
use PHPUnit\Framework\Attributes\DataProvider;
use PHPUnit\Framework\Attributes\Depends;


class BundleTest extends WebTestCase
{
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


    #[Depends('testSomething')]
    public function testSomethingDepending($value)
    {
        $this->assertNotEmpty($value);
    }
}
