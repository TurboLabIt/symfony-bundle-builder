<?php
/**
 * 🪄 Based on https://github.com/TurboLabIt/symfony-bundle-builder/blob/main/template/src/MyVendorNameMyPackageNameBundle.php
 *
 * 📚 Usage example (customize with your own):
 *
 * - MyVendorName   ➡ TurboLabIt
 * - MyPackageName  ➡ BaseCommand
 *
 * 💡 "Replace all" the above and you're ready to go
 *
 * 📚 Resources:
 *
 * - https://symfony.com/doc/current/bundles.html
 * - https://symfonycasts.com/screencast/symfony-bundle/bundle-directory
 */
namespace MyVendorName\MyPackageNameBundle;

use Symfony\Component\HttpKernel\Bundle\AbstractBundle;
use Symfony\Component\DependencyInjection\Loader\Configurator\ContainerConfigurator;
use Symfony\Component\DependencyInjection\ContainerBuilder;


class MyVendorNameMyPackageNameBundle extends AbstractBundle
{
    public function loadExtension(array $config, ContainerConfigurator $container, ContainerBuilder $builder) : void
    {
        $container->import('../config/services.yaml');
    }
}
