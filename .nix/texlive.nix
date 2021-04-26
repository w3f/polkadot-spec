# Generated with tex2nix 0.0.0
{ texlive, extraTexPackages ? {} }:
(texlive.combine ({
    inherit (texlive) scheme-small;
    "kvoptions" = texlive."kvoptions";
    "intcalc" = texlive."intcalc";
    "atveryend" = texlive."atveryend";
    "xkeyval" = texlive."xkeyval";
    "xargs" = texlive."xargs";
    "graphics" = texlive."graphics";
    "hyperref" = texlive."hyperref";
    "hycolor" = texlive."hycolor";
    "rerunfilecheck" = texlive."rerunfilecheck";
    "amsmath" = texlive."amsmath";
    "refcount" = texlive."refcount";
    "pdftexcmds" = texlive."pdftexcmds";
    "geometry" = texlive."geometry";
    "bitset" = texlive."bitset";
    "minitoc" = texlive."minitoc";
    "gettitlestring" = texlive."gettitlestring";
    "infwarerr" = texlive."infwarerr";
    "collectbox" = texlive."collectbox";
    "xcolor" = texlive."xcolor";
    "kvsetkeys" = texlive."kvsetkeys";
    "iftex" = texlive."iftex";
    "adjustbox" = texlive."adjustbox";
    "fancyvrb" = texlive."fancyvrb";
    "pdfescape" = texlive."pdfescape";
    "atbegshi" = texlive."atbegshi";
    "plantuml" = texlive."plantuml";
    "kvdefinekeys" = texlive."kvdefinekeys";
    "url" = texlive."url";
    "ltxcmds" = texlive."ltxcmds";
    "letltxmacro" = texlive."letltxmacro";
    "auxhook" = texlive."auxhook";
    "capt-of" = texlive."capt-of";
    "pgf" = texlive."pgf";
    "etexcmds" = texlive."etexcmds";
    "uniquecounter" = texlive."uniquecounter";

} // extraTexPackages))
