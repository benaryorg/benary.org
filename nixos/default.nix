{ callPackage
, lib
, config
, benaryorg-website
, ...
}:

{
  options.benaryorg.website =
  {
    enable = lib.mkOption
    {
      default = false;
      type = lib.types.bool;
      description = lib.mdDoc ''
        This option enables the website including deployment of nginx.
      '';
    };
    hostName = lib.mkOption
    {
      default = "benary.org";
      type = lib.types.str;
      description = lib.mdDoc ''
        The hostname under which the site should be available.
      '';
    };
  };
  config =
    let
      cfg = config.benaryorg.website;
    in
      lib.mkIf cfg.enable
      {
        services.nginx.enable = lib.mkDefault true;
        services.nginx.virtualHosts.${cfg.hostName} =
        {
          forceSSL = true;
          root = "${benaryorg-website.packages.x86_64-linux.default}/share/benaryorg-website/www/";
          useACMEHost = lib.mkDefault cfg.hostName;

          locations =
            let
              jsonLocation =
              {
                index = "index.json";
                extraConfig =
                ''
                  more_set_headers 'content-type: application/json';
                  more_set_headers 'access-control-allow-origin: *';
                '';
              };
            in
              {
                "= /" = jsonLocation;
                "= /index.json" = jsonLocation;
                "/" = {};
              };
        };
      };
}
