# Curiosity Modeling: Recitation Allocation
(cs1710 midterm project)

## Model Details

_What are you trying to model? Include a brief description that would give someone unfamiliar with the topic a basic understanding of your goal._

TODO: answer

_Give an overview of your model design choices, what checks or run statements you wrote, and what we should expect to see from an instance produced by the Sterling visualizer. How should we look at and interpret an instance created by your spec? Did you create a custom visualization, or did you use the default?_

TODO: answer

_At a high level, what do each of your sigs and preds represent in the context of the model? Justify the purpose for their existence and how they fit together._

This model's `sig`s include:
- `Student`: the students being allocated to recitations. Students have preferences in `sig TimeOption` and are allocated to a `TimeOption` in `sig Allocation`.
- `Available`: binary sig `Y` or `N` indicating whether the `Student` is available for a `TimeOption`. `Y` means "yes", `N` means "no".
- `TimeOption`: a time section for a recitation block. Has the `pref pfunc` that maps from `TimeOption -> Student -> Available`. This simulates students' responses to a form about their availability.
- `Allocation`: the final allocation outcome of the model. All students are allocated to a time they were available for, and no sections are empty.

The preds are:
-  `wellformed`: 
- `isAvaiable`: 
- `validAlloc`:
- `balancedAttendance`: 