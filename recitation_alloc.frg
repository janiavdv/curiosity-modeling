#lang forge/bsl

sig Student {}

abstract sig Available {}
one sig Y, N extends Available {}

sig TimeOption {
    pref: pfunc Student -> Available
}

one sig Allocation {
    alloc: pfunc Student -> TimeOption
}

-- A wellformed instance is one where every student gets assigned to some section
pred wellformed {
    all s: Student | {
        some Allocation.alloc[s]
    }   
}

-- Every student has at least one available time and one not avaliable time 
-- They also have a preference for every time.
pred isAvailable {
    all s: Student | {
        all t: TimeOption | some t.pref[s]
        some disj t1, t2: TimeOption | t1.pref[s] = Y and t2.pref[s] = N
    }
}

-- Every student is allocated to a section that they marked as having a preference for
pred validAlloc {
    all s: Student | {
        all t: TimeOption {
            (Allocation.alloc[s] = t) implies (t.pref[s] = Y)
        }
    }
}

-- Each section has at least 1 student, and two sections cannot differ by more than 2 students in size.
pred balancedAttendance {
    all t: TimeOption | {
        some s: Student | Allocation.alloc[s] = t
    }
    all disj t1, t2: TimeOption | {
        subtract[#{s: Student | Allocation.alloc[s] = t1}, #{s: Student | Allocation.alloc[s] = t2}] <= 2
    }
}

run {
    wellformed
    isAvailable
    validAlloc
    balancedAttendance
} for exactly 3 TimeOption, exactly 15 Student