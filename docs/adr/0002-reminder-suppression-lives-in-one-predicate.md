# Reminder suppression lives in one predicate

Four surfaces nag the user about watering: the daily push, the iOS badge count, the in-app notification dropdown, and the overdue badge on a plant's card. All four ask the same question — does this plant need watering? — and that predicate is the only place permitted to know about suppression. The pure time arithmetic lives separately as *overdue*, so the policy predicate can absorb death, and any future reason to go quiet, without four consumers each growing their own condition.

## Considered Options

Overloading the arithmetic predicate directly was rejected: its name would then describe only half of what it answers, which is precisely the trap a future reader falls into. Adding a *needs reminder* predicate alongside a pure *needs watering* was also rejected — all four consumers want the suppressed answer, so the pure version would have had no callers at all.

## Consequences

Do not add a death check to any consumer. If a consumer appears to need one, the suppression belongs in the predicate instead.
