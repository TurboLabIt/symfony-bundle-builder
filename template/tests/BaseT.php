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


abstract class BaseT extends TestCase
{
    protected static KernelT $kernelT;


    protected function setUp() :void
    {
        static::$kernelT = new KernelT('test', true);
        static::$kernelT->boot();
    }


    /*protected function tearDown(): void
    {
        self::ensureKernelShutdown();
        static::$crawler = null;
    }*/


    protected static function getService(string $name)
    {
        // boots the kernel and prevents LogicException:
        // Booting the kernel before calling "WebTestCase::createClient()" is not supported, the kernel should only be booted once.
        if(false && empty(static::$client) ) {

            static::$client = static::createClient();
            static::$client->setServerParameter('HTTP_HOST', $_ENV["APP_SITE_DOMAIN"]);
            static::$client->setServerParameter('HTTPS', 'https');
        }

        $container = static::$kernelT->getContainer();
        $connector = $container->get($name);
        return $connector;
    }
}


use Symfony\Component\HttpKernel\Kernel;
use MyVendorName\MyPackageName\MyVendorNameMyPackageNameBundle;

class KernelT extends Kernel
{
    use MicroKernelTrait;


    public function registerBundles(): iterable
    {
        return [
            new FrameworkBundle(),
            new MyVendorNameMyPackageNameBundle()
        ];
    }
}
