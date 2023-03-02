#lang forge/bsl

open "recitation_alloc.frg"

test suite for wellformed {
    --student 2 has no assigned section
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

    example noAssignment is not wellformed for {
        Student = `S0 + `S1 + `S2
        Y = `Y
        N = `N
        Available = Y + N
        TimeOption = `T0 + `T1
        Allocation = `Allocation
        alloc = Allocation -> `S0 -> `T0 +
                Allocation -> `S1 -> `T1
    }   
}

test suite for isAvailable {
    example allYes is not isAvailable for {
        Student = `S0 + `S1 + `S2
        Y = `Y
        N = `N
        Available = Y + N
        TimeOption = `T0 + `T1
        pref = `T0 -> `S0 -> Y +
                `T0 -> `S1 -> Y +
                `T0 -> `S2 -> N +
                `T1 -> `S0 -> N +
                `T1 -> `S1 -> Y +
                `T1 -> `S2 -> Y
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
    }

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
    }
}