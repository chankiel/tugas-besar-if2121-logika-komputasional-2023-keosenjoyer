prob_count(N, M, P) :-
    N > 0,
    M > 0,
    Sides = 6, % Assuming six-sided dice, you can change this value as needed

    % Calculate all possible outcomes for each player
    findall(SumA, roll_dice(N, Sides, SumA), OutcomesA),
    findall(SumB, roll_dice(M, Sides, SumB), OutcomesB),

    % Count the number of winning outcomes for Player A
    count_winning_outcomes(OutcomesA, OutcomesB, Wins),

    % Calculate the probability of winning for Player A
    length(OutcomesA, TotalOutcomesA),
    P is Wins / TotalOutcomesA.
    write(P).