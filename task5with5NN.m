%****classification by 5-NN rule*********
filelist={'n1.txt','n2.txt','n4.txt','n5.txt','n6.txt','n7.txt','n8.txt','n9.txt'};%8 data set files
meanlist=cell(1,8);%used to store the mean value for 8 numeric character
classlist=cell(8,1);%used to stroe the numeric class inclufing all the samples
getmean=1;
totalnumsample=1;
cmatrix=zeros(8,8);%used to construct the confusion matrix
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
  rownmb = rownmb +1;  %%go to the next line
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

getmean=getmean+1;

end

%task3 minimum distance for every sample

temp=1;
while temp<=length(classlist)%get every one from 8 numeric class
    sample=1;
    while sample<=length(classlist{temp,1})%100 samples for each pattern 
        min=inf;
        total=cell(1,8);
        
        classlistforthree=zeros(1,5);
        comparelist=zeros(1,756);
        relatedclasslist=zeros(1,756);
        listpointer=1;
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
             
             comparelist(1,listpointer)=total{inner_num};%put the 756 distances in to list
             relatedclasslist(1,listpointer)=inner_num;%point the related numeric class for every sample
             listpointer=listpointer+1;
             inner_sample=inner_sample+1;
           end
           inner_num=inner_num+1;
        end
        getmin=1;
        while getmin<=5%sort list 5 times and get 5 smallest one
        minvalue=inf;
        comparenum=1;
        while comparenum<=756
           if minvalue>comparelist(1,comparenum)
              minvalue=comparelist(1,comparenum);%try to find the first smallest three samples and their classes
              
           end
             comparenum=comparenum+1;
        end
        minvalueindex=find(comparelist==minvalue);
        comparelist(1,minvalueindex)=inf;%ignore the smallest one we have currently 
        classlistforthree(1,getmin)=relatedclasslist(1,minvalueindex);%find the classes three samples belong to respectively
        getmin=getmin+1; 
        end
      
         if (classlistforthree(1,1)~=classlistforthree(1,2))&&(classlistforthree(1,2)~=classlistforthree(1,3))&&(classlistforthree(1,1)~=classlistforthree(1,3))
             minpointer=classlistforthree(1,1);
            % fprintf('(1)the sample %d classlistforthree is %d %d %d and majority is %d \n',sample,classlistforthree(1,1),classlistforthree(1,2),classlistforthree(1,3),minpointer)
         end
         if (classlistforthree(1,1)==classlistforthree(1,2))||(classlistforthree(1,2)==classlistforthree(1,3))||(classlistforthree(1,1)==classlistforthree(1,3))
         classtable=tabulate(classlistforthree(:));
         minpointer=find(classtable(:,2)==max(classtable(:,2)));
        % fprintf('(2)the sample %d classlistforthree is %d %d %d and majority is %d \n',sample,classlistforthree(1,1),classlistforthree(1,2),classlistforthree(1,3),minpointer)
         end
        if minpointer==1
           cmatrix(temp,1) =cmatrix(temp,1)+1;%stand for 1
        end
        if minpointer==2
           cmatrix(temp,2) =cmatrix(temp,2)+1;%stand for 2
        end
        if minpointer==3
           cmatrix(temp,3) =cmatrix(temp,3)+1;%stand for 4
        end
        if minpointer==4
           cmatrix(temp,4) =cmatrix(temp,4)+1;%stand for 5
        end
         if minpointer==5
           cmatrix(temp,5) =cmatrix(temp,5)+1;%stand for 6
         end
         if minpointer==6
           cmatrix(temp,6) =cmatrix(temp,6)+1;%stand for 7
         end
         if minpointer==7
           cmatrix(temp,7) =cmatrix(temp,7)+1;%stand for 8
         end
         if minpointer==8
           cmatrix(temp,8) =cmatrix(temp,8)+1;%stand for 9
        end
     sample=sample+1;
    end
    temp=temp+1;


end
%calculate the correct accuracy
c=1;
totalcorrect=0;
while c<=8
    totalcorrect=totalcorrect+cmatrix(c,c);
    c=c+1;
end
precision=totalcorrect/757;
cmatrix
fprintf('********percentage of correct for classification by 5-NN**************************\n');
fprintf('correct accuracy for numeric character 1 is %.2f \n',cmatrix(1,1));
fprintf('correct accuracy for numeric character 2 is %.2f \n',cmatrix(2,2)/57*100);
fprintf('correct accuracy for numeric character 4 is %.2f \n',cmatrix(3,3));
fprintf('correct accuracy for numeric character 5 is %.2f \n',cmatrix(4,4));
fprintf('correct accuracy for numeric character 6 is %.2f \n',cmatrix(5,5));
fprintf('correct accuracy for numeric character 7 is %.2f \n',cmatrix(6,6));
fprintf('correct accuracy for numeric character 8 is %.2f \n',cmatrix(7,7));
fprintf('correct accuracy for numeric character 9 is %.2f \n',cmatrix(8,8));

fprintf('overall correct accuracy is %.2f \n',precision*100);