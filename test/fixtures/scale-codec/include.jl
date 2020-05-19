using .AdapterFixture


const TEST_DATA = "\"" .* [
  "1",
  "22",
  "333",
  "1234",
  "abcdefghijklmnopqrstuvwxyz",
  """A towel, it says, is about the most massively useful  thing  an 
      interstellar  hitch hiker can have. Partly it has great practical 
      value - you can wrap it around you for warmth as you bound across 
      the cold moons of Jaglan Beta; you can lie on it on the brilliant 
      marble-sanded beaches of Santraginus V, inhaling  the  heady  sea 
      vapours;  you can sleep under it beneath the stars which shine so 
      redly on the desert world of Kakrafoon; use it  to  sail  a  mini 
      raft  down  the slow heavy river Moth; wet it for use in hand-to- 
      hand-combat; wrap it round your head to ward off noxious fumes or 
      to  avoid  the  gaze of the Ravenous Bugblatter Beast of Traal (a 
      mindboggingly stupid animal, it assumes that if you can't see it, 
      it  can't  see  you - daft as a bush, but very ravenous); you can 
      wave your towel in emergencies  as  a  distress  signal,  and  of 
      course  dry  yourself  off  with it if it still seems to be clean 
      enough."""
] .* "\""


tests = AdapterFixture.Builder("Scale Codec", "scale-codec")

sub!(tests) do t
  arg!(t, "encode --input")
  foreach!(t, TEST_DATA)
  commit!(t)
end

prepare!(tests)

AdapterFixture.execute(tests)
