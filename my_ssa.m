function [ppgy, r, vr] = my_ssa(ppgx, acc3, L)

    close all;
    x1 = ppgx;


% Step1 : Build trayectory matrix

    N = length(x1); 
    if L > N/2
        L = N-L;
    end
    K = N - L + 1; 
    X = zeros(L, K);  
	for i = 1:K
        X(1:L,i) = x1(i:L + i - 1); 
	end
    
% Step 2: SVD

    S = X*X';
    [U,autoval] = eig(S);
	[d,i] = sort(-diag(autoval));  
    d = -d;
    U = U(:,i);
    sev = sum(d); 
    
    d = d(1:100);
    dll = log2(d);
    %plot(dll), hold on, plot(dll, 'rx');grid on;hold off;
	%plot((d./sev)*100),hold on,plot((d./sev)*100,'rx'),hold on;
    
% remove too small components
    thres = 0.01 * sev;
    d = d(d > thres);
    %plot((d./sev) * 100, 'gx');
	%title('Singular Spectrum');xlabel('Eigenvalue Number');ylabel('Eigenvalue (% Norm of trajectory matrix retained)')
    
    V = (X')*U; 
    rc = U*V';
    

    
    
% Step 3: Grouping

    %I = input('Choose the agrupation of components to reconstruct the series in the form I = [i1,i2:ik,...,iL]  ')
    Ilist = 1:size(d, 1);
    ppgy = zeros(1, size(ppgx, 2));
    for I = Ilist
        Vt = V';
        rca = U(:,I)*Vt(I,:);

    % Step 4: Reconstruction

        y = zeros(1,N);  
        Lp = min(L,K);
        Kp = max(L,K);

        for k = 0:Lp-2
            for m = 1:k+1;
                y(k+1) = y(k+1)+(1/(k+1))*rca(m,k-m+2);
            end
        end

        for k = Lp-1:Kp-1
            for m = 1:Lp;
                y(k+1) = y(k+1)+(1/(Lp))*rca(m,k-m+2);
            end
        end

        for k = Kp:N
            for m = k-Kp+2:N-Kp+1;
                y(k+1) = y(k+1)+(1/(N-k))*rca(m,k-m+2);
            end
        end

        %figure;subplot(2,1,1);hold on;xlabel('Data poit');ylabel('Original and reconstructed series')
        %plot(x1);grid on;plot(y,'r')
        %plot(y);

        r = x1-y;
        %subplot(2,1,2);plot(r,'g');xlabel('Data poit');ylabel('Residual series');grid on
        %vr = (sum(d(I))/sev)*100;
        vr = [];
        
        %fprintf('%d', I(1));
        if acc_dominant(y, acc3) == 1
            %fprintf(': acc_dominant\n');
            continue; 
        end
        %fprintf(': not\n');
        %plot(ppgy);
        ppgy = ppgy + y;
    end
    y = ppgy;
    %figure;subplot(2,1,1);hold on;xlabel('Data poit');ylabel('Original and reconstructed series')
    %plot(x1);grid on;plot(y,'r')
    %subplot(2,1,2);plot(r,'g');xlabel('Data poit');ylabel('Residual series');grid on
    
end

function bool = acc_dominant(ppg, acc3)
    ppgf = abs(fft(ppg, [], 2));
    ppgf([1:2, end/2:end]) = 0;
    domif = get_peaks(ppgf, 1, 1);
    bool = 0;
    for i = 1:3
        %accf = abs(fft(acc3(i, :), [], 2));
        %accf([1:2, end/2:end]) = 0;
        len = size(acc3, 2);
        accf = periodogram(acc3(i,:), rectwin(len), len, 125);
        freqs = get_peaks(accf, 5, 0.6);
        %freqs = [freqs-1, freqs, freqs+1];
        if ismember(domif, freqs)
            figure; subplot(2,1,1);plot(ppgf(1:100));
            subplot(2,1,2); plot(accf(1:100));
            bool = 1;
            close;
            break;
        end
    end
end


