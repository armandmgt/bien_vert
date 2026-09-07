# BienVert

Personal plant-care app: track your houseplants and get reminded when they need watering. A Rails web app served to the browser and to an embedded Hotwire Native iOS client. The user-facing language is French; this glossary gives the canonical English term with its French UI equivalent.

## Language

**Plant**:
A houseplant belonging to one user, with a species, an optional name, a watering frequency, and a watering history. French UI: _plante_.
_Avoid_: pot, specimen

**Species**:
The kind of plant, either typed by the user or proposed by a recognition request. French UI: _espèce_.
_Avoid_: variety, type

**Watering frequency**:
How long should pass between waterings of a plant, expressed in days and possibly fractional. French UI: _fréquence d'arrosage_.
_Avoid_: interval, schedule, cadence

**Overdue**:
A plant whose last watering plus its watering frequency lies in the past; a plant never watered is overdue from creation. Purely a fact about elapsed time — it says nothing about whether the user should be told.
_Avoid_: thirsty, due, late

**Needs watering**:
An overdue plant that is not dead — that is, a plant worth telling the user about. Every reminder surface counts plants that need watering, never plants that are merely overdue.
_Avoid_: due for watering, pending

**Dead plant**:
A plant that has died, recorded with its date of death and kept along with its photo and watering history. A dead plant never needs watering. French UI: _plante morte_.
_Avoid_: archived, inactive, retired, deleted

**Revive**:
To undo a plant's death, restoring its normal watering behaviour and its reminders.
_Avoid_: restore, unarchive, resurrect

**Watering reminder**:
The once-daily push notification telling a user which of their plants need watering. French UI: _rappel d'arrosage_.
_Avoid_: alert, notification

**Reminder criticality**:
How badly a plant's watering has slipped, as reflected on its card — normal, or urgent once it has been overdue for more than half its watering frequency again.
_Avoid_: severity, priority

**Recognition request**:
An attempt to identify a plant's species from a photograph using AI, which on success seeds a new plant's species and watering frequency.
_Avoid_: scan, identification, detection
