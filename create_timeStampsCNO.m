%z=hab_start
z=2;
ImportEvents
%You must subtract Events_TimeStamps(1) to make it match up with post
%sleep1
a=Events_TimeStamps(z)-Events_TimeStamps(1);
b=Events_TimeStamps(z+1)-Events_TimeStamps(1);

%OF1
c=Events_TimeStamps(z+2)-Events_TimeStamps(1);
d=Events_TimeStamps(z+3)-Events_TimeStamps(1);

%sleep2
e=Events_TimeStamps(z+4)-Events_TimeStamps(1);
f=Events_TimeStamps(z+5)-Events_TimeStamps(1);

%OF2
g=Events_TimeStamps(z+6)-Events_TimeStamps(1);
h=Events_TimeStamps(z+7)-Events_TimeStamps(1);

timeStamps={a b c d e f g h};