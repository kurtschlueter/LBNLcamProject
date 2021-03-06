% Hungarian notation chart 

% For a discussion about when to use hungarian notation, scroll to the
% bottom of this page

% MATLAB classes

% x:    mixed (can be any type)
% d:    double
% s:    single
% i8:   int8 (signed)
% i16:  int16 (signed)
% i32:  int32 (signed)
% u8:   uint8
% u16:  uint16
% u32:  uint32


% c:    char
% h:    double with ishandle(val) == true

% l:    logical (MATLAB equiv of boolean) (true is shorthand logical(1))
% st:   struct
% ce:   cell
% t:    timer
% fh:   function_handle
% vi:   videoinput (Image Acquisition Toolbox)
% j:    java native(must always be private to wrapper class)    

% Custom classes

% uip: UIPopup
% uil: UIList
% uie: UIEdit
% uic: UICheckbox
% uib: UIButton
% uit: UIToggle 

% hio:      HardwareIO
% ho:       HardwareO
% setup:    Setup*

% ax:   Axis
% as:   AxisSetup
% av:   AxisVirtual
% api:  API*
% apiv: APIVirtual*


% di: Diode
% ds: DiodeSetup
% dv: DiodeVirtual

% sc: scan
% cm: camera
% mr: Mirror
% cl: Clock

% win:  Window
% pan:  Panel


% ******************* loop counters

% k, m, p, q (loop counters are excempt from Hungarian notation)



% Array initialization
%
% true(0)                 0x0 logical
% []                      0x0 double
% {}                      0x0 cell
% struct()                1x1 struct with no fields
% struct([])              0x0 struct with no fields



% Constants: hungarian first letter, rest all caps

% ********************* uicontrol elements:

% popupmenu
% checkbox
% listbox
% toggle
% pushbutton

% all have two properties accessible by get(h, 'Value') and get(h,
% 'String').  For popupmenu and listbox, Value returns the selelcted index.
% For 'toggle', 'pushbutton', and 'checkbox', Value returns the selected
% state (pushed/checked).  In all cases it returns a double but I will cast
% toggles, pushbuttons, and checkbox as logical().  String returns the
% string on the button / checkbox or a cell if it is a popupmenu or list


% ******************** methods / member functions

% Have no Hungarian prefix.  Why?  because the prefix should relate to what
% is returned by the proterty/or method  being accessed.  Functions can
% return anything (string), whatever, we don't want to go through the
% trouble of prefixing every function by the type that it returns


% ******************* setters

% Always pass 'this' and a variable named Val with the hungarian prefix of
% the variable that is being set.  

% Step 1: validate on the value passed in.  If it passes validation, update
% the class property.  If it doesn't pass, leave class property as-is.
% Step 2: set the ui 'Value' / 'String' so that it reflects the property
% value.  This is most relevant in cases that fail validation - in this
% case you want to set the UI back to its last valid value, which is easy
% since it is stored in the class property linked to the UI




% ******************* APIHardwareIO classes

% These are always passed the instance of the hardware class and they serve
% as a wrapper to call methods within the hardware class.  They should
% contain nothing more than some switch blocks that call methods of the
% associated hardware instance
% 
% When possible, build general APIHardwareIO classes, for example check out
% the APIHardwareIOStageXYZ class which can be used for any general stage
% where you want to get/set 'x', 'y', and 'z' properties.  We leave the API
% general, and un-generalize it in the get(cProp) and set(cProp, dVal)
% properties of the parent, if needed. I also built a general one for
% StageXYZRxRy

%{

Every APIHardwareIO needs to implement three methods:

function get():double{
    returns value of hardware propery
}

function set(double):void{
    sets the hardware property to the value passed in and, if
    necessary, calls the move
}

function stop():void{
    updates hardware property to val() and/or calls a stop() method if
    the hardware supports it.
}

%}


% ******************* APIHardwareO classes

% These are always passed the instance of the hardware class and they serve
% as a wrapper to call methods within the hardware class.  They should
% contain nothing more than some switch blocks that call methods of the
% associated hardware instance

%{

Every APIHardwareO needs to implement one method:

function get():double{
    returns value of hardware propery
}
%}


% Notes on uistack()
% It seems like uistack doesn't work on hggroup or hgtransfom objects, only
% the actual instances of images, lights, lines, patches, rectangles, 
% surfaces, and text that are children of the hg* objects.  Also, there is
% a bug in the default renderer, 'painters', which doesn't properly stack
% objects in the heirarchy with which they are drawn when things are moved.
% This can be fixed by setting the renderer property of the figure to
% 'OpenGL' or 'zbuffer' but OpenGL is faster


% How to removed a nexted property from a structure
%
% Assume a structure "s" looks like this:
%
%   pt
%       uieUser
%       uieBase
%   rc
%       uilBooyah
%       uilBooyah2
% 
% and that you want to remove only pt.uieUser.  Here is how you would do
% it:
%
% s.pt = rmfield(s.pt, 'uieUser');


% When to use Hungarian notation?
%
% Only for primitive Matlab classes and core framework classes, as outlined
% above
%
% For me hungarian notation lets you define two things with the variable
% name:
% 
%   1. the Matlab class 
%   2. the physical thing the variable represents
% 
% For example, ?uieResistName? says that this variable represents the name
% of the resist and that it is a UIEdit Matlab class. We need the Hungarian
% prefix because the ?representation? part (ResistName) is not enough to
% specify what Matlab class it is (it could be a char, or anything ? it is
% ambiguous)
% 
% But lets consider a higher-level class like ReticleCoarseStage.  Here, if
% we use a variable name like ?reticleCoarseStage? the ?physical thing the
% variable represents? and the Matlab class name are identical, so there is
% no need for the hungarian prefix.  I.E., the variable instance represents
% the reticle coarse stage and the Matlab class is called
% ReticleCoarseStage, so there is no need for the Hungarian prefix.
% 
% I think whenever the Matlab class name is identical to the physical thing
% the variable represents, there is no need for a hungarian prefix.
% 
% What do you think?  


