classdef antDef < handle
    
    properties
        loc
        xlim
        ylim
        foodloc

        speed        % walking speed of ant
        vision       % distance ant can see other ants that he/she wants to befriend
        foodDesire   % desire for food (weighting term);
        friendDesire % desire for friends (weighting term);
        
        foundFood
        randMovement % magnitude of small random movements;
        
    end
    
    methods (Static)
        
        function getMove(antCurrent,antAll,dt)
            if abs(antCurrent.loc(1))>=1
                velocity=antCurrent.speed*[-1,0]*sign(antCurrent.loc(1)); %if Ant reaches boundary of domain, direct it in the opposite direction
            elseif abs(antCurrent.loc(2))>=1
                velocity=antCurrent.speed*[0,-1]*sign(antCurrent.loc(2)); %if Ant reaches boundary of domain, direct it in the opposite direction
            else
                nNearestFood=antCurrent.getClosestFoodDirection(antCurrent,antAll); %get normal vector in direction of food (if close enough)
                nNearestAnts=antCurrent.getClosestFriendsDirection(antCurrent,antAll); %get normal vector in direction of other ants (if close enough)
                
                vectorRandom=[rand(1,1)*2-1,rand(1,1)*2-1]; %get normal vector in random direction
                nRandom=vectorRandom/(norm(vectorRandom,2)); %normalize vectorRandom

                direction=antCurrent.foodDesire*nNearestFood+antCurrent.friendDesire*nNearestAnts+antCurrent.randMovement*nRandom; %add three vectors together (magnitude*direction) to get direction vector for ant movement
                ndirection=direction/norm(direction,2); %normalize direction vector
                velocity=antCurrent.speed*ndirection; %create velocity vector from direction vector

            end
            antCurrent.loc=antCurrent.loc+velocity*dt;
        end
        
        function [nNearestAnts]=getClosestFriendsDirection(antCurrent,antAll) %get normal vector in direction of nearest friends
            for i=1:length(antAll) %calculate position of all ants (antAll) relative to current ant (antCurrent)
                vectorAntDistance(i,:)=antAll(i).loc-antCurrent.loc; 
            end
            magnitudeAntDistance=(vectorAntDistance(:,1).^2+vectorAntDistance(:,2).^2).^(1/2); %obtain magnitude of each position vector
            magnitudeAntDistance=magnitudeAntDistance(magnitudeAntDistance>0,:); %extract magnitudes that do no include the currentAnt magnitude
            vectorNearbyAntDistance=vectorAntDistance(magnitudeAntDistance<=antCurrent.vision,:); %obtain position vector of ants in the 'vision' of the current ant  (i.e. nearby ants)
            numNearbyAnts=length(vectorNearbyAntDistance(:,1)); %obtain number of ants in the 'vision' of current ant (i.e. number of nearby ants)
            meanVectorNearbyAntDistance=[mean(vectorNearbyAntDistance(:,1)),mean(vectorNearbyAntDistance(:,2))]; %determine the mean vector of the nearby ants
            if numNearbyAnts==0 %if no nearby ants, direct ant to middle of plane
                meanVectorNearbyAntDistance=[(antCurrent.xlim(2)+antCurrent.xlim(1)),(antCurrent.ylim(2)+antCurrent.ylim(1))]/2-antCurrent.loc;
            end
            
            nNearestAnts=meanVectorNearbyAntDistance/norm(meanVectorNearbyAntDistance,2);%n is unit vector in the direction of meanVectorNearbyAntDistance (i.e. nearest friends)
            if norm(meanVectorNearbyAntDistance,2)<0.000001 %if vector is too small, do not divide by small number as in nNearestAnts
                nNearestAnts=meanVectorNearbyAntDistance;
            end
        end
        
        function [nNearestFood]=getClosestFoodDirection(antCurrent,antAll) %get normal vector in direction of nearest food
            vectorFoodDistance=antCurrent.loc-antCurrent.foodloc; %obtain distance from ant location to all food locations
            magnitudeFoodDistance=(vectorFoodDistance(:,1).^2+vectorFoodDistance(:,2).^2).^(1/2); %obtain magnitude of each food distance
            foodsourcenumber=find(magnitudeFoodDistance==min(magnitudeFoodDistance));
            locNearestFood=antCurrent.foodloc(foodsourcenumber,:); %find the minimum food location based on minimum magnitude
            vectorNearestFood=locNearestFood-antCurrent.loc; %get position vector from nearest food to ant location
            magnitudeNearestFood=norm(vectorNearestFood,2);  %obtain magnitude of position vector between the ant and nearest food
            
            %no-solution
            nNearestFood=vectorNearestFood/(magnitudeNearestFood); %n is unit vector in the direction of vectorNearestFood (i.e. nearest food)

           
            %antAllprox=antAll.loc-locNearestFood
            %numAntsAtFood=
            
%             if antCurrent.foundFood==foodsourcenumber %If already found food, continue in direction of that food
%                 nNearestFood=vectorNearestFood/(magnitudeNearestFood); %n is unit vector in the direction of vectorNearestFood (i.e. nearest food)
%             else %if haven't found food, then check how many are at food
%                 if sum([antAll.foundFood]==foodsourcenumber)>=5 %if 5 or more at food, then delete that food location from ant's knowledge and move in opposite direction
%                     %antCurrent.foodloc=antCurrent.foodloc([1 2]~=foodsourcenumber,:);
%                     antCurrent.foodloc(foodsourcenumber,:)=antCurrent.foodloc(foodsourcenumber,:)
%                     nNearestFood=-vectorNearestFood/(magnitudeNearestFood); %n is unit vector in the direction of vectorNearestFood (i.e. nearest food)
%                 elseif magnitudeNearestFood<=antCurrent.vision
%                     nNearestFood=vectorNearestFood/(magnitudeNearestFood); %n is unit vector in the direction of vectorNearestFood (i.e. nearest food)
%                     antCurrent.foodDesire=1;
%                     antCurrent.friendDesire=0;
%                     antCurrent.foundFood=foodsourcenumber;
%                 end
%             end
            
            
            
                 %obtain distance from ant location to all food locations             magnitudeFoodDistance=(vectorFoodDistance(:,1).^2+vectorFoodDistance(:,2).^2).^(1/2); %obtain magnitude of each food distance
            %min(vectorFriendsWithFoodDistance)
     
            %locNearestFriendsWithFood=antCurrent.foodloc(vectorFriendsWithFoodDistance==min(vectorFriendsWithFoodDistance),:); %find the minimum food location based on minimum magnitude
%             vectorNearestFood=locNearestFood-antCurrent.loc; %get position vector from nearest food to ant location
%             magnitudeNearestFood=norm(vectorNearestFood,2);  %obtain magnitude of position vector between the ant and nearest food
            
            %solution

%                 vectorRandom=[rand(1,1)*2-1,rand(1,1)*2-1];
%                 nNearestFood=vectorRandom/(norm(vectorRandom,2));
%             end


%             elseif magnitudeNearestFood>antCurrent.vision
%                 friendsWithFood=find([antAll.foundFood]==1)
%                 if isempty(friendsWithFood)==1
%                     vectorRandom=[rand(1,1)*2-1,rand(1,1)*2-1]; %get normal vector in random direction
%                     nNearestFood=vectorRandom/(norm(vectorRandom,2)); %normalize vectorRandom)
%                 elseif isempty(friendsWithFood)==0
%                     vectorFriendsWithFoodDistance=antCurrent.loc-antAll(friendsWithFood).loc;
%                     magnitudeFriendsWithFoodDistance=(vectorFriendsWithFoodDistance(:,1).^2+vectorFriendsWithFoodDistance(:,2).^2).^(1/2);
%                     locNearestFriendsWithFood=antAll(magnitudeFriendsWithFoodDistance==min(magnitudeFriendsWithFoodDistance)).loc; %find the minimum food location based on minimum magnitude
%                     vectorNearestFriendWithFood=locNearestFriendsWithFood-antCurrent.loc; %get position vector from nearest food to ant location
%                     nNearestNearestFriendWithFood=vectorNearestFriendWithFood/(norm(vectorNearestFriendWithFood,2));
%                     nNearestFood=nNearestNearestFriendWithFood;
%                 end
%             end
                            
        end
    end
end