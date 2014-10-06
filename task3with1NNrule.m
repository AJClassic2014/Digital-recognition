%****classification by 1-NN rule**********
filelist={'n1.txt','n2.txt','n4.txt','n5.txt','n6.txt','n7.txt','n8.txt','n9.txt'};%8 data set files
meanlist=cell(1,8);%used to store the mean value for 8 numeric character
classlist=cell(8,1);%used to stroe the numeric class inclufing all the samples
getmean=1;
totalnumsample=1;

cmatrix=cell(10,10);%used to construct the confusion matrix
%construct the column
cmatrix{1,1}='class';
cmatrix{1,2}=1;%first item is "1"
cmatrix{1,3}=2;%second item is "2"
charNum=4;
while charNum<=9
    cmatrix{1,charNum}=charNum;
    charNum=charNum+1;
end
cmatrix{1,10}='Total';
%construct the row
cmatrix{2,1}=1;%first item is "1"
cmatrix{3,1}=2;%second item is "2"
charNumcolumn=4;
while charNumcolumn<=9
    cmatrix{charNumcolumn,1}=charNumcolumn;
    charNumcolumn=charNumcolumn+1;
end
cmatrix{10,1}='Total';
%initialise the matrix
initializeColumn=2;
while initializeColumn<=9
    initializeRow=2;
    while initializeRow<=9
        cmatrix{initializeColumn,initializeRow}=0;
        initializeRow=initializeRow+1;
    end
    initializeColumn=initializeColumn+1;
end

while getmean<=8
filename = filelist{1,getmean};
fid = fopen(filename,'r');  % open the file,read only
if fid==-1
    disp('File does not exist'); %open file is not successful
end
num_class=cell(100,1);
num_classfor2=cell(57,1);
%import the data
sum=1;
 while ~feof(fid)    %if the end of the file
  rownmb = 0;  %used to point the line
  data=cell(5,4);
  nextline = fgetl(fid);  %read one line from data set file
  line_content =textscan(nextline,'%*s %*8.6f %8.6f %8.6f %8.6f %8.6f'); %get the content of the data(control the format)
  rownmb = rownmb +1;  %get the content of the data(control the format)
  data(rownmb,:) = line_content;
 
  for n=1:4
     nextline = fgetl(fid);  %go to the next line
     line_content =textscan(nextline,'%8.6f %8.6f %8.6f %8.6f');
     rownmb = rownmb +1;  %go to the next line
     data(rownmb,:) = line_content; %store the data line by line
  end
  if getmean~=2
  num_class{sum,1}=cell2mat(data);
  end
  if getmean==2
  num_classfor2{sum,1}=cell2mat(data);
  end
  sum=sum+1;
  data(:)=[];
 end
if getmean~=2
classlist{getmean}=num_class;
end
if getmean==2
classlist{getmean}=num_classfor2;%store all the samples into classlist for every numeric character
end
sta=fclose(fid);  %close the file
if sta == -1  
    disp('File not cloed');
end

%calculate the mean value 
getmean=getmean+1;

end

%task3 minimum distance for every sample

temp=1;
while temp<=length(classlist)%get every one from 8 numeric class
    sample=1;
    while sample<=length(classlist{temp,1})%100 samples for each pattern 
        min=inf;
        total=cell(1,8);
        inner_num=1;
        while inner_num<=length(classlist)%calculate with other 756 samples
           inner_sample=1;
           while inner_sample<=length(classlist{inner_num,1}) 
             if (temp==inner_num)&&(sample==inner_sample)
              inner_sample=inner_sample+1;
              continue;
             end
             k=(classlist{temp,1}{sample,1}-classlist{inner_num,1}{inner_sample,1}).^2;
             totalx=k(1,:)+k(2,:)+k(3,:)+k(4,:)+k(5,:);
             total{inner_num}=sqrt(totalx(1,1)+totalx(1,2)+totalx(1,3)+totalx(1,4));
             if min>total{inner_num}
              min=total{inner_num};
              minpointer=inner_num;
             end
             inner_sample=inner_sample+1;
           end
           inner_num=inner_num+1;
        end
    
        if minpointer==1
           cmatrix{temp+1,2} =cmatrix{temp+1,2}+1;%stand for 1
        end
        if minpointer==2
           cmatrix{temp+1,3} =cmatrix{temp+1,3}+1;%stand for 2
        end
        if minpointer==3
           cmatrix{temp+1,4} =cmatrix{temp+1,4}+1;%stand for 4
        end
        if minpointer==4
           cmatrix{temp+1,5} =cmatrix{temp+1,5}+1;%stand for 5
        end
         if minpointer==5
           cmatrix{temp+1,6} =cmatrix{temp+1,6}+1;%stand for 6
         end
         if minpointer==6
           cmatrix{temp+1,7} =cmatrix{temp+1,7}+1;%stand for 7
         end
         if minpointer==7
           cmatrix{temp+1,8} =cmatrix{temp+1,8}+1;%stand for 8
         end
         if minpointer==8
           cmatrix{temp+1,9} =cmatrix{temp+1,9}+1;%stand for 9
         end
     sample=sample+1;
    end
    temp=temp+1;


end
%calculate the correct accuracy
c=2;
totalcorrect=0;
while c<=9
    totalcorrect=totalcorrect+cmatrix{c,c};
    c=c+1;
end
overallCorrect=totalcorrect/757;
cmatrix{10,10}=overallCorrect*100;%the overall percentage of correction
fprintf('********percentage of correct for classification by 1-NN**************************\n');
totalRow=2;
while totalRow<=9
    sumofColumnpointer=2;
    sumofColum=0;
    while sumofColumnpointer<=9
        sumofColum=sumofColum+cmatrix{totalRow,sumofColumnpointer};
        sumofColumnpointer=sumofColumnpointer+1;
    end
    cmatrix{totalRow,10}=sumofColum;
    totalRow=totalRow+1;
end

totalColumn=2;
while totalColumn<=9
    sumofRowpointer=2;
    sumofRow=0;
    while sumofRowpointer<=9
        sumofRow=sumofRow+cmatrix{sumofRowpointer,totalColumn};
        sumofRowpointer=sumofRowpointer+1;
    end
    cmatrix{10,totalColumn}=sumofRow;
    totalColumn=totalColumn+1;
end

cmatrix

fprintf('correct accuracy for numeric character 1 is %.2f \n',cmatrix{2,2});
fprintf('correct accuracy for numeric character 2 is %.2f \n',cmatrix{3,3}/57*100);
fprintf('correct accuracy for numeric character 4 is %.2f \n',cmatrix{4,4});
fprintf('correct accuracy for numeric character 5 is %.2f \n',cmatrix{5,5});
fprintf('correct accuracy for numeric character 6 is %.2f \n',cmatrix{6,6});
fprintf('correct accuracy for numeric character 7 is %.2f \n',cmatrix{7,7});
fprintf('correct accuracy for numeric character 8 is %.2f \n',cmatrix{8,8});
fprintf('correct accuracy for numeric character 9 is %.2f \n',cmatrix{9,9});


fprintf('***************overall percentage of correct classification is %.2f ************************\n',overallCorrect*100);