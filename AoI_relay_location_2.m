%GUI
function GUI()

W=inputdlg({'The length of data packet','The number of data packets','The bandwidth in communication','The wavelength in communication','The distance between the nodes','The transmitted signal power of relay'},'Set of input parameters',1,{'800000','100','20000000','0.125','1500','1.5'});
%'The transmitted signal power of node',
L=str2double(W{1});%bit
S=str2double(W{2});%
B=str2double(W{3});%Hz
namuda=str2double(W{4});%m
D=str2double(W{5});%m
Pt2=str2double(W{6});%W
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
Fig =figure("name","AoI Relay", "position", [100 100 1200 750]);
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
xlabel('distance m');
ylabel('');

subplot(2,3,2) %
axis([0 Pt2 0 0.2]);
hold on;
% Add a title and tags
xlabel("The transmitted signal power of node");
ylabel("t");
title("Age");

subplot(2,3,3) %
axis([0 Pt2 0 0.2]);
hold on;
% Add a title and tags
xlabel("The transmitted signal power of node");
ylabel("t");
title("Age");

subplot(2,3,4) %
axis([0 0.1 0 0.1]);
hold on;
% Add a title and tags
xlabel("t");
ylabel("");
title("Aoi");

subplot(2,3,5) %
axis([0 Pt2 0 0.05]);
hold on;
% Add a title and tags
xlabel("The transmitted signal power of node");
ylabel("");
title("Aoi");

g=0;%Temporary Parameters (Count)
pc1=0;%Temporary Parameters (Count)
pc2=0;%Temporary Parameters (Count)
pc3=0;%Temporary Parameters (Count)

subplot(2,3,1)
b=plot(0,0.5,'o','color',[1 0 1], 'MarkerSize', 10 );% Draw the target node
b=plot(D,0.5,'o','color',[1 0 1], 'MarkerSize', 10 );% Draw the target node


x = [];
y11= [];
y12= [];
y13= [];
y14= [];
y21= [];
y22= [];
y23= [];
y24= [];


j=Pt2/10;

while j<=7*Pt2/10

    x=[x;j];
    choose=D/((Pt2/j)^(1/2)+1);
    D2=D/2;
    D3=D-100;
    ll=[D/5;choose;D2;D-D/5];
    i=1;

    while i <= length(ll)

        d=ll(i);

        pause(1); % Delay for a period of time to control the drawing speed
        p1=S;
        p_1_2=0;
        p_1_2_location="";
        p2=0;
        p_2_3=d;
        p_2_3_location="";
        p3=0;

        Tr =[];%Packet arrival time
        Total=0;%integral

        if g~=0
            delete(g);
        end
        g=annotation('textbox',[0.92,0.4,0.05,0.05],'LineStyle','-','LineWidth',1,'String',d);%Text box showing the relay location

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

        w=plot(d,0.5,'o','color',[0 1 0], 'MarkerSize', 20 );% Draw relay nodes

        Y1=B*log2(1+((namuda/(4*pi*d)))^2*Gt*Gr*j/N);%bit/s
        t1=L/Y1;
        Y2=B*log2(1+((namuda/(4*pi*(D-d))))^2*Gt*Gr*Pt2/N);%bit/s
        t2=L/Y2;

        dstep1=St*d/t1;% Step length 1
        dstep2=St*(D-d)/t2;% Step length 2

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
                    if p_1_2 >= d
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

            if (0<p_1_2) && (p_1_2 < d)
                p_1_2 = p_1_2+dstep1;
                if p_1_2 >= d
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
                if p_2_3 ==d
                    p2=p2-1;
                    subplot(2,3,1)%Positioning window
                    delete(pc2);
                    pc2=annotation('textbox',[0.2,0.6,0.05,0.05],'LineStyle','-','LineWidth',1,'String',p2);%The text box shows the number of packets
                    p_2_3= d+dstep2;
                    if p_2_3 >= D
                        p_2_3=d;
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
                            subplot(2,3,1)%Positioning window
                            delete(w);
                            break;
                        end
                    else
                        subplot(2,3,1)%Positioning window
                        c=plot(p_2_3,0.5,'>','color',[1 0 0], 'MarkerSize', 10 );% Plotting packet locations
                        p_2_3_location =c;
                    end
                end
            end

            if (d<p_2_3) && (p_2_3< D)
                p_2_3 = p_2_3+dstep2;
                if p_2_3 >= D
                    p_2_3=d;
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
                        subplot(2,3,1)%Positioning window
                        delete(w);
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


        subplot(2,3,2) % Positioning window

        plot(j,T/S,'-dg','linewidth',2,'MarkerSize',5);% Time spent drawing actual age


        if i==1
            y11=[y11;T/S];
            y21=[y21;(Total+((Tr(2))^2)/2)/T];
        end
        if i==2
            y12=[y12;T/S];
            y22=[y22;(Total+((Tr(2))^2)/2)/T];
        end

        if i==3
            y13=[y13;T/S];
            y23=[y23;(Total+((Tr(2))^2)/2)/T];
        end

        if i==4
            y14=[y14;T/S];
            y24=[y24;(Total+((Tr(2))^2)/2)/T];
        end

        i=i+1;
    end
    j=j+Pt2/10;

end

subplot(2,3,3) % Positioning window
plot(x,y11,'-om','linewidth',2,'MarkerSize',10);% linear, color, marker, Plotting the experimental age

plot(x,y12,'-dg','linewidth',2,'MarkerSize',10);% linear, color, marker, Plotting the experimental age

plot(x,y13,'-or','linewidth',2,'MarkerSize',10);% linear, color, marker, Plotting the experimental age

plot(x,y14,'-db','linewidth',2,'MarkerSize',10);% linear, color, marker, Plotting the experimental age

subplot(2,3,5) % Positioning window
plot(x,y21,'-om','linewidth',2,'MarkerSize',10);% linear, color, marker, Plotting the average AoI of the experiment

plot(x,y22,'-dg','linewidth',2,'MarkerSize',10);% linear, color, marker, Plotting the average AoI of the experiment

plot(x,y23,'-or','linewidth',2,'MarkerSize',10);% linear, color, marker, Plotting the average AoI of the experiment

plot(x,y24,'-db','linewidth',2,'MarkerSize',10);% linear, color, marker, Plotting the average AoI of the experiment

figure(2)
axis([0 1.1 0 1.5]);
set(gca,'XTick',[0:0.1:1.1],'FontSize',25) %x axis range 0-1, interval 0.2
set(gca,'YTick',[0:0.2:1.5],'FontSize',25) %y axis range 0-1, interval 0.1
axis square;
hold on;
% Add title and tags
%title('PoA');
% xlabel("length l (m)",'FontSize',35,'FontWeight','bold','FontName','Times New Roman','Color','b');
xlabel("The transmitted signal power of node {\it{P_{node}}}",'FontSize',35,'FontName','Times New Roman');
ylabel('AoI','FontSize',35,'FontName','Times New Roman');

plot(x,y21,'--om',x,y22,'--dg',x,y23,'--or',x,y24,'--db','linewidth',2,'MarkerSize',8); % linear, color, marker
legend('d/5','{\it{t_1=t_2}}','d/2','4d/5','FontSize',20,'FontName','Times New Roman');   % Upper right corner mark
grid on


save data2 x y11 y12 y13 y14 y21 y22 y23 y24 dstep1 dstep2 choose D2


end
