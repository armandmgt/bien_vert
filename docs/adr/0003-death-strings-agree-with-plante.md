# Death strings agree with "plante", never with the species

French adjectives agree in gender and the app does not know whether a given species is masculine or feminine — *le ficus est mort*, but *la fougère est morte*. Every user-facing string about a plant's death is therefore phrased against the noun _plante_, which is feminine ("Marquer comme morte", "Plante morte", "Morte le 3 mars"), and no such string may interpolate the species or the plant's display name. This sidesteps grammatical gender rather than solving it.

## Considered Options

Storing a grammatical gender per plant, or per species, was rejected as far more machinery than a handful of strings can justify.

## Consequences

The existing display name prefix picks *mon* / *ma* from whether the name starts with a vowel. That is a rule about elision, not gender, and it gets the gender wrong often — treat it as a known rough edge, not as a precedent to copy.
