<TeXmacs|1.0.7.14>

<style|<tuple|source|env-theorem|env|cite-author-year|std-list|env-base|mypack>>

<\body>
  <assign|alg-keyword|<macro|body|<with|font-series|bold|<arg|body>>>>

  <\style-with|src-compact|none>
    <new-counter|algo>

    <assign|init-indent|3>

    <assign|indent-inc|2>

    <assign|render-algo-list|<macro|bodyb|<indent-left|3fn|<with|par-par-sep|.2fn|<surround|<no-page-break*>|<no-indent*>|<arg|bodyb>>>>>>

    <style-with|src-compact|all|<assign|algorithmic|<macro|bodya|<with|algo-nr|0|algo-ind|0|ind|<value|algo-indent>|state|<value|algo-item>|<algo-indent|<arg|bodya>>>>>>

    <style-with|src-compact|all|<style-with|src-compact|all|<style-with|src-compact|none|<assign|algo-indent|<\macro|bodyc>
      <with|algo-ind|<plus|<value|algo-ind>|3>|<render-algo-list|<arg|bodyc>>>
    </macro>>>>>

    <assign|render-algo|<\macro|x|algobody>
      <with|par-first|<times|-1fn|<value|algo-ind>>|<yes-indent><resize|<arg|x>:|<plus|1r|-2fn>||<plus|<plus|1r|-2fn>|<times|<value|algo-ind>|1fn>>|>><arg|algobody>
    </macro>>

    <assign|algo-item|<\macro|itembody>
      <next-algo><render-algo|<the-algo>|<arg|itembody>>
    </macro>>

    \;
  </style-with>

  <assign|WHILE|<\macro|cond>
    <alg-keyword|while> <arg|cond><assign|algo-ind|<plus|<value|algo-ind>|<value|indent-inc>>>
  </macro>>

  <assign|FOR-TO|<\macro|low|high>
    <alg-keyword|for> <arg|low> <alg-keyword|to>
    <arg|high><assign|algo-ind|<plus|<value|algo-ind>|<value|indent-inc>>>\ 
  </macro>>

  <assign|FOR-IN|<\macro|element|set>
    <alg-keyword|for> <arg|element> <alg-keyword|in>
    <arg|set><assign|algo-ind|<plus|<value|algo-ind>|<value|indent-inc>>>
  </macro>>

  <assign|END|<macro|<if|<greater|<algo-ind>|<init-indent>>|<assign|algo-ind|<minus|<value|algo-ind>|<value|indent-inc>>>>>>

  \;

  <assign|REPEAT|<macro|<alg-keyword|repeat><assign|algo-ind|<plus|<value|algo-ind>|<value|indent-inc>>>>>

  <assign|UNTIL|<\macro|cond>
    <alg-keyword|until> <arg|cond><if|<greater|<algo-ind>|<init-indent>>|<assign|algo-ind|<minus|<value|algo-ind>|<value|indent-inc>>>>
  </macro>>

  \;

  <assign|BREAK|<macro|<alg-keyword|break>>>

  <assign|CONTINUE|<macro|<alg-keyword|continue>>>

  \;

  <assign|RETURN|<\macro|body>
    <alg-keyword|return> <arg|body>
  </macro>>

  \;

  <assign|ERROR|<\macro|body>
    <alg-keyword|error> <arg|body>
  </macro>>

  \;

  <assign|count+|<macro|x|1>>

  <assign|count|<xmacro|x|<map-args|count+|plus|x>>>

  \;

  <assign|IF|<\macro|cond>
    <alg-keyword|if> <arg|cond><assign|algo-ind|<plus|<value|algo-ind>|<value|indent-inc>>>
  </macro>>

  <assign|ELSE|<\macro|cond>
    <alg-keyword|else> <arg|cond><assign|algo-ind|<plus|<value|algo-ind>|<value|indent-inc>>>
  </macro>>

  <assign|ELSE-IF|<\macro|cond>
    <alg-keyword|else if> <arg|cond><assign|algo-ind|<plus|<value|algo-ind>|<value|indent-inc>>>
  </macro>>

  \;

  <extern|(define-group enumerate-tag algo-indent)>

  \;

  <assign|new-algorithm|<macro|env|name|<new-env|<arg|env>|<arg|name>|theorem-env|render-algorithm>>>

  <new-algorithm|algorithmenv|Algorithm>

  <assign|render-big-algorithm|<\macro|type|name|body|cap>
    <\padded-normal|1fn|1fn>
      <block|<tformat|<twith|table-width|1par>|<twith|table-hmode|exact>|<cwith|1|-1|1|-1|cell-lborder|0>|<cwith|1|-1|1|-1|cell-rborder|0>|<cwith|1|-1|1|-1|cell-tborder|2ln>|<cwith|1|-1|1|-1|cell-lsep|0>|<cwith|1|-1|1|-1|cell-tsep|5ln>|<cwith|1|-1|1|-1|cell-bsep|4ln>|<cwith|1|-1|1|-1|cell-rsep|0>|<table|<row|<cell|<theorem-name|<arg|name><theorem-sep>>
      <arg|cap>>>>>>

      <arg|body>

      <hrule>
    </padded-normal>
  </macro>>

  <assign|new-algorithm|<\macro|env|name>
    <quasi|<style-with|src-compact|none|<add-to-counter-group|<unquote|<arg|env>>|figure-env><assign|<unquote|<merge|<arg|env>|-text>>|<macro|<localize|<unquote|<arg|name>>>>><assign|<unquote|<merge|<arg|env>|>>|<\macro|caption|body>
      <surround|<compound|<unquote|<merge|next-|<arg|env>>>>||<style-with|src-compact|none|<render-big-algorithm|<unquote|<arg|env>>|<style-with|src-compact|none|<compound|<unquote|<merge|<arg|env>|-text>>>
      <compound|<unquote|<merge|the-|<arg|env>>>>>|<with|alg-indentation|0cm|<arg|body>>|<arg|caption>>>>
    </macro>><assign|<unquote|<merge|<arg|env>|*>>|<\macro|caption|body>
      <style-with|src-compact|none|<render-big-algorithm|<unquote|<arg|env>>|<compound|<unquote|<merge|<arg|env>|-text>>>|<with|alg-indentation|0cm|<arg|body>>|<arg|caption>>>
    </macro>>>>
  </macro>>

  <new-algorithm|algorithm|Algorithm>

  \ \ 
</body>

<\initial>
  <\collection>
    <associate|preamble|true>
    <associate|src-special|normal>
    <associate|src-style|angular>
  </collection>
</initial>
