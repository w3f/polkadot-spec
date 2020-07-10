<TeXmacs|1.99.12>

<project|host-spec.tm>

<style|<tuple|book|old-dots>>

<\body>
  <appendix|Auxiliary Encodings><label|sect-encoding>

  <section|SCALE Codec><label|sect-scale-codec>

  The Polkadot Host uses <em|Simple Concatenated Aggregate Little-Endian\Q
  (SCALE) codec> to encode byte arrays as well as other data structures.
  SCALE provides a canonical encoding to produce consistent hash values
  across their implementation, including the Merkle hash proof for the State
  Storage.

  <\definition>
    <label|defn-scale-byte-array>The <strong|SCALE codec> for <strong|Byte
    array> <math|A> such that

    <\equation*>
      A\<assign\>b<rsub|1>*b<rsub|2>*\<ldots\>*b<rsub|n>
    </equation*>

    such that <math|n\<less\>2<rsup|536>> is a byte array refered to
    <math|Enc<rsub|SC><around|(|A|)>> and defined as:

    <\equation*>
      Enc<rsub|SC><around|(|A|)>\<assign\>Enc<rsup|Len><rsub|SC><around*|(|<around*|\<\|\|\>|A|\<\|\|\>>|)><around*|\|||\|>A
    </equation*>

    where <math|Enc<rsub|SC><rsup|Len>> is defined in Definition
    <reference|defn-sc-len-encoding>.\ 
  </definition>

  <\definition>
    <label|defn-scale-tuple>The <strong|SCALE codec> for <strong|Tuple>
    <math|T> such that:

    <\equation*>
      T\<assign\><around|(|A<rsub|1>,\<ldots\>,A<rsub|n>|)>
    </equation*>

    Where <math|A<rsub|i>>'s are values of <strong|different types>, is
    defined as:

    <\equation*>
      Enc<rsub|SC><around|(|T|)>\<assign\>Enc<rsub|SC><around|(|A<rsub|1>|)><around*|\|||\|>Enc<rsub|SC><around|(|A<rsub|2>|)><around*|\|||\|>\<ldots\><around*|\|||\|>*Enc<rsub|SC><around|(|A<rsub|n>|)>
    </equation*>
  </definition>

  In case of a tuple (or struct), the knowledge of the shape of data is not
  encoded even though it is necessary for decoding. The decoder needs to
  derive that information from the context where the encoding/decoding is
  happenning.

  <\definition>
    <label|defn-varrying-data-type>We define a <strong|varying data> type to
    be an ordered set of data types\ 

    <\equation*>
      \<cal-T\>=<around*|{|T<rsub|1>,\<ldots\>,T<rsub|n>|}>
    </equation*>

    A value <math|\<b-A\>> of varying date type is a pair
    <math|<around*|(|A<rsub|Type>,A<rsub|Value>|)>> where
    <math|A<rsub|Type>=T<rsub|i>> for some <math|T<rsub|i>\<in\>\<cal-T\>>
    and <math|A<rsub|Value>> is its value of type <math|T<rsub|i>>, which can
    be empty. We define <math|idx<around*|(|T<rsub|i>|)>=i-1>, unless it is
    explicitly defined as another value in the definition of a particular
    varying data type.
  </definition>

  In particular, we define two specific varying data which are frequently
  used in various part of Polkadot Protocol.

  <\definition>
    <math|<label|defn-option-type>>The <strong|Option> type is a varying data
    type of <math|{None,<math|T<rsub|2>>}> which indicates if data of
    <math|T<rsub|2>> type is available (referred to as \Psome\Q state) or not
    (referred to as \Pempty\Q, \Pnone\Q or \Pnull\Q state). The presence of
    type None, indicated by <math|idx<around*|(|T<rsub|None>|)>=0>, implies
    that the data corresponding to <math|T<rsub|2>> type is not available and
    contains no additional data. Where as the presence of type
    <math|T<rsub|2>> indicated by <math|idx<around*|(|T<rsub|2>|)>=1> implies
    that the data is available.
  </definition>

  <\definition>
    <label|defn-result-type>The <strong|Result> type is a varying data type
    of <math|{<math|T<rsub|1>>,<math|T<rsub|2>>}> which is used to indicate
    if a certain operation or function was executed successfully (referred to
    as \Pok\Q state) or not (referred to as \Perr\Q state). <math|T<rsub|1>>
    implies success, <math|T<rsub|2>> implies failure. Both types can either
    contain additional data or are defined as empty type otherwise.
  </definition>

  <\definition>
    <label|defn-scale-variable-type>Scale coded for value
    <strong|<math|A=<around*|(|A<rsub|Type>,A<rsub|Value>|)>> of varying data
    type> <math|\<cal-T\>=<around*|{|T<rsub|1>,\<ldots\>,T<rsub|n>|}>>

    <\equation*>
      Enc<rsub|SC><around*|(|A|)>\<assign\>Enc<rsub|SC><around*|(|Idx<around*|(|A<rsub|Type>|)>|)><around*|\|||\|>Enc<rsub|SC><around*|(|A<rsub|Value>|)>
    </equation*>

    Where <math|Idx> is encoded in a fixed length integer determining the
    type of <math|A>.

    In particular, for the optional type defined in Definition
    <reference|defn-varrying-data-type>, we have:

    <\equation*>
      Enc<rsub|SC><around*|(|<around*|(|None,\<phi\>|)>|)>\<assign\>0<rsub|\<bbb-B\><rsub|1>>
    </equation*>
  </definition>

  SCALE codec does not encode the correspondence between the value of
  <math|Idx> defined in Definition <reference|defn-scale-variable-type> and
  the data type it represents; the decoder needs prior knowledge of such
  correspondence to decode the data.

  <\definition>
    <label|defn-scale-list>The <strong|SCALE codec> for <strong|sequence>
    <math|S> such that:

    <\equation*>
      S\<assign\>A<rsub|1>,\<ldots\>,A<rsub|n>
    </equation*>

    where <math|A<rsub|i>>'s are values of <strong|the same type> (and the
    decoder is unable to infer value of <math|n> from the context) is defined
    as:

    <\equation*>
      Enc<rsub|SC><around|(|S|)>\<assign\>Enc<rsup|Len><rsub|SC><around*|(|<around*|\<\|\|\>|S|\<\|\|\>>|)><mid|\|>Enc<rsub|SC><around|(|A<rsub|1>|)>\|Enc<rsub|SC><around|(|A<rsub|2>|)><around|\||\<ldots\>|\|>*Enc<rsub|SC><around|(|A<rsub|n>|)>
    </equation*>

    where <math|Enc<rsub|SC><rsup|Len>> is defined in Definition
    <reference|defn-sc-len-encoding>.
  </definition>

  <\definition>
    SCALE codec for <strong|dictionary> or <strong|hashtable> D with
    key-value pairs <math|<around*|(|k<rsub|i>,v<rsub|i>|)>>s such that:

    <\equation*>
      D\<assign\><around*|{|<around*|(|k<rsub|1>,v<rsub|1>|)>,\<ldots\>,<around*|(|k<rsub|1>,v<rsub|n>|)>|}>
    </equation*>

    is defined the SCALE codec of <math|D> as a sequence of key value pairs
    (as tuples):

    <\equation*>
      Enc<rsub|SC><around|(|D|)>\<assign\>Enc<rsup|Size><rsub|SC><around*|(|<around*|\|||\|>D<around*|\|||\|>|)><mid|\|>Enc<rsub|SC><around|(|<around*|(|k<rsub|1>,v<rsub|1>|)><rsub|>|)>\|Enc<rsub|SC><around|(|<around*|(|k<rsub|2>,v<rsub|2>|)>|)><around|\||\<ldots\>|\|>*Enc<rsub|SC><around|(|<around*|(|k<rsub|n>,v<rsub|n>|)>|)>
    </equation*>

    <math|Enc<rsup|Size><rsub|SC>> is encoded the same way as
    <math|Enc<rsup|Len><rsub|SC>> but argument <math|size> refers to the
    number of key-value pairs rather than the length.
  </definition>

  <\definition>
    The <strong|SCALE codec> for <strong|boolean value> <math|b> defined as a
    byte as follows:

    <\equation*>
      <tabular|<tformat|<table|<row|<cell|Enc<rsub|SC>:>|<cell|<around*|{|False,True|}>\<rightarrow\>\<bbb-B\><rsub|1>>>|<row|<cell|>|<cell|b\<rightarrow\><around*|{|<tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|3|3|cell-rborder|0ln>|<table|<row|<cell|0>|<cell|>|<cell|b=False>>|<row|<cell|1>|<cell|>|<cell|b=True>>>>>|\<nobracket\>>>>>>>
    </equation*>
  </definition>

  <\definition>
    <label|defn-scale-fixed-length>The <strong|SCALE codec,
    <math|Enc<rsub|SC>>> for other types such as fixed length integers not
    defined here otherwise, is equal to little endian encoding of those
    values defined in Definition <reference|defn-little-endian>.\ 
  </definition>

  <\definition>
    <label|defn-scale-empty>The <strong|SCALE codec, <math|Enc<rsub|SC>>> for
    an empty type is defined to a byte array of zero length and depicted as
    <strong|<math|\<phi\>>>.
  </definition>

  <subsection|Length and Compact Encoding><label|sect-int-encoding>

  <em|SCALE Length encoding> is used to encode integer numbers of variying
  sizes prominently in an encoding length of arrays:\ 

  <\definition>
    <label|defn-sc-len-encoding><strong|SCALE Length Encoding,
    <math|Enc<rsup|Len><rsub|SC>>> also known as compact encoding of a
    non-negative integer number <math|n> is defined as follows:

    <\equation*>
      <tabular|<tformat|<table|<row|<cell|Enc<rsup|Len><rsub|SC>:>|<cell|\<bbb-N\>\<rightarrow\>\<bbb-B\>>>|<row|<cell|>|<cell|n\<rightarrow\>b\<assign\><around*|{|<tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|3|3|cell-rborder|0ln>|<table|<row|<cell|l<rsup|\<nosymbol\>><rsub|1>>|<cell|>|<cell|0\<leqslant\>n\<less\>2<rsup|6>>>|<row|<cell|i<rsup|\<nosymbol\>><rsub|1>*i<rsup|\<nosymbol\>><rsub|2>>|<cell|>|<cell|2<rsup|6>\<leqslant\>n\<less\>2<rsup|14>>>|<row|<cell|j<rsup|\<nosymbol\>><rsub|1>*j<rsup|\<nosymbol\>><rsub|2>*j<rsub|3>>|<cell|>|<cell|2<rsup|14>\<leqslant\>n\<less\>2<rsup|30>>>|<row|<cell|k<rsub|1><rsup|\<nosymbol\>>*k<rsub|2><rsup|\<nosymbol\>>*\<ldots\>*k<rsub|m><rsup|\<nosymbol\>>*>|<cell|>|<cell|2<rsup|30>\<leqslant\>n>>>>>|\<nobracket\>>>>>>>
    </equation*>

    in where the least significant bits of the first byte of byte array b are
    defined as follows:

    <\equation*>
      <tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|2|2|cell-rborder|0ln>|<cwith|1|-1|3|3|cell-lborder|0ln>|<cwith|1|-1|3|3|cell-rborder|0ln>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|1|1|cell-rborder|0ln>|<cwith|1|-1|2|2|cell-lborder|0ln>|<cwith|1|1|1|-1|cell-tborder|0ln>|<cwith|1|2|1|1|cell-lborder|0ln>|<cwith|1|2|3|3|cell-rborder|0ln>|<cwith|2|2|1|-1|cell-tborder|0ln>|<cwith|1|1|1|-1|cell-bborder|0ln>|<cwith|2|-1|1|1|cell-lborder|0ln>|<cwith|2|-1|3|3|cell-rborder|0ln>|<cwith|4|4|1|-1|cell-bborder|0ln>|<cwith|3|4|1|1|cell-lborder|0ln>|<cwith|3|4|3|3|cell-rborder|0ln>|<cwith|3|3|1|-1|cell-tborder|0ln>|<cwith|2|2|1|-1|cell-bborder|0ln>|<cwith|3|3|1|-1|cell-bborder|0ln>|<cwith|4|4|1|-1|cell-tborder|0ln>|<cwith|3|3|1|1|cell-lborder|0ln>|<cwith|3|3|3|3|cell-rborder|0ln>|<table|<row|<cell|l<rsup|1><rsub|1>*l<rsub|1><rsup|0>>|<cell|=>|<cell|00>>|<row|<cell|i<rsup|1><rsub|1>*i<rsub|1><rsup|0>>|<cell|=>|<cell|01>>|<row|<cell|j<rsup|1><rsub|1>*j<rsub|1><rsup|0>>|<cell|=>|<cell|10>>|<row|<cell|k<rsup|1><rsub|1>*k<rsub|1><rsup|0>>|<cell|=>|<cell|11>>>>>
    </equation*>

    and the rest of the bits of <math|b> store the value of <math|n> in
    little-endian format in base-2 as follows:

    <\equation*>
      <around*|\<nobracket\>|<tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|3|3|cell-rborder|0ln>|<table|<row|<cell|l<rsup|7><rsub|1>*\<ldots\>*l<rsup|3><rsub|1>*l<rsup|2><rsub|1>>|<cell|>|<cell|n\<less\>2<rsup|6>>>|<row|<cell|i<rsub|2><rsup|7>*\<ldots\>*i<rsub|2><rsup|0>*i<rsub|1><rsup|7>*\<ldots\>*i<rsup|2><rsub|1><rsup|\<nosymbol\>>>|<cell|>|<cell|2<rsup|6>\<leqslant\>n\<less\>2<rsup|14>>>|<row|<cell|j<rsub|4><rsup|7>*\<ldots\>*j<rsub|4><rsup|0>*j<rsub|3><rsup|7>*\<ldots\>*j<rsub|1><rsup|7>*\<ldots\>*j<rsup|2><rsub|1>>|<cell|>|<cell|2<rsup|14>\<leqslant\>n\<less\>2<rsup|30>>>|<row|<cell|k<rsub|2>+k<rsub|3>*2<rsup|8>+k<rsub|4>*2<rsup|2*\<cdummy\>*8>+\<cdots\>+k<rsub|m>*2<rsup|<around|(|m-2|)>*8>>|<cell|>|<cell|2<rsup|30>\<leqslant\>n>>>>>|}>\<assign\>n
    </equation*>

    such that:

    <\equation*>
      k<rsup|7><rsub|1>*\<ldots\>*k<rsup|3><rsub|1>*k<rsup|2><rsub|1>:=m-4
    </equation*>
  </definition>

  <section|Hex Encoding>

  Practically, it is more convenient and efficient to store and process data
  which is stored in a byte array. On the other hand, the Trie keys are
  broken into 4-bits nibbles. Accordingly, we need a method to encode
  sequences of 4-bits nibbles into byte arrays canonically:

  <\definition>
    <label|defn-hex-encoding>Suppose that
    <math|PK=<around|(|k<rsub|1>,\<ldots\>,k<rsub|n>|)>> is a sequence of
    nibbles, then

    <tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|1|1|cell-rborder|0ln>|<cwith|1|-1|1|-1|cell-valign|c>|<table|<row|<cell|<math|Enc<rsub|HE><around|(|PK|)>\<assign\>>>>|<row|<cell|<math|<around*|{|<tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|3|3|cell-halign|l>|<cwith|1|-1|3|3|cell-rborder|0ln>|<table|<row|<cell|Nibbles<rsub|4>>|<cell|\<rightarrow\>>|<cell|\<bbb-B\>>>|<row|<cell|PK=<around|(|k<rsub|1>,\<ldots\>,k<rsub|n>|)>>|<cell|\<mapsto\>>|<cell|<around*|{|<tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|1|1|cell-rborder|0ln>|<table|<row|<cell|<tabular*|<tformat|<cwith|1|-1|1|1|cell-halign|l>|<cwith|1|-1|1|1|cell-lborder|0ln>|<cwith|1|-1|2|2|cell-halign|l>|<cwith|1|-1|2|2|cell-rborder|0ln>|<table|<row|<cell|<around|(|16k<rsub|1>+*k<rsub|2>,\<ldots\>,16k<rsub|2*i-1>+*k<rsub|2*i>|)>>|<cell|n=2*i>>|<row|<cell|<around|(|k<rsub|1>,16k<rsub|2>+*k<rsub|3>,\<ldots\>,16k<rsub|2*i>+*k<rsub|2*i+1>|)>>|<cell|n=2*i+1>>>>>>>>>>|\<nobracket\>>>>>>>|\<nobracket\>>>>>>>>
  </definition>

  \;

  <\with|par-mode|right>
    <qed>
  </with>

  \;
</body>

<\initial>
  <\collection>
    <associate|chapter-nr|6>
    <associate|page-first|55>
    <associate|page-height|auto>
    <associate|page-type|letter>
    <associate|page-width|auto>
    <associate|section-nr|5<uninit>>
    <associate|subsection-nr|5>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|auto-1|<tuple|A|55>>
    <associate|auto-2|<tuple|A.1|55>>
    <associate|auto-3|<tuple|A.1.1|56>>
    <associate|auto-4|<tuple|A.2|57>>
    <associate|defn-hex-encoding|<tuple|A.12|57>>
    <associate|defn-option-type|<tuple|A.4|55>>
    <associate|defn-result-type|<tuple|A.5|55>>
    <associate|defn-sc-len-encoding|<tuple|A.11|56>>
    <associate|defn-scale-byte-array|<tuple|A.1|55>>
    <associate|defn-scale-empty|<tuple|A.10|56>>
    <associate|defn-scale-fixed-length|<tuple|A.9|56>>
    <associate|defn-scale-list|<tuple|A.7|56>>
    <associate|defn-scale-tuple|<tuple|A.2|55>>
    <associate|defn-scale-variable-type|<tuple|A.6|56>>
    <associate|defn-varrying-data-type|<tuple|A.3|55>>
    <associate|sect-encoding|<tuple|A|55>>
    <associate|sect-int-encoding|<tuple|A.1.1|56>>
    <associate|sect-scale-codec|<tuple|A.1|55>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|Appendix
      A<space|2spc>Auxiliary Encodings> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|0.5fn>

      A.1<space|2spc>SCALE Codec <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2>

      <with|par-left|<quote|1tab>|A.1.1<space|2spc>Length and Compact
      Encoding <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3>>

      A.2<space|2spc>Hex Encoding <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4>
    </associate>
  </collection>
</auxiliary>