{
  addressable = {
    dependencies = ["public_suffix"];
    groups = ["default" "pdf"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ypdmpdn20hxp5vwxz3zc04r5xcwqc25qszdlg41h8ghdqbllwmw";
      type = "gem";
    };
    version = "2.8.1";
  };
  afm = {
    groups = ["default" "pdf"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06kj9hgd0z8pj27bxp2diwqh6fv7qhwwm17z64rhdc4sfn76jgn8";
      type = "gem";
    };
    version = "0.2.2";
  };
  Ascii85 = {
    groups = ["default" "pdf"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ds4v9xgsyvijnlflak4dzf1qwmda9yd5bv8jwsb56nngd399rlw";
      type = "gem";
    };
    version = "1.1.0";
  };
  asciidoctor = {
    groups = ["default" "pdf"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11z3vnd8vh3ny1vx69bjrbck5b2g8zsbj94npyadpn7fdp8y3ldv";
      type = "gem";
    };
    version = "2.0.18";
  };
  asciidoctor-bibtex = {
    dependencies = ["asciidoctor" "bibtex-ruby" "citeproc-ruby" "csl-styles" "latex-decode"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fx80bpykixvnlscyz2c4dnjr1063r5ar7j1zn2977vsr8fi8ial";
      type = "gem";
    };
    version = "0.8.0";
  };
  asciidoctor-mathematical = {
    dependencies = ["asciidoctor" "asciimath" "mathematical"];
    groups = ["pdf"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lxfq7qn3ql642pva6jh3h1abm9j9daxg5icfn1h73k6cjsmcisp";
      type = "gem";
    };
    version = "0.3.5";
  };
  asciidoctor-pdf = {
    dependencies = ["asciidoctor" "concurrent-ruby" "matrix" "prawn" "prawn-icon" "prawn-svg" "prawn-table" "prawn-templates" "treetop"];
    groups = ["pdf"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v2pq05yfgdjrpqh7skc637rmghcyg0z494lvdm81h0jcy08swqd";
      type = "gem";
    };
    version = "2.3.4";
  };
  asciimath = {
    groups = ["default" "pdf"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fy2jrn3gr7cl33qydp3pwyfilcmb4m4z6hfhnvydzg8r3srp36j";
      type = "gem";
    };
    version = "2.0.4";
  };
  bibtex-ruby = {
    dependencies = ["latex-decode"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0adh2x935r69nm8qmns5fjsjw034xlyaqddzza2jr2npvf41g34r";
      type = "gem";
    };
    version = "5.1.6";
  };
  blake2b = {
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i7kxnnvv2lqglc1crhkqp0s9hybx20wgrl04jqkk7y2sawyb6hg";
      type = "gem";
    };
    version = "0.10.0";
  };
  citeproc = {
    dependencies = ["namae"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13vl5sjmksk5a8kjcqnjxh7kn9gn1n4f9p1rvqfgsfhs54p0m6l2";
      type = "gem";
    };
    version = "1.0.10";
  };
  citeproc-ruby = {
    dependencies = ["citeproc" "csl"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a8ahyhhmdinl4kcyv51r74ipnclmfyz4zjv366dns8v49n5vkk3";
      type = "gem";
    };
    version = "1.1.14";
  };
  concurrent-ruby = {
    groups = ["default" "pdf"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s4fpn3mqiizpmpy2a24k4v365pv75y50292r8ajrv4i1p5b2k14";
      type = "gem";
    };
    version = "1.1.10";
  };
  csl = {
    dependencies = ["namae" "rexml"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0n8iqmzvvqy2b1wfr4c7yj28x4z3zgm36628y8ybl49dgnmjycrk";
      type = "gem";
    };
    version = "1.6.0";
  };
  csl-styles = {
    dependencies = ["csl"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0l29qlk7i74088fpba5iqhhgiqkj7glcmc42nbmvgqysx577nag8";
      type = "gem";
    };
    version = "1.0.1.11";
  };
  css_parser = {
    dependencies = ["addressable"];
    groups = ["default" "pdf"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1107j3frhmcd95wcsz0rypchynnzhnjiyyxxcl6dlmr2lfy08z4b";
      type = "gem";
    };
    version = "1.12.0";
  };
  execjs = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "121h6af4i6wr3wxvv84y53jcyw2sk71j5wsncm6wq6yqrwcrk4vd";
      type = "gem";
    };
    version = "2.8.1";
  };
  hashery = {
    groups = ["default" "pdf"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qj8815bf7q6q7llm5rzdz279gzmpqmqqicxnzv066a020iwqffj";
      type = "gem";
    };
    version = "2.1.2";
  };
  i18n = {
    dependencies = ["concurrent-ruby"];
    groups = ["default" "pdf"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vdcchz7jli1p0gnc669a7bj3q1fv09y9ppf0y3k0vb1jwdwrqwi";
      type = "gem";
    };
    version = "1.12.0";
  };
  kaitai-struct = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zq02am2r3w1l71jm7x65hvdlny4q4v2wwsa49m4jvyb7i4ji8ps";
      type = "gem";
    };
    version = "0.10";
  };
  katex = {
    dependencies = ["execjs"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bl5hgvsapkn4qk3ibz365x3q7qrypdb3dxn54q3p2cm10683z8w";
      type = "gem";
    };
    version = "0.9.0";
  };
  latex-decode = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1y5xn3zwghpqr6lvs4s0mn5knms8zw3zk7jb58zkkiagb386nq72";
      type = "gem";
    };
    version = "0.4.0";
  };
  libv8-node = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1259iqwprlv3axxrlmnrwhr3dvmz5hzdjipwk9qzx5hdh7ydwn3n";
      type = "gem";
    };
    version = "16.10.0.0-x86_64-linux";
  };
  mathematical = {
    dependencies = ["ruby-enum"];
    groups = ["default" "pdf"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05mn68gxhfa37qsnzsmdqaa005hf511j5lga76qsrad2gcnhan1b";
      type = "gem";
    };
    version = "1.6.14";
  };
  matrix = {
    groups = ["default" "pdf"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h2cgkpzkh3dd0flnnwfq6f3nl2b1zff9lvqz8xs853ssv5kq23i";
      type = "gem";
    };
    version = "0.4.2";
  };
  mini_racer = {
    dependencies = ["libv8-node"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i4vbb1549rxbl8a35yaizfkbh28nxby5mcwri5mz3x19yg3p6r8";
      type = "gem";
    };
    version = "0.6.3";
  };
  namae = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1j3nl1klkx3gymrdxfc1hlq4a8qlvhhl9aj5v1v08b9fz27sky0l";
      type = "gem";
    };
    version = "1.1.1";
  };
  pdf-core = {
    groups = ["default" "pdf"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fz0yj4zrlii2j08kaw11j769s373ayz8jrdhxwwjzmm28pqndjg";
      type = "gem";
    };
    version = "0.9.0";
  };
  pdf-reader = {
    dependencies = ["Ascii85" "afm" "hashery" "ruby-rc4" "ttfunk"];
    groups = ["default" "pdf"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09sx25jpnip2sp6wh5sn5ad7za78rfi95qp5iiczfh43z4jqa8q3";
      type = "gem";
    };
    version = "2.11.0";
  };
  polyglot = {
    groups = ["default" "pdf"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bqnxwyip623d8pr29rg6m8r0hdg08fpr2yb74f46rn1wgsnxmjr";
      type = "gem";
    };
    version = "0.3.5";
  };
  prawn = {
    dependencies = ["pdf-core" "ttfunk"];
    groups = ["default" "pdf"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g9avv2rprsjisdk137s9ljr05r7ajhm78hxa1vjsv0jyx22f1l2";
      type = "gem";
    };
    version = "2.4.0";
  };
  prawn-icon = {
    dependencies = ["prawn"];
    groups = ["default" "pdf"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xdnjik5zinnkjavmybbh2s52wzcpb8hzaqckiv0mxp0vs0x9j6s";
      type = "gem";
    };
    version = "3.0.0";
  };
  prawn-svg = {
    dependencies = ["css_parser" "prawn" "rexml"];
    groups = ["default" "pdf"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mbxzw7r7hv43db9422flc24ib9d8bdy1nasbni2h998jc5a5lb6";
      type = "gem";
    };
    version = "0.32.0";
  };
  prawn-table = {
    dependencies = ["prawn"];
    groups = ["default" "pdf"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nxd6qmxqwl850icp18wjh5k0s3amxcajdrkjyzpfgq0kvilcv9k";
      type = "gem";
    };
    version = "0.2.2";
  };
  prawn-templates = {
    dependencies = ["pdf-reader" "prawn"];
    groups = ["default" "pdf"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w9irn3rllm992c6j7fsx81gg539i7yy8zfddyw7q53hnlys0yhi";
      type = "gem";
    };
    version = "0.1.2";
  };
  pseudocode = {
    dependencies = ["execjs" "katex"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1byg4xx3r9bxll1rgzi3rw95bkqw9sy63j8wxz1jpgyy1kgm358v";
      type = "gem";
    };
    version = "0.1.1";
  };
  public_suffix = {
    groups = ["default" "pdf"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sqw1zls6227bgq38sxb2hs8nkdz4hn1zivs27mjbniswfy4zvi6";
      type = "gem";
    };
    version = "5.0.0";
  };
  rexml = {
    groups = ["default" "pdf"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08ximcyfjy94pm1rhcx04ny1vx2sk0x4y185gzn86yfsbzwkng53";
      type = "gem";
    };
    version = "3.2.5";
  };
  rghost = {
    groups = ["pdf"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gqnzyk4lcgb5w86s65n4xwyhhi3igk17bfhdxb2i1yszhkww4m3";
      type = "gem";
    };
    version = "0.9.7";
  };
  rouge = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "066w2wf3mwkzynz9h7qqvvr0w6rq6q45ngjfh9z0s08ny2gpdbmq";
      type = "gem";
    };
    version = "4.0.0";
  };
  ruby-enum = {
    dependencies = ["i18n"];
    groups = ["default" "pdf"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pys90hxylhyg969iw9lz3qai5lblf8xwbdg1g5aj52731a9k83p";
      type = "gem";
    };
    version = "0.9.0";
  };
  ruby-rc4 = {
    groups = ["default" "pdf"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00vci475258mmbvsdqkmqadlwn6gj9m01sp7b5a3zd90knil1k00";
      type = "gem";
    };
    version = "0.1.5";
  };
  treetop = {
    dependencies = ["polyglot"];
    groups = ["default" "pdf"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0697qz1akblf8r3wi0s2dsjh468hfsd57fb0mrp93z35y2ni6bhh";
      type = "gem";
    };
    version = "1.6.11";
  };
  ttfunk = {
    groups = ["default" "pdf"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15iaxz9iak5643bq2bc0jkbjv8w2zn649lxgvh5wg48q9d4blw13";
      type = "gem";
    };
    version = "1.7.0";
  };
  wkhtml = {
    groups = ["pdf"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "162p82yvg42qzzwggyiynl7r5ph2yvhbaljipqwz3c6bacy4qfiv";
      type = "gem";
    };
    version = "0.0.1";
  };
}
