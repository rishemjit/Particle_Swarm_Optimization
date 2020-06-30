function adj = topology(type, P, N)
 

if(strcmp(type, 'ring'))
    neighbor = zeros(P,N*2);
    %topology:URing
    
    for i = 1: N
        neighbor(i,:)=[ i-N+P : 1: P,  1: 1: i-1, i+1: 1: i+N  ];
    end
    
    
    for i=N+1:P-N
        neighbor(i,:)=[i-N:1: i-1,   i+1: 1: i+N];
    end
    
    for i=P-N +1 :P
        neighbor(i,:)=[i-N:1: i-1,   i+1: 1:P, 1:1: N-(P - i) ];
    end
    adj =[];
    
    for i = 1:P
        adj(i,neighbor(i, :))=1;
    end
    


elseif(strcmp(type, 'fully'))
  % where N=P
  
adj(1:P, 1:P) =1;



 
elseif (strcmp (type, 'square'))
    % considering that always 8 neighbours will be considered
%    error('not implemented yet')
   neighbor = zeros(P,8);
   edge = sqrt(P);
   tempmat = vec2mat([1:P], edge);
   tempmat = padarray(tempmat, [1,1], 'circular');
   temp =1;
   for r = 2: edge+1
       for c = 2: edge+1
            row_index1 = r - 1 ;
                row_index2 = r +1 ;
                column_index1 = c - 1 ;
                column_index2 = c + 1 ;
                Individual_Neighbourhood = tempmat(row_index1 : row_index2,column_index1 : column_index2);
                Individual_Neighbourhood(5)=[];
                neighbor(temp,:) =Individual_Neighbourhood;
                temp =temp+1;
       end
   end
 
  for i = 1:P
    adj(i,neighbor(i, :))=1;
  end 
      
elseif(strcmp (type, 'mesh')) % only 4 neighbor but also wraps arounds like toroidal
  neighbor = zeros(P,4);
  edge = sqrt(P);
   tempmat = vec2mat([1:P], edge);
   tempmat = padarray(tempmat, [1,1], 'circular');
   temp =1;
   for r = 2: edge+1
       for c = 2: edge+1
          Individual_Neighbourhood(1:2)=  tempmat(r, [c-1, c+1]);
          Individual_Neighbourhood(3:4)=  tempmat([r-1, r+1], c);
          neighbor(temp,:) =Individual_Neighbourhood;
           temp =temp+1;
       end
   end
 
  for i = 1:P
    adj(i,neighbor(i, :))=1;
  end 

  
 
 
elseif(strcmp (type, 'random'))
  adj = random_graph(P,0.0808);%0.0808
    
elseif (strcmp (type, 'scalefree'))
    adj =[];
  el = preferential_attachment(P,2);
  for i = 1: size(el,1)
     adj(el(i,1), el(i,2)) = 1; 
  end
    
elseif (strcmp (type, 'star'))
  adj = [];
  centralInd = ceil(rand*P); % randomly pick any individual to be the central node
  if (centralInd<=0 || centralInd>P)
      centralInd = 1
  end
  adj(centralInd, 1:P) = 1;
  for i = 1: P
   adj(i, centralInd)=1; 
  end
   adj(centralInd, centralInd)=0;
else
    
    error('unknown topology')
    
end
    