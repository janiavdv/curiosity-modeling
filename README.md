# Curiosity Modeling: Recitation Allocation
(cs1710 midterm project)

## Model Details

_What are you trying to model? Include a brief description that would give someone unfamiliar with the topic a basic understanding of your goal._

Our project is a rudimentary model of a system that would be used to assign students into different recitation sections for a course based off of 
indicated preferences (think a Google Sheet where students would indicate whether or not they can attend a section). Often, it is difficult to do this
manually, as the number of different constraints on which allocations are acceptable increase steeply as course size grows -- for example, weekday evening
sections are often far more popular than weekend morning ones, but how do we ensure that the sections are (somewhat) evenly filled while also respecting
the preferences of the students? Therefore, some sort of system to model this would be extremely useful in its ability to not produce instances where 
any of these concerns we have are violated.

_Give an overview of your model design choices, what checks or run statements you wrote, and what we should expect to see from an instance produced by the Sterling visualizer. How should we look at and interpret an instance created by your spec? Did you create a custom visualization, or did you use the default?_

Our model was designed with a smaller number of students being allocated to a smaller number of sections in mind, due to not only the limitations of Forge,
but the limitations of Froglet as well (less ability to work with sets directly). The important part of an instance produced in the sterling visualizer is 
the Allocation sig, which essentially (in Table view) serves as a list as to which section each student was assigned to. Then, one can check that the instance 
is valid by comparing a student's assigned section to their preference for that section in the TimeOption sig - if a student is assigned to a section then they 
necessarily must have indicated a preference for it. Because of the limitations of Integers in this language, we were unable to directly assign a "capacity" field
to the "TimeOption" sigs, because often the capacity would overflow and so an instance would interpret some larger number of students being assigned to a section
as a smaller integer that is less than the capacity. We used the default visualization in the Table view, as there were too many different allocations and 
preferences in the directed graph for it to be useful,as every student had to have indicated a preference for every TimeOption. The hope for this project is that 
it will serve as a precursor to a larger final project that, when freed from the constraints of Forge/Froglet, will be able to better represent section allocation
for a large course where students are able to indicate multiple different preference levels.

_At a high level, what do each of your sigs and preds represent in the context of the model? Justify the purpose for their existence and how they fit together._

This model's `sig`s include:
- `Student`: the students being allocated to recitations. Students have preferences in `sig TimeOption` and are allocated to a `TimeOption` in `sig Allocation`.
- `Available`: binary sig `Y` or `N` indicating whether the `Student` is available for a `TimeOption`. `Y` means "yes", `N` means "no".
- `TimeOption`: a time section for a recitation block. Has the `pref pfunc` that maps from `TimeOption -> Student -> Available`. This simulates students' responses to a form about their availability.
- `Allocation`: the final allocation outcome of the model. All students are allocated to a time they were available for, and no sections are empty.

The preds are:
-  `wellformed`: This is the predicate that ensures that we actually get a functioning instance. It constrains the system such that every student MUST be allocated to a recitation section.
- `isAvailable`: This is the predicate that simulates the idea that every student must have "filled out a form" indicating their preferences for each of the TimeOptions. In order to 
try and "more accurately" simulate what outcomes from a section assignment form would actually look like, we constrained it such that each student must say Yes to at least one TimeOption,
and they must say No to at least one TimeOption. 
- `validAlloc`: This is the predicate that constrains it so students can only be assigned to sections that they have indicated they have a preference for. 
- `balancedAttendance`: This is the predicate that was created in an attempt to mitigate the integer overflow issues presented by Forge/Froglet. Rather than directly comparing the number
of students in a section to an arbitrary capacity, this predicate ensures that the all sections have enrollment within +- 1 of each other. However, because of integer bitwidth limits, 
this predicate breaks when sorting a large(ish) number of students into a smaller number of sections - in a different modeling language, it would be easily translatable and implemented.