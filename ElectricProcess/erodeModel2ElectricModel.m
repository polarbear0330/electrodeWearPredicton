function [ edgePoints,edgeNums ] = erodeModel2ElectricModel( vertexes4,mnPoints_t,mnPoints_w,origin_left_up,grid )
%ERODEMODEL2ELECTRICMODEL 此处显示有关此函数的摘要
%   此处显示详细说明

% [edgePoints,edgeNums] = pdeEdgeGeom( m,n,origin_left_up,grid );
[edgePoints_t] = pdeEdgeGeom( mnPoints_t,origin_left_up,grid );
edgeNums=1:size(edgePoints_t,2);
[edgePoints_w] = pdeEdgeGeom( mnPoints_w,origin_left_up,grid );

[ edgePoints ] = rotateC( edgePoints,edgeNums, angleC, originC );

end

