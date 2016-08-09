clear all
clc
data=[];
qq=[];
y_files = dir('*.txt');
N_files = numel( y_files );
for i=1:N_files
    file2read = y_files(i).name;
fid=fopen(file2read);
val = fscanf(fid,'%d');
fclose(fid);
minval=min(val);
maxval=max(val);
stdval=std(val);
varval=var(val);
medianval=median(val);
skewnessval=skewness(val);
harmmeanval=harmmean((val));
kurtosisval=kurtosis(val);
unqx = unique(val);
valueCount = histc(val, unqx);
frstfreq=unqx(valueCount==max(valueCount));
q=max(valueCount(valueCount~=max(valueCount)));
scndtfreq=unqx(valueCount==q);
fsize=length(frstfreq);
ssize=length(scndtfreq);
if (ssize==0)
    scndtfreq=frstfreq;
end
if (fsize>1)
    frstfreq=frstfreq(1);
end
if (ssize>1)
    scndtfreq=scndtfreq(1);
end
class=1;
qq=[qq;val];

data=[data; minval maxval stdval varval frstfreq scndtfreq medianval skewnessval harmmeanval kurtosisval class ];
end