x = [1 2 3 4];
histo = zeros(1,4);
for i = 1:1000
    prob = quantum_minority(pi/2,pi/4,0,pi/2,pi/4,0);
    prob = cumsum(prob);
    r = rand;
    if r<prob(1)            % (r>=0       && r<prob(1))
        reward = '00';
    elseif (r>=prob(1) && r<prob(2))
        reward = '01';
    elseif (r>=prob(2) && r<prob(3))
        reward = '10';
    else                    % elseif (r>=prob(3) && r<prob(4))
        reward = '11';
    end
    switch reward
        case '00'
            histo(1) = histo(1) + 1;
        case '01'
            histo(2) = histo(2) + 1;
        case '10'
            histo(3) = histo(3) + 1;
        case '11'
            histo(4) = histo(4) + 1;
    end
end
bar(x, histo)