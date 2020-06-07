n=10;
x=randint(1,n);
figure(1)
subplot(411)
stairs(0:n,[x(1:n) x(n)],'linewidth',1.5);
title('Binary information at Transmitter');grid on

f1=3;
t=0:1/(f1*n):1-1/(f1*n);
sa1=sin(2*pi*f1*t);
E1=sum(sa1.^2);
sa1=sa1/sqrt(E1);
sa0=0*sin(2*pi*f1*t);
ask=[];
for i=1:n
if x(i)==1
ask=[ask sa1];
else
ask=[ask sa0];
end
end
figure(1)
subplot(412)
tb=0:1/(f1*n):n-1/(f1*n);
plot(tb, ask(1:n*n*f1),'b','linewidth',1.5)
title('ASK Modulation');

A=[];

SNR_dB=0:100;
SNR=10.^(SNR_dB/10);

snr=randi(20);
askn=awgn(ask,snr);

figure(1)
subplot(413)
tb=0:1/(f1*n):n-1/(f1*n);
plot(tb, askn(1:n*n*f1),'b','linewidth',1.5)
title('Received signal after AWGN Channel');

for i=1:n
if sum(sa1.*askn(1+f1*n*(i-1):f1*n*i))>0.5
A=[A 1];
else
A=[A 0];
end
end

figure(1)
subplot(414)
tb=0:1/(f1*n):n-1/(f1*n);
stairs(0:n,[A(1:n) A(n)],'linewidth',1.5);
title('Received information as digital signal after binary ASK demodulation');

for snr=0:20
askn=awgn(ask,snr);

%DETECTION
A=[];
for i=1:n
%ASK Detection
if sum(sa1.*askn(1+f1*n*(i-1):f1*n*i))>0.5
A=[A 1];
else
A=[A 0];
end
end
%BER
errA=0;errF=0; errP=0;
for i=1:n
if A(i)==x(i)
errA=errA;
else
errA=errA+1;
end

end
BER_A(snr+1)=errA/n;
end
figure(2)
semilogy(0:20,BER_A, 'o','linewidth',2)
grid on,
hold on,
snr=0:20;
SNR=10.^(snr/10);
BER_th=(1/2)*erfc(.5*sqrt(SNR));
semilogy(0:20,BER_th,'r','linewidth',2.5),grid on,
title('BER Vs SNR')
grid on;
