from tools.fsm_reference import State, transition, outputs


def walk(*moves):
    current = State.START
    for move in moves:
        current = transition(current, **move)
    return current


def test_win_with_sword():
    assert walk({"north": True}, {"north": True},
                {"east": True, "sword": True}) == State.WIN


def test_lose_without_sword():
    assert walk({"north": True}, {"north": True},
                {"east": True}) == State.LOSE


def test_armory_round_trip():
    assert walk({"north": True}, {"east": True},
                {"west": True}, {"south": True}) == State.START


def test_multiple_buttons_are_ignored():
    assert transition(State.START, north=True, east=True) == State.START


def test_unsupported_direction_is_ignored():
    assert transition(State.START, west=True) == State.START


def test_terminal_state_sticks():
    assert transition(State.WIN, south=True) == State.WIN
    assert transition(State.LOSE, north=True) == State.LOSE


def test_outputs():
    assert outputs(State.WIN) == {"room": 4, "win": True, "lose": False}
    assert outputs(State.LOSE) == {"room": 5, "win": False, "lose": True}
