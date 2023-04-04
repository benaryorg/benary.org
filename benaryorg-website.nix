{ callPackage
, lib
, stdenv
, gnupg
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "benaryorg-website";
  version = "1";

  src = ./src;
  makeFlags = [ "PREFIX=$(out)" ];

  nativeBuildInputs = [ gnupg ];

  doCheck = true;

  meta = with lib; {
    description = "The website of benaryorg.";
    longDescription = ''
      The website of benaryorg as usually deployed on https://benary.org.
    '';
    homepage = "https://benary.org/";
    license = licenses.isc;
    platforms = platforms.all;
  };
})

