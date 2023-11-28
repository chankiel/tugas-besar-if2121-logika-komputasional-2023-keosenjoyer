prob_count(N, M, P) :-
    Sides = 6,
    count_winning_outcomes(OutcomesYou, OutcomesEnemy, Wins),
    length(OutcomesYou, TotalOutcomes),
    (TotalOutcomes > 0 -> P is Wins / TotalOutcomes ; P is 0).

roll_dice_v2(0, _, 0).
roll_dice_v2(N, Sides, Sum) :-
    Sides_plus_one is Sides + 1,
    random(1, Sides_plus_one, Outcome),
    N_minus_1 is N - 1,
    roll_dice_v2(N_minus_1, Sides, SumRest),
    Sum is Outcome + SumRest.

count_winning_outcomes([], _, 0).
count_winning_outcomes([SumYou | RestYou], OutcomesEnemy, Wins) :-
    count_greater_than_sum(SumYou, OutcomesEnemy, WinsRest),
    count_winning_outcomes(RestYou, OutcomesEnemy, RestWins),
    Wins is WinsRest + RestWins.

count_greater_than_sum(_, [], 0).
count_greater_than_sum(Sum, [Y | Rest], Wins) :-
    Sum > Y,
    count_greater_than_sum(Sum, Rest, RestWins),
    Wins is 1 + RestWins.
count_greater_than_sum(Sum, [Y | Rest], Wins) :-
    Sum =< Y,
    count_greater_than_sum(Sum, Rest, Wins).

generate_all_outcomes(N, Outcomes) :-
    findall(Result, roll_dice_n_times(N, Result), Outcomes).

rll_dc(Sides, Result) :-
    Sides_p1 is Sides + 1,
    random(1, Sides, Result).

roll_dice_n_times(0, []).
roll_dice_n_times(N, [Outcome | Rest]) :-
    rll_dc(6, Outcome),
    N_minus_1 is N - 1,
    roll_dice_n_times(N_minus_1, Rest).

% Predicate to generate all possible sums
insert_in(N, Sums) :-
    findall(Sum, generate_sums(N, Sum), Sums).

% Helper predicate to generate the sum of pairs recursively
generate_sums(0, 0).
generate_sums(N, Sum) :-
    N > 0,
    between(1, 6, Number),
    N_minus_1 is N - 1,
    generate_sums(N_minus_1, RestSum),
    Sum is Number + RestSum.

compare(N, M, Res) :-
    integer(N),
    integer(M),
    insert_in(N, ListA),
    insert_in(M, ListB),
    length(ListA, LenA),
    length(ListB, LenB),
    total_wins(ListA, ListB, Wins),
    Res is Wins / (LenA * LenB) * 100.

% Count the number of elements in ListA that are greater than elements in ListB
total_wins([], _, 0).
total_wins([A | RestA], ListB, Wins) :-
    count_greater_than(A, ListB, WinsRest),
    total_wins(RestA, ListB, RestWins),
    Wins is WinsRest + RestWins.

% Count the number of elements greater than X in a list
count_greater_than(_, [], 0).
count_greater_than(X, [Y | Rest], Count) :-
    X > Y,
    count_greater_than(X, Rest, Count).
count_greater_than(X, [Y | Rest], Count) :-
    X =< Y,
    count_greater_than(X, Rest, RestCount),
    Count is 1 + RestCount.



