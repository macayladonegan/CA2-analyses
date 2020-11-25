load('bins_field.mat');

fieldProp=struct2cell(fieldProp);
x_centerField=fieldProp(1);
x_centerField=cell2mat(x_centerField);
y_centerField=fieldProp(2);
y_centerField=cell2mat(y_centerField);


field_Xs=(x_centerField-(binsX/2)):(x_centerField+(binsX/2));%a vector of length binsX with center at x_centerfield
field_Ys=(y_centerField-(binsY/2)):(y_centerField+(binsY/2));
field_Xs=field_Xs';
field_Ys=field_Ys';
min_fieldXs=min(field_Xs);
max_fieldXs=max(field_Xs);
min_fieldYs=min(field_Ys);
max_fieldYs=max(field_Ys);

posx_Field=find ((posx> min_fieldXs) & (posx< max_fieldXs));
posy_Field=find ((posy> min_fieldYs) & (posy< max_fieldYs));

Field_xy=ismember(posx,posy);
Field_xy=find(Field_xy==1);
xs_infield=posx_Field(Field_xy);
Xs_infield=posx(xs_infield);
ts_infield=post(xs_infield);

spkx_infield_ismem=ismember(spkx,Xs_infield);
spkx_infield_ind=find(spkx_infield_ismem==1);
spxk_infield=spkx(spkx_infield_ind);










