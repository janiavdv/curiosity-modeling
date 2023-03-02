#lang forge/bsl

open "recitation_alloc.frg"

test suite for wellformed {
    //everyone assigned to a section is wellformed
    example everyoneAssigned is wellformed for {
        Student = `S0 + `S1 + `S2
        Y = `Y
        N = `N
        Available = Y + N
        TimeOption = `T0 + `T1
        Allocation = `Allocation
        alloc = Allocation -> `S0 -> `T0 +
                Allocation -> `S1 -> `T1 +
                Allocation -> `S2 -> `T1
    } 
    //an instance where one student does not receive an assignment is not wellformed
    example noAssignment is not wellformed for {
        Student = `S0 + `S1 + `S2
        Y = `Y
        N = `N
        Available = Y + N
        TimeOption = `T0 + `T1
        Allocation = `Allocation
        alloc = Allocation -> `S0 -> `T0 +
                Allocation -> `S1 -> `T1
                // `S2 has no recitation assignmnet -> not wellformed
    }   
}

test suite for isAvailable {
    //each student having at least one section they are avaliable for and
    //one section they are not, while indicating a preference for every section
    //is a good instance.
    example yesNo is isAvailable for {
        Student = `S0 + `S1 + `S2
        Y = `Y
        N = `N
        Available = Y + N
        TimeOption = `T0 + `T1
        pref =  `T0 -> `S0 -> Y +
                `T0 -> `S1 -> Y +
                `T0 -> `S2 -> N +
                `T1 -> `S0 -> N +
                `T1 -> `S1 -> N +
                `T1 -> `S2 -> Y
    }
    //an example where a student did not indicate that they were available for any 
    //section is a bad instance
    example allNo is not isAvailable for {
        Student = `S0 + `S1 + `S2
        Y = `Y
        N = `N
        Available = Y + N
        TimeOption = `T0 + `T1
        pref =  `T0 -> `S0 -> N +
                `T0 -> `S1 -> N +
                `T0 -> `S2 -> N +
                `T1 -> `S0 -> N +
                `T1 -> `S1 -> N +
                `T1 -> `S2 -> N
    }
    //an example where a student indicated that they were available for every section
    //section is a bad instance
    example allYes is not isAvailable for {
        Student = `S0 + `S1 + `S2
        Y = `Y
        N = `N
        Available = Y + N
        TimeOption = `T0 + `T1
        pref =  `T0 -> `S0 -> Y +
                `T0 -> `S1 -> Y +
                `T0 -> `S2 -> N +
                `T1 -> `S0 -> N +
                `T1 -> `S1 -> Y +
                `T1 -> `S2 -> Y
    }
    //an example where a student has not indicated a preference for a single section
    //is a bad instance
    example noPrefs is not isAvailable for {
        Student = `S0 + `S1 + `S2
        Y = `Y
        N = `N
        Available = Y + N
        TimeOption = `T0 + `T1
        pref =  `T0 -> `S0 -> Y +
                `T0 -> `S1 -> Y +
                `T0 -> `S2 -> N 
                // no one has indicated whether they're available for `T1 :(
    }
    //an example where one student did not indicate a preference for ANY sections
    //is a bad instance
    example formEmpty is not isAvailable for {
        Student = `S0 + `S1 + `S2
        Y = `Y
        N = `N
        Available = Y + N
        TimeOption = `T0 + `T1
        pref =  `T0 -> `S0 -> Y +
                `T0 -> `S1 -> Y +
                `T1 -> `S0 -> N +
                `T1 -> `S1 -> Y 
                // `S2 hasn't indicated their preferences :(
    }
}

test suite for validAlloc {
    example isValid is validAlloc for {
        // Everyone was allocated to a time they were available for
        Student = `S0 + `S1 + `S2
        Y = `Y
        N = `N
        Available = Y + N
        TimeOption = `T0 + `T1
        pref =  `T0 -> `S0 -> Y +
                `T0 -> `S1 -> Y +
                `T0 -> `S2 -> N +
                `T1 -> `S0 -> N +
                `T1 -> `S1 -> N +
                `T1 -> `S2 -> Y
        Allocation = `Allocation
        alloc = Allocation -> `S0 -> `T0 +
                Allocation -> `S1 -> `T0 +
                Allocation -> `S2 -> `T1
    }

    example notAvailable is not validAlloc for {
        // One student is allocated to a section they were not available for
        Student = `S0 + `S1 + `S2
        Y = `Y
        N = `N
        Available = Y + N
        TimeOption = `T0 + `T1
        pref =  `T0 -> `S0 -> Y +
                `T0 -> `S1 -> N +
                `T0 -> `S2 -> N +
                `T1 -> `S0 -> N +
                `T1 -> `S1 -> Y +
                `T1 -> `S2 -> Y
        Allocation = `Allocation
        alloc = Allocation -> `S0 -> `T0 +
                Allocation -> `S1 -> `T0 + // `S1 wasn't available for `T0
                Allocation -> `S2 -> `T1
    }
}

test suite for balancedAttendance {
    example equalAttendance is balancedAttendance for {
        Student = `S0 + `S1 + `S2 + `S3 + `S4 + `S5
        Y = `Y
        N = `N
        Available = Y + N
        TimeOption = `T0 + `T1
        Allocation = `Allocation
        alloc = Allocation -> `S0 -> `T0 +
                Allocation -> `S1 -> `T0 +
                Allocation -> `S2 -> `T0 +
                Allocation -> `S3 -> `T1 +
                Allocation -> `S4 -> `T1 +
                Allocation -> `S5 -> `T1
    }

    example offByTwo is balancedAttendance for {
        Student = `S0 + `S1 + `S2 + `S3 + `S4 + `S5
        Y = `Y
        N = `N
        Available = Y + N
        TimeOption = `T0 + `T1
        Allocation = `Allocation
        alloc = Allocation -> `S0 -> `T0 +
                Allocation -> `S1 -> `T0 +
                Allocation -> `S2 -> `T1 +
                Allocation -> `S3 -> `T1 +
                Allocation -> `S4 -> `T1 +
                Allocation -> `S5 -> `T1 
                // `T0 has 2 less students than `T1
    }

    example offByThree is not balancedAttendance for {
        Student = `S0 + `S1 + `S2 + `S3 + `S4 + `S5 + `S6
        Y = `Y
        N = `N
        Available = Y + N
        TimeOption = `T0 + `T1
        Allocation = `Allocation
        alloc = Allocation -> `S0 -> `T0 +
                Allocation -> `S1 -> `T0 +
                Allocation -> `S2 -> `T1 +
                Allocation -> `S3 -> `T1 +
                Allocation -> `S4 -> `T1 +
                Allocation -> `S5 -> `T1 +
                Allocation -> `S6 -> `T1
                // `T1 has 3 more students than `T0, which violates the predicate
    }
    //An example with two valid sections and one without any students assigned
    //violates the predicate.
    example oneEmpty is not balancedAttendance for {
        Student = `S0 + `S1 + `S2 + `S3 + `S4 + `S5 + `S6
        Y = `Y
        N = `N
        Available = Y + N
        TimeOption = `T0 + `T1 + `T2
        Allocation = `Allocation
        alloc = Allocation -> `S0 -> `T0 +
                Allocation -> `S1 -> `T0 +
                Allocation -> `S2 -> `T0 +
                Allocation -> `S3 -> `T1 +
                Allocation -> `S4 -> `T1 +
                Allocation -> `S5 -> `T1 +
                Allocation -> `S6 -> `T1
                // `T2 doesn't have any students :(
    }
}