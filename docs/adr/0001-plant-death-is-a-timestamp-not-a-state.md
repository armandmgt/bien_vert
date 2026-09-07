# Plant death is a timestamp, not a state

A plant records death as a nullable date of death rather than as a state value, even though `RecognitionRequest` establishes a string-backed enum as this codebase's pattern for states. A timestamp also keeps the date itself, which a boolean or a bare state value would discard.

## Considered Options

An enum along the lines of `alive` / `dead` / `gone` / `dormant`, covering every reason a plant stops being watered, was rejected. Winter dormancy is temporary, should resume on its own, and arguably wants a seasonal watering frequency rather than a mute — folding it into the same state machine would mismodel it. Giving a plant away has never actually come up.

## Consequences

Generalising to a state enum later means a data migration. We accept that: a narrow timestamp is cheaper to widen once a second reason genuinely appears than a speculative enum is to narrow.
