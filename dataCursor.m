function dataCursor(handle, data, columns, dataTipInfo, callBack)
% Function to customize the behavior of data cursors in MATLAB
% figures. This function should be used in conjunction
% with one of MATLAB plotting commands (plot, stem, scatter, etc.)
%
% How to use:
%   The first argument is the handle to the figure.
% 
%   The second argument is the data that is being plotted.
%   The data must be in Table format.
%
%   The third argument is the Table columns that are being plotted.
%
%   The fourth argument specifics the extra columns which are
%   desired to be displayed on the data tip.
%
%   The fifth argument (optional) specifics any other call back 
%   function needs to be executed when a point on the plot is 
%   clicked on. 
%   The index of the clicked point is stored in a variable called 
%   'selected_point'. This variable is updated each time a 
%   data-point is clicked.
%
% Example 1: 
%   In this example columns col1and col2 are plotted. In this 
%   case, the data tip shows additional columns col3, col4, 
%   and col5: 
%   fig_handle = figure;
%   plot( data.col1, data.col2, '.', 'MarkerSize', 10 )
%   dataCursor(fig_handle, data, {'col1'; 'col2'}, {'col3'; 'col4'; 'col5'});
% 
% Example 2: 
%   In this example columns col1and col2 are plotted. In this
%   case, the data tip shows additional columns col3, col4,
%   and col5. In addition the callback defined in the fifth argument
%   prints the row corresponding to the clicked point in the command
%   window. 
%   Note that the variable 'selected_point' is defined by the data cursor
%   function and stores theindex of the clicked point in the data table. 
%   
%   fig_handle = figure;
%   plot( data.col1, data.col2, '.', 'MarkerSize', 10 )
%   dataCursor(fig_handle, data, {'col1'; 'col2'}, ...
%   {'col3'; 'col4'; 'col5'}, 'data(selected_point,:)');
% 
% See the file 'example.m' for more examples.
% Vahid Montazeri, 10/7/2018

if( nargin<5 )
    callBack = '';
end

variable_name = inputname(2);
callBack = strrep( callBack, variable_name, 'dataPointsInData' );

global dataPointsInData;

if( ~istable( data ) )
    error(['Data must be table data :(' newline newline 'See https://in.mathworks.com/help/matlab/tables.html for more details and how to convert your data to a table.']);
end

dataPointsInData = data;

str1 = ...
    ['function output_txt = callBackFunction(obj,event_obj)' newline 'global dataPointsInData;' newline 'pos = get(event_obj,''Position'');' newline 'indx = find(dataPointsInData.' columns{1} '==pos(1) & dataPointsInData.' columns{2} '==pos(2));' newline 'if( ~isempty(indx) ), selected_point = indx;' newline];

temp_str = '';

for i = 1 : length(dataTipInfo)
    temp_str = [temp_str 'if(iscell( dataPointsInData.' dataTipInfo{i} ')) ' newline];
    temp_str = [temp_str dataTipInfo{i} '= dataPointsInData.' dataTipInfo{i} '{selected_point};' newline];
    
    temp_str = [temp_str 'elseif(isnumeric( dataPointsInData.' dataTipInfo{i} ')) ' newline];
    temp_str = [temp_str dataTipInfo{i} '= num2str(dataPointsInData.' dataTipInfo{i} '(selected_point));' newline];
    
    temp_str = [temp_str 'elseif(ischar( dataPointsInData.' dataTipInfo{i} ')) ' newline];
    temp_str = [temp_str dataTipInfo{i} '= dataPointsInData.' dataTipInfo{i} '(selected_point);' newline];
    
    temp_str = [temp_str 'elseif(isstring( dataPointsInData.' dataTipInfo{i} ')) ' newline];
    temp_str = [temp_str dataTipInfo{i} '= char(dataPointsInData.' dataTipInfo{i} '(selected_point));' newline];
    
    temp_str = [temp_str newline 'end' newline];
end
temp_str  = [temp_str 'end' newline newline];
str = [str1 temp_str];

str = [str newline 'try' newline callBack newline 'catch ME' newline 'disp(''Wrong callback function :(''); disp(ME.message);' newline 'end' newline];

str2 = ['output_txt = {[''' columns{1} ': ' ''', num2str(pos(1),4)],[''' columns{2} ': ' ''', num2str(pos(2),4)],'];

% [''File name: '',  [file_name ''.wav''] ]};if length(pos) > 2,output_txt{end+1} = [''Z: '',num2str(pos(3),4)];end'];


for i = 1 : length(dataTipInfo)
    str2 = [str2 '[''' dataTipInfo{i} ': ' ''' ' dataTipInfo{i} '],'];
end

str2 = [ str2(1:end-1) '} ;' newline 'if(length(pos) > 2),output_txt{end+1} = [''Z: '',num2str(pos(3),4)];' newline 'end'];

str = [str str2];

fid = fopen('callBackFunction.m', 'w');
fprintf( fid, '%s', str );
fclose(fid);

% data cursor handle
dcm_object = datacursormode( handle );
% set the update function to callBackFunction
set(dcm_object, 'UpdateFcn', @callBackFunction, 'enable', 'on');

