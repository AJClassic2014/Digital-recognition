%***classification by Mahalanodis distance(Leave-One-Out)*******
filelist={'n1.txt','n2.txt','n4.txt','n5.txt','n6.txt','n7.txt','n8.txt','n9.txt'};%8 data set files
meanlist=cell(1,8);%used to store the mean value for 8 numeric character
sigmalist=cell(1,8);%used to stroe the numeric class inclufing all the samples
classlist=cell(8,1);
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
fid = fopen(filename,'r');  %  open the file,read only
if fid==-1
    disp('File does not exist'); %open file is not successful
end
num_class=cell(100,1);

%import the data
sum=1;
 while ~feof(fid)    %if the end of the file
  rownmb = 0;  %used to point the line
  data=cell(5,4);
  nextline = fgetl(fid);  %read one line from data set file
  line_content =textscan(nextline,'%*s %*8.6f %8.6f %8.6f %8.6f %8.6f'); %get the content of the data(control the format)
  rownmb = rownmb +1;  %go to the next line
  data(rownmb,:) = line_content;
 
  for n=1:4
     nextline = fgetl(fid);  %import the next line
     line_content =textscan(nextline,'%8.6f %8.6f %8.6f %8.6f');
     rownmb = rownmb +1;  %go to the next line
     data(rownmb,:) = line_content; %store the data line by line
  end
  num_class{sum,1}=cell2mat(data);
  
  
  sum=sum+1;
  data(:)=[];
 end

classlist{getmean}=num_class;%store all the samples into classlist for every numeric character
sta=fclose(fid);  %close the file
if sta == -1  
    disp('File not cloed');
end

%calculate the mean value without leave-one-out
i=1;
sumoffeature=zeros(5,4);
while i<=sum-1
    
    sumoffeature=sumoffeature+num_class{i,1};
    i=i+1;
end
meanofclass=sumoffeature/(sum-1);

meanlist{getmean}=meanofclass;


%calculate mean of sigma

samplex=1;
while samplex<=5
    sampley=1;
    while sampley<=4
      sumofpoints=0;
      numofsamples=1;
      %calcule the sum for one of features from 100 samples
      while numofsamples<=sum-1
        sumofpoints=sumofpoints+num_class{numofsamples,1}(samplex,sampley);
        
        numofsamples=numofsamples+1;
      end
      
     % if (samplex==1)&&(sampley==1)
      %   fprintf('%d\n',getmean);
       %  fprintf('%f\n',sumofpoints);
      %end
      %calcule the sum of square for one of features from 100 samples
      z=1;
      sumofsquare=0;
      while z<=sum-1
      sumofsquare=sumofsquare+(num_class{z,1}(samplex,sampley)).^2;
      z=z+1;
      end
      sumofsigma=0;
      sumofsigma=sumofsquare-(sumofpoints)^2/(sum-1);
      sigmalist{getmean}(samplex,sampley)=sumofsigma/(sum-1);
      
      
      sampley=sampley+1;
    end
    samplex=samplex+1;
end

%next numeric character
getmean=getmean+1;
end

temp=1;
while temp<=length(classlist)%get every one from 8 numeric class
    
if temp~=2    
    
    sample=1;
    while sample<=100%100 samples for each pattern 
        
       member=1; %calculate the new mean value
       newsum=zeros(5,4);
       while member<=100
        if member==sample
            member=member+1;
            continue;
        end
        newsum=newsum+classlist{temp,1}{member,1};  
        member=member+1;
       end
        newmean=newsum/99;
        tempmean=zeros(5,4);
        tempmean=meanlist{1,temp};
        meanlist{1,temp}=newmean;
        
        sigmamember=1;%calculate the new sigma
        sumofp=zeros(5,4);
        sumofs=zeros(5,4);
        while sigmamember<=100
          if sigmamember==sample
            sigmamember=sigmamember+1;
            continue;
          end
          sumofp=sumofp+classlist{temp,1}{sigmamember,1};
          sumofs=sumofs+(classlist{temp,1}{sigmamember,1}).^2;
          sigmamember=sigmamember+1;
        end
        newsigma=zeros(5,4);
        newsigma=(sumofs-sumofp.^2./99)./99;
        tempsigma=sigmalist{1,temp};
        sigmalist{1,temp}=newsigma;
        
        min=inf;
        total=cell(1,8);
        distance=1;
        while distance<=8%comparing with the 8 mean values
           k=((classlist{temp,1}{sample,1}-meanlist{1,distance}).^2)./sigmalist{1,distance};
           totalx=k(1,:)+k(2,:)+k(3,:)+k(4,:)+k(5,:);
           total{distance}=sqrt(totalx(1,1)+totalx(1,2)+totalx(1,3)+totalx(1,4));
           if min>total{distance}
              min=total{distance};
              minpointer=distance;
           end
           distance=distance+1;
        end
        meanlist{1,temp}=tempmean;
        sigmalist{1,temp}=tempsigma;
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
if temp==2
       sample=1;
    while sample<=57%100 samples for each pattern 
        
       member=1;
       newsum=zeros(5,4);
       while member<=57
        if member==sample
            member=member+1;
            continue;
        end
        newsum=newsum+classlist{temp,1}{member,1};  
        member=member+1;
       end
        newmean=newsum/56;
        tempmean=zeros(5,4);
        tempmean=meanlist{1,temp};
        meanlist{1,temp}=newmean;
        
        sigmamember=1;%calculate the new sigma
        sumofp=zeros(5,4);
        sumofs=zeros(5,4);
        while sigmamember<=57
          if sigmamember==sample
            sigmamember=sigmamember+1;
            continue;
          end
          sumofp=sumofp+classlist{temp,1}{sigmamember,1};
          sumofs=sumofs+(classlist{temp,1}{sigmamember,1}).^2;
          sigmamember=sigmamember+1;
        end
        newsigma=zeros(5,4);
        newsigma=(sumofs-sumofp.^2./56)./56;
        tempsigma=sigmalist{1,temp};
        sigmalist{1,temp}=newsigma;
        
        min=inf;
        total=cell(1,8);
        distance=1;
        while distance<=8%comparing with the 8 mean values
           k=((classlist{temp,1}{sample,1}-meanlist{1,distance}).^2)./sigmalist{1,distance};
           totalx=k(1,:)+k(2,:)+k(3,:)+k(4,:)+k(5,:);
           total{distance}=sqrt(totalx(1,1)+totalx(1,2)+totalx(1,3)+totalx(1,4));
           if min>total{distance}
              min=total{distance};
              minpointer=distance;
           end
           distance=distance+1;
        end
        meanlist{1,temp}=tempmean;
        sigmalist{1,temp}=tempsigma;
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
fprintf('********percentage of correct for classification by Mahalanodis(Leave-One-Out)**************************\n');
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