<TeXmacs|1.99.12>

<project|polkadot_host_spec.tm>

<style|<tuple|book|algorithmacs-style>>

<\body>
  <include|c06-consensus.tm>

  A Catch-up response message contains critical information for the requester
  node to update their view on the active rounds which are being voted on by
  GRANDPA voters. As such, the requester node should verify the content of
  the catch-up response message and subsequently updates its view of the
  state of finality of the Relay chain according to Algorithm
  <reference|algo-process-catchup-response>.

  <\algorithm>
    <label|algo-process-catchup-response> <name|Process-Catchup-Response>(

    <math|M<rsub|v,i><rsup|Cat-s><around*|(|id<rsub|\<bbb-V\>>,r|)>>: the
    catch-up response received from node <math|v> (See Definition
    <reference|defn-grandpa-catchup-response-msg>)

    )
  <|algorithm>
    <\algorithmic>
      <\state>
        <math|M<rsub|v,i><rsup|Cat-s><around*|(|id<rsub|\<bbb-V\>>,r|)>.id<rsub|\<bbb-V\>>,r,J<rsup|r,pv><around*|(|B|)>,J<rsup|r,pc><around*|(|B|)>,H<rsub|h><around*|(|B<rprime|'>|)>,H<rsub|i><around*|(|B<rprime|'>|)>\<leftarrow\>><math|Dec<rsub|SC>>(<math|M<rsub|v,i><rsup|Cat-s><around*|(|id<rsub|\<bbb-V\>>,r|)>>)
      </state>

      <\state>
        <\IF>
          <math|M<rsub|v,i><rsup|Cat-s><around*|(|id<rsub|\<bbb-V\>>,r|)>.id<rsub|\<bbb-V\>>\<neq\>id<rsub|\<bbb-V\>>>
        </IF>
      </state>

      <\state>
        <\ERROR>
          \PCatching up on different set\Q<END>
        </ERROR>
      </state>

      <\state>
        <\IF>
          <math|r\<leqslant\>><name|Leading-Round>
        </IF>
      </state>

      <\state>
        <\ERROR>
          \PCatching up in to the past\Q<END>
        </ERROR>
      </state>

      <\state>
        TBS
      </state>

      <\state>
        <name|Last-Completed-Round><math|\<leftarrow\>r>
      </state>

      <\state>
        <\IF>
          <math|i\<in\>\<bbb-V\>>
        </IF>
      </state>

      <\state>
        <name|Play-Grandpa-round><math|<around|(|r|)>><END>
      </state>
    </algorithmic>
  </algorithm>

  \;
</body>

<\initial>
  <\collection>
    <associate|page-medium|papyrus>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|algo-attempt-to\Ufinalize|<tuple|6.11|?>>
    <associate|algo-block-production|<tuple|6.3|?>>
    <associate|algo-block-production-lottery|<tuple|6.1|?>>
    <associate|algo-build-block|<tuple|6.7|?>>
    <associate|algo-epoch-randomness|<tuple|6.4|?>>
    <associate|algo-grandpa-best-candidate|<tuple|6.10|?>>
    <associate|algo-grandpa-round|<tuple|6.9|?>>
    <associate|algo-initiate-grandpa|<tuple|6.8|?>>
    <associate|algo-process-catchup-request|<tuple|6.12|?>>
    <associate|algo-slot-time|<tuple|6.2|?>>
    <associate|algo-verify-authorship-right|<tuple|6.5|?>>
    <associate|algo-verify-slot-winner|<tuple|6.6|?>>
    <associate|auto-1|<tuple|6|?>>
    <associate|auto-10|<tuple|6.2.4|?>>
    <associate|auto-11|<tuple|6.2.5|?>>
    <associate|auto-12|<tuple|6.2.6|?>>
    <associate|auto-13|<tuple|6.2.7|?>>
    <associate|auto-14|<tuple|6.3|?>>
    <associate|auto-15|<tuple|6.3.1|?>>
    <associate|auto-16|<tuple|6.3.2|?>>
    <associate|auto-17|<tuple|6.3.2.1|?>>
    <associate|auto-18|<tuple|6.3.2.2|?>>
    <associate|auto-19|<tuple|6.3.2.3|?>>
    <associate|auto-2|<tuple|6.1|?>>
    <associate|auto-20|<tuple|6.3.3|?>>
    <associate|auto-21|<tuple|6.3.3.1|?>>
    <associate|auto-22|<tuple|6.3.4|?>>
    <associate|auto-23|<tuple|6.4|?>>
    <associate|auto-24|<tuple|6.4.1|?>>
    <associate|auto-25|<tuple|6.4.1.1|?>>
    <associate|auto-26|<tuple|6.4.1.2|?>>
    <associate|auto-3|<tuple|6.1.1|?>>
    <associate|auto-4|<tuple|6.1.2|?>>
    <associate|auto-5|<tuple|6.1|?>>
    <associate|auto-6|<tuple|6.2|?>>
    <associate|auto-7|<tuple|6.2.1|?>>
    <associate|auto-8|<tuple|6.2.2|?>>
    <associate|auto-9|<tuple|6.2.3|?>>
    <associate|chap-consensu|<tuple|6|?>>
    <associate|defn-authority-list|<tuple|6.1|?>>
    <associate|defn-babe-header|<tuple|6.12|?>>
    <associate|defn-babe-seal|<tuple|6.13|?>>
    <associate|defn-block-signature|<tuple|6.13|?>>
    <associate|defn-block-time|<tuple|6.10|?>>
    <associate|defn-consensus-message-digest|<tuple|6.2|?>>
    <associate|defn-epoch-slot|<tuple|6.5|?>>
    <associate|defn-epoch-subchain|<tuple|6.7|?>>
    <associate|defn-finalized-block|<tuple|6.29|?>>
    <associate|defn-grandpa-catchup-request-msg|<tuple|6.27|?>>
    <associate|defn-grandpa-catchup-response-msg|<tuple|6.28|?>>
    <associate|defn-grandpa-completable|<tuple|6.23|?>>
    <associate|defn-grandpa-justification|<tuple|6.25|?>>
    <associate|defn-slot-offset|<tuple|6.11|?>>
    <associate|defn-vote|<tuple|6.16|?>>
    <associate|defn-winning-threshold|<tuple|6.8|?>>
    <associate|note-slot|<tuple|6.6|?>>
    <associate|sect-authority-set|<tuple|6.1.1|?>>
    <associate|sect-babe|<tuple|6.2|?>>
    <associate|sect-block-building|<tuple|6.2.7|?>>
    <associate|sect-block-finalization|<tuple|6.4|?>>
    <associate|sect-block-production|<tuple|6.2|?>>
    <associate|sect-consensus-message-digest|<tuple|6.1.2|?>>
    <associate|sect-epoch-randomness|<tuple|6.2.5|?>>
    <associate|sect-finality|<tuple|6.3|?>>
    <associate|sect-grandpa-catchup|<tuple|6.4.1|?>>
    <associate|sect-grandpa-catchup-messages|<tuple|6.3.2.3|?>>
    <associate|sect-sending-catchup-request|<tuple|6.4.1.1|?>>
    <associate|sect-verifying-authorship|<tuple|6.2.6|?>>
    <associate|slot-time-cal-tail|<tuple|6.9|?>>
    <associate|tabl-consensus-messages|<tuple|6.1|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|bib>
      w3f_research_group_blind_2019

      david_ouroboros_2018

      stewart_grandpa:_2019
    </associate>
    <\associate|table>
      <tuple|normal|<\surround|<hidden-binding|<tuple>|6.1>|>
        The consensus digest item for GRANDPA authorities
      </surround>|<pageref|auto-5>>
    </associate>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|6<space|2spc>Consensus>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|0.5fn>

      6.1<space|2spc>Common Consensus Structures
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2>

      <with|par-left|<quote|1tab>|6.1.1<space|2spc>Consensus Authority Set
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3>>

      <with|par-left|<quote|1tab>|6.1.2<space|2spc>Runtime-to-Consensus
      Engine Message <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4>>

      6.2<space|2spc>Block Production <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6>

      <with|par-left|<quote|1tab>|6.2.1<space|2spc>Preliminaries
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-7>>

      <with|par-left|<quote|1tab>|6.2.2<space|2spc>Block Production Lottery
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-8>>

      <with|par-left|<quote|1tab>|6.2.3<space|2spc>Slot Number Calculation
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-9>>

      <with|par-left|<quote|1tab>|6.2.4<space|2spc>Block Production
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-10>>

      <with|par-left|<quote|1tab>|6.2.5<space|2spc>Epoch Randomness
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-11>>

      <with|par-left|<quote|1tab>|6.2.6<space|2spc>Verifying Authorship Right
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-12>>

      <with|par-left|<quote|1tab>|6.2.7<space|2spc>Block Building Process
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-13>>

      6.3<space|2spc>Finality <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-14>

      <with|par-left|<quote|1tab>|6.3.1<space|2spc>Preliminaries
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-15>>

      <with|par-left|<quote|1tab>|6.3.2<space|2spc>GRANDPA Messages
      Specification <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-16>>

      <with|par-left|<quote|2tab>|6.3.2.1<space|2spc>Vote Messages
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-17>>

      <with|par-left|<quote|2tab>|6.3.2.2<space|2spc>Finalizing Message
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-18>>

      <with|par-left|<quote|2tab>|6.3.2.3<space|2spc>Catch-up Messages
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-19>>

      <with|par-left|<quote|1tab>|6.3.3<space|2spc>Initiating the GRANDPA
      State <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-20>>

      <with|par-left|<quote|2tab>|6.3.3.1<space|2spc>Voter Set Changes
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-21>>

      <with|par-left|<quote|1tab>|6.3.4<space|2spc>Voting Process in Round
      <with|mode|<quote|math>|r> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-22>>

      6.4<space|2spc>Block Finalization <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-23>

      <with|par-left|<quote|1tab>|6.4.1<space|2spc>Catching up
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-24>>

      <with|par-left|<quote|2tab>|6.4.1.1<space|2spc>Sending catch-up request
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-25>>

      <with|par-left|<quote|2tab>|6.4.1.2<space|2spc>Processing catch-up
      request <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-26>>
    </associate>
  </collection>
</auxiliary>