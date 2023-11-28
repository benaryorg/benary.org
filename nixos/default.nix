{ callPackage
, lib
, config
, pkgs
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
    package = lib.mkPackageOption pkgs "benaryorg-website" {};
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
          root = "${cfg.package}/share/benaryorg-website/www/";
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
                  more_set_headers 'link: <https://catcatnya.com/@benaryorg>; rel="me", <https://en.pronouns.page/@benaryorg>; rel="me"';
                '';
              };
              evilLocation =
              {
                tryFiles = "/evil =404";
                extraConfig =
                ''
                  more_set_headers 'content-length: 941';
                  more_set_headers 'content-encoding: gzip, gzip';
                  more_set_headers 'content-type: application/json';
                '';
              };
            in
              {
                "= /" = jsonLocation;
                "= /index.json" = jsonLocation;
                "= /robots.txt" = {};
                "= /favicon.ico" = {};
                "/.well-known" = {};
                "/" = evilLocation;
              };
        };
      };
}
