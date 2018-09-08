function [ edgePoints,edgeNums ] = erodeModel2ElectricModel( vertexes4,mnPoints_t,mnPoints_w,start_tool,start_workp,origin_left_up,grid )
%ERODEMODEL2ELECTRICMODEL 此处显示有关此函数的摘要
%   此处显示详细说明

% [edgePoints,edgeNums] = pdeEdgeGeom( m,n,origin_left_up,grid );
[edgePoints_t,~] = pdeEdgeGeom( mnPoints_t,start_tool,origin_left_up,grid );
[edgePoints_w,~] = pdeEdgeGeom( mnPoints_w,start_workp,origin_left_up,grid );

edgePoints=[edgePoints_t,vertexes4(:,[1,2]),edgePoints_w,vertexes4(:,[3,4])];

edgeNums=1:size(edgePoints_t,2)-1;
end

