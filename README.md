## dataCursor

#### function dataCursor(handle, data, columns, dataTipInfo, callBack)

 Function to customize the behavior of data cursors in MATLAB
 figures. This function should be used in conjunction
 with one of MATLAB plotting commands (plot, stem, scatter, etc.)

#### How to use:
   The first argument is the handle to the figure.
 
   The second argument is the data that is being plotted.
   The data must be in Table format.

   The third argument is the Table columns that are being plotted.

   The fourth argument specifics the extra columns which are
   desired to be displayed on the data tip.

   The fifth argument (optional) specifics any other call back 
   function that needs to be executed when a point on the plot is 
   clicked on. 
   The index of the clicked point is stored in a variable called 
   'selected_point'. This variable is updated each time a 
   data-point is clicked.

#### Example 1: 
   In this example columns col1and col2 are plotted. In this 
   case, the data tip shows additional columns col3, col4, 
   and col5: 
   fig_handle = figure;
   plot( data.col1, data.col2, '.', 'MarkerSize', 10 );
   dataCursor(fig_handle, data, {'col1'; 'col2'}, {'col3'; 'col4'; 'col5'});
 
#### Example 2: 
   In this example columns col1and col2 are plotted. In this
   case, the data tip shows additional columns col3, col4,
   and col5. In addition the callback defined in the fifth argument
   prints the row corresponding to the clicked point in the command
   window. 
   Note that the variable 'selected_point' is defined by the data cursor
   function and stores the index of the clicked point in the data table. 
   
   fig_handle = figure;
   plot( data.col1, data.col2, '.', 'MarkerSize', 10 );
   dataCursor(fig_handle, data, {'col1'; 'col2'}, ...
   {'col3'; 'col4'; 'col5'}, 'data(selected_point,:)');
 
#### See the file 'example.m' for more examples.
#### Vahid Montazeri, 10/7/2018
:simple_smile:
