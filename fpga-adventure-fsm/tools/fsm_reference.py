"""Reference model for the synthesizable adventure FSM."""
from enum import IntEnum

class State(IntEnum):
    START = 0
    HALL = 1
    ARMORY = 2
    DRAGON = 3
    WIN = 4
    LOSE = 5


def transition(state: State, *, north=False, east=False, south=False,
               west=False, sword=False) -> State:
    """One clock-step transition; ignore zero or multiple directions."""
    if sum((bool(north), bool(east), bool(south), bool(west))) != 1:
        return state
    if state == State.START and north:
        return State.HALL
    if state == State.HALL:
        if east:
            return State.ARMORY
        if north:
            return State.DRAGON
        if south:
            return State.START
    if state == State.ARMORY and west:
        return State.HALL
    if state == State.DRAGON:
        if east:
            return State.WIN if sword else State.LOSE
        if south:
            return State.HALL
    return state


def outputs(state: State) -> dict:
    return {"room": int(state), "win": state == State.WIN,
            "lose": state == State.LOSE}
