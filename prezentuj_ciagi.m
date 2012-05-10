function [] = prezentuj_ciagi(u1,y1,u2,y2)
    f1 = figure(3);
    subplot(211)
    plot(u1);
    title('Ciag uczacy - wejscie systemu');
    xlabel('t');
    ylabel('u(t)');
    subplot(212)
    plot(y1);
    title('Ciag uczacy - wyjscie systemu');
    xlabel('t');
    ylabel('y(t)');

    print(f1, '-dpng', 'nlin_uczacy');

    f2 = figure(4);
    subplot(211)
    plot(u2);
    title('Ciag walidacyjny - wejscie systemu');
    xlabel('t');
    ylabel('u(t)');
    subplot(212)
    plot(y2);
    title('Ciag walidacyjny - wyjscie systemu');
    xlabel('t');
    ylabel('y(t)');

    print(f2, '-dpng', 'nlin_walid');
end