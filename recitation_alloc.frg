#lang forge/bsl

sig Student {}

abstract sig Available {}
one sig Y, N extends Available {}

sig TimeOption {
    pref: pfunc Student -> Available,
    capacity: one Int
}

one sig Allocation {
    alloc: pfunc Student -> TimeOption
}

pred wellformed {
    all t: TimeOption | {
        t.capacity > 0 and t.capacity <= 7 
    }
    all s: Student | {
        some Allocation.alloc[s]
    }   
}

-- The student has selected an availability option (Y/N) for each time
pred filledOutForm {
    all t: TimeOption | {
        all s: Student | {
            some t.pref[s]
        }
    }
}

-- Every student has at least one available time
pred isAvailable {
    all s: Student | {
        some t: TimeOption | t.pref[s] = Y
    }
}

pred validAlloc {
    all s: Student | {
        all t: TimeOption {
            (Allocation.alloc[s] = t) implies (t.pref[s] = Y)
        }
    }
}

pred underCapacity {
    all t: TimeOption | {
        #{s: Student | Allocation.alloc[s] = t} <= t.capacity   
    }
}

run {
  wellformed 
  filledOutForm
  isAvailable
  validAlloc
  underCapacity
} for exactly 3 TimeOption, exactly 18 Student