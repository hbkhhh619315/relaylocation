%GUI
function GUI()

W=inputdlg({'The length of data packet','The number of data packets','The bandwidth in communication','The wavelength in communication','The distance between the nodes','The transmitted signal power of node','The transmitted signal power of relay'},'Set of input parameters',1,{'800000','100','20000000','0.125','1500','0.75','1.5'});
L=str2double(W{1});%bit
S=str2double(W{2});%
B=str2double(W{3});%Hz
namuda=str2double(W{4});%m
D=str2double(W{5});%m
Pt1=str2double(W{6});%W
Pt2=str2double(W{7});%W
N=1*10^(-10);%W


Gt=1;%Antenna gain of transmitter
Gr=1;%Antenna gain of receiver
St=0.001;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function do(~,~) %Pause button style settings
        state = get(bt,'Value');
        if state
            set(bt,'String','>>');
            uiwait(Fig)
        else
            uiresume(Fig)
            set(bt,'String','||');
        end
    end

% Creating a Window
Fig =figure("name","Drones Trajectory new", "position", [100 100 1200 750]);
%Add a pause button
bt =uicontrol(Fig,'Style','togglebutton','String','||','FontSize',10,'Units','normalized','Position',[0.92,0.3,0.05,0.05],'Callback',@do);

% Creating an Axis

subplot(2,3,1) %
axis([0 D 0 1]);
set(gca,'XTick',[0:D/10:D],'FontSize',10) %x axis range 0-D, interval ""
set(gca,'YTick',[]) %y axis range 0-1, interval 0.1
set(gca,'box','off')
set(gca,'XColor','red');% X-axis color
hold on;
% Add a title and tags
title('scenario');
xlabel('distant m');
ylabel('');

subplot(2,3,2) %
axis([0 D 0 0.2]);
hold on;
% Add a title and tags
xlabel("distant m");
ylabel("t");
title("Age");

subplot(2,3,3) %
axis([0 D 0 0.2]);
hold on;
% Add a title and tags
xlabel("distant m");
ylabel("t");
title("Age");

subplot(2,3,4) %
axis([0 0.1 0 0.1]);
hold on;
% Add a title and tags
xlabel("t");
ylabel("t");
title("Aoi");

subplot(2,3,5) %
axis([0 D 0 0.05]);
hold on;
% Add a title and tags
xlabel("distant m");
ylabel("t");
title("Aoi");

subplot(2,3,6) %
axis([0 D 0 0.05]);
hold on;
% Add a title and tags
xlabel("distant m");
ylabel("t");
title("time");

g=0;%Temporary Parameters (Count)
pc1=0;%Temporary Parameters (Count)
pc2=0;%Temporary Parameters (Count)
pc3=0;%Temporary Parameters (Count)

subplot(2,3,1)
b=plot(0,0.5,'o','color',[1 0 1], 'MarkerSize', 10 );% Draw the target node
b=plot(D,0.5,'o','color',[1 0 1], 'MarkerSize', 10 );% Draw the target node

cc=21;
i=D/cc;

x = [];
y11= [];
y12= [];
y21= [];
y22= [];

tt1=[];
tt2=[];

while i < D-1

    pause(1); % Delay for a period of time to control the drawing speed
    p1=S;
    p_1_2=0;
    p_1_2_location="";
    p2=0;
    p_2_3=i;
    p_2_3_location="";
    p3=0;

    Tr =[];%Packet arrival time
    Total=0;%integral

    if g~=0
        delete(g);
    end
    g=annotation('textbox',[0.92,0.4,0.05,0.05],'LineStyle','-','LineWidth',1,'String',i);%Text box showing the relay location

    if pc1~=0
        delete(pc1);
    end
    pc1=annotation('textbox',[0.06,0.7,0.05,0.05],'LineStyle','-','LineWidth',1,'String',p1);%The text box shows the number of packets

    if pc2~=0
        delete(pc2);
    end
    pc2=annotation('textbox',[0.2,0.6,0.05,0.05],'LineStyle','-','LineWidth',1,'String',p2);%The text box shows the number of packets
    if pc3~=0
        delete(pc3);
    end
    pc3=annotation('textbox',[0.35,0.68,0.05,0.05],'LineStyle','-','LineWidth',1,'String',p3);%The text box shows the number of packets

    subplot(2,3,1)%Positioning window
    if i ~= D/cc
        delete(b);%
    end
    b=plot(i,0.5,'o','color',[0 1 0], 'MarkerSize', 20 );% Draw relay nodes

    Y1=B*log2(1+((namuda/(4*pi*i)))^2*Gt*Gr*Pt1/N);%bit/s
    t1=L/Y1;
    tt1=[tt1;t1];
    Y2=B*log2(1+((namuda/(4*pi*(D-i))))^2*Gt*Gr*Pt2/N);%bit/s
    t2=L/Y2;
    tt2=[tt2;t2];

    dstep1=St*i/t1;% Step length 1
    dstep2=St*(D-i)/t2;% Step length 2

    T=0;

    while true
        T=T+St;
        pause(St); % Delay for a period of time to control the drawing speed

        if p1 >0
            if p_1_2 ==0
                p1=p1-1;
                subplot(2,3,1)%Positioning window
                delete(pc1)
                pc1=annotation('textbox',[0.06,0.7,0.05,0.05],'LineStyle','-','LineWidth',1,'String',p1);%The text box shows the number of packets
                p_1_2= dstep1;
                if p_1_2 >= i
                    p_1_2=0;
                    p2=p2+1;
                    subplot(2,3,1)%Positioning window
                    delete(pc2);
                    pc2=annotation('textbox',[0.2,0.6,0.05,0.05],'LineStyle','-','LineWidth',1,'String',p2);%The text box shows the number of packets
                    if p_1_2_location ~=""
                        subplot(2,3,1)%Positioning window
                        delete(p_1_2_location);
                        p_1_2_location ="";
                    end

                else
                    subplot(2,3,1)%Positioning window
                    c=plot(p_1_2,0.5,'>','color',[1 0 0], 'MarkerSize', 10 );% Plotting packet locations
                    p_1_2_location =c;
                end
            end
        end

        if (0<p_1_2) && (p_1_2 < i)
            p_1_2 = p_1_2+dstep1;
            if p_1_2 >= i
                p_1_2=0;
                p2=p2+1;
                subplot(2,3,1)%Positioning window
                delete(pc2);
                pc2=annotation('textbox',[0.2,0.6,0.05,0.05],'LineStyle','-','LineWidth',1,'String',p2);%The text box shows the number of packets
                if p_1_2_location ~=""
                    subplot(2,3,1)%Positioning window
                    delete(p_1_2_location);
                    p_1_2_location ="";
                end
            else
                if p_1_2_location ~=""
                    subplot(2,3,1)%Positioning window
                    delete(p_1_2_location);
                    c=plot(p_1_2,0.5,'>','color',[1 0 0], 'MarkerSize', 10 );% Plotting packet locations
                    p_1_2_location =c;
                end
            end
        end

        if p2 >0
            if p_2_3 ==i
                p2=p2-1;
                subplot(2,3,1)%Positioning window
                delete(pc2);
                pc2=annotation('textbox',[0.2,0.6,0.05,0.05],'LineStyle','-','LineWidth',1,'String',p2);%The text box shows the number of packets
                p_2_3= i+dstep2;
                if p_2_3 >= D
                    p_2_3=i;
                    p3=p3+1;
                    Tr = [Tr;T];

                    if length(Tr) ==1
                        subplot(2,3,4) % Positioning window
                        plot([0,0],[Tr(1),Tr(1)],'r-');% Draw Instant Aoi
                        xx=Tr(1);
                        yy=Tr(1);
                    else
                        subplot(2,3,4) % Positioning window
                        xx2=Tr(length(Tr));
                        yy2=yy+(Tr(length(Tr))-Tr(length(Tr)-1));

                        xx3=xx2;
                        yy3=yy2-t1;

                        plot([xx,xx2],[yy,yy2],'r-');% Draw Instant Aoi
                        plot([xx2,xx3],[yy2,yy3],'r-');% Draw Instant Aoi
                        xx=xx3;
                        if yy3 > yy
                            yy=yy3;
                        else
                            yy=yy;
                        end
                    end

                    subplot(2,3,1)%Positioning window
                    delete(pc3);
                    pc3=annotation('textbox',[0.35,0.68,0.05,0.05],'LineStyle','-','LineWidth',1,'String',p3);%The text box shows the number of packets
                    if p_2_3_location ~=""
                        subplot(2,3,1)%Positioning window
                        delete(p_2_3_location);
                        p_2_3_location ="";
                    end
                    if p3 ==S
                        break;
                    end
                else
                    subplot(2,3,1)%Positioning window
                    c=plot(p_2_3,0.5,'>','color',[1 0 0], 'MarkerSize', 10 );% Plotting packet locations
                    p_2_3_location =c;
                end
            end
        end

        if (i<p_2_3) && (p_2_3< D)
            p_2_3 = p_2_3+dstep2;
            if p_2_3 >= D
                p_2_3=i;
                p3=p3+1;
                Tr = [Tr;T];

                if length(Tr) ==1
                    subplot(2,3,4) % Positioning window
                    plot([0,Tr(1)],[0,Tr(1)],'r-');% Draw Instant Aoi
                    xx=Tr(1);
                    yy=Tr(1);
                else
                    subplot(2,3,4) % Positioning window

                    xx2=Tr(length(Tr));
                    yy2=yy+(Tr(length(Tr))-Tr(length(Tr)-1));

                    xx3=xx2;
                    yy3=yy2-t1;

                    plot([xx,xx2],[yy,yy2],'r-');% Draw Instant Aoi
                    plot([xx2,xx3],[yy2,yy3],'r-');% Draw Instant Aoi
                    xx=xx3;
                    if yy3 > yy
                        yy=yy3;
                    else
                        yy=yy;
                    end

                end

                subplot(2,3,1)%Positioning window
                delete(pc3);
                pc3=annotation('textbox',[0.35,0.68,0.05,0.05],'LineStyle','-','LineWidth',1,'String',p3);%The text box shows the number of packets
                if p_2_3_location ~=""
                    subplot(2,3,1)%Positioning window
                    delete(p_2_3_location);
                    p_2_3_location ="";
                end
                if p3 ==S
                    break;
                end
            else
                if p_2_3_location ~=""
                    subplot(2,3,1)%Positioning window
                    delete(p_2_3_location);
                    c=plot(p_2_3,0.5,'>','color',[1 0 0], 'MarkerSize', 10 );% Plotting packet locations
                    p_2_3_location =c;
                end

            end
        end
    end

    kk =2;
    while kk < S
        if kk==2
            x1=Tr(kk);
            y1=Tr(kk)-t1;
        end

        x2=Tr(kk+1);
        y2=y1+(Tr(kk+1)-Tr(kk));

        fun = @(z) ((y2-y1)/(x2-x1))*(z-x1)+y1;
        q = integral(fun,x1,x2);
        %         q=(y1+y2)*(x2-x1)/2;

        Total=Total + q;

        x1=x2;
        new_y=y2-t1;
        if new_y < y1
            y1=y1;
        else
            y1=new_y;
        end

        kk=kk+1;
    end

    if i== D/cc
        A=Tr;
    end


    subplot(2,3,2) % Positioning window

    if t1>t2
        plot(i,t1,'-om','linewidth',2,'MarkerSize',10);% Time consuming to draw theoretical age

        plot(i,T/S,'-dg','linewidth',2,'MarkerSize',5);% Time spent drawing actual age
    else
        plot(i,t2,'-om','linewidth',2,'MarkerSize',10);% Time consuming to draw theoretical age

        plot(i,T/S,'-dg','linewidth',2,'MarkerSize',5);% Time spent drawing actual age
    end

    if t1>t2
        x=[x;i];
        y11=[y11;t1];
        y12=[y12;T/S];
        y21=[y21;(3/2)*t1+t2];
        y22=[y22;(Total+((Tr(2))^2)/2)/T];
    else
        x=[x;i];
        y11=[y11;t2];
        y12=[y12;T/S];
        y21=[y21;(5/2)*t2+(S/2)*(t2-t1)];
        y22=[y22;(Total+((Tr(2))^2)/2)/T];
    end

    i=i+D/cc;
end

subplot(2,3,3) % 定位窗口
plot(x,y11,'-om','linewidth',2,'MarkerSize',10);% linear, color, marker, Time consuming to draw theoretical age

plot(x,y12,'-dg','linewidth',2,'MarkerSize',5);% linear, color, marker, Plotting the experimental age

subplot(2,3,5) % 定位窗口
plot(x,y21,'-om','linewidth',2,'MarkerSize',10);% linear, color, marker, Plotting the theoretical average AoI

plot(x,y22,'-dg','linewidth',2,'MarkerSize',5);% linear, color, marker, Plotting the average AoI of the experiment

subplot(2,3,6) %
plot(x,tt1,'-sc',x,tt2,'-db','linewidth',4,'MarkerSize',8); % linear, color, marker

figure(2)
axis([0 1500 0 2.5]);
set(gca,'XTick',[0:100:1500],'FontSize',25) %x axis range 0-1, interval 0.2
set(gca,'YTick',[0:0.5:2.5],'FontSize',25) %y axis range 0-1, interval 0.1
axis square;
hold on;
% Add title and tags
%title('PoA');
xlabel("distant d (m)",'FontSize',35);
ylabel('t (s)','FontSize',35);

plot(x,y11,'--db',x,y12,'--sc',x,y21,'--hg',x,y22,'--om','linewidth',2,'MarkerSize',8); % linear, color, marker
legend('Network Delay (Theory)','Network Delay (Simulation)','AoI (Theory)','AoI (Simulation)','FontSize',20);   % Upper right corner mark
grid on

save data x y11 y12 y21 y22 Tr A tt1 tt2


end
