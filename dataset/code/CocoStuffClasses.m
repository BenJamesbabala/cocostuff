classdef CocoStuffClasses
    % CocoStuffClasses
    %
    % Semantic segmentation dataset for stuff classes in COCO
    %
    % Copyright by Holger Caesar, 2017
    
    properties (Constant)
        thingCount = 91;
        stuffCount = 91;
    end
    
    methods (Static)
        function[labelNames, labelCount] = getLabelNamesStuff()
            % [labelNames, labelCount] = getLabelNamesStuff()
            %
            % Note that the stuff labels are always sorted alphabetically !!!
            % Does not include "unlabeled" class!
            
            % Retrieve labels from hierarchy to make sure they match
            [~, categories, heights] = CocoStuffClasses.getClassHierarchyStuff();
            
            % Select only leaf nodes
            sel = heights == max(heights);
            categories = categories(sel);
            
            % Get stuff and thing labels
            labelNames = sort(categories);
            labelCount = numel(labelNames);
        end
        
        function[labelNames, labelCount] = getLabelNamesThings()
            % [labelNames, labelCount] = getLabelNamesThings()
            %
            % Note that the thing labels are in the original COCO order and
            % not sorted by alphabet !!!
            % Does not include "unlabeled" class!
            
            % Retrieve labels from hierarchy to make sure they match
            [~, categories, heights] = CocoStuffClasses.getClassHierarchyThings();
            
            % Select only leaf nodes
            sel = heights == max(heights);
            categories = categories(sel);
            
            % Get stuff and thing labels
            labelNames = categories;
            labelCount = numel(labelNames);
        end
        
        function[labelNames, labelCount] = getLabelNamesThingsStuff()
            % [labelNames, labelCount] = getLabelNamesThingsStuff()
            %
            % Return thing and stuff classes in order.
            % Does not include "unlabeled" class!
            
            % Get stuff labels
            labelNamesStuff = CocoStuffClasses.getLabelNamesStuff();
            
            % Get thing labels
            labelNamesThings = CocoStuffClasses.getLabelNamesThings();
            
            % Concatenate both
            labelNames = [labelNamesThings; labelNamesStuff];
            labelCount = numel(labelNames);
        end
        
        function[nodes, categories, heights, parents] = getClassHierarchy()
            % Gets a hierarchies of all labels in CocoStuff (things+stuff)
            [~, ~, ~, parentsStuff] = CocoStuffClasses.getClassHierarchyStuff();
            [~, ~, ~, parentsThings] = CocoStuffClasses.getClassHierarchyThings();
            
            % Combine both subtrees
            parentsStuff{1, 2} = 'root';
            parentsThings{1, 2} = 'root';
            parents = [{'root'}, {'root'}; ...
                parentsThings; parentsStuff];
            
            % Convert to tree
            [nodes, categories, heights] = parentsToTrees(parents);
        end
        
        function[nodes, categories, heights, parents] = getClassHierarchyThings()
            % Returns a hierarchy of classes to be plotted with treeplot(nodes)
            
            parents = { ...
                'things', 'things'; ...
                ... % End of level 1
                'indoor-super-things', 'things'; ...
                'outdoor-super-things', 'things'; ...
                ... % End of level 2
                'person-things', 'outdoor-super-things'; ...
                'vehicle-things', 'outdoor-super-things'; ...
                'outdoor-things', 'outdoor-super-things'; ...
                'animal-things', 'outdoor-super-things'; ...
                'accessory-things', 'outdoor-super-things'; ...
                'sports-things', 'outdoor-super-things'; ...
                'kitchen-things', 'indoor-super-things'; ...
                'food-things', 'indoor-super-things'; ...
                'furniture-things', 'indoor-super-things'; ...
                'electronic-things', 'indoor-super-things'; ...
                'appliance-things', 'indoor-super-things'; ...
                'indoor-things', 'indoor-super-things'; ...
                ... % End of level 3
                'person', 'person-things'; ...
                'bicycle', 'vehicle-things'; ...
                'car', 'vehicle-things'; ...
                'motorcycle', 'vehicle-things'; ...
                'airplane', 'vehicle-things'; ...
                'bus', 'vehicle-things'; ...
                'train', 'vehicle-things'; ...
                'truck', 'vehicle-things'; ...
                'boat', 'vehicle-things'; ...
                'traffic light', 'outdoor-things'; ...
                'fire hydrant', 'outdoor-things'; ...
                'street sign', 'outdoor-things'; ...
                'stop sign', 'outdoor-things'; ...
                'parking meter', 'outdoor-things'; ...
                'bench', 'outdoor-things'; ...
                'bird', 'animal-things'; ...
                'cat', 'animal-things'; ...
                'dog', 'animal-things'; ...
                'horse', 'animal-things'; ...
                'sheep', 'animal-things'; ...
                'cow', 'animal-things'; ...
                'elephant', 'animal-things'; ...
                'bear', 'animal-things'; ...
                'zebra', 'animal-things'; ...
                'giraffe', 'animal-things'; ...
                'hat', 'accessory-things'; ...
                'backpack', 'accessory-things'; ...
                'umbrella', 'accessory-things'; ...
                'shoe', 'accessory-things'; ...
                'eye glasses', 'accessory-things'; ...
                'handbag', 'accessory-things'; ...
                'tie', 'accessory-things'; ...
                'suitcase', 'accessory-things'; ...
                'frisbee', 'sports-things'; ...
                'skis', 'sports-things'; ...
                'snowboard', 'sports-things'; ...
                'sports ball', 'sports-things'; ...
                'kite', 'sports-things'; ...
                'baseball bat', 'sports-things'; ...
                'baseball glove', 'sports-things'; ...
                'skateboard', 'sports-things'; ...
                'surfboard', 'sports-things'; ...
                'tennis racket', 'sports-things'; ...
                'bottle', 'kitchen-things'; ...
                'plate', 'kitchen-things'; ...
                'wine glass', 'kitchen-things'; ...
                'cup', 'kitchen-things'; ...
                'fork', 'kitchen-things'; ...
                'knife', 'kitchen-things'; ...
                'spoon', 'kitchen-things'; ...
                'bowl', 'kitchen-things'; ...
                'banana', 'food-things'; ...
                'apple', 'food-things'; ...
                'sandwich', 'food-things'; ...
                'orange', 'food-things'; ...
                'broccoli', 'food-things'; ...
                'carrot', 'food-things'; ...
                'hot dog', 'food-things'; ...
                'pizza', 'food-things'; ...
                'donut', 'food-things'; ...
                'cake', 'food-things'; ...
                'chair', 'furniture-things'; ...
                'couch', 'furniture-things'; ...
                'potted plant', 'furniture-things'; ...
                'bed', 'furniture-things'; ...
                'mirror', 'furniture-things'; ...
                'dining table', 'furniture-things'; ...
                'window', 'furniture-things'; ...
                'desk', 'furniture-things'; ...
                'toilet', 'furniture-things'; ...
                'door', 'furniture-things'
                'tv', 'electronic-things'; ...
                'laptop', 'electronic-things'; ...
                'mouse', 'electronic-things'; ...
                'remote', 'electronic-things'; ...
                'keyboard', 'electronic-things'; ...
                'cell phone', 'electronic-things'; ...
                'microwave', 'appliance-things'; ...
                'oven', 'appliance-things'; ...
                'toaster', 'appliance-things'; ...
                'sink', 'appliance-things'; ...
                'refrigerator', 'appliance-things'; ...
                'blender', 'appliance-things'; ...
                'book', 'indoor-things'; ...
                'clock', 'indoor-things'; ...
                'vase', 'indoor-things'; ...
                'scissors', 'indoor-things'; ...
                'teddy bear', 'indoor-things'; ...
                'hair drier', 'indoor-things'; ...
                'toothbrush', 'indoor-things'; ...
                'hair brush', 'indoor-things'; ...
                };
            
            % Convert to tree
            [nodes, categories, heights] = parentsToTrees(parents);
        end
        
        function[nodes, categories, heights, parents] = getClassHierarchyStuff(~)
            % Returns a hierarchy of stuff classes to be plotted with treeplot(nodes)
            
            parents = { ...
                'stuff', 'stuff'; ...
                ... % End of level 1
                'indoor-super-stuff', 'stuff'; ...
                'outdoor-super-stuff', 'stuff'; ...
                ... % End of level 2
                'rawmaterial-stuff', 'indoor-super-stuff'; ...
                'wall-stuff', 'indoor-super-stuff'; ...
                'ceiling-stuff', 'indoor-super-stuff'; ...
                'floor-stuff', 'indoor-super-stuff'; ...
                'window-stuff', 'indoor-super-stuff'; ...
                'furniture-stuff', 'indoor-super-stuff'; ...
                'textile-stuff', 'indoor-super-stuff'; ...
                'food-stuff', 'indoor-super-stuff'; ...
                'building-stuff', 'outdoor-super-stuff'; ...
                'structural-stuff', 'outdoor-super-stuff'; ...
                'plant-stuff', 'outdoor-super-stuff'; ...
                'sky-stuff', 'outdoor-super-stuff'; ...
                'solid-stuff', 'outdoor-super-stuff'; ...
                'ground-stuff', 'outdoor-super-stuff'; ...
                'water-stuff', 'outdoor-super-stuff'; ...
                ... % End of level 3
                'cardboard', 'rawmaterial-stuff'; ...
                'paper', 'rawmaterial-stuff'; ...
                'plastic', 'rawmaterial-stuff'; ...
                'metal', 'rawmaterial-stuff'; ...
                'wall-tile', 'wall-stuff'; ...
                'wall-panel', 'wall-stuff'; ...
                'wall-wood', 'wall-stuff'; ...
                'wall-brick', 'wall-stuff'; ...
                'wall-stone', 'wall-stuff'; ...
                'wall-concrete', 'wall-stuff'; ...
                'wall-other', 'wall-stuff'; ...
                'ceiling-tile', 'ceiling-stuff'; ...
                'ceiling-other', 'ceiling-stuff'; ...
                'carpet', 'floor-stuff'; ...
                'floor-tile', 'floor-stuff'; ...
                'floor-wood', 'floor-stuff'; ...
                'floor-marble', 'floor-stuff'; ...
                'floor-stone', 'floor-stuff'; ...
                'floor-other', 'floor-stuff'; ...
                'window-blind', 'window-stuff'; ...
                'window-other', 'window-stuff'; ...
                'door-stuff', 'furniture-stuff'; ...
                'desk-stuff', 'furniture-stuff'; ...
                'table', 'furniture-stuff'; ...
                'shelf', 'furniture-stuff'; ...
                'cabinet', 'furniture-stuff'; ...
                'cupboard', 'furniture-stuff'; ...
                'mirror-stuff', 'furniture-stuff'; ...
                'counter', 'furniture-stuff'; ...
                'light', 'furniture-stuff'; ...
                'stairs', 'furniture-stuff'; ...
                'furniture-other', 'furniture-stuff'; ...
                'rug', 'textile-stuff'; ...
                'mat', 'textile-stuff'; ...
                'towel', 'textile-stuff'; ...
                'napkin', 'textile-stuff'; ...
                'clothes', 'textile-stuff'; ...
                'cloth', 'textile-stuff'; ...
                'curtain', 'textile-stuff'; ...
                'blanket', 'textile-stuff'; ...
                'pillow', 'textile-stuff'; ...
                'banner', 'textile-stuff'; ...
                'textile-other', 'textile-stuff'; ...
                'fruit', 'food-stuff'; ...
                'salad', 'food-stuff'; ...
                'vegetable', 'food-stuff'; ...
                'food-other', 'food-stuff'; ...
                ... % End of level 4 left
                'house', 'building-stuff'; ...
                'skyscraper', 'building-stuff'; ...
                'bridge', 'building-stuff'; ...
                'tent', 'building-stuff'; ...
                'roof', 'building-stuff'; ...
                'building-other', 'building-stuff'; ...
                'fence', 'structural-stuff'; ...
                'cage', 'structural-stuff'; ...
                'net', 'structural-stuff'; ...
                'railing', 'structural-stuff'; ...
                'structural-other', 'structural-stuff'; ...
                'grass', 'plant-stuff'; ...
                'tree', 'plant-stuff'; ...
                'bush', 'plant-stuff'; ...
                'leaves', 'plant-stuff'; ...
                'flower', 'plant-stuff'; ...
                'branch', 'plant-stuff'; ...
                'moss', 'plant-stuff'; ...
                'straw', 'plant-stuff'; ...
                'plant-other', 'plant-stuff'; ...
                'clouds', 'sky-stuff'; ...
                'sky-other', 'sky-stuff'; ...
                'wood', 'solid-stuff'; ...
                'rock', 'solid-stuff'; ...
                'stone', 'solid-stuff'; ...
                'mountain', 'solid-stuff'; ...
                'hill', 'solid-stuff'; ...
                'solid-other', 'solid-stuff'; ...
                'sand', 'ground-stuff'; ...
                'snow', 'ground-stuff'; ...
                'dirt', 'ground-stuff'; ...
                'mud', 'ground-stuff'; ...
                'gravel', 'ground-stuff'; ...
                'road', 'ground-stuff'; ...
                'pavement', 'ground-stuff'; ...
                'railroad', 'ground-stuff'; ...
                'platform', 'ground-stuff'; ...
                'playingfield', 'ground-stuff'; ...
                'ground-other', 'ground-stuff'; ...
                'fog', 'water-stuff'; ...
                'river', 'water-stuff'; ...
                'sea', 'water-stuff'; ...
                'waterdrops', 'water-stuff'; ...
                'water-other', 'water-stuff'; ...
                };
            
            % Convert to tree
            [nodes, categories, heights] = parentsToTrees(parents);
        end
        
        function[nodes, categories, heights, parents] = getClassHierarchyStuffThings()
            % [nodes, categories, heights, parents] = getClassHierarchyStuffThings()
            
            % Get stuff and thing subtrees
            [~, ~, ~, parentsS] = CocoStuffClasses.getClassHierarchyStuff();
            [~, ~, ~, parentsT] = CocoStuffClasses.getClassHierarchyThings();
            
            % Add root node which holds both subtrees
            parentsS{1, 2} = 'root';
            parentsT{1, 2} = 'root';
            parents = [{'root', 'root'}; parentsT; parentsS];
            
            % Convert to tree
            [nodes, categories, heights] = parentsToTrees(parents);
        end
        
        function[stuffLabels, thingLabels, stuffLabelInds, thingLabelInds] = getStuffThingLabels()
            % [stuffLabels, thingLabels, stuffLabelInds, thingLabelInds] = getStuffThingLabels()
            %
            % Note that "unlabeled" is neither thing nor stuff!
            
            % Get all stuff and thing labels
            [stuffLabelsAll, thingLabelsAll] = CocoStuffClasses.getStuffThingLabelsAll();
            
            % Limit to classes used in current annotation
            labelNames = CocoStuffClasses.getLabelNamesThingsStuff();
            thingLabelInds = find(ismember(labelNames, thingLabelsAll));
            stuffLabelInds = find(ismember(labelNames, stuffLabelsAll));
            thingLabels = labelNames(thingLabelInds);
            stuffLabels = labelNames(stuffLabelInds);
            
            % Check consistency
            allInds = [1; thingLabelInds; stuffLabelInds];
            assert(isequal(allInds, unique(allInds)));
        end
        
        function[stuffLabels, thingLabels, stuffLabelInds, thingLabelInds] = getStuffThingLabelsAll()
            % [stuffLabels, thingLabels, stuffLabelInds, thingLabelInds] = getStuffThingLabels()
            %
            % Note that "unlabeled" is neither thing nor stuff!
            
            labelNamesAll = ['unlabeled'; CocoStuffClasses.getLabelNamesThingsStuff()];
            thingLabelInds = (1 + 1 : CocoStuffClasses.thingCount + 1)';
            stuffLabelInds = (1 + CocoStuffClasses.thingCount + 1 : numel(labelNamesAll))';
            thingLabels = labelNamesAll(thingLabelInds);
            stuffLabels = labelNamesAll(stuffLabelInds);
            
            % Check consistency
            allInds = [1; thingLabelInds; stuffLabelInds];
            assert(isequal(allInds, unique(allInds)));
        end
        
        function[dists] = hierarchyDistances()
            % [dists] = hierarchyDistances()
            %
            % Returns a symmetric matrix of pairwise distances between
            % labels i and j, where the distance function is the path
            % length between i and j in the hierarchy.
            
            % Get dataset label hierarchy
            [nodes, categories, heights, ~] = CocoStuffClasses.getClassHierarchy();
            
            % Init
            nodeCount = numel(nodes);
            distsN = zeros(nodeCount, nodeCount);
            
            for i = 2 : nodeCount % skip "unlabeled" class
                for j = i + 1 : nodeCount
                    distI = 0;
                    distJ = 0;
                    curI = i;
                    curJ = j;
                    while curI ~= curJ
                        if heights(curI) < heights(curJ)
                            % Go to parent of j
                            curJ = nodes(curJ);
                            distJ = distJ + 1;
                        elseif heights(curI) > heights(curJ)
                            % Go to parent of i
                            curI = nodes(curI);
                            distI = distI + 1;
                        else
                            % Go to parent of j
                            curJ = nodes(curJ);
                            distJ = distJ + 1;
                            
                            % Go to parent of i
                            curI = nodes(curI);
                            distI = distI + 1;
                        end
                    end
                    % The final distance is the sum of both distances
                    dist = distI + distJ;
                    
                    distsN(i, j) = dist;
                    distsN(j, i) = dist;
                end
            end
            
            % Remove all inner nodes of the tree
            labelNames = CocoStuffClasses.getLabelNamesThingsStuff();
            relInds = indicesOfAInB(labelNames(2:end), categories);
            distsN = distsN(relInds, relInds);
            
            % Add "unlabeled" class with largest distance to any label
            maxDist = max(distsN(:));
            dists = nan(size(distsN) + 1);
            dists(2:end, 2:end) = distsN;
            dists(1, 2:end) = maxDist + 1;
            dists(2:end, 1) = maxDist + 1;
            dists(1, 1) = 0;
        end
        
        function showClassHierarchyStuff()
            % showClassHierarchyStuff()
            
            [nodes, cats] = CocoStuffClasses.getClassHierarchyStuff();
            % Make label names nicer/shorter
            cats = strrep(cats, '-stuff', '');
            cats = strrep(cats, '-things', '');
            cats = strrep(cats, '-super', '');
            
            % Plot label hierarchy
            plotTree(nodes, cats);
        end
        
        function showClassHierarchyThings()
            % showClassHierarchyThings()
            
            [nodes, cats] = CocoStuffClasses.getClassHierarchyThings();
            
            % Make label names nicer/shorter
            cats = strrep(cats, '-stuff', '');
            cats = strrep(cats, '-things', '');
            cats = strrep(cats, '-super', '');
            
            % Plot label hierarchy
            plotTree(nodes, cats);
        end
        
        function showClassHierarchyStuffThings()
            % showClassHierarchyStuffThings()
            
            [nodes, cats] = CocoStuffClasses.getClassHierarchyStuffThings();
            
            % Make label names nicer/shorter
            cats = strrep(cats, '-stuff', '');
            cats = strrep(cats, '-things', '');
            cats = strrep(cats, '-super', '');
            
            % Start figure
            figLabelHierarchy = figure();
            set(gcf, 'Color', 'w');
            
            % Plot label hierarchy
            plotTree(nodes, cats,  1, figLabelHierarchy);
            plotTree(nodes, cats, -1, figLabelHierarchy);
            
            % Set figure size
            pos = get(figLabelHierarchy, 'Position');
            newPos = pos;
            newPos(3) = 1000;
            newPos(4) = 1000;
            set(figLabelHierarchy, 'Position', newPos);
        end
    end
end