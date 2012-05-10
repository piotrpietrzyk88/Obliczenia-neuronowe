function y = obliczanie_wyjsc(u,model)
    x = zeros(1,length(u));
    x1 = zeros(1,length(u));
    x2 = zeros(1,length(u));
    y = zeros(1,length(u));
    x1(1) = 0;
    x2(1) = u(1);

    if model == 0
        for k = 1:length(u)
            x1(k+1) = 0.5*x2(k) + 0.2*x1(k)*x2(k);
            x2(k+1) = -0.3*x1(k) + 0.8*x2(k) + u(k);
            y(k) = x1(k) + (x2(k))^2;
        end
    elseif model == 1
        for k = 1:length(u)
            x(k+1) = x(k) + u(k);
            y(k) = (x(k))^2;
        end   
    end
end

% function y = obliczanie_wyjsc(u,model)
%     x1 = zeros(1,length(u));
%     x2 = zeros(1,length(u));
%     y = zeros(1,length(u));
%     x1(1) = 0;
%     x2(1) = u(1);
% 
%     for k = 1:length(u)
%         x1(k+1) = 0.5*x2(k) + 0.2*x1(k)*x2(k);
%         x2(k+1) = -0.3*x1(k) + 0.8*x2(k) + u(k);
%         y(k) = x1(k) + (x2(k))^2;
%     end
% end