module ScaleCodecFixtures
const test_byte_arrays = [b"1", b"22", b"333", b"1234", b"abcdefghijklmnopqrstuvwxyz",
                    b"""A towel, it says, is about the most massively useful  thing  an 
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
                    ]
#reference implementation to be first
const cli_scale_encoders = ["../build/test/testers/rust-tester/scale_codec", 
                            "../build/test/testers/go-tester/scale_codec_go"]

const reference_implementation = 1
end
